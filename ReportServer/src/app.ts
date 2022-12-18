// app.ts
import express from 'express';
import {PrismaClient} from '@prisma/client'
import {Report} from "./report";
import DiscordWebhook from 'discord-webhook-ts';
import moment from "moment";
import fileUpload, {UploadedFile} from "express-fileupload";
import {exists, existsSync, mkdirSync} from "fs";
import * as fs from "fs";
import {randomUUID} from "crypto";
import {LowTask} from "../dist/lowTask";
import {monitorEventLoopDelay} from "perf_hooks";

const app = express();
const port = 3000;

const prisma = new PrismaClient()
const discordClient = new DiscordWebhook('https://discord.com/api/webhooks/1054036115222437998/soLJ_fgy4VxlDJmZajNWmYeoz8ZBzLX9vocoCIEOmBdDbrSAxgVpH0IOOZm7t5_ekqw9');
const imgStorage = "img"

app.use('/api/img', express.static(imgStorage));
app.use(fileUpload({
    useTempFiles: true,
    tempFileDir: '/tmp/'
}));
app.use(express.json())


app.get('/', (req, res) => {
    res.send('<h1>Report Server</h1>');
});

app.post('/api/signUp', async (req, res) => {
    let email = req.body["email"] as string
    let password = req.body["password"] as string
    let name = req.body["name"] as string
    if (email == null || password == null || name == null) {
        res.status(400).send({
            "error": "email or password or name can't empty"
        })
        return
    }

    let accountExist = await prisma.account.findFirst({
        where: {
            email: email
        }
    })

    if (accountExist != null) {
        res.status(400).send({
            "error": "this account is exist"
        })
        return
    }

    await prisma.account.create({
        data: {
            email: email,
            password: password,
            name: name
        }
    })

    res.send({
        "success": true
    })
})

app.post('/api/login', async (req, res) => {
    let email = req.body["email"]
    let password = req.body["password"]
    if (email == null || password == null) {
        res.status(400).send({
            "error": "email or password can't empty"
        })
        return
    }

    let account = await prisma.account.findFirst({
        where: {
            email: email,
            password: password
        }
    })

    if (account == null) {
        res.status(400).send({
            "error": "account not found"
        })
        return
    }

    res.send(JSON.stringify(account))
})

app.post('/api/getReport', async (req, res) => {
    let accountId = req.body["accountId"]
    let dataList = await prisma.reportContent.findMany({
        where: {
            accountId: accountId
        },
        orderBy: [
            {
                dateTime: 'desc'
            }
        ],
        select: {
            id: true,
            dateTime: true,
            reportDetail: true,
            imageDetail: true
        }
    })

    res.send(dataList)
})

app.post('/api/sendReport', async (req, res) => {
    let dataList = req.body["data"] as [Report]
    let id = req.body["accountId"] as number

    if (dataList == null || id == null) {
        res.status(400).send({
            "error": "accountId or data can't empty."
        })
        return
    }

    let existReport = await prisma.reportContent.findFirst({
        where: {
            accountId: id,
            dateTime: moment().format("yyyy-MM-DD")
        }
    })

    if (existReport != null) {
        res.status(400).send({
            "error": "Today's report was send"
        })
        return
    }

    let reportContent = await prisma.reportContent.create({
        data: {
            accountId: id,
            dateTime: moment().format("yyyy-MM-DD")
        }
    })

    let reportContentId = reportContent.id as number

    for (const x of dataList) {
        await prisma.reportDetail.create({
            data: {
                content: x.content ?? "",
                reportContentId: reportContentId
            }
        })
    }

    res.send({
        "reportId": reportContentId
    })
})

app.post('/api/uploadImg', async (req, res) => {
    let reportId = parseInt(req.query.reportId as string)
    let imgFile = req.files?.image as [UploadedFile]

    if (imgFile == null) {
        res.status(400).send({
            "error": "upload image can't empty"
        })
        return
    }

    if (!existsSync(imgStorage)) {
        mkdirSync(imgStorage)
    }

    try {
        for (const x of imgFile) {
            await saveImg(reportId, x)
        }
    } catch (e) {
        let imgFile1 = req.files?.image as UploadedFile
        await saveImg(reportId, imgFile1)
    }


    res.status(200).send({
        "success": true
    })
})

app.get('/api/getAllImage', async (req, res) => {
    let imgDetailList = await prisma.imageDetail.findMany()
    res.send(imgDetailList)
})

app.get('/api/getAllAccount', async (req, res) => {
    let accountList = await prisma.account.findMany()
    res.send(accountList)
})

app.get('/api/getAllReport', async (req, res) => {
    let accountList = await prisma.reportContent.findMany({
        select: {
            id: true,
            dateTime: true,
            account: true,
            imageDetail: true,
            reportDetail: true
        }
    })
    res.send(accountList)
})

app.post('/api/setLowTaskAccount', async (req, res) => {
    createLowTaskJsonFile()
    let id = req.body["accountId"] as number
    if (id == null) {
        res.status(400).send({
            "error": "accountId or data can't empty."
        })
        return
    }

    let content = JSON.parse(fs.readFileSync("./lowTask.json").toString()) as LowTask
    content.accountId = id
    content.date = moment().format("")
    fs.writeFileSync('./lowTask.json', JSON.stringify(content, null, 4))

    res.send({
        "success": true
    })
})

app.post('/api/setDetectMode', async (req, res) => {
    // mode 0 is auto, mode 1 is manual
    createLowTaskJsonFile()
    let mode = req.body["mode"] as number
    if (mode == null) {
        res.status(400).send({
            "error": "request body can't empty"
        })
        return
    }

    if(mode != 1 && mode != 0) {
        res.status(400).send({
            "error": "mode number only have 0 or 1"
        })
        return
    }

    let content = JSON.parse(fs.readFileSync("./lowTask.json").toString()) as LowTask
    content.mode = mode

    fs.writeFileSync('./lowTask.json', JSON.stringify(content, null, 4))

    res.send({
        "success": true
    })
})

app.get('/api/getLowTaskAccount', async (req, res) => {
    createLowTaskJsonFile()
    let content = JSON.parse(fs.readFileSync("./lowTask.json").toString())
    return res.send(content)
})

app.get('/api/getTodayReport', async (req, res) => {

})

async function saveImg(reportId: number, x: UploadedFile) {
    let newPath = imgStorage + `/${randomUUID()}.jpg`

    await prisma.imageDetail.create({
        data: {
            imgPath: newPath,
            reportContentId: reportId
        }
    })

    fs.rename(x.tempFilePath, newPath, (err) => {
    })
}

function createLowTaskJsonFile() {
    let date = new Date()
    if (!existsSync("./lowTask.json")) {
        fs.writeFileSync("./lowTask.json", JSON.stringify({
            "accountId": 0,
            "mode": 0,
            "date": moment(date.setDate(date.getDate() - 1)).format("yyyy/MM/DD")
        }, null, 4))
    }
}

setInterval(async () => {
    if (moment().format("HH:mm") != "23:00") {
        let list = (await prisma.reportContent.findMany({
            where: {
                dateTime: moment().format("yyyy-MM-DD")
            },
            orderBy: [
                {
                    accountId: 'asc'
                }
            ],
            select: {
                account: true,
                reportDetail: true
            }
        }))

        // if all account in system not report task
        if (list.length == 0) {
            await discordClient.execute({
                "embeds": [
                    {
                        "title": `${moment().format("yyyy/MM/DD")}今日進度`,
                        "color": 15258703,
                        "fields": [
                            {
                                "name": "全部人",
                                "value": "都沒進度",
                                "inline": false
                            }
                        ]
                    }
                ]
            })
            return
        }

        let dataList = list.map(x => {
            return {
                "name": x.account.name,
                "value": x.reportDetail.map(z => z.content).join("\n"),
                "inline": false
            }
        })

        // sort report task count with all account
        list.sort(x => x.reportDetail.length)


        dataList.push({
            "name": "**本日進度最低**",
            "value": `**${list[list.length - 1].account.name}**`,
            "inline": false
        })

        await discordClient.execute({
            "embeds": [
                {
                    "title": `${moment().format("yyyy/MM/DD")}今日進度`,
                    "color": 15258703,
                    "fields": dataList
                }
            ]
        })
    }

}, 5 * 1000)

app.listen(port, () => {
    console.log(`server is listening on ${port}`);
});

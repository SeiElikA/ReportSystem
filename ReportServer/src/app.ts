// app.ts
import express from 'express';
import {PrismaClient} from '@prisma/client'
import {Report} from "./report";
import DiscordWebhook from 'discord-webhook-ts';
import moment from "moment";

const app = express();
const port = 3000;

const prisma = new PrismaClient()
const discordClient = new DiscordWebhook('https://discord.com/api/webhooks/1050020644718399510/kw40GWB45Az-Ynzik1CQzHmpisUDflZyzdh4UUSeFh7AQ_8TLJyMa6jkMafe0682cYVQ');

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

    if(accountExist != null) {
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

    if(account == null) {
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
            reportDetail: true
        }
    })

    res.send(dataList)
})

app.post('/api/sendReport', async (req, res) => {
    let dataList = req.body["data"] as [Report]
    let id = req.body["accountId"] as number

    if(dataList == null || id == null) {
        res.status(400).send({
            "error":"accountId or data can't empty."
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
                imgPath: x.imgPath ?? "",
                reportContentId: reportContentId
            }
        })
    }

    res.send({
        "success": true
    })
})

setInterval(async () => {
    if(moment().format("HH:mm") == "23:00") {
        let dataList = (await prisma.reportContent.findMany({
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
        })).map(x => {
            return {
                "name": x.account.name,
                "value": x.reportDetail.map(z=>z.content).join("\n"),
                "inline": false
            }
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

}, 55 * 1000)

app.listen(port, () => {
    console.log(`server is listening on ${port}`);
});
"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
// app.ts
const express_1 = __importDefault(require("express"));
const client_1 = require("@prisma/client");
const discord_webhook_ts_1 = __importDefault(require("discord-webhook-ts"));
const moment_1 = __importDefault(require("moment"));
const express_fileupload_1 = __importDefault(require("express-fileupload"));
const fs_1 = require("fs");
const fs = __importStar(require("fs"));
const crypto_1 = require("crypto");
const app = (0, express_1.default)();
const port = 3001;
const prisma = new client_1.PrismaClient();
const discordClient = new discord_webhook_ts_1.default('https://discord.com/api/webhooks/1056776296123879464/r5LlcEiNmsEWFuYfrJfLPIarBEHO6Bub-zxMfkzQs-EnMoYHdx1Bg_6N7Ez8UjSiVY9z');
const imgStorage = "img";
app.use('/api/img', express_1.default.static(imgStorage));
app.use((0, express_fileupload_1.default)({
    useTempFiles: true,
    tempFileDir: '/tmp/'
}));
app.use(express_1.default.json());
app.get('/', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    res.send('<h1>Report Server</h1>');
}));
app.post('/api/signUp', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    let email = req.body["email"];
    let password = req.body["password"];
    let name = req.body["name"];
    if (email == null || password == null || name == null) {
        res.status(400).send({
            "error": "email or password or name can't empty"
        });
        return;
    }
    let accountExist = yield prisma.account.findFirst({
        where: {
            email: email
        }
    });
    if (accountExist != null) {
        res.status(400).send({
            "error": "this account is exist"
        });
        return;
    }
    yield prisma.account.create({
        data: {
            email: email,
            password: password,
            name: name
        }
    });
    res.send({
        "success": true
    });
}));
app.post('/api/login', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    let email = req.body["email"];
    let password = req.body["password"];
    if (email == null || password == null) {
        res.status(400).send({
            "error": "email or password can't empty"
        });
        return;
    }
    let account = yield prisma.account.findFirst({
        where: {
            email: email,
            password: password
        }
    });
    if (account == null) {
        res.status(400).send({
            "error": "account not found"
        });
        return;
    }
    res.send(JSON.stringify(account));
}));
app.post('/api/getReport', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    let accountId = req.body["accountId"];
    let dataList = yield prisma.reportContent.findMany({
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
    });
    res.send(dataList);
}));
app.post('/api/sendReport', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _a;
    let dataList = req.body["data"];
    let id = req.body["accountId"];
    if (dataList == null || id == null) {
        res.status(400).send({
            "error": "accountId or data can't empty."
        });
        return;
    }
    let existReport = yield prisma.reportContent.findFirst({
        where: {
            accountId: id,
            dateTime: (0, moment_1.default)().format("yyyy-MM-DD")
        }
    });
    if (existReport != null) {
        res.status(400).send({
            "error": "Today's report was send"
        });
        return;
    }
    let reportContent = yield prisma.reportContent.create({
        data: {
            accountId: id,
            dateTime: (0, moment_1.default)().format("yyyy-MM-DD")
        }
    });
    let reportContentId = reportContent.id;
    for (const x of dataList) {
        yield prisma.reportDetail.create({
            data: {
                content: (_a = x.content) !== null && _a !== void 0 ? _a : "",
                reportContentId: reportContentId
            }
        });
    }
    res.send({
        "reportId": reportContentId
    });
}));
app.post('/api/uploadImg', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _b, _c;
    let reportId = parseInt(req.query.reportId);
    let imgFile = (_b = req.files) === null || _b === void 0 ? void 0 : _b.image;
    if (imgFile == null) {
        res.status(400).send({
            "error": "upload image can't empty"
        });
        return;
    }
    if (!(0, fs_1.existsSync)(imgStorage)) {
        (0, fs_1.mkdirSync)(imgStorage);
    }
    try {
        for (const x of imgFile) {
            yield saveImg(reportId, x);
        }
    }
    catch (e) {
        let imgFile1 = (_c = req.files) === null || _c === void 0 ? void 0 : _c.image;
        yield saveImg(reportId, imgFile1);
    }
    res.status(200).send({
        "success": true
    });
}));
app.get('/api/getAllImage', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    let imgDetailList = yield prisma.imageDetail.findMany();
    res.send(imgDetailList);
}));
app.get('/api/getAllAccount', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    let accountList = yield prisma.account.findMany();
    res.send(accountList);
}));
app.get('/api/getAllReport', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    let accountList = yield prisma.reportContent.findMany({
        select: {
            id: true,
            dateTime: true,
            account: true,
            imageDetail: true,
            reportDetail: true
        }
    });
    res.send(accountList);
}));
app.post('/api/setLowTaskAccount', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    createLowTaskJsonFile();
    let id = req.body["accountId"];
    if (id == null) {
        res.status(400).send({
            "error": "accountId or data can't empty."
        });
        return;
    }
    let content = JSON.parse(fs.readFileSync("./lowTask.json").toString());
    content.accountId = id;
    content.date = (0, moment_1.default)().format("yyyy/MM/DD HH:mm:ss");
    fs.writeFileSync('./lowTask.json', JSON.stringify(content, null, 4));
    res.send({
        "success": true
    });
}));
app.post('/api/setDetectMode', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    // mode 0 is auto, mode 1 is manual
    createLowTaskJsonFile();
    let mode = req.body["mode"];
    if (mode == null) {
        res.status(400).send({
            "error": "request body can't empty"
        });
        return;
    }
    if (mode != 1 && mode != 0) {
        res.status(400).send({
            "error": "mode number only have 0 or 1"
        });
        return;
    }
    let content = JSON.parse(fs.readFileSync("./lowTask.json").toString());
    content.mode = mode;
    fs.writeFileSync('./lowTask.json', JSON.stringify(content, null, 4));
    res.send({
        "success": true
    });
}));
app.get('/api/getLowTaskAccount', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    createLowTaskJsonFile();
    let content = JSON.parse(fs.readFileSync("./lowTask.json").toString());
    return res.send(content);
}));
app.get("/api/getDetectMode", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    var _d;
    createLowTaskJsonFile();
    let data = JSON.parse(fs.readFileSync("./lowTask.json").toString());
    let accountName = yield prisma.account.findFirst({
        where: {
            id: data.accountId
        }
    });
    return res.send({
        "mode": data.mode,
        "dateTime": data.date,
        "name": (_d = accountName === null || accountName === void 0 ? void 0 : accountName.name) !== null && _d !== void 0 ? _d : "null"
    });
}));
app.get('/api/getTodayReport', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    let list = (yield prisma.reportContent.findMany({
        where: {
            dateTime: (0, moment_1.default)().format("yyyy-MM-DD")
        },
        orderBy: [
            {
                accountId: 'asc'
            }
        ],
        select: {
            account: true,
            reportDetail: true,
            imageDetail: true
        }
    }));
    return res.send(list);
}));
app.get('/api/getAccount', (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    let accountNameList = yield prisma.account.findMany({
        select: {
            id: true,
            name: true
        }
    });
    res.send(accountNameList);
}));
function saveImg(reportId, x) {
    return __awaiter(this, void 0, void 0, function* () {
        let newPath = imgStorage + `/${(0, crypto_1.randomUUID)()}.jpg`;
        yield prisma.imageDetail.create({
            data: {
                imgPath: newPath,
                reportContentId: reportId
            }
        });
        fs.rename(x.tempFilePath, newPath, (err) => {
        });
    });
}
function createLowTaskJsonFile() {
    let date = new Date();
    if (!(0, fs_1.existsSync)("./lowTask.json")) {
        fs.writeFileSync("./lowTask.json", JSON.stringify({
            "accountId": 0,
            "mode": 0,
            "date": (0, moment_1.default)(date.setDate(date.getDate() - 1)).format("yyyy/MM/DD")
        }, null, 4));
    }
}
setInterval(() => __awaiter(void 0, void 0, void 0, function* () {
    var _e, _f;
    if ((0, moment_1.default)().format("HH:mm") == "23:00") {
        let allAccount = yield prisma.account.findMany();
        let list = (yield prisma.reportContent.findMany({
            where: {
                dateTime: (0, moment_1.default)().format("yyyy-MM-DD")
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
        }));
        // 篩選出沒有回報的帳號
        list.forEach(x => {
            allAccount = allAccount.filter(z => z.name != x.account.name);
        });
        // 如果全部人都沒有回報
        if (list.length == 0) {
            yield discordClient.execute({
                "embeds": [
                    {
                        "title": `${(0, moment_1.default)().format("yyyy/MM/DD")}今日進度`,
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
            });
            return;
        }
        let dataList = list.map(x => {
            return {
                "name": x.account.name,
                "value": x.reportDetail.map((z, key) => (key + 1) + "." + z.content).join("\n　"),
                "inline": false
            };
        });
        // 取項目最低的帳號為進度最低(自動模式)
        list.sort(x => x.reportDetail.length);
        let msg = `\`\`\`${(0, moment_1.default)().format("yyyy/MM/DD")} 進度統計\`\`\``;
        dataList.forEach((data) => {
            msg += `\`\`\`diff\n+${data.name}\n今日進度：\n　${data.value}\`\`\``;
        });
        // 讀取設定json
        let settingData = JSON.parse(fs.readFileSync("./lowTask.json").toString());
        // mode 0 is auto, mode 1 is manual
        if (settingData.mode != 0 && settingData.accountId != 0) {
            let accountName = (_f = (_e = (yield prisma.account.findFirst({
                where: {
                    id: settingData.accountId
                }
            }))) === null || _e === void 0 ? void 0 : _e.name) !== null && _f !== void 0 ? _f : "null";
            msg += `\`\`\`diff\n-本日進度最低-\n${accountName}\`\`\``;
        }
        else {
            if (allAccount.length != 0) { // 如果有兩個以上沒回報
                msg += `\`\`\`diff\n-本日進度最低-\n${allAccount.map(x => x.name).join(",")}\`\`\``;
            }
            else { // 正常取得進度最低
                msg += `\`\`\`diff\n-本日進度最低-\n${list[list.length - 1].account.name}\`\`\``;
            }
        }
        yield discordClient.execute({
            "content": msg
        });
    }
}), 55 * 1000);
app.listen(port, () => {
    console.log(`server is listening on ${port}`);
});

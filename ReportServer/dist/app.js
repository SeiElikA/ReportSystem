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
const port = 3000;
const prisma = new client_1.PrismaClient();
const discordClient = new discord_webhook_ts_1.default('https://discord.com/api/webhooks/1050020644718399510/kw40GWB45Az-Ynzik1CQzHmpisUDflZyzdh4UUSeFh7AQ_8TLJyMa6jkMafe0682cYVQ');
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
function saveImg(reportId, x) {
    return __awaiter(this, void 0, void 0, function* () {
        let newPath = imgStorage + `/${(0, crypto_1.randomUUID)()}.jpg`;
        yield prisma.imageDetail.create({
            data: {
                imgPath: newPath,
                reportContentId: reportId
            }
        });
        fs.rename(x.tempFilePath, newPath, (err) => { });
    });
}
setInterval(() => __awaiter(void 0, void 0, void 0, function* () {
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
        list.forEach(x => {
            allAccount = allAccount.filter(z => z.name != x.account.name);
        });
        if (list.length == 0) {
            yield discordClient.execute({
                "embeds": [
                    {
                        "title": `${(0, moment_1.default)().format("yyyy/MM/DD")}今日進度`,
                        "color": 15258703,
                        "fields": {
                            "name": "**全部人**",
                            "value": "**都沒進度**",
                            "inline": false
                        }
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
        list.sort(x => x.reportDetail.length);
        let msg = "\`\`\`2022/10/14 進度統計\`\`\`";
        dataList.forEach((data) => {
            msg += `\`\`\`diff\n+${data.name}\n今日進度：\n　${data.value}\`\`\``;
        });
        if (allAccount.length != 0) {
            msg += `\`\`\`diff\n-本日進度最低-\n${allAccount.map(x => x.name).join(",")}\`\`\``;
        }
        else {
            msg += `\`\`\`diff\n-本日進度最低-\n${list[list.length - 1].account.name}\`\`\``;
        }
        yield discordClient.execute({
            "content": msg,
        });
    }
}), 55 * 1000);
app.listen(port, () => {
    console.log(`server is listening on ${port}`);
});

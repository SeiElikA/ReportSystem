"use strict";
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
const app = (0, express_1.default)();
const port = 2020;
const prisma = new client_1.PrismaClient();
app.use(express_1.default.json);
app.get('/', (req, res) => {
    res.send('<h1>Report Server</h1>');
});
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
app.listen(port, () => {
    console.log(`server is listening on ${port}`);
});

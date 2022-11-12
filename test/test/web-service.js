const Web3 = require('web3')
const HDWalletProvider = require("@truffle/hdwallet-provider");
require("dotenv").config();
// for test
const privateKeys = [
    "ac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80",
    "59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d",
    "5de4111afa1a4b94908f83103eb1f1706367c2e68ca870fc3fb9a804cdab365a",
    "7c852118294e51e653712a81e05800f419141751be58f605c371e15141b007a6",
    "47e179ec197488593b187f80a00eb0da91f1b9d0b13f8733639f19c30a34926a"
];
let provider = new HDWalletProvider(
    privateKeys,
    "http://localhost:8545",
    0,
    5
);

// for producting
// const INFURA = process.env.INFURA_KEY;
// const privateKeys = [
//     process.env.KEY
// ];

// let provider = new HDWalletProvider(
//     privateKeys,
//     `https://goerli.infura.io/v3/${INFURA}`,
//     0,
//     1
// );
const web3 = new Web3(provider);
module.exports = { web3 }
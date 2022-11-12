require('@nomiclabs/hardhat-waffle');
require('@nomiclabs/hardhat-etherscan');
require('@nomiclabs/hardhat-ethers');
require("@nomiclabs/hardhat-truffle5");
require('@openzeppelin/hardhat-upgrades');
require('@openzeppelin/upgrades-core');
require('hardhat-contract-sizer');
require("dotenv").config();


const INFURA = process.env.INFURA_KEY;
const ACCOUNT = process.env.ACCOUNT;

let API_KEY = "";
const ID = process.env.ID;

if (ID == "ETH") {
  API_KEY = process.env.API_KEY_ETH;

} else if (ID == "BSC") {
  API_KEY = process.env.API_KEY_BSC;
} else {
  console.log("NETWORK is comming soon")
}

module.exports = {
  defaultNetwork: "localhost",
  solidity: {
    version: '0.8.4',
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      },
    },
  },
  contractSizer: {
    alphaSort: false,
    runOnCompile: false,
    disambiguatePaths: false,
  },

  networks: {
    hardhat: {
      gas: 'auto',
      allowUnlimitedContractSize: true,
    },
    // testnet
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${INFURA}`,
      accounts: [ACCOUNT],
      gas: 5500000,
      gasPrice: 10000000000,
      blockGasLimit: 15000000,
      timeout: 20000,
    },
    goerli: {
      url: `https://goerli.infura.io/v3/${INFURA}`,
      accounts: [ACCOUNT],
      gas: 5500000,
      gasPrice: 70000000000,
      blockGasLimit: 15000000,
      timeout: 200000,
    },
    ropsten: {
      url: `https://ropsten.infura.io/v3/${INFURA}`,
      accounts: [ACCOUNT],
      gas: 550000000,
      gasPrice: 90000000000,
      blockGasLimit: 15000000,
      timeout: 200000,
    },
    bsc_testnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545/",
      chainId: 97,
      gasPrice: 30000000000,
      accounts: [ACCOUNT],
    },

    //mainnet
    ethereum: {
      url: `https://mainnet.infura.io/v3/${INFURA}`,
      accounts: [ACCOUNT],
      timeout: 20000,
    },
    binance: {
      url: "https://bsc-dataseed.binance.org/",
      chainId: 56,
      accounts: [ACCOUNT],
    },
    localhost: {
      url: "http://127.0.0.1:8545/",
      chainId: 31337,
    }
  },
  etherscan: {
    apiKey: API_KEY,
  }
};


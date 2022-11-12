# Creator NFT smart contract

## Local Development

The following assumes the use of `node@>=10`.

## Enviroment

Version: 1.0.0  

solidity: 0.8.4 

hardhat: ^2.7.0

hardhat-ethers: ^2.0.3

hardhat-etherscan: ^2.1.8

hardhat-waffle: ^2.0.1


## Setup Command

Config file .env

```
mkdir .env
cp -i .env.example .env

--> update variable in file .env 
```

Install dependencies.   

`yarn install`

Compile smart contract.    

`yarn compile` 

## Deploy Verify Command
### Deploy Smart Contract use rinkeby network, infura API and etherscan for verify contracts   
### Alter key for INFURA_RINKEBY_URI, ACCOUNT and ETHERSCAN/BINANCE in .env.

Setting config network `hardhat.config.js`

```
module.exports = {
  solidity: {
    version: '0.8.4',
    settings: {
      optimizer: {
        enabled: true,
        runs: 1
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
    creator_v1: {
      url: "https://dev.rpc.magnet.creatorchain.network",
      chainId: 1509,
      gasPrice: 9000000000,
      accounts: [ACCOUNT],
    },
    creator_v2: {
      url: "https://rpc.magnet.creatorchain.network",
      chainId: 1509,
      gasPrice: 9000000000,
      accounts: [ACCOUNT],
    },
    // testnet
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${INFURA}`,
      accounts: [ACCOUNT],
      gas: 5500000,
      gasPrice: 9000000000,
      blockGasLimit: 15000000,
      timeout: 20000,
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
      gasPrice: 20000000000,
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
  },
  etherscan: {
    apiKey: API_KEY,
  }
};
```

**Deploy Smart Contract **

```
yarn install

- Network: Binance
  + Testnet: yarn bsc-testnet-erc721 -> set address beacon -> yarn bsc-testnet-collection
  + Mainet: 

- Network: Ethereum
  + Testnet: yarn eth-testnet-erc721 -> set address beacon -> yarn eth-testnet-collection
  + Mainet: 
```


**Auto verify contract**

## Run test
```
 npx hardhat node
 npx hardhat test 
```


## SPDX License Identifier: 
[MIT](https://choosealicense.com/licenses/mit/)






# FE-Guide

## Configuration

### Prepare

The following assumes the use:  
`Node v12.18.3`, `Yarn 1.22.10`.  
`Hardhat version 2.5.0`, `Solidity - 0.8.0 (solc-js)`

--------------

### Intergrate environment

1. Add keys by leave private key in `.env`, leave ether scan api key in `.env`  

2. Modify `hardhat-config.js` to support some networks. 

### Intergrate command

1. When verify smart contract of ERC20 or ERC721, put the token address of that Contract after deployed in the command. 

`yarn verify -tokenAddress`

2. When verify the contract factory of ERC20, copy the addressChild after deployed, put it in the file name `args_factory.js` and run the command   

`yarn verify-factory-erc20`


### FE Intergrate

### Call function balanceOf() of ERC2917

1. Connect with Wallet(MetaMask). 
2. Choose testnet network (Binance test network)
3. Deploy and verify Smart Contract to bscan
4. Import contract ABI into Web3Query
5. In Web3Query, put your contract's anddress and contract's ABI in the function Contract() of method initialize 
6. Create method getBalanceOf() to get balance of the contract. Put the contract's address in that function
7. In gove.module.js create method to get ERC2917 infomation and store method getBalanceOf()
8. In GovernmentAsset template, we display balance of ERC2917 contract 
9. In Government template, we display balance of ERC2917 contract on screen for user to see by using GovernmentAsset component

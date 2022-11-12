const { ethers, upgrades } = require("hardhat");

async function main() {

     // deploy
    //  const ERC1155 = await hre.ethers.getContractFactory("ERC1155Burn");
    //  const erc1155 = await ERC1155.deploy();
    //  await erc1155.deployed();
    //  console.log("ERC20 deployed to:", erc1155.address);
 
     
     await hre.run("verify:verify", {
         address: "0xC1a50745790C33c26a36dD459dBBB6d9F9Dea73e",
         contract: "contracts/factory/token/erc1155/ERC1155Burn.sol:ERC1155Burn"
     });
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });

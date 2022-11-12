const { upgrades } = require('hardhat')

async function main() {
  const CyberRyo = await hre.ethers.getContractFactory('CyberRyo')
  const cyberRyo = await CyberRyo.deploy(
    5000,
    10,
    'https://ipfs.shinik.io/ipfs/QmXsqcTGtDCrThWirtQvzzTGNNY3kd38zfbUkbMJw6Y735',
  )
  await cyberRyo.deployed()
  console.log('CyberRyo deployed to:', cyberRyo.address)

  await hre.run('verify:verify', {
    address: cyberRyo.address,
    constructorArguments: [
      5000,
      10,
      'https://ipfs.shinik.io/ipfs/QmXsqcTGtDCrThWirtQvzzTGNNY3kd38zfbUkbMJw6Y735',
    ],
  })
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })

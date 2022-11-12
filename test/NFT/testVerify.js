const Web3 = require('web3')
require('dotenv').config()

const web3 = new Web3()
const privateKey = process.env.ACCOUNT1 || ''

const account = web3.eth.accounts.privateKeyToAccount(privateKey)

console.log(account)

// sign Claim
const encodedMessageClaim = web3.eth.abi.encodeParameters(
  ['address','uint256', 'uint256', 'uint256'],
  [
    '0x700aE7569b9dfF27Af4c9790b4401D827FDf1598', // receiver
    '133673193185921039', // maxAllowce
    '133673193185921039', // amount
    '667776667766', // nonce
  ],
)
const hashMessageClaim = web3.utils.keccak256(encodedMessageClaim)
const signedMessageClaim = account.sign(hashMessageClaim)
console.log(signedMessageClaim)

// sign PreSaleMint
const encodedMessagePreSaleMint = web3.eth.abi.encodeParameters(
  ['address', 'bytes32[]', 'uint256[]', 'uint256', 'uint256'],
  [
    '0x08f48161FE7b6C8eC3559f1928F381Ae88ad1522',
    ['0x33d9b6a83d9f6c40374670302183487afd6f6b41426b9c3518fb7bfca094a544',
    '0x1a571ff5fd2aaba77df45c20471ba2d62945f00b32030fbe6af65f7cb68f385f'],
    [1,1],
    5,
    '6644454',
  ],
)
console.log(encodedMessagePreSaleMint)
const hashMessagePreSaleMint = web3.utils.keccak256(encodedMessagePreSaleMint)
console.log(hashMessagePreSaleMint)
const signedMessagePreSaleMint = account.sign(hashMessagePreSaleMint)
console.log(signedMessagePreSaleMint)

// sign transfer
const encodedMessageTransfer = web3.eth.abi.encodeParameters(
  ['address', 'uint256'],
  [
    '0x08f48161FE7b6C8eC3559f1928F381Ae88ad1522', // newOwner
    '334455667887', // nonce
  ],
)
const hashMessageTransfer = web3.utils.keccak256(encodedMessageTransfer)
const signedMessageTransfer = account.sign(hashMessageTransfer)
console.log(signedMessageTransfer)

const arr = []
for (let i = 27; i < 77; i ++) {
  arr.push(i);
}
for (let i = 3915; i < 3965; i ++) {
  arr.push(i);
}

console.log(arr.toString())
console.log(arr)
const encodedMessageAirdrop = web3.eth.abi.encodeParameters(
  ['address', 'uint256', 'uint256'],
  [
    '0xa88fC5462127432E4880981b317A230c1682a338', // newOwner
    3, // amount
    '760996736417189548981222336815395679642513600033166444233287445', // nonce
  ],
)
const hashMessageAirdrop = web3.utils.keccak256(encodedMessageAirdrop)
const signedMessageAirdrop = account.sign(hashMessageAirdrop)
console.log(signedMessageAirdrop)

const encodedMessage = web3.eth.abi.encodeParameters(
  ['address', 'address[]', 'uint256[]', 'uint256[]', 'uint256'],
  [
    '0x08f48161FE7b6C8eC3559f1928F381Ae88ad1522', // recipient
    ['0x98922A7b6b88465d34dc9a7D4D8C5eE3B5757752', '0x27e476fd836226fae1a96278e32ed64dd5cc3060'], // collection
    [5,1], // amounts
    [6,7], // campaignIds
    128, // nonce
  ],
)
console.log(encodedMessage)
const hashMessage = web3.utils.keccak256(encodedMessage)
console.log(hashMessage)
const signedMessag = account.sign(hashMessage)
console.log(signedMessag)

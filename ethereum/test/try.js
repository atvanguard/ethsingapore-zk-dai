const BN = require('bn.js');

async function encrypt(address, _amount) {
  // 20 12
  let amount = new BN(_amount, 16).toString(16, 24); // 12 bytes = 24 chars in hex
  const payload = address + amount;
  console.log(payload)
  const encryptedNote = await web3.eth.accounts.encrypt('0x' + payload, 'vitalik')
}

encrypt('2B522cABE9950D1153c26C1b399B293CaA99FcF9', '5');
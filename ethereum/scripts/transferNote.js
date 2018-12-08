const contractArtifact = artifacts.require('./SecretNote.sol');
const BN = require('bn.js')
const fs = require('fs');
const path = require('path');

async function execute() {
  // console.log(path.join(__dirname, 'proof.json'))
  let proofJson = fs.readFileSync(path.join(__dirname, 'proof.json'), 'utf8');
  var rx2 = /([0-9]+)[,]/gm
  // console.log(proofJson.match(rx2))
  proofJson.match(rx2).forEach(p => {
    proofJson = proofJson.replace(p, `"${p.slice(0, p.length-1)}",`)
  })
  proofJson = JSON.parse(proofJson);
  // console.log(proofJson)
  
  const proof = proofJson.proof;
  const input = proofJson.input;
  input.forEach((i, key) => {
    if (typeof i == 'number') i = i.toString();
    input[key] = '0x' + new BN(i, 10).toString('hex')
  })
  
  const _proof = [];
  Object.keys(proof).forEach(key => _proof.push(proof[key]));
  _proof.push(input)
  
  // let instance = await verifier.deployed();
  const instance = await contractArtifact.deployed();
  const encNote1 = await encrypt('3644B986B3F5Ba3cb8D5627A22465942f8E06d09', 'a');
  const encNote2 = await encrypt('2B522cABE9950D1153c26C1b399B293CaA99FcF9', 'a5');
  // console.log(..._proof, encNote1, encNote2)
  console.log('calling transferNote with params', ..._proof, encNote1, encNote2);
  try {
    const tx = await instance.transferNote(..._proof, encNote1, encNote2);
    console.dir(tx, {depth: null});
  } catch(e) {
    console.log(e)
  }
}

async function encrypt(address, _amount) {
  // 20 12
  let amount = new BN(_amount, 16).toString(16, 24); // 12 bytes = 24 chars in hex
  const payload = address + amount;
  return payload;
  // console.log('enc payload', payload)
  // const encryptedNote = await web3.eth.accounts.encrypt('0x' + payload, 'vitalik')
  // return JSON.stringify(encryptedNote);
}

module.exports = async function(callback) {
  // perform actions
  await execute();
  callback();
}
import web3 from './web3';
import compiledSecretNote from './SecretNote.json';
const BN = require('bn.js');
const crypto = require('crypto');

console.log('compiledSecretNote', compiledSecretNote, )
const netId = Object.keys(compiledSecretNote.networks)[0];

const contractAddress = compiledSecretNote.networks[netId].address;
console.log('contractAddress', contractAddress)

const SecretNote =  new web3.eth.Contract(
  compiledSecretNote.abi,
  contractAddress
)

console.log('SecretNote', SecretNote)

export const getAccounts = async () => {
  const accounts = await web3.eth.getAccounts();
  return accounts
}

export const getCurrentAccount = async () => {
  const accounts = await web3.eth.getAccounts();
  return accounts[0];
}

export const getNotes = async () => {
  const notes = [];
  const accounts = await getAccounts();
  const userAccount = accounts[0].slice(2);

  const len = await SecretNote.methods.getNotesLength().call();
  for(let i = 0; i < len; i++) {
    const cipher = await SecretNote.methods.allNotes(i).call();
    console.log('cipher', cipher)
    const dec = await decrypt(cipher, userAccount);
    console.log('dec', dec)
    if (dec.isMine) {
      console.log('worked')
      const noteHash = getNoteHash(userAccount, dec.amount);
      const state = await SecretNote.methods.notes('0x' + noteHash).call()
      console.log('state', state)
      if (state == '1' || state == '2') {
        // needs to be displayed
        notes.push({hash: '0x' + noteHash, status: state == '1' ? 'Created' : 'Spent', amount: parseInt(dec.amount, 16)});
      }
    }
  }
  console.log('notes', notes)
  return notes;
}

export const getAllNotes = async () => {
  const notes = [];
  const len = await SecretNote.methods.getNotesLength().call();
  console.log('len', len)
  for(let i = 0; i < len; i++) {
    // const hash = await SecretNote.methods.allHashedNotes(i).call();
    const hash = await SecretNote.methods.allHashedNotes(i).call();
    notes.push({hash})
  }
  console.log('allnotes', notes)
  return notes;
}

function getNoteHash(address, amount) {
  // pad address and amount to 32bytes
  let _address = new BN(address, 16).toString(16, 64);
  let _amount = new BN(amount, 16).toString(16, 64); // 32 bytes = 64 chars in hex
  console.log(_address, _amount)
  const buf = Buffer.from(_address + _amount, 'hex');
  const digest = crypto.createHash('sha256').update(buf).digest('hex');
  console.log('digest', digest)
  return digest;
}

async function decrypt(cipher, userAccount) {
  // let payload = await web3.eth.accounts.decrypt(JSON.parse(cipher), 'vitalik').privateKey
  const address = cipher.slice(0, 40).toLowerCase();
  const amount = cipher.slice(40);
  console.log(address, amount)
  return {isMine: address === userAccount.toLowerCase(), amount}
  // console.log('decrypt', address, userAccount)
  // return true;
  // payload = payload.slice(2)
  // const amount = payload.slice(40)
  // console.log(address, amount);

  
}


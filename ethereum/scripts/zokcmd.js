const crypto = require('crypto');
const BN = require('bn.js');

function getSecretZokratesParams(concat) {
  return [concat.slice(0, 32), concat.slice(32, 64), concat.slice(64, 96), concat.slice(96)]//.map(e => e.toString(10))
}

function getPublicZokratesParams(hexPayload) {
  // console.log('getPublicZokratesParams - hexPayload', hexPayload)
  const buf = Buffer.from(hexPayload, 'hex');
  const digest = crypto.createHash('sha256').update(buf).digest('hex');
  // console.log('digest', digest)
  // split into 128 bits each
  return [digest.slice(0, 32), digest.slice(32)]
}

function getHexPayload(from, amount) {
  let paddedAddress = new BN(from, 16).toString(16, 64);
  let paddedAmount = new BN(amount, 16).toString(16, 64);
  return paddedAddress + paddedAmount;
}

function getNoteParams(from, amount) {
  let hexPayload = getHexPayload(from, amount);
  // console.log('hexPayload', hexPayload)
  let zkParams = getPublicZokratesParams(hexPayload).concat(getSecretZokratesParams(hexPayload));
  return zkParams;
}

function printZokratesCommand(params) {
  let cmd = './zokrates compute-witness -a '
  params.forEach(p => {
    cmd += `${new BN(p, 16).toString(10)} `
  })
  console.log(cmd);
}

function getTransferZkParams(from, fromAmount, to, toAmount) {
  from = from.slice(2);
  fromAmount = fromAmount.slice(2);
  to = to.slice(2);
  toAmount = toAmount.slice(2);

  let change = parseInt(fromAmount, 16) - parseInt(toAmount, 16);
  const params = getNoteParams(from, fromAmount).concat(getNoteParams(to, toAmount));
  let leftOver = getNoteParams(from, change);
  // for the leftover change note, first 2 params (spender public key) are the same. delete elements at 2, 3 index
  leftOver.splice(2, 2);
  printZokratesCommand(params.concat(leftOver));
}

getTransferZkParams(
  '0x3644B986B3F5Ba3cb8D5627A22465942f8E06d09', // sender
  '0xb', // value of the secret note
  '0x9e8f633D0C46ED7170EF3B30E291c64a91a49C7E', // receiver
  '0x9' // value to be sent
);

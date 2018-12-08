const crypto = require('crypto');
const BN = require('bn.js');

function getSecretZokratesParams(concat) {
  return [concat.slice(0, 32), concat.slice(32, 64), concat.slice(64, 96), concat.slice(96)]//.map(e => e.toString(10))
}

function getPublicZokratesParams(hexPayload) {
  console.log('getPublicZokratesParams', hexPayload)
  const buf = Buffer.from(hexPayload, 'hex');
  const digest = crypto.createHash('sha256').update(buf).digest('hex');
  console.log('digest', digest, digest.length)
  // split into 128 bits each
  console.log([digest.slice(0, 32), digest.slice(32)]);
  return [digest.slice(0, 32), digest.slice(32)]
}

function getHexPayload(from, amount) {
  let paddedAddress = new BN(from, 16).toString(16, 64);
  let paddedAmount = new BN(amount, 16).toString(16, 64);
  return paddedAddress + paddedAmount;
}

function getNoteParams(from, amount) {
  let hexPayload = getHexPayload(from, amount);
  let zkParams = getPublicZokratesParams(hexPayload).concat(getSecretZokratesParams(hexPayload));
  return zkParams;
}

function printZokratesCommand(params) {
  let cmd = '../zokrates compute-witness -a '
  params.forEach(p => {
    cmd += `${new BN(p, 16).toString(10)} `
  })
  console.log(cmd);
}

function getTransferZkParams(from, fromAmount) {
  from = from.slice(2);
  const params = getNoteParams(from, fromAmount);
  printZokratesCommand(params);
}

getTransferZkParams('0x3644B986B3F5Ba3cb8D5627A22465942f8E06d09', '2')

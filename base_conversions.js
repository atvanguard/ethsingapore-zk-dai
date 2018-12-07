const crypto = require('crypto');

var k=Buffer.from('00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005','hex')
// console.log(k.length)

// var b = parseInt(k.toString('hex'), 16)
// console.log(b.toString(2))

// const hash = crypto.createHash('sha256').update(k).digest('hex');
// console.log(hash);

/*
var t = Buffer.from('F0188aa23d6D63091Dff507A1A242f99 c521Efb5000000000000000000000000 00000000000000000000000000000000 00000000000000000000000000000005')
*/
var t = Buffer.from('000000000000000000000000F0188aa23d6D63091Dff507A1A242f99c521Efb50000000000000000000000000000000000000000000000000000000000000005', 'hex')
// var t = Buffer.from('00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000005', 'hex')
// var t = Buffer.from('000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000', 'hex')
// // console.log(t.length)
// // console.log(crypto.createHash('sha256').update(k).digest('hex'))
// console.log(crypto.createHash('sha256').update(t).digest('hex'))

const BN = require('bn.js');
// var i1 = new BN('263561599766550617289250058199814760685', 10)
// var i2 = new BN('65303172752238645975888084098459749904', 10)
// inverted - c6481e22c5ff4164af680b8cfaa5e8ed3120eeff89c4f307c4a6faaae059ce10

var i1 = new BN('286550427305488977394924694994018785834', 10)
var i2 = new BN('205474949803715015552170743613827585172', 10)
// d7939ad79c5e3327dbec1c78f49a5a2a9a95092e703b99a4e4593cd21fdc1494

var bin = i1.toString(2, 128) + i2.toString(2, 128);
var hex = new BN(bin, 2).toString(16)
console.log(hex);

const hash = crypto.createHash('sha256').update(t).digest('hex');
console.log(hash); // sha256 solidity hash

// hex to base 10
console.log(`./zokrates compute-witness -a \
${new BN('000000000000000000000000F0188aa2', 16).toString(10)} \
${new BN('3d6D63091Dff507A1A242f99c521Efb5', 16).toString(10)} \
${new BN('00000000000000000000000000000000', 16).toString(10)} \
${new BN('00000000000000000000000000000005', 16).toString(10)}
`);
// console.log()

// ./zokrates compute-witness -a console.log(new BN('1', 16).toString(10))
// console.log(new BN('0', 16).toString(10))
// console.log(new BN('00000000000000000000000000000000', 16).toString(10))
// console.log(new BN('00000000000000000000000000000005', 16).toString(10))

// ./zokrates compute-witness -a 319142145939483102797243700616014081945 262034122802152764104867925078604513280 0 5
// ./zokrates compute-witness -a 1 0 0 5

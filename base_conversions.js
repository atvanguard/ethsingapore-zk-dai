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
// var t = Buffer.from('F0188aa23d6D63091Dff507A1A242f99c521Efb50000000000000000000000000000000000000000000000000000000000000000000000000000000000000005', 'hex')
// // console.log(t.length)
// // console.log(crypto.createHash('sha256').update(k).digest('hex'))
// console.log(crypto.createHash('sha256').update(t).digest('hex'))

const BN = require('bn.js');
// var i1 = new BN('263561599766550617289250058199814760685', 10)
// var i2 = new BN('65303172752238645975888084098459749904', 10)
// var bin = i1.toString(2, 128) + i2.toString(2, 128);
// var hex = new BN(bin, 2).toString(16)
// console.log(hex);

 // hex to base 10
console.log(new BN('F0188aa23d6D63091Dff507A1A242f99', 16).toString(10))
console.log(new BN('c521Efb5000000000000000000000000', 16).toString(10))
console.log(new BN('00000000000000000000000000000000', 16).toString(10))
console.log(new BN('00000000000000000000000000000005', 16).toString(10))

319142145939483102797243700616014081945
262034122802152764104867925078604513280
0
5

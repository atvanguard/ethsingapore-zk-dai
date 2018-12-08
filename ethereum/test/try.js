const fs = require('fs');
const BN = require('bn.js');

// const proofJson = JSON.parse(fs.readFileSync('./zksnark/proof.json', 'utf8'));
//     const proof = proofJson.proof;
//     const input = proofJson.input;
//     console.log(input.toString())
    let proofJson = fs.readFileSync('./zksnark/proof.json', 'utf8');
    // console.log(proofJson)
    var rx2 = /([0-9]+)[,]/gm
    console.log(proofJson.match(rx2))
    proofJson.match(rx2).forEach(p => {
      proofJson = proofJson.replace(p, `"${p.slice(0, p.length-1)}",`)
    })
    proofJson = JSON.parse(proofJson);
    console.log(proofJson)
    // console.log(new BN(proofJson.input[0].toString()).toString())
    // console.log(JSON.stringify(proofJson.input))
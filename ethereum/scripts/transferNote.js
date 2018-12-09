// const contractArtifact = artifacts.require('./SecretNote.sol');
// import secretNoteContract from './listener.js';
const abi = [
  {
    "constant": false,
    "inputs": [
      {
        "name": "a",
        "type": "uint256[2]"
      },
      {
        "name": "a_p",
        "type": "uint256[2]"
      },
      {
        "name": "b",
        "type": "uint256[2][2]"
      },
      {
        "name": "b_p",
        "type": "uint256[2]"
      },
      {
        "name": "c",
        "type": "uint256[2]"
      },
      {
        "name": "c_p",
        "type": "uint256[2]"
      },
      {
        "name": "h",
        "type": "uint256[2]"
      },
      {
        "name": "k",
        "type": "uint256[2]"
      },
      {
        "name": "input",
        "type": "uint256[7]"
      }
    ],
    "name": "verifyTx",
    "outputs": [
      {
        "name": "r",
        "type": "bool"
      }
    ],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function",
    "signature": "0x1cdf1357"
  },
  {
    "constant": true,
    "inputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "name": "allHashedNotes",
    "outputs": [
      {
        "name": "",
        "type": "bytes32"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function",
    "signature": "0x58a5d596"
  },
  {
    "constant": true,
    "inputs": [
      {
        "name": "",
        "type": "bytes32"
      }
    ],
    "name": "notes",
    "outputs": [
      {
        "name": "",
        "type": "uint8"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function",
    "signature": "0x85de26b7"
  },
  {
    "constant": true,
    "inputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "name": "allNotes",
    "outputs": [
      {
        "name": "",
        "type": "string"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function",
    "signature": "0xddabcf41"
  },
  {
    "inputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "constructor",
    "signature": "constructor"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "m",
        "type": "bytes32"
      },
      {
        "indexed": false,
        "name": "m2",
        "type": "bytes32"
      }
    ],
    "name": "debug",
    "type": "event",
    "signature": "0x02451fae0adb7ceff4e670c0e623b1c9e0b2898e612e291ad76e596de0a2d053"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "to",
        "type": "address"
      },
      {
        "indexed": false,
        "name": "amount",
        "type": "uint256"
      }
    ],
    "name": "Claim",
    "type": "event",
    "signature": "0x47cee97cb7acd717b3c0aa1435d004cd5b3c8c57d70dbceb4e4458bbd60e39d4"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "noteId",
        "type": "bytes32"
      },
      {
        "indexed": false,
        "name": "index",
        "type": "uint256"
      }
    ],
    "name": "NoteCreated",
    "type": "event",
    "signature": "0xc904a92388c152c0c63dfe30e3e880273673ef7d33ea18195aecb5ba50f546fc"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "a",
        "type": "bytes16"
      },
      {
        "indexed": false,
        "name": "b",
        "type": "bytes16"
      }
    ],
    "name": "d2",
    "type": "event",
    "signature": "0xd278e8c3a630dc4a7eb08180a3880316949e0f4b449df0b97df01512353786ce"
  },
  {
    "anonymous": false,
    "inputs": [
      {
        "indexed": false,
        "name": "s",
        "type": "string"
      }
    ],
    "name": "Verified",
    "type": "event",
    "signature": "0x3f3cfdb26fb5f9f1786ab4f1a1f9cd4c0b5e726cbdfc26e495261731aad44e39"
  },
  {
    "constant": true,
    "inputs": [],
    "name": "getNotesLength",
    "outputs": [
      {
        "name": "",
        "type": "uint256"
      }
    ],
    "payable": false,
    "stateMutability": "view",
    "type": "function",
    "signature": "0xeb3d72d1"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "owner",
        "type": "address"
      },
      {
        "name": "amount",
        "type": "uint256"
      },
      {
        "name": "encryptedNote",
        "type": "string"
      }
    ],
    "name": "createNoteDummy",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function",
    "signature": "0xd9758ae0"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "amount",
        "type": "uint256"
      }
    ],
    "name": "claimNote",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function",
    "signature": "0xa4654ead"
  },
  {
    "constant": false,
    "inputs": [
      {
        "name": "a",
        "type": "uint256[2]"
      },
      {
        "name": "a_p",
        "type": "uint256[2]"
      },
      {
        "name": "b",
        "type": "uint256[2][2]"
      },
      {
        "name": "b_p",
        "type": "uint256[2]"
      },
      {
        "name": "c",
        "type": "uint256[2]"
      },
      {
        "name": "c_p",
        "type": "uint256[2]"
      },
      {
        "name": "h",
        "type": "uint256[2]"
      },
      {
        "name": "k",
        "type": "uint256[2]"
      },
      {
        "name": "input",
        "type": "uint256[7]"
      },
      {
        "name": "encryptedNote1",
        "type": "string"
      },
      {
        "name": "encryptedNote2",
        "type": "string"
      }
    ],
    "name": "transferNote",
    "outputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "function",
    "signature": "0x573d7339"
  }
]

const secretNoteAddress = '0x9960818c27697f89b9639eb5ec6f8437172ef8af'

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
  
  const encNote1 = await encrypt('9e8f633D0C46ED7170EF3B30E291c64a91a49C7E', '9');
  const encNote2 = await encrypt('3644B986B3F5Ba3cb8D5627A22465942f8E06d09', '2');
  // console.log(..._proof, encNote1, encNote2)
  console.log('calling transferNote with params', ..._proof, encNote1, encNote2);
  let secretNoteContract = new web3.eth.Contract(abi, secretNoteAddress);

  try {
    await secretNoteContract.methods.transferNote(..._proof, encNote1, encNote2)
    .send({
      from: '0x2B522cABE9950D1153c26C1b399B293CaA99FcF9',
      gasPrice: '0x' + parseInt('10000000000').toString(16)
    })
    // const tx = await instance.transferNote(..._proof, encNote1, encNote2);
    // console.dir(tx, {depth: null});
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
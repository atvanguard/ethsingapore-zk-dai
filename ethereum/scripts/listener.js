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
    "type": "function"
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
    "type": "function"
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
    "type": "function"
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
    "type": "function"
  },
  {
    "inputs": [],
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "constructor"
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
    "type": "event"
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
    "type": "event"
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
    "type": "event"
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
    "type": "event"
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
    "type": "function"
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
    "type": "function"
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
    "type": "function"
  }
]

// import Web3 from 'web3';
const Web3 = require('web3');
const BN = require('bn.js')
// const provider = new Web3.providers.HttpProvider(
//   'https://ropsten.infura.io/v3/6dfe769f94364017b82a58d6b5c3543e'
// );

// let web3 = new Web3(provider);
const _web3 = new Web3(new Web3.providers.WebsocketProvider('wss://ropsten.infura.io/ws'))

let daiContract = new _web3.eth.Contract([{"constant":true,"inputs":[],"name":"mintingFinished","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"name","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_value","type":"uint256"}],"name":"approve","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"totalSupply","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transferFrom","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"decimals","outputs":[{"name":"","type":"uint8"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_amount","type":"uint256"}],"name":"mint","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_value","type":"uint256"}],"name":"burn","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_subtractedValue","type":"uint256"}],"name":"decreaseApproval","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"}],"name":"balanceOf","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"renounceOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_from","type":"address"},{"name":"_value","type":"uint256"}],"name":"burnFrom","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[],"name":"finishMinting","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[],"name":"owner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"symbol","outputs":[{"name":"","type":"string"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_to","type":"address"},{"name":"_value","type":"uint256"}],"name":"transfer","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":false,"inputs":[{"name":"_spender","type":"address"},{"name":"_addedValue","type":"uint256"}],"name":"increaseApproval","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"},{"constant":true,"inputs":[{"name":"_owner","type":"address"},{"name":"_spender","type":"address"}],"name":"allowance","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[{"name":"_newOwner","type":"address"}],"name":"transferOwnership","outputs":[],"payable":false,"stateMutability":"nonpayable","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"},{"anonymous":false,"inputs":[{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"amount","type":"uint256"}],"name":"Mint","type":"event"},{"anonymous":false,"inputs":[],"name":"MintFinished","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"previousOwner","type":"address"}],"name":"OwnershipRenounced","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"previousOwner","type":"address"},{"indexed":true,"name":"newOwner","type":"address"}],"name":"OwnershipTransferred","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"burner","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Burn","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"owner","type":"address"},{"indexed":true,"name":"spender","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Approval","type":"event"},{"anonymous":false,"inputs":[{"indexed":true,"name":"from","type":"address"},{"indexed":true,"name":"to","type":"address"},{"indexed":false,"name":"value","type":"uint256"}],"name":"Transfer","type":"event"}],
'0xaD6D458402F60fD3Bd25163575031ACDce07538D');

const secretNoteAddress = '0x1578d87c52be8bcddb6d8f8e9b3749e06ad814d0'
// const secretNoteAddress = '0xc7a5b080b59621281fa9bd9ea40fb6d8942a69d2'

let secretNoteContract = new web3.eth.Contract(abi, secretNoteAddress);
// exports.module = {secretNoteAddress, abi};

const options = {
  filter: {
    to:    secretNoteAddress,
    from: '0x91a502C678605fbCe581eae053319747482276b9',
  },
  fromBlock: 'latest'
}

async function execute() {
  console.log('here')
  try {
    await createNote('3644B986B3F5Ba3cb8D5627A22465942f8E06d09', 'af');
  } catch(e) {
    console.log(e)
  }
  return new Promise((resolve, reject) => {
    daiContract.events.Transfer(options,
      async (error, event) => {
        if (error) {
          console.log(error)
          return
        }
        console.log(event);

        // create secret note
        try {
          const tx = await web3.eth.getTransaction(event.transactionHash)
          const benefiaciary = tx.from.slice(2);
          const val = new BN(event.returnValues.value, 10).div(new BN('1000000000000000000')).toString('hex')
          await createNote(benefiaciary, val);
        } catch(e) {
          console.log(e)
        }
    })
  })
}

async function createNote(address, amount) {
  let enc = encrypt(address, amount);
  console.log('enc', enc)
  await secretNoteContract.methods.createNoteDummy('0x' + address, '0x' + amount, enc)
  .send({
    from: '0x2B522cABE9950D1153c26C1b399B293CaA99FcF9',
    gasPrice: '0x' + parseInt('10000000000').toString(16)
  })
}

function encrypt(address, _amount) {
  let amount = new BN(_amount, 16).toString(16, 24); // 12 bytes = 24 chars in hex
  const payload = address + amount;
  return payload;
}

module.exports = async function(callback) {
  // perform actions
  await execute();
  callback();
}
#!/usr/bin/env node
const fs = require('fs');
const moment = require('moment');
const Web3 = require('web3');

process.on('unhandledRejection', console.error.bind(console));

const rpcUrl = 'http://localhost:8545'; // ganache-cli
const web3 = new Web3(new Web3.providers.HttpProvider(rpcUrl));

const KyberNetworkProxyABI = JSON.parse(fs.readFileSync('./abi/KyberNetworkProxy.abi', 'utf8'));
const KyberNetworkProxyAddress = '0xF6084Ad447076da0246cD28e104533f9f51dbD2F';
const NetworkProxyInstance = new web3.eth.Contract(KyberNetworkProxyABI, KyberNetworkProxyAddress);

const ETH_ADDRESS = '0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee';
const KNC_ADDRESS = '0x8c13AFB7815f10A8333955854E6ec7503eD841B7';
const OMG_ADDRESS = '0x3750bE154260872270EbA56eEf89E78E6E21C1D9';
const MANA_ADDRESS = '0xe19Ec968c15f487E96f631Ad9AA54fAE09A67C8c';

function stdlog(input) {
  console.log(`${moment().format('YYYY-MM-DD HH:mm:ss.SSS')}] ${input}`);
}

async function main() {
  let expectedRate;
  let slippageRate;

  stdlog('- START -');
  stdlog(`KyberNetworkProxy (${KyberNetworkProxyAddress})`);

  ({ expectedRate, slippageRate } = await NetworkProxyInstance.methods.getExpectedRate(
    ETH_ADDRESS, // srcToken
    KNC_ADDRESS, // destToken
    web3.utils.toWei('1'), // srcQty
  ).call());
  stdlog(`ETH <-> KNC getExpectedRate() = expectedRate: ${expectedRate}, slippageRate:${slippageRate}`);

  ({ expectedRate, slippageRate } = await NetworkProxyInstance.methods.getExpectedRate(
    KNC_ADDRESS, // srcToken
    ETH_ADDRESS, // destToken
    web3.utils.toWei('1'), // srcQty
  ).call());
  stdlog(`KNC <-> ETH getExpectedRate() = expectedRate: ${expectedRate}, slippageRate:${slippageRate}`);

  ({ expectedRate, slippageRate } = await NetworkProxyInstance.methods.getExpectedRate(
    KNC_ADDRESS, // srcToken
    OMG_ADDRESS, // destToken
    web3.utils.toWei('1'), // srcQty
  ).call());
  stdlog(`KNC <-> OMG getExpectedRate() = expectedRate: ${expectedRate}, slippageRate:${slippageRate}`);

  ({ expectedRate, slippageRate } = await NetworkProxyInstance.methods.getExpectedRate(
    ETH_ADDRESS, // srcToken
    MANA_ADDRESS, // destToken
    web3.utils.toWei('1'), // srcQty
  ).call());
  stdlog(`ETH <-> MANA getExpectedRate() = expectedRate: ${expectedRate}, slippageRate:${slippageRate}`);

  ({ expectedRate, slippageRate } = await NetworkProxyInstance.methods.getExpectedRate(
    MANA_ADDRESS, // srcToken
    ETH_ADDRESS, // destToken
    web3.utils.toWei('1'), // srcQty
  ).call());
  stdlog(`MANA <-> ETH getExpectedRate() = expectedRate: ${expectedRate}, slippageRate:${slippageRate}`);

  ({ expectedRate, slippageRate } = await NetworkProxyInstance.methods.getExpectedRate(
    KNC_ADDRESS, // srcToken
    MANA_ADDRESS, // destToken
    web3.utils.toWei('1'), // srcQty
  ).call());
  stdlog(`KNC <-> KNC getExpectedRate() = expectedRate: ${expectedRate}, slippageRate:${slippageRate}`);

  stdlog('- END -');
}

// Start the script
main();

var HDWalletProvider = require("truffle-hdwallet-provider");
const MNEMONIC = 'vibrant round obscure celery gravity obey explain sauce coffee lecture glow dwarf';

/*
 * NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a 
 * function when declaring them. Failure to do so will cause commands to hang. ex:
 * ```
 * mainnet: {
 *     provider: function() { 
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>') 
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 9545,
      network_id: "*" // Match any network id
    },
    ropsten: {
      provider: function () {
        return new HDWalletProvider(MNEMONIC, "https://kovan.infura.io/v3/f2aa27e5bf2b4bf1b3b002e8687b61da")
      },
      network_id: 42,
      gas: 3000000      //make sure this gas allocation isn't over 4M, which is the max
    }
  },
};
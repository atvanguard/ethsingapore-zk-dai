// var verifier = artifacts.require("./verifier.sol");
var SecretNote = artifacts.require("./SecretNote.sol");

module.exports = function(deployer) {
  // deployer.deploy(SecretNote, 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee, 0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
  deployer.deploy(SecretNote);
};

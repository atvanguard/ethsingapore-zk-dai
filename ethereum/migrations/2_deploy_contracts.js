var verifier = artifacts.require("./verifier.sol");

module.exports = function(deployer) {
  deployer.deploy(verifier);
};

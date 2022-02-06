const Voting = artifacts.require("./Voting.sol");
const Survey = artifacts.require("./Survey.sol");

module.exports = function (deployer) {
    deployer.deploy(Voting);
    deployer.deploy(Survey);
}
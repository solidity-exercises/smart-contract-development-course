var Ownable = artifacts.require('../contracts/Ownable.sol');
var PeopleBalances = artifacts.require('../contracts/PeopleBalances.sol')

module.exports = function(deployer) {
    deployer.deploy(Ownable);
    deployer.deploy(PeopleBalances);
}
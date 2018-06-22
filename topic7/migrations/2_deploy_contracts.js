var SafeMath = artifacts.require('../contracts/SafeMath.sol');
var Ownable = artifacts.require('../contracts/Ownable.sol');
var Destructible = artifacts.require('../contracts/Destructible.sol');
var Membership = artifacts.require('../contracts/Membership.sol');

module.exports = function(deployer) {
    deployer.deploy(SafeMath);
    deployer.deploy(Ownable);
    deployer.deploy(Destructible);
    deployer.deploy(Membership);
}
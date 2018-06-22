var SafeMath = artifacts.require('../contracts/SafeMath.sol');
var ERC20 = artifacts.require('../contracts/ERC20.sol');
var ICO = artifacts.require('../contracts/ICO.sol');

module.exports = function(deployer) {
    deployer.deploy(SafeMath);
    deployer.deploy(ERC20);
    deployer.deploy(ICO);
}
const SafeMath = artifacts.require('../contracts/SafeMath.sol');
// const DogeCoin = artifacts.require('../contracts/DogeCoin.sol');
const StandardToken = artifacts.require('../contracts/StandardToken.sol');

module.exports = function(deployer) {
    deployer.deploy(SafeMath);
    deployer.link(SafeMath, StandardToken);
    console.log("fdafgu891et jidajfgadlj glad jgil dildjagdilagjdl")
    deployer.deploy(StandardToken);
}
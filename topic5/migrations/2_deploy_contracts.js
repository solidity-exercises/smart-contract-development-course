const Owned = artifacts.require('../contracts/Owned.sol');
const Faucet = artifacts.require('../contracts/Faucet.sol');
const Service = artifacts.require('../contracts/Service.sol');

module.exports = (deployer) => {
    deployer.deploy(Owned);
    deployer.deploy(Faucet);
    deployer.deploy(Service);
}
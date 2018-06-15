const Math = artifacts.require('../contracts/Math.sol');

module.exports = (deployer) => {
	deployer.deploy(Math);
};

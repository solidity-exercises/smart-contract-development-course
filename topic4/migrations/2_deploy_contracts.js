const HelloWorld = artifacts.require('../contracts/HelloWorld.sol');

module.exports = (deployer) => {
	deployer.deploy(HelloWorld);
};

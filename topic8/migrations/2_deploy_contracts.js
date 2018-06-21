const Pokemons = artifacts.require("../contracts/Pokemons.sol");

module.exports = (deployer) => {
	deployer.deploy(Pokemons);
};
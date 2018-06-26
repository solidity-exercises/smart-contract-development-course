const HelloWorld = artifacts.require('../contracts/HelloWorld.sol');

const testUtil = require('./utils/test.util.js');

contract('HelloWorld', () => {
	let sut;

	beforeEach(async () => {
		sut = await HelloWorld.new();
	});

	it('greet Should return expected value', async () => {
		// Arrange
		const expectedGreet = web3.fromAscii('Hello World!').padEnd(66, '0');
		// Act
		const greet = await sut.greet.call();
		// Assert
		assert.equal(greet, expectedGreet);
	});
});
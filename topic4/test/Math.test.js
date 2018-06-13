const Math = artifacts.require('../contracts/Math.sol');

const testUtil = require('./utils/test.util.js');

contract('Math', () => {
	let sut;

	beforeEach(async () => {
		sut = await Math.new();
	});

	// Tests naming:
	// [functionName] [Should -> what do we expect the function to do] [When - in what circumstances]
	it('stateNumber Should be zero When instantiating contract', async () => {
		// Arrange
		// Act
		// Assert
	});

	it('add Should throw When overflow occurs', async () => {
		// Arrange
		// Act
		// Assert
	});

	it('add Should add `_inputNumber` to the stateNumber When passed valid argument', async () => {
		// Arrange
		// Act
		// Assert
	});

	it('sub Should throw When underflow occurs', async () => {
		// Arrange
		// Act
		// Assert
	});

	it('sub Should subtract `_inputNumber` from the stateNumber When passed valid argument', async () => {
		// Arrange
		// Act
		// Assert
	});

	it('mul Should throw When overflow occurs', async () => {
		// Arrange
		// Act
		// Assert
	});

	it('mul Should multiply the stateNumber with the `_inputNumber` When passed valid argument', async () => {
		// Arrange
		// Act
		// Assert
	});

	// It should throw automatically, even if you have no guard clause, but a test won't do no harm.
	it('div Should throw When dividing the stateNumber by 0', async () => {
		// Arrange
		// Act
		// Assert
	});

	it('div Should divide the stateNumber with the `_inputNumber` When passed valid argument', async () => {
		// Arrange
		// Act
		// Assert
	});

	it('pow Should throw When overflow occurs', async () => {
		// Arrange
		// Act
		// Assert
	});

	it('pow Should raise the stateNumber to the `_inputNumber`-th power When passed valid argument', async () => {
		// Arrange
		// Act
		// Assert
	});

	it('mod Should return the remainder of dividing the stateNumber by the `_inputNumber` When passed valid argument', async () => {
		// Arrange
		// Act
		// Assert
	});
});
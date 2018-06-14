const Math = artifacts.require('../contracts/Math.sol');

const testUtil = require('./utils/test.util.js');

contract('Math', () => {
	let sut;
	
	const uint256MaxValue = '115792089237316195423570985008687907853269984665640564039457584007913129639935';

	beforeEach( async () => {
		sut = await Math.new();
	});

	// Tests naming:
	// [functionName] [Should -> what do we expect the function to do] [When - in what circumstances]
	it('stateNumber Should be zero When instantiating contract', async () => {
		// Arrange
		const stateNumber = await sut.stateNumber.call();
		// Act
		// Assert
		assert.equal(stateNumber, 0);
	});

	it('resetStateNumber Should reset the stateNumber value to 0 When invoked', async () => {
		// Arrange
		await sut.add(42);
		const currentStateNumber = await sut.stateNumber.call();
		assert.isTrue(currentStateNumber != 0);
		// Act
		await sut.resetStateNumber();
		const resetStateNumber = await sut.stateNumber.call();
		// Assert
		assert.equal(resetStateNumber, 0);
	});

	it('add Should throw When overflow occurs', async () => {
		// Arrange
		await sut.add(1);
		// Act
		const result = sut.add(uint256MaxValue);
		// Assert
		await testUtil.assertThrow(result);
	});

	it('add Should add `_inputNumber` to the stateNumber When passed valid argument', async () => {
		// Arrange
		const valueToAdd = 42;
		// Act
		await sut.add(valueToAdd);
		const currentStateNumber = await sut.stateNumber.call();
		// Assert
		assert.equal(currentStateNumber, valueToAdd);
	});

	it('sub Should throw When underflow occurs', async () => {
		// Arrange
		// Act
		const result = sut.sub(1);
		// Assert
		await testUtil.assertThrow(result);
	});

	it('sub Should subtract `_inputNumber` from the stateNumber When passed valid argument', async () => {
		// Arrange
		const valueToAdd = 42;
		await sut.add(valueToAdd);

		const valueToSubtract = 32;
		// Act
		await sut.sub(valueToSubtract);
		const currentStateNumber = await sut.stateNumber.call();
		// Assert
		assert.equal(currentStateNumber, valueToAdd - valueToSubtract);
	});

	it('mul Should throw When overflow occurs', async () => {
		// Arrange
		await sut.add(2);
		// Act
		const result = sut.mul(uint256MaxValue);
		// Assert
		await testUtil.assertThrow(result);
	});

	it('mul Should multiply the stateNumber with the `_inputNumber` When passed valid argument', async () => {
		// Arrange
		const valueToAdd = 42;
		await sut.add(valueToAdd);

		const multiplier = 2;
		// Act
		await sut.mul(multiplier);

		const currentStateNumber = await sut.stateNumber.call();
		// Assert
		assert.equal(currentStateNumber, valueToAdd * multiplier);
	});

	// It should throw automatically, even if you have no guard clause, but a test won't do no harm.
	it('div Should throw When dividing the stateNumber by 0', async () => {
		// Arrange
		// Act
		const result = sut.div(0);
		// Assert
		await testUtil.assertThrow(result);
	});

	it('div Should divide the stateNumber with the `_inputNumber` When passed valid argument', async () => {
		// Arrange
		const valueToAdd = 42;
		await sut.add(valueToAdd);

		const divisor = 42;
		// Act
		await sut.div(divisor);

		const currentStateNumber = await sut.stateNumber.call();
		// Assert
		assert.equal(currentStateNumber, valueToAdd / divisor);
	});

	it('pow Should throw When overflow occurs', async () => {
		// Arrange
		const valueToAdd = 42;
		await sut.add(valueToAdd);
		// Act
		const result = sut.pow(uint256MaxValue);
		// Assert
		await testUtil.assertThrow(result);
	});

	it('pow Should raise the stateNumber to the `_inputNumber`-th power When passed valid argument', async () => {
		// Arrange
		const valueToAdd = 2;
		await sut.add(valueToAdd);

		const empower = 32;
		// Act
		await sut.pow(empower);

		const currentStateNumber = await sut.stateNumber.call();
		// Assert
		assert.equal(currentStateNumber, 4294967296);
	});

	it('mod Should return the remainder of dividing the stateNumber by the `_inputNumber` When passed valid argument', async () => {
		// Arrange
		const valueToAdd = 5;
		await sut.add(valueToAdd);
		
		const modulus = 3;
		// Act
		await sut.mod(modulus);

		const currentStateNumber = await sut.stateNumber.call();
		// Assert
		assert.equal(currentStateNumber, valueToAdd % modulus);
	});
});
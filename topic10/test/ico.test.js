const DogeCoin = artifacts.require('../contracts/DogeCoin.sol');

const testUtil = require('./utils/test.util.js');

contract('DogeCoin', (accounts) => {
    let sut;
    
	beforeEach( async () => {
		sut = await DogeCoin.new();
    });

    it('buy Should not allow people to purchase tokens When crowdsale ends', async () => {
        // Arrange
        const buyer = accounts[1];

        // Act
        await testUtil.increaseTime(testUtil.constants.hours(4));

        const buy = sut.buy({from: buyer, value: web3.toWei('3', 'ether')});

        // Assert
        await testUtil.assertRevert(buy);
    });
});
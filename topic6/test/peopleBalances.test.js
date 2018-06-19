const PeopleBalances = artifacts.require('../contracts/PeopleBalances.sol');

const testUtil = require('./utils/test.util.js');

contract('PeopleBalances', (accounts) => {
    let sut;
    
	beforeEach( async () => {
		sut = await PeopleBalances.new();
    });
    
    it('balances Should change When someone buys tokens', async () => {
        // Arrange
        const buyer = accounts[1];
        const buyAmount = web3.toWei('2', 'ether');
    
        // Act
        await sut.buy({from: buyer, value: buyAmount});

        const buyerBalance = await sut.balances.call(buyer);
        // Assert
        assert.equal(buyerBalance, buyAmount*5);
    });
    it('buy Should revert When someone tries to buy outside of crowdsale period', async () => {
        // Arrange
        const buyer = accounts[1];
        const buyAmount = web3.toWei('2', 'ether');
    
        // Act
        await testUtil.increaseTime(testUtil.constants.minutes(6));
        const purchase = sut.buy({from: buyer, value: buyAmount});

        // Assert
        await testUtil.assertRevert(purchase);
    });
    it('transfer Should exchange tokens between people When called', async () => {
        // Arrange
        const fromAcc = accounts[1];
        const toAcc = accounts[2];
        const transferAmount = web3.toWei('10', 'ether');

        await sut.buy({from: fromAcc, value: web3.toWei('3', 'ether')});
        await testUtil.increaseTime(testUtil.constants.minutes(6));
        // Act

        await sut.transferTokens(toAcc, transferAmount, {from: fromAcc});

        const toAccBalance = await sut.balances.call(toAcc);
        const fromAccBalance = await sut.balances.call(fromAcc);
        // Assert

        assert.equal(toAccBalance, transferAmount);
        assert.equal(fromAccBalance.valueOf(), web3.toWei('5', 'ether'));
    });
    it('transfer Should revert When called before end of crowdsale', async () => {
        // Arrange
        const fromAcc = accounts[1];
        const toAcc = accounts[2];
        const transferAmount = 10;

        // Act
        const transfer = sut.transferTokens(toAcc, transferAmount, {from: fromAcc});

        // Assert
        await testUtil.assertRevert(transfer);
    });
    it('withdraw Should give withdrawAmount of money to owner When called', async () => {
        // Arrange
        const owner = accounts[0];
        const withdrawAmount = web3.toWei('2', 'ether');

        await sut.buy({from: accounts[1], value: web3.toWei('3', 'ether')});
        await testUtil.increaseTime(testUtil.constants.years(1));

        // Act
        await sut.withdraw(withdrawAmount, {from: owner});

        const contractBalance = await sut.getContractBalance.call();
        // Assert
        assert.equal(contractBalance, web3.toWei('1', 'ether'));
    });
    it('withdraw Should revert When not Owner call it', async () => {
        const notOwner = accounts[1];
        const withdrawAmount = web3.toWei('2', 'ether');

        await testUtil.increaseTime(testUtil.constants.years(1));

        // Act
        const withdraw = sut.withdraw(withdrawAmount, {from: notOwner});

        // Assert
        await testUtil.assertRevert(withdraw);
    });
    it('withdraw Should revert When 1 year has not passed since contract creation', async () => {
        const notOwner = accounts[1];
        const withdrawAmount = web3.toWei('2', 'ether');

        // Act
        const withdraw = sut.withdraw(withdrawAmount, {from: notOwner});

        // Assert
        await testUtil.assertRevert(withdraw);
    });
});
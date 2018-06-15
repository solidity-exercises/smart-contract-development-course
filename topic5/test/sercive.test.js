const Service = artifacts.require('../contracts/Service.sol');

const testUtil = require('./utils/test.util.js');

contract('Service', (accounts) => {
    let sut;

    beforeEach( async () => {
        sut = await Service.new();
    });
    
    it('contract Should receive 1 ETH When someone buys a service', async () => {
        // Arrange
        const balanceBefore = await sut.getContractBalance.call();
        const payment = await web3.toWei('1', 'ether');

        // Act
        await sut.buyService({from: accounts[1], value: payment});

        const contractBalance = await sut.getContractBalance.call();
        // Assert
        assert.equal(contractBalance, payment);
    });
    it('withdraw Should send owner ETH When owner withdraws money', async () => {
        // Arrange
        const owner = accounts[0];
        const withdrawAmount = web3.toWei('1', 'ether');

        const payment = await web3.toWei('1', 'ether');
        await sut.buyService({from: accounts[1], value: payment});

        const contractBalanceBefore = await sut.getContractBalance.call();
        // Act
        await sut.withdraw(withdrawAmount, {from: owner});

        const contractBalanceAfter = await sut.getContractBalance.call();
        // Assert
        assert.equal(contractBalanceBefore - withdrawAmount, contractBalanceAfter);
    });
    it('withdraw Should revert When not owner withdraws money', async () => {
        // Arrange
        const notOwner = accounts[1];
        const withdrawAmount = web3.toWei('2', 'ether');

        // Act
        const withdraw = sut.withdraw(withdrawAmount, {from: notOwner});
        
        // Assert
        await testUtil.assertRevert(withdraw);
    });
    it('withdraw Should throw When owner withdraws more than withdrawLimit', async () => {
        // Arrange
        const owner = accounts[0];
        const withdrawAmount = web3.toWei('6', 'ether');

        // Act
        const withdraw = sut.withdraw(withdrawAmount, {from: owner});

        // Assert
        await testUtil.assertThrow(withdraw);
    });
    it('buyService Should emit event When account buys a service', async () => {
        // Arrange
        const account = accounts[1];
        const payment = web3.toWei('1', 'ether');

        // Act
        const purchase = await sut.buyService({from: account, value: payment});
        const event = sut.LogPurchase();
        // Assert
        await testUtil.watchEvent(event);
    });
    it('buyService Should revert When another account tries to buy a service when less than 2 minutes have passed after previous purchase', async () => {
        // Arrange
        const firstAccount = accounts[1];
        const payment = web3.toWei('1', 'ether');

        // Act
        await sut.buyService({from: firstAccount, value: payment});
        const purchase = sut.buyService({from: firstAccount, value: payment});
        // Assert
        await testUtil.assertRevert(purchase);
    });
    it('withdraw Should revert When owner tries to withdraw when less than 5 Hr have passed after last withdraw', async () => {
        // Assert
        const owner = accounts[0];
        const withdrawAmount = web3.toWei('1', 'ether');
        
        const payment = web3.toWei('1', 'ether');
        await sut.buyService({from: accounts[1], value: payment});
        await testUtil.increaseTime(testUtil.constants.minutes(3));
        await sut.buyService({from: accounts[2], value: payment});

        // Act
        await sut.withdraw(withdrawAmount, {from: owner});
        
        const withdraw = sut.withdraw(withdrawAmount, {from: owner});

        // Assert
        await testUtil.assertRevert(withdraw);
    });
});
const Faucet = artifacts.require('../contracts/Faucet.sol');

const testUtil = require('./utils/test.util.js');

contract('Faucet', (accounts) => {
    let sut;

    beforeEach( async () => {
        sut = await Faucet.new();
    });

    it('contract Should be able to receive ETH payments', async () => {
        // Arrange
        const payment = 1;
        const sender = accounts[1]
        const contractAddress = sut.address;
        
        // Act
        await sut.sendTransaction({
            value: payment,
            from: sender
        });
        
        const balance = await sut.getContractBalance.call();
        // Assert
        assert.equal(balance, 1);
    });
    it('sendAmount Should be 1 ETH When instantiating contract', async () => {
        // Arrange
        const sendAmount = await sut.sendAmount.call();
        // Act
        // Assert
        assert.equal(sendAmount, web3.toWei('1', 'ether'));
    });
    it('sendAmount Should be set When the owner calls its setter', async () => {
        // Arrange
        const sendAmount = await sut.sendAmount.call();
        const setAmount = sendAmount + 1;
        
        // Act
        await sut.setSendAmount(setAmount, {from: accounts[0]});

        const sendAmountAfter = await sut.sendAmount.call();
        // Assert
        assert.equal(sendAmountAfter, setAmount);
    });
    it('sendAmount Should revert When address who is not owner calls its setter', async () => {
        // Arrange
        const notOwner = accounts[1];
        const amount = 1;
        // Act
        // Assert
        await testUtil.assertRevert(sut.setSendAmount(amount, {from: notOwner}));
    });
    it('withdraw Should withdraw sendAmount of money When it is called', async () => {
        // Arrange
        const sendAmount = await sut.sendAmount.call();
        const sender = accounts[1];
        
        await sut.sendTransaction({value: sendAmount, from: accounts[2]});
        await sut.sendTransaction({value: sendAmount, from: accounts[3]});
        
        const contractBalanceBeforeWithdraw = await sut.getContractBalance.call();
        // Act
        await sut.withdraw({from: sender});

        const contractBalanceAfterWithdraw = await sut.getContractBalance.call();

        // Assert
        assert.equal(contractBalanceAfterWithdraw.valueOf()*2, contractBalanceBeforeWithdraw.valueOf());
    });
});
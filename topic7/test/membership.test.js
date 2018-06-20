const Membership = artifacts.require('../contracts/Membership.sol');

const testUtil = require('./utils/test.util.js');

contract('Membership', (accounts) => {
    let sut;
    
	beforeEach( async () => {
		sut = await Membership.new();
    });

    it('addMember Should add a new member When owner calls it', async () => {
        // Arrange 
        const owner = accounts[0];
        const member = accounts[1];

        // Act
        await sut.addMember(member, {from: owner});

        const memberCount = await sut.memberCount.call();
        // Assert   
        assert.equal(memberCount, 2);
    });
    it('vote Should allow members to vote When they want a new member to enter', async () => {
        // Arrange
        const owner = accounts[0];
        const member1 = accounts[1];
        const member2 = accounts[2];
        const votedMember = accounts[3];

        // Act
        await sut.addMember(member1, {from: owner});
        await sut.addMember(member2, {from: owner});

        await sut.vote(votedMember, {from: member1});
        await sut.vote(votedMember, {from: member2});

        const wasMemberAccepted = await sut.isMember.call(votedMember);
        const votes = await sut.getVotes(votedMember);
        // Assert
        assert.equal(votes, 2);
        assert.equal(wasMemberAccepted, true);
    });
    it('donate Should renew membership When members donate money to the contracts within 1 hour', async () => {
        // Arrange
        const member1 = accounts[1];

        // Act 
        await sut.addMember(member1, {from: accounts[0]});
        await testUtil.increaseTime(testUtil.constants.minutes(30));

        const checkExpiry = await sut.checkMembershipExpiry(member1);
        // Assert
        assert.equal(checkExpiry, false);
    });
    it('vote Should remove members When member has not donated within hour of last donation', async () => {
        // Arrange
        const member1 = accounts[1];
        
        // Act
        await sut.addMember(member1, {from: accounts[0]});
        await testUtil.increaseTime(testUtil.constants.minutes(60));
        
        const vote = await sut.vote(accounts[2], {from: member1});
        
        const removed = await sut.isMember(member1);
        const memberCount = await sut.memberCount.call();
        // Assert
        assert.equal(removed, false);
        assert.equal(memberCount, 1);
    });
    it('donate Should remove members When member has not donated within hour of last donation', async () => {
        // Arrange
        const member1 = accounts[1];
        
        // Act
        await sut.addMember(member1, {from: accounts[0]});
        await testUtil.increaseTime(testUtil.constants.minutes(60));
        
        const vote = await sut.donate({from: member1, value: web3.toWei('1', 'ether')});
        
        const removed = await sut.isMember(member1);
        const memberCount = await sut.memberCount.call();
        // Assert
        assert.equal(removed, false);
        assert.equal(memberCount, 1);
    });
    
});
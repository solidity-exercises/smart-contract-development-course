pragma solidity 0.4.23;

library VotingLib {
    using SafeMath for uint;

    struct VotingProposal {
        address addr;
        uint value;
        uint votesFor;
        uint votesAgainst;
        uint decidingVotes;
        mapping (address=>bool) voted;
        bool finished;
        bool accepted;
    }

    function createVoting(address _proposal, uint _value, uint _decidingVotes) {
        return VotingProposal({value: _value, votesFor: 0, votesAgainst: 0, finished: false, accepted: false, addr: _proposal, votes: 0, decidingVotes: _decidingVotes});
    }

    function vote(Voting storage self, uint importance, bool forOrAgainst) {
        require(!self.finished);
        require(!self.voted[msg.sender]);

        self.voted[msg.sender] = true;

        if (forOrAgainst) {
            self.votesFor = self.votesFor.add(importance);

            if (self.votesFor >= self.decidingVotes) {
                self.finished = true;
                self.accepted = true;
            }
        } else {
            self.votesAgainst = self.votesAgainst.add(importance);

            if (self.votesAgainst >= self.decidingVotes) {
                self.finished = true;
                self.accepted = false;
            }
        }
    }
}


contract Voter is Ownable {
    using VotingLib for VotingLib.VotingProposal;
    using SafeMath for uint;

    event LogVotingStart(address indexed addr, uint value);
    event LogVotingSuccessful(address indexed addr, uint value);
    event LogWithdrawal(address indexed addr);

    function () public payable {}

    struct Member {
        bool isMember;
        uint importance;    
    }

    uint totalImportance;
    mapping (address=>Member) members;
    mapping (address=>VotingLib.VotingProposal) proposals;
    mapping (address=>uint) withdrawals;

    constructor(address[] initialMembers, uint[] importances) public {
        init(initialMembers, impotances);
    }

    function init(address[] initialMembers, uint[] importances) public onlyOwner {
        require(initialMembers.length >= 3);
        require(initialMembers.length == importances.length);

        uint tI = 0;

        for (var i = 0; i < initialMembers.length; i++) {
            members[initialMembers[i]].isMember = true;
            members[initialMembers[i]].importance = importances[i];
            tI = tI.add(importances[i]);
        }


        totalImportance = tI;
    }

    function propose(address _proposal, uint _value) public onlyOwner {
        require(_proposal != address(0));
        require(_value > 0);
        require(proposals[_proposal].addr == address(0));

        VotingLib.VotingProposal memory proposal = VotingLib.createVoting(_proposal, _value, totalImportance);
        proposals[_proposal] = proposal;

        emit LogVotingStart(_proposal, _value);
    }

    function vote(address addr, bool forOrAgainst) {
        require(members[msg.sender].isMember);

        VotingLib.VotingProposal storage proposal = proposals[addr];

        VotingLib.vote(proposal, forOrAgainst, members[msg.sender].importance)

        if(proposal.finished && proposal.accepted) {
            withdrawals[addr] = withdrawals[addr].add(proposal.value);

            emit LogVotingSuccessfull(addr, proposal.value);
        }
    }

    function withdraw() {
        require(proposals[msg.sender].accepted);

        uint value = withdrawals[msg.sender];
        withdrawals[msg.sender] = 0;

        emit LogWithdrawal(msg.sender);

        msg.sender.transfer(value);
    }
}
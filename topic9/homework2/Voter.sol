pragma solidity 0.4.23;

library VotingLib {
    using SafeMath for uint;

    struct VotingProposal {
        mapping (address=>bool) voted;
        address addr;
        uint decidingVotes;
        uint votesFor;
        uint deadline;
        uint value;
    }

    function createVoting(address _proposal, uint _value, uint _decidingVotes) {
        return VotingProposal({value: _value, votesFor: 0, deadline: now, addr: _proposal, votes: 0, decidingVotes: _decidingVotes});
    }

    function vote(Voting storage _self, uint _importance) {
        require(!_self.deadline < now);
        require(!_self.voted[msg.sender]);

        _self.voted[msg.sender] = true;
        _self.votesFor = _self.votesFor.add(_importance);
    }
}


contract Voter is Ownable {
    using VotingLib for VotingLib.VotingProposal;
    using SafeMath for uint;

    event LogVotingStart(address indexed addr, uint value);
    event LogVotingSuccessful(address indexed addr, uint value);
    event LogWithdrawal(address indexed addr);

    struct Member {
        uint importance;    
    }
    
    uint totalImportance;
    mapping (address=>Member) members;
    mapping (address=>VotingLib.VotingProposal) proposals;
    mapping (address=>uint) withdrawals;

    function () public payable {}

    function init(address[] _initialMembers, uint[] _importances) public onlyOwner {
        require(_initialMembers.length >= 3);
        require(_initialMembers.length == _importances.length);

        uint tI = 0;

        for (uint i = 0; i < _initialMembers.length; i++) {
            members[_initialMembers[i]].importance = _importances[i];
            tI = tI.add(_importances[i]);
            
            require(_importances >= 1);
        }


        totalImportance = tI;
    }

    function propose(address _proposal, uint _value) public onlyOwner {
        require(_proposal != address(0));
        require(_value > 0);
        require(proposals[_proposal].addr == address(0));

        proposals[_proposal] = VotingLib.createVoting(_proposal, _value, totalImportance);

        emit LogVotingStart(_proposal, _value);
    }

    function voteFor(address _addr) public {
        require(members[msg.sender].importance != 0);

        VotingLib.VotingProposal storage proposal = proposals[_addr];

        VotingLib.vote(proposal, _forOrAgainst, members[msg.sender].importance);

        if (proposal.votesFor >= decidingVotes && now < deadline) {
            withdrawals[_addr] = withdrawals[_addr].add(proposal.value);

            emit LogVotingSuccessfull(_addr, proposal.value);
        }
    }

    function withdraw() public {
        require(proposals[msg.sender].accepted);

        uint value = withdrawals[msg.sender];
        withdrawals[msg.sender] = 0;

        emit LogWithdrawal(msg.sender);

        msg.sender.transfer(value);
    }
}
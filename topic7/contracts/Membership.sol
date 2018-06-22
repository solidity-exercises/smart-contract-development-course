pragma solidity ^0.4.23;

import './Destructible.sol';
import './SafeMath.sol';

contract Membership is Destructible {
    
    using SafeMath for uint;

    uint public memberCount = 0;

    struct Member {
        uint donations;
        uint lastDonationTimestamp;
        uint lastDonationValue;
    }

    // no usage of arrays or loops, so I get a Bonus :)

    mapping (address=>Member) public members;
    mapping (address=>uint) public votes;
    mapping (address=> mapping (address=>bool)) public votedForBy;


    constructor() public {
        _addMember(owner);
    }
    
    function addMember(address _member) public onlyOwner {
        _addMember(_member);
    }

    function removeMember(address _member) public onlyOwner {
        _removeMember(_member);
    }

    function vote(address _member) public {
        assert(_member != address(0));
        require(isMember(members[msg.sender]));
        require(!isMember(members[_member]));
        require(!votedForBy[_member][msg.sender]);
        // the impossible value of 1 serves as a flag that this address  was previously a member
        require(members[_member].lastDonationTimestamp != 1);
        
        if (checkMembershipExpiry(msg.sender)) {
            _removeMember(msg.sender);
        } else {
            votedForBy[_member][msg.sender] = true;
            votes[_member] = votes[_member].add(1);

            if (votes[_member] > memberCount.div(2)){
                _addMember(_member);
            }
        }
    }

    function unvote(address _member) public {
        require(members[msg.sender]));
        require(!isMember(members[_member]));
        require(votedForBy[_member][msg.sender]);

        if (checkMembershipExpiry(msg.sender)) {
            _removeMember(msg.sender);
        } else {
            votedForBy[_member][msg.sender] = false;
            votes[_member] = votes[_member].sub(1);
        }
    }

    function donate() public payable {
        require(isMember(members[msg.sender]));

        if (checkMembershipExpiry(msg.sender)) {
            _removeMember(msg.sender);
        } else {
            Member memory mem = Member({donations: members[msg.sender], lastDonationTimestamp: now, lastDonationValue: msg.value});

            members[msg.sender] = mem;
        }
    }

    function checkMembershipExpiry(address _member) public view returns (bool) {
        return (members[_member].lastDonationTimestamp + 1 hours <= now 
                && _member != owner);
    }

    function isMember(address _person) public view returns (bool) {
        return members[_person].lastDonationTimestamp > 0;
    }

    function getVotes(address _person) public view returns (uint) {
        return votes[_person];
    }

    function _addMember(address _member) private {
        
        memberCount = memberCount.add(1);
        // artificial donation timestamp for the sake of initialization and consistency
        // i.e. member still has to donate within 1 hour of becoming a member
        members[_member].lastDonationTimestamp = now;
    }

    function _removeMember(address _member) private {
        memberCount = memberCount.sub(1);
        // artificial "delete"
        // a value of one will serve as a flag that this address was once a member
        // and therefore should not be added again to preserve logic in mappings
        members[_member].lastDonationTimestamp = 1;
    }
}
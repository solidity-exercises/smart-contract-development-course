pragma solidity ^0.4.23;

import './Destructible.sol';
import './SafeMath.sol';

contract Membership is Destructible {
    
    using SafeMath for uint;

    uint public memberCount = 0;

    struct Member {
        bool isMember;
        uint donations;
        uint lastDonationTimestamp;
        uint lastDonationValue;
    }

    // no usage of arrays or loops, so I get a Bonus :)

    mapping (address=>Member) public members;
    mapping (address=>uint) votes;
    mapping (address=> mapping (address=>bool)) votedForBy;


    constructor() public {
        addMember(owner);
    }
    
    function addMember(address _member) public {
        require(_member == owner || votes[_member] > memberCount.div(2) || msg.sender == owner);
        require(!members[_member].isMember)

        memberCount = memberCount.add(1);
        members[_member].isMember = true;
        // artificial donation timestamp for the sake of initialization and consistency
        // i.e. member still has to donate within 1 hour of becoming a member
        members[_member].lastDonationTimestamp = now;
    }

    function removeMember(address _member) public onlyOwner {
        _removeMember(_member);
    }

    function _removeMember(address _member) private {
        memberCount = memberCount.sub(1);
        delete member[_member];
    }

    function vote(address _member) public {
        assert(_member != address(0));
        require(members[msg.sender].isMember);
        require(!members[_member].isMember);
        require(!votedForBy[_member][msg.sender]);
        
        if (members[msg.sender].lastDonationTimestamp + 1 hours > now && msg.sender != owner) {
            _removeMember(msg.sender);
        } else {
            votedForBy[_member][msg.sender] = true;
            votes[_member] = votes[_member].add(1);
        }
    }

    function unvote(address _member) public {
        require(members[msg.sender].isMember);
        require(!members[_member].isMember);
        require(votedForBy[_member][msg.sender]);

        if (members[msg.sender].lastDonationTimestamp + 1 hours > now && msg.sender != owner) {
            _removeMember(msg.sender);
        } else {
            votedForBy[_member][msg.sender] = false;
            votes[_member] = votes[_member].sub(1);
        }
    }

    function donate() public payable {
        require(members[msg.sender].isMember);

        if (members[msg.sender].lastDonationTimestamp + 1 hours > now && msg.sender != owner) {
            _removeMember(msg.sender);
        } else {
            members[msg.sender].donations = members[msg.sender].donations.add(msg.value);
            members[msg.sender].lastDonationTimestamp = now;
            members[msg.sender].lastDonationValue = msg.value;
        }
    }
}
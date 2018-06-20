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
    mapping (address=>uint) public votes;
    mapping (address=> mapping (address=>bool)) public votedForBy;


    constructor() public {
        _addMember(owner);
    }
    
    function addMember(address _member) public onlyOwner {
        _addMember(_member);
    }

    function _addMember(address _member) private {
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
        delete members[_member];
    }

    function vote(address _member) public {
        assert(_member != address(0));
        require(members[msg.sender].isMember);
        require(!members[_member].isMember);
        require(!votedForBy[_member][msg.sender]);
        
        if (checkMembershipExpiry(msg.sender)) {
            _removeMember(msg.sender);
        } else {
            votedForBy[_member][msg.sender] = true;
            votes[_member] = votes[_member].add(1);

            if (votes[_member] > uint(memberCount.div(2))){
                _addMember(_member);
            }
        }
    }

    function unvote(address _member) public {
        require(members[msg.sender].isMember);
        require(!members[_member].isMember);
        require(votedForBy[_member][msg.sender]);

        if (checkMembershipExpiry(msg.sender)) {
            _removeMember(msg.sender);
        } else {
            votedForBy[_member][msg.sender] = false;
            votes[_member] = votes[_member].sub(1);
        }
    }

    function donate() public payable {
        require(members[msg.sender].isMember);

        if (checkMembershipExpiry(msg.sender)) {
            _removeMember(msg.sender);
        } else {
            members[msg.sender].donations = members[msg.sender].donations.add(msg.value);
            members[msg.sender].lastDonationTimestamp = now;
            members[msg.sender].lastDonationValue = msg.value;
        }
    }

    function checkMembershipExpiry(address _member) public view returns (bool) {
        return (members[_member].lastDonationTimestamp + 1 hours <= now 
                && _member != owner);
    }

    function isMember(address _person) public view returns (bool) {
        return members[_person].isMember;
    }

    function getVotes(address _person) public view returns (uint) {
        return votes[_person];
    }
}
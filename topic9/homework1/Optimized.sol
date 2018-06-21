pragma solidity ^0.4.20;


//this contract is optimized, don't touch it.
contract Ownable {
    address public owner;
    
    
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    
    
    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0));
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

}

//The objective is to have a contract that has members. The members are added by the owner and hold information about their address, timestamp of being added to the contract and amount of funds donated. Each member can donate to the contract.
//Many anti-patterns have been used to create them.
//Some logical checks have been missed in the implementation.
//Objective: lower the publish/execution gas costs as much as you can and fix the logical checks.

library MemberLib {
    struct Member {
        bool isMember;
        uint joinedAt;
        uint fundsDonated;
    }

    function createMember(bool _isMember, uint _joinedAt, uint _donation) public returns (Member){
        return Member({isMember: _isMember, joinedAt: _joinedAt, fundsDonated: _donation});
    }
    
    function donated(Member storage self, uint value) public {
        self.fundsDonated = value;
    }
}

contract Membered is Ownable{
    using MemberLib for MemberLib.Member;
    
    mapping(address => MemberLib.Member) members;
    
    modifier onlyMember {
        require(members[msg.sender].isMember);
        _;
    }
    
    function addMember(address adr) public onlyOwner {
        MemberLib.Member memory newMember = MemberLib.createMember(true, now, 0);
        
        members[adr] = newMember;
    }
    
    function donate() public onlyMember payable {
        require(msg.value > 0);
        
        members[msg.sender].donated(msg.value);
    }
}
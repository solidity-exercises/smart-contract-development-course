pragma solidity ^0.4.23;

contract Owned {
    address owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function destroy() public onlyOwner {
        selfdestruct(owner);
    }

    function getOwnerBalance() public view returns (uint256) {
        return owner.balance;
    }
}
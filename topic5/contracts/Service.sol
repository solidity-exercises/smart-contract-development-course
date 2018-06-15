pragma solidity ^0.4.23;

contract Service {
    
    address public owner;
    uint256 serviceCost = 1 ether;
    uint256 withdrawLimit = 5 ether;
    uint256 lastPurchaseTime = 0;
    uint256 lastWithdrawTime = 0;

    event LogPurchase(address _buyer);

    modifier canBuy() {
        if (lastPurchaseTime != 0){
            require(lastPurchaseTime + 2 minutes <= now);
        }
        _;
    }

    modifier canWithdraw(uint256 _amount) {
        require(msg.sender == owner);   
        assert(_amount <= withdrawLimit);
        require(address(this).balance >= _amount);
        if (lastWithdrawTime != 0) {
            require(lastWithdrawTime + 5 hours <= now);
        }
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function buyService() public payable canBuy {
        require(msg.value >= serviceCost);
        if (msg.value > serviceCost) {
            msg.sender.transfer(msg.value - serviceCost);
        }
        lastPurchaseTime = now;
        emit LogPurchase(msg.sender);
    }

    function withdraw(uint256 _amount) public canWithdraw(_amount) {
        owner.transfer(_amount);
        lastWithdrawTime = now;
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
pragma solidity ^0.4.23;

import "./Owned.sol";

contract Service is Owned {
    
    uint256 constant public serviceCost = 1 ether;
    uint256 constant public withdrawLimit = 5 ether;
    uint256 public lastPurchaseTime = 0;
    uint256 public lastWithdrawTime = 0;

    event LogPurchase(address _buyer);

    modifier canBuy() {
        require(lastPurchaseTime + 2 minutes <= now);
        require(msg.value >= serviceCost);
        _;
    }

    modifier canWithdraw(uint256 _amount) { 
        assert(_amount <= withdrawLimit);
        require(address(this).balance >= _amount);
        require(lastWithdrawTime + 5 hours <= now);
        _;
    }

    function buyService() public payable canBuy {
        if (msg.value > serviceCost) {
            msg.sender.transfer(msg.value - serviceCost);
        }
     
        emit LogPurchase(msg.sender);
     
        lastPurchaseTime = now;
    }

    function withdraw(uint256 _amount) public canWithdraw(_amount) onlyOwner {
        owner.transfer(_amount);
        lastWithdrawTime = now;
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}

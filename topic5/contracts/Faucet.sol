pragma solidity ^0.4.23;

import './Destructible.sol';

contract Faucet is Destructible {

    uint256 public sendAmount = 1 ether;
    
    event LogWithdrawal(address withdrawAddr, uint256 amount);
    
    modifier canWithdraw {
        require(sendAmount <= address(this).balance);
        _;
    }

    function () public payable {}

    function setSendAmount(uint256 _amount) public onlyOwner {
        sendAmount = _amount;
    }

    function withdraw() public canWithdraw {
        emit LogWithdrawal(msg.sender, sendAmount);
        
        msg.sender.transfer(sendAmount);
    }

    function sendTo(address _to) public canWithdraw {
        require(_to != address(0));
        require(_to != address(this));

        emit LogWithdrawal(msg.sender, sendAmount);
        
        _to.transfer(sendAmount);
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
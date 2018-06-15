pragma solidity ^0.4.23;

import './Owned.sol';

contract Faucet is Owned {

    uint256 public sendAmount = 1 ether;
    
    event LogWithdrawal(address _withdrawAddr, uint256 _amount);
    
    modifier canWithdraw {
        require(sendAmount <= address(this).balance);
        _;
    }

    function () public payable {}

    function setSendAmount(uint256 _amount) public onlyOwner {
        sendAmount = _amount;
    }

    function withdraw() public canWithdraw {
        msg.sender.transfer(sendAmount);
        emit LogWithdrawal(msg.sender, sendAmount);
    }

    function sendTo(address _to) public canWithdraw {
        require(_to != address(0));
        require(_to != address(this));
        _to.transfer(sendAmount);
        emit LogWithdrawal(msg.sender, sendAmount);
    }

    function selfdestructContract() public onlyOwner {
        selfdestruct(this);
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
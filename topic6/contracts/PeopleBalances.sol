pragma solidity ^0.4.23;

import './Ownable.sol';

contract PeopleBalances is Ownable {
    
    uint256 public crowdsaleEndTime = now + 5 minutes;
    uint256 public ownerWithdrawStartTime = now + 365 days;
    uint16 constant public EXCHANGE_RATE = 5;

    mapping (address=>uint256) public balances;
    mapping (address=>bool) public hasHeldTokens;
    address[] public tokenHolders;

    modifier isCrowdsale {
        require(crowdsaleEndTime >= now);
        _;
    }

    function buy() public payable isCrowdsale {
           if (!hasHeldTokens[msg.sender]) {
               hasHeldTokens[msg.sender] = true;
               tokenHolders.push(msg.sender);
           }
           
           balances[msg.sender] += msg.value * EXCHANGE_RATE;
    }
    
    function transferTokens(address _to, uint256 _amount) public {
        require(crowdsaleEndTime < now);
        require(balances[msg.sender] >= _amount);
        require(_to != address(0));

        if (!hasHeldTokens[_to]) {
            hasHeldTokens[_to] = true;
            tokenHolders.push(_to);
        }

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }

    function withdraw(uint256 _amount) public onlyOwner {
        require(now >= ownerWithdrawStartTime);
        require(address(this).balance >= _amount);

        owner.transfer(_amount);
    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
pragma solidity ^0.4.23;

import './Ownable.sol';
import './SafeMath.sol';

contract PeopleBalances is Ownable {
    
    using SafeMath for uint256;

    uint256 public crowdsaleEndTime = now + 5 minutes;
    uint256 public ownerWithdrawStartTime = now + 365 days;
    uint16 constant public EXCHANGE_RATE = 5;

    mapping (address=>uint256) public balances;
    mapping (address=>bool) public hasHeldTokens;
    address[] public tokenHolders;

    function buy() public payable {
        require(crowdsaleEndTime >= now);

        _checkHolder(msg.sender);
        
        balances[msg.sender] += msg.value * EXCHANGE_RATE;
    }
    
    function transferTokens(address _to, uint256 _amount) public {
        require(crowdsaleEndTime < now);
        require(balances[msg.sender] >= _amount);
        require(_to != address(0));

        _checkHolder(_to);

        balances[msg.sender] = balances[msg.sender].sub(_amount);
        balances[_to] = balances[_to].add(_amount);
    }

    function _checkHolder(address _holder) private {
        if (!hasHeldTokens[_holder]) {
            hasHeldTokens[_holder] = true;
            tokenHolders.push(_holder);
        }
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
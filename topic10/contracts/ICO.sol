pragma solidity ^0.4.23;

import './ERC20.sol';
import './SafeMath.sol';

contract StandardToken is ERC20 {
    
    uint transferLockUntil;

    using SafeMath for uint256;

    uint256 public totalSupply;

    mapping (address=>uint256) public balances;
    mapping (address=>mapping (address=>uint)) public allowances;

    modifier isUnlocked {
        require(now > transferLockUntil);
        _;
    }

    function balanceOf(address who) public view returns (uint256) {
        return balances[who];
    }

    function transfer(address to, uint256 value) public isUnlocked returns (bool) {
        require(balances[msg.sender] >= value);
        require(to != address(0));

        emit Transfer(msg.sender, to, value);

        balances[msg.sender] = balances[msg.sender].sub(value);
        balances[to] = balances[to].add(value); 
    }

    function transferFrom(address from, address to, uint256 value) public isUnlocked returns (bool) {
        require(to != address(0));
        require(balances[from] >= value);
        require(allowances[from][msg.sender] >= value);

        emit Transfer(from, to, value);

        balances[from] = balances[from].sub(value);
        balances[to] = balances[to].add(value);
        allowances[from][msg.sender] = allowances[from][msg.sender].sub(value);
    }


    function approve(address spender, uint256 value) public isUnlocked returns (bool) {
        require(spender != address(0));
        require(value > 0);

        emit Approval(msg.sender, spender, value);
        
        allowances[msg.sender][spender] = value;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return allowances[owner][spender];
    }
}

contract DogeCoin is StandardToken {

    uint256 public presaleEnd = now + 1 hours;
    uint256 public icoEnd = presaleEnd + 3 hours;

    uint256 constant INITIAL_SUPPLY = 9999;

    uint256 constant PRESALE_PRICE = 1 ether;
    uint256 constant ICO_PRICE = 2 ether;

    constructor() public {
        transferLockUntil = now + 3 hours;
        balances[this] = INITIAL_SUPPLY;
    }

    modifier isCrowdsale {
        require(now < icoEnd);
        _;
    }

    function isPresale() public view returns (bool) {
        return presaleEnd > now;
    }

    function buy() public isCrowdsale payable {
        uint256 price;
        if (isPresale()) {
            price = PRESALE_PRICE;
        } else {
            price = ICO_PRICE;
        }

        uint tokens = msg.value.div(price);
        
        balances[msg.sender] = tokens;
    }
}
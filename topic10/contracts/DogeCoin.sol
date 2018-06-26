pragma solidity ^0.4.23;

import './StandardToken.sol';

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
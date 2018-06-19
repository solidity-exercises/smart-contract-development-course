pragma solidity ^0.4.23;

import './Destructible.sol';

contract Con is Destructible {
    
    struct Member {
        address addr;
        uint donation;
        uint lastDonationTimestamp;
        uint lastDonationValue;
    }

    mapping (uint=>Member) name;

    
}
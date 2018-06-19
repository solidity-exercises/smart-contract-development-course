pragma solidity ^0.4.23;

import "./Ownable.sol";


contract Destructible is Ownable {

  function destroy() onlyOwner public {
    selfdestruct(owner);
  }

  function destroyAndSend(address _recipient) onlyOwner public {
    selfdestruct(_recipient);
  }
}
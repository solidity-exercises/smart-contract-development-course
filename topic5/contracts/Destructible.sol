pragma solidity ^0.4.23;

import "./Owned.sol";


contract Destructible is Owned {

  function destroy() onlyOwner public {
    selfdestruct(owner);
  }

  function destroyAndSend(address _recipient) onlyOwner public {
    selfdestruct(_recipient);
  }
}
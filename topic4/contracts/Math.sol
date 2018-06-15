pragma solidity ^0.4.23;

import './interfaces/IMath.sol';


contract Math is IMath {

	uint256 public number = 0;

	function resetStateNumber() external {
		number = 0;
	}

	function add(uint256 _inputNumber) external {
		uint256 sum = number + _inputNumber;
		assert(sum >= number);
		number = sum;
	}

	function sub(uint256 _inputNumber) external {
		assert(_inputNumber <= number);
		number -= _inputNumber;
	}

	function mul(uint256 _inputNumber) external {
		uint256 product = number * _inputNumber;
		assert(product == 0 || number == product / _inputNumber);
		number = product;
	}

	function div(uint256 _inputNumber) external {
		number /= _inputNumber;
	}

	function pow(uint256 _inputNumber) external {
		uint256 raised = number**_inputNumber;
		assert(raised >= number);
		number = raised;
	}

	function mod(uint256 _inputNumber) external {
		number %= _inputNumber;
	}

}
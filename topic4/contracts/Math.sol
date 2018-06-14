pragma solidity ^0.4.23;

import './interfaces/IMath.sol';

contract Math is IMath {

    uint _stateNumber = 0;

	function stateNumber() external view returns (uint) {
        return _stateNumber;
    }

	function resetStateNumber() external {
        _stateNumber = 0;
    }

	function add(uint256 _inputNumber) external {
        uint sum = _stateNumber + _inputNumber;
		assert(sum >= _stateNumber);
		_stateNumber = sum;
    }

	function sub(uint256 _inputNumber) external {
		assert(_inputNumber <= _stateNumber);
        uint diff = _stateNumber - _inputNumber;
		_stateNumber = diff;
    }

	function mul(uint256 _inputNumber) external {
        uint product = _stateNumber * _inputNumber;
		assert(_stateNumber == 0 || _stateNumber == product / _inputNumber);
		_stateNumber = product;
    }

	function div(uint256 _inputNumber) external {
        uint res = _stateNumber / _inputNumber;
		_stateNumber = res;
    }

	function pow(uint256 _inputNumber) external {
        uint raised = _stateNumber**_inputNumber;
		assert(raised > _stateNumber);
		_stateNumber = raised;
    }

	function mod(uint256 _inputNumber) external {
        _stateNumber = _stateNumber % _inputNumber;
    }

}
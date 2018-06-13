pragma solidity ^0.4.23;

interface IMath {
	function stateNumber() external view;

	function resetStateNumber() external;

	function add(uint256 _inputNumber) external;

	function sub(uint256 _inputNumber) external;
	
	function mul(uint256 _inputNumber) external;
	
	function div(uint256 _inputNumber) external;

	function pow(uint256 _inputNumber) external;

	function mod(uint256 _inputNumber) external;
}
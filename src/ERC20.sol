// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ERC20 {
    address owner;
    uint private _totalSupply;
    string private _name;
    string private _symbol;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;

    constructor(string memory name_, string memory symbol_, uint totalSupply_) {
        owner = msg.sender;
        _totalSupply = totalSupply_;
        _name = name_;
        _symbol = symbol_;

        // transfer to the owner or distribute
    }

    function totalSupply() external view returns(uint256) {
        return _totalSupply;
    }

    function decimals() external pure returns(uint8) {
        return 18;
    }

    function name() external view returns(string memory) {
        return _name;
    }
    
    function symbol() external view returns(string memory) {
        return _symbol;
    }

}

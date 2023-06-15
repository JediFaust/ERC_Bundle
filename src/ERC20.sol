// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract ERC20 {
    address public owner;
    uint private _totalSupply;
    string private _name;
    string private _symbol;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;

    event Transfer(address from, address to, uint amount);
    event Approval(address owner, address spender, uint amount);

    constructor(string memory name_, string memory symbol_, uint totalSupply_) {
        owner = msg.sender;
        _totalSupply = totalSupply_;
        _name = name_;
        _symbol = symbol_;

        balances[msg.sender] = totalSupply_;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, 'ERC20: Ownership required');
        _;
    }

    function renounceOwnership() external onlyOwner returns(bool) {
        owner = address(0);

        return true;
    }

    function transfer(address to, uint amount) public returns(bool) {
        _transfer(msg.sender, to, amount);

        return true;
    }

    function transferFrom(address from, address to, uint amount) public returns(bool) {
        require(allowances[from][msg.sender] >= amount || from == msg.sender, 'ERC20: Not enough allowance');

        allowances[from][msg.sender] -= amount;

        _transfer(from, to, amount);

        return true;
    }

    function _transfer(address from, address to, uint amount) internal {
        require(to != address(0) && from != address(0), 'ERC20: Zero address transfer');
        require(amount > 0, 'ERC20: Zero amount transfer');
        require(balances[from] >= amount, 'ERC20: Not enough balance');

        balances[from] -= amount;
        balances[to] += amount;
    }

    function approve(address to, uint value) external returns(bool) {
        allowances[msg.sender][to] = value;

        return true;
    }

    function allowance(address owner_, address spender_) public view returns(uint) {
        return allowances[owner_][spender_];
    }

    function balanceOf(address of_) public view returns(uint) {
        return balances[of_];
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

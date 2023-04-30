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
        require(msg.sender == owner, 'Ownership required');
        _;
    }

    function renounceOwnership() external onlyOwner returns(bool) {
        owner = address(0);

        return true;
    }

    function transfer(address to_, uint amount_) public returns(bool) {
        require(to_ != address(0) && to_ != address(msg.sender), 'Invalid destination address');
        require(balances[msg.sender] >= amount_, 'Not enough balance');
        require(amount_ > 0, 'Zero amount!');
        balances[msg.sender] -= amount_;
        balances[to_] += amount_;

        return true;
    }

    function transferFrom(address from_, address to_, uint amount_) public returns(bool) {
        require(to_ != address(0) && from_ != address(0), 'Zero address transfer!');
        require(to_ != from_, 'Self transfer!');
        require(allowances[from_][msg.sender] >= amount_ || from_ == msg.sender, 'Not enough allowance');

        allowances[from_][msg.sender] -= amount_;
        balances[from_] -= amount_;
        balances[to_] += amount_;

        return true;
    }

    function approve(address to_, uint value_) external returns(bool) {
        require(balances[msg.sender] >= value_, 'Not enough balance');
        
        allowances[msg.sender][to_] = value_;

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

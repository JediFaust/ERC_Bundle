// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/ERC20.sol";

contract ERC20Test is Test {
    ERC20 public erc20;
    ERC20 public terc20;
    address public deployer;
    address public tester;
    uint public totalSupply = 1000000 * 10 ** 18;

    function setUp() public {
        erc20 = new ERC20('JediToken', 'JDT', totalSupply);
        deployer = erc20.owner();
        tester = msg.sender;
    }

    function testBalanceOf() public {
        uint testerBalanceInitial = erc20.balanceOf(tester);
        uint deployerBalanceInitial = erc20.balanceOf(deployer);

        assertEq(testerBalanceInitial, 0);
        assertEq(deployerBalanceInitial, totalSupply);

        erc20.approve(tester, totalSupply);
        vm.prank(address(tester));
        erc20.transferFrom(deployer, tester, totalSupply);

        uint testerBalanceFinal = erc20.balanceOf(tester);
        uint deployerBalanceFinal = erc20.balanceOf(deployer);

        assertEq(testerBalanceFinal, totalSupply);
        assertEq(deployerBalanceFinal, 0);
    }

    function testOwnerAddress() public {
        address owner = erc20.owner();

        assertEq(owner, deployer);
    }

    function testTotalSupply() public {
        uint supply = erc20.totalSupply();
        assertEq(supply, 1000000 * 10 ** 18);
    }
}

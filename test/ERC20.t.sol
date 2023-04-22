// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import { Test } from "forge-std/Test.sol";
import { console } from "forge-std/console.sol";
import { ERC20 } from "../src/ERC20.sol";

contract ERC20Core is Test {
    ERC20 internal erc20;
    ERC20 internal terc20;
    address internal deployer;
    address internal tester;
    uint internal SUPPLY = 1000000 * 10 ** 18;
    string internal NAME = 'JediToken';
    string internal SYMBOL = 'JDT';

    function setUp() public {
        erc20 = new ERC20(NAME, SYMBOL, SUPPLY);
        deployer = erc20.owner();
        tester = msg.sender;
    }
}

contract Info is ERC20Core {
    function test_owner() external {
        assertEq(deployer, erc20.owner());
    }

    function test_name() external {
        assertEq(NAME, erc20.name(), 'JediToken');
    }

    function test_symbol() external {
        assertEq(SYMBOL, erc20.symbol(), 'JDT');
    }

    function test_decimals() external {
        assertEq(18, erc20.decimals());
    }

    function test_totalSupply() public {
        uint supply = erc20.totalSupply();
        assertEq(supply, SUPPLY);
    }
}

contract Transfer is ERC20Core {
    function test_ApprovalAndTransfer() public {
        uint testerBalanceInitial = erc20.balanceOf(tester);
        uint deployerBalanceInitial = erc20.balanceOf(deployer);

        assertEq(testerBalanceInitial, 0);
        assertEq(deployerBalanceInitial, SUPPLY);

        erc20.approve(tester, SUPPLY);
        vm.prank(address(tester));
        erc20.transferFrom(deployer, tester, SUPPLY);

        uint testerBalanceFinal = erc20.balanceOf(tester);
        uint deployerBalanceFinal = erc20.balanceOf(deployer);

        assertEq(testerBalanceFinal, SUPPLY);
        assertEq(deployerBalanceFinal, 0);
    }

    function test_Allowance() external {
        assertEq(erc20.allowance(address(this), tester), 0);
        erc20.approve(tester, 100);
        uint allowance = erc20.allowance(address(this), tester);
        assertEq(allowance, 100);
        
        vm.prank(address(tester));
        erc20.transferFrom(deployer, tester, 100);
        assertEq(erc20.allowance(deployer, tester), 0);
        assertEq(erc20.balanceOf(deployer), SUPPLY - 100);
        assertEq(erc20.balanceOf(tester), 100);
    }

    function test_RenounceOwnership() public {
        erc20.renounceOwnership();

        address owner = erc20.owner();

        assertEq(owner, address(0));
    }
}

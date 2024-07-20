// SPDX-License-Identifier: GPL
pragma solidity ^0.8.7;

import "forge-std/Test.sol";
import {InvariantChecker} from "../src/Invariant.sol";

contract InvariantCheckerTest is Test {
    InvariantChecker checker;

    function setUp() public {
        checker = new InvariantChecker();
    }

    function testInvariantZeroLiquidity() public {
        assertTrue(checker.invariant(0, 0, 0, 1));
        assertFalse(checker.invariant(1, 0, 0, 1));
        assertFalse(checker.invariant(0, 1, 0, 1));
    }

    function testInvariantNonZeroLiquidity() public {
        assertTrue(checker.invariant(1e18, 1e18, 1e18, 1e18));
        assertFalse(checker.invariant(1e18, 1e18, 1e18, 0));
        assertFalse(checker.invariant(1e18, 1e18, 0, 1e18));
    }

    function testInvariantWithValues() public {
        uint256 amount0 = 100e18;
        uint256 amount1 = 50e18;
        uint256 liquidity = 150e18;
        uint256 strike = 1e18;

        // Adjust the parameters to meet the invariant condition
        assertTrue(checker.invariant(amount0, amount1, liquidity, strike));

        // Change parameters to break the invariant
        amount1 = 200e18;
        assertFalse(checker.invariant(amount0, amount1, liquidity, strike));
    }
}

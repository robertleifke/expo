// SPDX-License-Identifier: GPL
pragma solidity ^0.8.7;

import "forge-std/src/Test.sol";
import "forge-std/src/console2.sol";
import {InvariantChecker} from "../src/Invariant.sol";

contract InvariantCheckerTest is Test {
    InvariantChecker checker;

    function setUp() public {
        checker = new InvariantChecker();
    }

    function testInvariantZeroLiquidity() public view {
        assertTrue(checker.checkInvariant(0, 0, 0, 1));
        assertFalse(checker.checkInvariant(1, 0, 0, 1));
        assertFalse(checker.checkInvariant(0, 1, 0, 1));
    }

    function testInvariantNonZeroLiquidity() public view {
        assertTrue(checker.checkInvariant(1e18, 1e18, 1e18, 1e18));
        assertFalse(checker.checkInvariant(1e18, 1e18, 1e18, 0));
        assertFalse(checker.checkInvariant(1e18, 1e18, 0, 1e18));
    }

    function testInvariantWithValues() public view {
        uint256 amount0 = 100e18;
        uint256 amount1 = 50e18;
        uint256 liquidity = 150e18;
        uint256 strike = 1e18;

        console2.log("amount0:", amount0);
        console2.log("amount1:", amount1);
        console2.log("liquidity:", liquidity);
        console2.log("strike:", strike);

        // Adjust the parameters to meet the invariant condition
        assertTrue(checker.checkInvariant(amount0, amount1, liquidity, strike));

        // Change parameters to break the invariant
        amount1 = 200e18;
        assertFalse(checker.checkInvariant(amount0, amount1, liquidity, strike));
    }

    // function invariant() public view {
    //     uint256 amount0;
    //     uint256 amount1;
    //     uint256 liquidity;
    //     uint256 strike;

    //     for (uint i = 0; i < 100; i++) {
    //         // Fuzz values, ensure they are within safe ranges
    //         amount0 = uint256(keccak256(abi.encode(i, block.timestamp))) % 1e18;
    //         amount1 = uint256(keccak256(abi.encode(i, block.timestamp + 1))) % 1e18;
    //         liquidity = uint256(keccak256(abi.encode(i, block.timestamp + 2))) % 1e18 + 1;  // Avoid zero liquidity
    //         strike = uint256(keccak256(abi.encode(i, block.timestamp + 3))) % 1e18 + 1;  // Avoid zero strike

    //         assertTrue(checker.checkInvariant(amount0, amount1, liquidity, strike));
    //     }
    // }
}

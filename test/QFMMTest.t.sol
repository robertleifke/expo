// SPDX-License-Identifier: GPL
pragma solidity ^0.8.7;

import "forge-std/src/Test.sol";
import "forge-std/src/console2.sol";
import {QFMM} from "../src/QFMM.sol";

contract InvariantCheckerTest is Test {
    QFMM cfmm;

    function setUp() public {
        cfmm = new QFMM();
    }

    // Tests checkQuintic() when the liquidity is zero.
    function testQuinticLiquidityEqualsZero() public view {
        assertTrue(cfmm.checkQuartic(0, 0, 0, 1));
        assertFalse(cfmm.checkQuartic(1, 0, 0, 1));
        assertFalse(cfmm.checkQuartic(0, 1, 0, 1));
    }

    // Verify checkQuintic() with large non-zero values.
    function testQuinticLiquidityIsLarge() public view {
        assertTrue(cfmm.checkQuartic(1e18, 1e18, 1e18, 1e18));
    }

    // function testQuinticWithSpecificValues() public view {
    // uint256 amount0 = 100e18;  // 100 USDC
    // uint256 amount1 = 3e18;    // 3 ETH
    // uint256 totalLiquidity = 850e18;  // 850 USDC (in value)
    // uint256 strike = 300e18;   // 300 USDC

    // console2.log("amount0 (USDC):", amount0);
    // console2.log("amount1 (ETH):", amount1);
    // console2.log("totalLiquidity:", totalLiquidity);
    // console2.log("strike:", strike);

    // // Adjust the parameters to meet the invariant condition
    // bool result = invariant.checkQuintic(amount0, amount1, totalLiquidity, strike);
    // console2.log("Invariant check result:", result);
    // assertTrue(result);

    // // Change parameters to break the invariant
    // amount1 = 200e18;  // Change to 200 ETH to break the invariant
    // console2.log("Testing with modified amountY (ETH):", amount1);
    // result = invariant.checkQuintic(amount0, amount1, totalLiquidity, strike);
    // console2.log("Invariant check result with modified amountY (ETH):", result);
    // assertFalse(result);
    // }


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

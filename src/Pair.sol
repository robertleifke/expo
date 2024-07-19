// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.13;

import {FullMath} from "solmate/utils/FullMath.sol";

contract InvariantChecker {
    function invariant(
        uint256 amount0,
        uint256 amount1,
        uint256 liquidity,
        uint256 strike
    ) public pure returns (bool) {
        if (liquidity == 0) return (amount0 == 0 && amount1 == 0);

        // Calculate amount0 / liquidity and amount1 / liquidity with 1e18 precision
        uint256 scaleX = FullMath.mulDiv(amount0, 1e18, liquidity);
        uint256 scaleY = FullMath.mulDiv(amount1, 1e18, liquidity);

        // Calculate strike^22 dynamically
        uint256 strikeTo22 = fixedPointSquare(strike, 1e18);
        for (uint256 i = 0; i < 20; i++) {
            strikeTo22 = FullMath.mulDiv(strikeTo22, strike, 1e18);
        }

        // Calculate (strike^22 - (22/23 * scaleY))^(23/22) with 1e18 precision
        uint256 termInside = strikeTo22 - FullMath.mulDiv(22, scaleY, 23);
        uint256 termPower = fixedPointExp(termInside, 23, 22);

        return scaleX >= termPower;
    }

    function fixedPointSquare(uint256 x, uint256 precision) internal pure returns (uint256) {
        return FullMath.mulDiv(x, x, precision);
    }

    function fixedPointExp(uint256 base, uint256 numerator, uint256 denominator) internal pure returns (uint256) {
        // Approximate method for demonstration
        uint256 logBase = FullMath.log(base);
        uint256 exponent = FullMath.mulDiv(logBase, numerator, denominator);
        return FullMath.exp(exponent);
    }
}
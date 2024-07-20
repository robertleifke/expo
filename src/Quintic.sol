// SPDX-License-Identifier: GPL
pragma solidity ^0.8.7;

import { UD60x18, ud, mul, div, pow, sub } from "@prb/math/src/UD60x18.sol";
import "forge-std/src/console2.sol";

contract Quintic {


// Checks the quintic invariant
    function checkQuintic(
        uint256 amount0,
        uint256 amount1,
        uint256 liquidity,
        uint256 strike
    ) public pure returns (bool) {
        if (liquidity == 0) return (amount0 == 0 && amount1 == 0);
        require(liquidity > 0, "liquidity must be greater than zero");
        require(strike > 0, "strike must be greater than zero");


        // Convert amounts to UD60x18 types
        UD60x18 udAmount0 = ud(amount0);
        UD60x18 udAmount1 = ud(amount1);
        UD60x18 udLiquidity = ud(liquidity);
        UD60x18 udStrike = ud(strike);

        // Calculate (amount0 / totalLiquidity) and (amount1 / totalLiquidity)
        UD60x18 scale0 = div(udAmount0, udLiquidity);
        UD60x18 scale1 = div(udAmount1, udLiquidity);

        // Calculate strike^4
        UD60x18 expo4 = ud(4e18);
        UD60x18 strikeTo4 = pow(udStrike, expo4);

        // Calculate (strike^4 - (4/5 * scale1))^(5/4)
        UD60x18 insideTerm = sub(strikeTo4, mul(scale1, div(ud(4e18), ud(5e18))));
        UD60x18 fracExpo = div(ud(5e18), ud(4e18));
        UD60x18 termToExpo = pow(insideTerm, fracExpo);

        return scale0.unwrap() >= termToExpo.unwrap();
    }
}

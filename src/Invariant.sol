// SPDX-License-Identifier: GPL
pragma solidity ^0.8.7;

import { UD60x18, ud, mul, div, pow, sub } from "@prb/math/src/UD60x18.sol";

contract InvariantChecker {

    function invariant(
        uint256 amount0,
        uint256 amount1,
        uint256 liquidity,
        uint256 strike
    ) public pure returns (bool) {
        if (liquidity == 0) return (amount0 == 0 && amount1 == 0);

        // Convert amounts to UD60x18 types
        UD60x18 udAmount0 = ud(amount0);
        UD60x18 udAmount1 = ud(amount1);
        UD60x18 udLiquidity = ud(liquidity);
        UD60x18 udStrike = ud(strike);

        // Calculate (amount0 / totalLiquidity) and (amount1 / totalLiquidity)
        UD60x18 scale0 = div(udAmount0, udLiquidity);
        UD60x18 scale1 = div(udAmount1, udLiquidity);

        // Calculate strike^22
        UD60x18 expo22 = ud(22e18);
        UD60x18 strikeTo22 = pow(udStrike, expo22);

        // Calculate (strike^22 - (22/23 * scaleY))^(23/22)
        UD60x18 insideTerm = sub(strikeTo22, mul(scale1, div(ud(22e18), ud(23e18))));
        UD60x18 fracExpo = div(ud(23e18), ud(22e18));
        UD60x18 termToExpo = pow(insideTerm, fracExpo);

        return scale0.unwrap() >= termToExpo.unwrap();
    }
}

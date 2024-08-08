// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.5.0;

/// @title  View functions of the QFMM contract
/// @author Robert Leifke
interface IQFMMView {
    // ===== View =====

    /// @notice             Fetches the current invariant, notation is usually `k`, based on risky and stable token reserves of pool with `poolId`
    /// @param  poolId      Keccak256 hash of the engine address, strike, sigma, maturity, and gamma
    /// @return invariant   Signed fixed point 64.64 number, invariant of `poolId`
    function invariantOf(bytes32 poolId) external view returns (int128 invariant);

    // ===== Constants =====

    /// @return Precision units to scale to when doing token related calculations
    function PRECISION() external view returns (uint256);

    /// @return Amount of seconds after pool expiry which allows swaps, no swaps after buffer
    function BUFFER() external view returns (uint256);

    // ===== Immutables =====

    /// @return Amount of liquidity burned on `create()` calls
    function MIN_LIQUIDITY() external view returns (uint256);

    //// @return Factory address which deployed this engine contract
    function factory() external view returns (address);

    //// @return Underlying token address
    function tokenY() external view returns (address);

    /// @return Quote token address
    function tokenX() external view returns (address);

    /// @return Multiplier to scale amounts to/from, equal to 10^(18 - riskyDecimals)
    function scaleFactorTokenY() external view returns (uint256);

    /// @return Multiplier to scale amounts to/from, equal to 10^(18 - stableDecimals)
    function scaleFactorTokenX() external view returns (uint256);

    // ===== Pool State =====

    /// @notice                      Fetches the global reserve state for a pool with `poolId`
    /// @param  poolId               Keccak256 hash of the engine address, strike maturity, and gamma
    /// @return reserveY            tokenY balance in the reserve
    /// @return reserveX            tokenX balance in the reserve
    /// @return liquidity            Total supply of liquidity along the curve
    /// @return blockTimestamp       Timestamp when the cumulative reserve values were last updated
    /// @return cumulativeY      Cumulative sum of risky token reserves of the previous update
    /// @return cumulativeX     Cumulative sum of stable token reserves of the previous update
    /// @return cumulativeLiquidity  Cumulative sum of total supply of liquidity of the previous update
    function reserves(bytes32 poolId)
        external
        view
        returns (
            uint128 reserveY,
            uint128 reserveX,
            uint128 liquidity,
            uint32 blockTimestamp,
            uint256 cumulativeY,
            uint256 cumulativeX,
            uint256 cumulativeLiquidity
        );

    /// @notice                 Fetches `Calibration` pool parameters
    /// @param  poolId          Keccak256 hash of the engine address, strike, sigma, maturity, and gamma
    /// @return strike          Marginal price of the pool's risky token at maturity, with the same decimals as the stable token, valid [0, 2^128-1]
    /// @return maturity        Timestamp which starts the BUFFER countdown until swaps will cease, in seconds, valid for (block.timestamp, 2^32-1]
    /// @return lastTimestamp   Last timestamp used to calculate time until expiry, aka "tau"
    /// @return gamma           Multiplied against swap in amounts to apply fee, equal to 1 - fee % but units are in basis points, valid for (9_000, 10_000)
    function calibrations(bytes32 poolId)
        external
        view
        returns (
            uint128 strike,
            uint32 maturity,
            uint32 lastTimestamp,
            uint32 gamma
        );

    /// @notice             Fetches position liquidity an account address and poolId
    /// @param  poolId      Keccak256 hash of the engine address, strike, sigma, maturity, and gamma
    /// @return liquidity   Liquidity owned by `account` in `poolId`
    function liquidity(address account, bytes32 poolId) external view returns (uint256 liquidity);

    /// @notice                 Fetches the margin balances of `account`
    /// @param  account         Margin account to fetch
    /// @return balanceY    Balance of the risky token
    /// @return balanceX   Balance of the stable token
    function margins(address account) external view returns (uint128 balanceY, uint128 balanceX);
}
// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.8.4;

/// @title  Errors for the QFMM contract
/// @author Robert Leifke
/// @notice Custom errors are encoded with their selector and arguments
/// @dev    Peripheral smart contracts should try catch and check if data matches another custom error
interface IQFMMErrors {
    /// @notice Thrown on attempted re-entrancy on a function with a re-entrancy guard
    error LockedError();

    /// @notice Thrown when the balanceOf function is not successful and does not return data
    error BalanceError();

    // /// @notice Thrown in create when a pool with computed poolId already exists
    // error PoolDuplicateError();

    // /// @notice Thrown when calling an expired pool, where block.timestamp > maturity, + BUFFER if swap
    // error PoolExpiredError();

    // /// @notice Thrown when liquidity is lower than or equal to the minimum amount of liquidity
    // error MinLiquidityError(uint256 value);

    // /// @notice Thrown when riskyPerLp is outside the range of acceptable values, 0 < riskyPerLp <= 1eRiskyDecimals
    // error TokenYPerLpError(uint256 value);

    // /// @notice Thrown when strike is not valid, i.e. equal to 0 or greater than 2^128
    // error StrikeError(uint256 value);

    // /// @notice Thrown when gamma, equal to 1 - fee %, is outside its bounds: 9_000 <= gamma <= 10_000; 1_000 = 10% fee
    // error GammaError(uint256 value);

    // /// @notice Thrown when the parameters of a new pool are invalid, causing initial reserves to be 0
    // error CalibrationError(uint256 delTokenY, uint256 delTokenX);

    /// @notice         Thrown when the expected risky balance is less than the actual balance
    /// @param expected Expected tokenY balance
    /// @param actual   Actual tokenX balance
    error TokenYBalanceError(uint256 expected, uint256 actual);

    /// @notice         Thrown when the expected stable balance is less than the actual balance
    /// @param expected Expected tokenY balance
    /// @param actual   Actual tokenX balance
    error TokenXBalanceError(uint256 expected, uint256 actual);

    /// @notice Thrown when the pool with poolId has not been created
    error UninitializedError();

    /// @notice Thrown when the risky or stable amount is 0
    error ZeroDeltasError();

    /// @notice Thrown when the liquidity parameter is 0
    error ZeroLiquidityError();

    /// @notice Thrown when the deltaIn parameter is 0
    error DeltaInError();

    /// @notice Thrown when the deltaOut parameter is 0
    error DeltaOutError();
}
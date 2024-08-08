// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.5.0;

/// @title  Events of the QFMM contract
/// @author Robert Leifke
interface IQFMMEvents {
    /// @notice             Creates a pool with liquidity
    /// @dev                Keccak256 hash of the QFMM address, strike, sigma, maturity, and gamma
    /// @param  from        Calling `msg.sender` of the create function
    /// @param  strike      Marginal price of the pool's risky token at maturity, with the same decimals as the stable token, valid [0, 2^128-1]
    /// @param  maturity    Timestamp which starts the BUFFER countdown until swaps will cease, in seconds, valid for (block.timestamp, 2^32-1]
    /// @param  gamma       Multiplied against swap in amounts to apply fee, equal to 1 - fee % but units are in basis points, valid for (9000, 10_000)
    /// @param  delTokenY    Amount of risky tokens deposited
    /// @param  delTokenX   Amount of stable tokens deposited
    /// @param  delLiquidity Amount of liquidity granted to `recipient`
    event Create(
        address indexed from,
        uint128 strike,
        uint32 indexed maturity,
        uint32 indexed gamma,
        uint256 delTokenY,
        uint256 delTokenX,
        uint256 delLiquidity
    );

    /// @notice             Updates the time until expiry of the pool with `poolId`
    /// @param  poolId      Keccak256 hash of the QFMM address, strike, sigma, maturity, and gamma
    event UpdateLastTimestamp(bytes32 indexed poolId);

    // ===== Margin ====

    /// @notice             Added stable and/or risky tokens to a margin account
    /// @param  from        Method caller `msg.sender`
    /// @param  recipient   Margin account recieving deposits
    /// @param  delTokenY   Amount of risky tokens deposited
    /// @param  delTokenX  Amount of stable tokens deposited
    event Deposit(address indexed from, address indexed recipient, uint256 delTokenY, uint256 delTokenX);

    /// @notice             Removes stable and/or risky from a margin account
    /// @param  from        Method caller `msg.sender`
    /// @param  recipient   Address that tokens are sent to
    /// @param  delTokenY    Amount of risky tokens withdrawn
    /// @param  delTokenX   Amount of stable tokens withdrawn
    event Withdraw(address indexed from, address indexed recipient, uint256 delTokenY, uint256 delTokenX);

    // ===== Liquidity =====

    /// @notice             Adds liquidity of risky and stable tokens to a specified `poolId`
    /// @param  from        Method caller `msg.sender`
    /// @param  recipient   Address that receives liquidity
    /// @param  poolId      Keccak256 hash of the QFMM address, strike, maturity, and gamma
    /// @param  delTokenY    Amount of risky tokens deposited
    /// @param  delTokenX   Amount of stable tokens deposited
    /// @param  delLiquidity Amount of liquidity granted to `recipient`
    event Allocate(
        address indexed from,
        address indexed recipient,
        bytes32 indexed poolId,
        uint256 delTokenY,
        uint256 delTokenX,
        uint256 delLiquidity
    );

    /// @notice             Adds liquidity of risky and stable tokens to a specified `poolId`
    /// @param  from        Method caller `msg.sender`
    /// @param  poolId      Keccak256 hash of the QFMM address, strike, maturity, and gamma
    /// @param  delTokenY    Amount of risky tokens deposited
    /// @param  delTokenX   Amount of stable tokens deposited
    /// @param  delLiquidity Amount of liquidity decreased from `from`
    event Remove(
        address indexed from,
        bytes32 indexed poolId,
        uint256 delTokenY,
        uint256 delTokenX,
        uint256 delLiquidity
    );

    // ===== Swaps =====

    /// @notice             Swaps between `risky` and `stable` assets
    /// @param  from        Method caller `msg.sender`
    /// @param  recipient   Address that receives `deltaOut` amount of tokens
    /// @param  poolId      Keccak256 hash of the QFMM address, strike, sigma, maturity, and gamma
    /// @param  tokenYForTokenX  If true, swaps risky to stable, else swaps stable to risky
    /// @param  deltaIn     Amount of tokens added to reserves
    /// @param  deltaOut    Amount of tokens removed from reserves
    event Swap(
        address indexed from,
        address indexed recipient,
        bytes32 indexed poolId,
        bool tokenYForTokenX,
        uint256 deltaIn,
        uint256 deltaOut
    );
}
// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.7;

// import { IImmutableState } from "./IImmutableState.sol";

// /// @notice AMM implementing the capped power invariant
// /// @author Kyle Scott and Robert Leifke
// interface IQFMM {
//   /// @notice The amount of token0 in the QFMM
//   function reserve0() external view returns (uint120);

//   /// @notice The amount of token1 in the QFMM
//   function reserve1() external view returns (uint120);

//   /// @notice The total amount of liquidity shares in the QFMM
//   function totalLiquidity() external view returns (uint256);

//   /// @notice The fee charged on each swap
//   function swapFee() external view returns (uint256);

//   /// @notice The implementation of the quartic invariant
//   /// @return valid True if the invariant is satisfied
//   function invariant(uint256 amount0, uint256 amount1, uint256 liquidity) external view returns (bool);

//   /// @notice Exchange between token0 and token1, either accepts or rejects the proposed trade
//   /// @param data The data to be passed through to the callback
//   /// @dev A callback is invoked on the caller
//   function swap(address to, uint256 amount0Out, uint256 amount1Out, bytes calldata data) external;
// }

import "./qfmm/IQFMMActions.sol";
import "./qfmm/IQFMMEvents.sol";
import "./qfmm/IQFMMView.sol";
import "./qfmm/IQFMMErrors.sol";

/// @title QFMM Interface
interface IQFMM is
    IQFMMActions,
    IQFMMEvents,
    IQFMMView,
    IQFMMErrors
{

}
// SPDX-License-Identifier: GPL
pragma solidity ^0.8.7;

import "./interfaces/IERC20.sol";
import { UD60x18, ud, mul, div, pow, sub } from "@prb/math/src/UD60x18.sol";
import {SafeTransferLib} from "../lib/solmate/src/utils/SafeTransferLib.sol";
import {IQFMM} from "./interfaces/IQFMM.sol";
import "./interfaces/IFactory.sol";
import "forge-std/src/console2.sol";

/// @title Quartic Function Market Maker 
/// @author Robert Leifke 
/// @notice A CFMM that rebalances liquidity to a power-4 perpetual
contract QFMM is IQFMM {
  // struct Calibration {
  //         uint128 strike;
  //         uint32 sigma;
  //         uint32 maturity;
  //         uint32 lastTimestamp;
  //         uint32 gamma;
  //     }

  // uint256 public constant override PRECISION = 10**18;
  // uint256 public constant override BUFFER = 120 seconds;

  uint256 public immutable override MIN_LIQUIDITY;
  uint256 public immutable override scaleFactorTokenY;
  uint256 public immutable override scaleFactorTokenX;
  address public immutable override factory;
  address public immutable override tokenY;
  address public immutable override tokenX;

  // mapping(bytes32 => Calibration) public override calibrations;
  // mapping(address => Margin.Data) public override margins;
  // mapping(bytes32 => Reserve.Data) public override reserves;
  // mapping(address => mapping(bytes32 => uint256)) public override liquidity;

  /// @dev Reentrancy guard initialized to state
  uint256 private locked = 1;

  //fix rentrency guard
  modifier lock() {
    if (locked != 1) revert LockedError();

    locked = 2;
    _;
    locked = 1;
  }

  /// @notice Deploys an QFMM with two tokens, a 'Risky' and 'Stable'
  constructor() {
    (factory, tokenY, tokenX, scaleFactorTokenY, scaleFactorTokenX, MIN_LIQUIDITY) = IFactory(msg.sender).args();
  }

  // // Checks the quintic invariant
  //     function checkQuartic(
  //         uint256 amount0,
  //         uint256 amount1,
  //         uint256 liquidity,
  //         uint256 strike
  //     ) public pure returns (bool) {
  //         if (liquidity == 0) return (amount0 == 0 && amount1 == 0);
  //         require(liquidity > 0, "liquidity must be greater than zero");
  //         require(strike > 0, "strike must be greater than zero");

  //         // Convert amounts to UD60x18 types
  //         UD60x18 udAmount0 = ud(amount0);
  //         UD60x18 udAmount1 = ud(amount1);
  //         UD60x18 udLiquidity = ud(liquidity);
  //         UD60x18 udStrike = ud(strike);

  //         // Calculate (amount0 / totalLiquidity) and (amount1 / totalLiquidity)
  //         UD60x18 scale0 = div(udAmount0, udLiquidity);
  //         UD60x18 scale1 = div(udAmount1, udLiquidity);

  //         // Calculate strike^3
  //         UD60x18 expo3 = ud(3e18);
  //         UD60x18 strikeTo3 = pow(udStrike, expo3);

  //         // Calculate (strike^3 - (3/4 * scale1))^(4/3)
  //         UD60x18 insideTerm = sub(strikeTo3, mul(scale1, div(ud(3e18), ud(4e18))));
  //         UD60x18 fracExpo = div(ud(4e18), ud(3e18));
  //         UD60x18 termToExpo = pow(insideTerm, fracExpo);

  //         return scale0.unwrap() >= termToExpo.unwrap();
  //     }
  // }

  function updateLastTimestamp(bytes32 poolId) external override returns (uint32 lastTimestamp) {}

  function create(
    uint128 strike,
    uint32 maturity,
    uint32 gamma,
    uint256 tokenYPerLp,
    uint256 delLiquidity,
    bytes calldata data
  ) external override returns (bytes32 poolId, uint256 delTokenY, uint256 delTokenX) {}

  function deposit(address recipient, uint256 delTokenY, uint256 delTokenX, bytes calldata data) external override {}

  function withdraw(address recipient, uint256 delTokenY, uint256 delTokenX) external override {}

  function allocate(
    bytes32 poolId,
    address recipient,
    uint256 delTokenY,
    uint256 delTokenX,
    bool fromMargin,
    bytes calldata data
  ) external override returns (uint256 delLiquidity) {}

  function remove(
    bytes32 poolId,
    uint256 delLiquidity
  ) external override returns (uint256 delTokenY, uint256 delTokenX) {}

  function swap(
    // address recipient,
    // bytes32 poolId,
    // bool riskyForStable,
    // uint256 deltaIn,
    // uint256 deltaOut,
    // bool fromMargin,
    // bool toMargin,
    // bytes calldata data
  ) external override {}

  function PRECISION() external view override returns (uint256) {}

  function BUFFER() external view override returns (uint256) {}

//   function MIN_LIQUIDITY() external view override returns (uint256) {}

//   function factory() external view override returns (address) {}

//   function tokenY() external view override returns (address) {}

//   function tokenX() external view override returns (address) {}

//   function scaleFactorTokenY() external view override returns (uint256) {}

//   function scaleFactorTokenX() external view override returns (uint256) {}

  function reserves(
    bytes32 poolId
  )
    external
    view
    override
    returns (
      uint128 reserveY,
      uint128 reserveX,
      uint128 liquidity,
      uint32 blockTimestamp,
      uint256 cumulativeY,
      uint256 cumulativeX,
      uint256 cumulativeLiquidity
    )
  {}

  function calibrations(
    bytes32 poolId
  ) external view override returns (uint128 strike, uint32 maturity, uint32 lastTimestamp, uint32 gamma) {}

  function liquidity(address account, bytes32 poolId) external view override returns (uint256 liquidity) {}

  function margins(address account) external view override returns (uint128 balanceY, uint128 balanceX) {}


  // ===== View =====
function invariantOf(bytes32 poolId) public view override returns (int128 invariant) {
    // Calibration memory cal = calibrations[poolId];
    // uint32 tau = cal.maturity - cal.lastTimestamp; // cal maturity can never be less than lastTimestamp
    // (uint256 riskyPerLiquidity, uint256 stablePerLiquidity) = reserves[poolId].getAmounts(PRECISION); // 1e18 liquidity
    // invariant = ReplicationMath.calcInvariant(
    //     scaleFactorRisky,
    //     scaleFactorStable,
    //     riskyPerLiquidity,
    //     stablePerLiquidity,
    //     cal.strike,
    //     tau
    //     );
    }
}
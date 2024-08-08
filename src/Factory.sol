// SPDX-License-Identifier: GPL-3.0-only
pragma solidity ^0.8.7;

import "./interfaces/IFactory.sol";
import "./QFMM.sol";

/// @title   Factory
/// @author  Robert Leifke
/// @notice  Inspired by https://github.com/primitivefinance/rmm-core/blob/main/contracts/PrimitiveFactory.sol
/// @notice  No access controls are available to deployer
/// @dev     Deploy new QFMM contracts
contract Factory is IFactory {
    /// @notice Thrown when the risky and stable tokens are the same
    error SameTokenError();

    /// @notice Thrown when the risky or the stable token is 0x0...
    error ZeroAddressError();

    /// @notice Thrown on attempting to deploy an already deployed Engine
    error DeployedError();

    /// @notice Thrown on attempting to deploy a pool using a token with unsupported decimals
    error DecimalsError(uint256 decimals);

    /// @notice Engine will use these variables for its immutable variables
    struct Args {
        address factory;
        address tokenY;
        address tokenX;
        uint256 scaleFactorTokenY;
        uint256 scaleFactorTokenX;
        uint256 minLiquidity;
    }

    uint256 public constant override MIN_LIQUIDITY_FACTOR = 6;
    address public immutable override deployer;
    mapping(address => mapping(address => address)) public override getQFMM;
    Args public override args; // Used instead of an initializer in qfmm contract

    constructor() {
        deployer = msg.sender;
    }

    function deploy(address tokenY, address tokenX) external override returns (address qfmm) {
        if (tokenY == tokenX) revert SameTokenError();
        if (tokenY == address(0) || tokenX == address(0)) revert ZeroAddressError();
        if (getQFMM[tokenY][tokenX] != address(0)) revert DeployedError();

        qfmm = deploy(address(this), tokenY, tokenX);
        getQFMM[tokenY][tokenX] = qfmm;
        emit DeployEngine(msg.sender, tokenY, tokenX, qfmm);
    }

    /// @notice         Deploys an qfmm with a `salt`. Only supports tokens with 6 <= decimals <= 18
    /// @dev            qfmm contract should have no constructor args, because this affects the deployed address
    ///                 From solidity docs:
    ///                 "It will compute the address from the address of the creating contract,
    ///                 the given salt value, the (creation) bytecode of the created contract,
    ///                 and the constructor arguments."
    ///                 While the address is still deterministic by appending constructor args to a contract's bytecode,
    ///                 it's not efficient to do so on chain.
    /// @param  factory Address of the deploying smart contract
    /// @param  tokenY  tokenY address, underlying token
    /// @param  tokenX  tokenX address, quote token
    /// @return qfmm    qfmm contract address which was deployed
    function deploy(
        address factory,
        address tokenY,
        address tokenX
    ) internal returns (address qfmm) {
        (uint256 tokenYDecimals, uint256 tokenXDecimals) = (IERC20(tokenY).decimals(), IERC20(tokenX).decimals());
        if (tokenYDecimals > 18 || tokenYDecimals < 6) revert DecimalsError(tokenYDecimals);
        if (tokenXDecimals > 18 || tokenXDecimals < 6) revert DecimalsError(tokenXDecimals);

        unchecked {
            uint256 scaleFactorTokenY = 10**(18 - tokenYDecimals);
            uint256 scaleFactorTokenX = 10**(18 - tokenXDecimals);
            uint256 lowestDecimals = (tokenYDecimals > tokenXDecimals ? tokenXDecimals : tokenYDecimals);
            uint256 minLiquidity = 10**(lowestDecimals / MIN_LIQUIDITY_FACTOR);
            args = Args({
                factory: factory,
                tokenY: tokenY,
                tokenX: tokenX,
                scaleFactorTokenY: scaleFactorTokenY,
                scaleFactorTokenX: scaleFactorTokenX,
                minLiquidity: minLiquidity
            }); // QFMMs call this to get constructor args
        }
        
        qfmm = address(new QFMM{salt: keccak256(abi.encode(tokenY, tokenX))}());
        delete args;
    }
}
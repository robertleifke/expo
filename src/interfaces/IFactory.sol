// SPDX-License-Identifier: GPL-3.0-only
pragma solidity >=0.8.4;

/// @title   Factory Interface
/// @author  Robert Leifke
interface IFactory {
    /// @notice         Created a new qfmm contract!
    /// @param  from    Calling `msg.sender` of deploy
    /// @param  tokenX  tokenX of QFMM to deploy
    /// @param  tokenY  tokenY token of QFMM to deploy
    /// @param  qfmm  Deployed qfmm address
    event DeployEngine(address indexed from, address indexed tokenY, address indexed tokenX, address qfmm);

    /// @notice         Deploys a new Engine contract and sets the `getEngine` mapping for the tokens
    /// @param  tokenY   Risky token, the underlying token
    /// @param  tokenX  Stable token, the quote token
    function deploy(address tokenY, address tokenX) external returns (address qfmm);

    // ===== View =====

    /// @notice         Used to scale the minimum amount of liquidity to lowest precision
    /// @dev            E.g. if the lowest decimal token is 6, min liquidity w/ 18 decimals
    ///                 cannot be 1000 wei, therefore the token decimals
    ///                 divided by the min liquidity factor is the amount of minimum liquidity
    ///                 MIN_LIQUIDITY = 10 ^ (Decimals / MIN_LIQUIDITY_FACTOR)
    function MIN_LIQUIDITY_FACTOR() external pure returns (uint256);

    /// @notice                    Called within QFMM constructor so QFMM can set immutable
    ///                            variables without constructor args
    /// @return factory            Smart contract deploying the QFMM contract
    /// @return tokenY             tokenY, speculative token
    /// @return tokenX             tokenX, quote token
    /// @return scaleFactorTokenY  Scale factor of the tokenY, 10^(18 - tokenYTokenDecimals)
    /// @return scaleFactorTokenX  Scale factor of the tokenX, 10^(18 - tokenXTokenDecimals)
    /// @return minLiquidity       Minimum amount of liquidity on pool creation
    function args()
        external
        view
        returns (
            address factory,
            address tokenY,
            address tokenX,
            uint256 scaleFactorTokenY,
            uint256 scaleFactorTokenX,
            uint256 minLiquidity
        );

    /// @notice         Fetches engine address of a token pair which has been deployed from this factory
    /// @param tokenY   tokenY, the underlying token
    /// @param tokenX   tokenX token, the quote token
    /// @return qfmm    QFMM address for a tokenY and tokenX
    function getQFMM(address tokenY, address tokenX) external view returns (address qfmm);

    /// @notice         Deployer does not have any access controls to wield
    /// @return         Deployer of this factory contract
    function deployer() external view returns (address);
}
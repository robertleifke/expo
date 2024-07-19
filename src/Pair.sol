// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.25;

import { SafeTransferLib } from "lib/solmate/src/utils/SafeTransferLib.sol";
import { ABDKMathQuad } from "lib/abdk-libraries-solidity/ABDKMathQuad.sol";

contract Pair is ERC20 {

    using SafeTransferLib for ERC20;
    using ABDKMathQuad for bytes16;

    // Define p0 and p1 as constants or state variables
    bytes16 private constant p0 = ABDKMathQuad.fromUInt(10); // Example value
    bytes16 private constant p1 = ABDKMathQuad.fromUInt(5);  // Example value

    
    // int256 public constant INIT_UPPER_BOUND = 30;
    // uint256 public constant IMPLIED_RATE_TIME = 365 * 86400;
    // uint256 public constant BURNT_LIQUIDITY = 1000;
    // address public immutable WETH;

    modifier lock() {
        if (lock_ != 1) revert Reentrancy();
        lock_ = 0;
        _;
        lock_ = 1;
    }

    constructor(address weth_, string memory name_, string memory symbol_) ERC20(name_, symbol_, 18) {
        WETH = weth_;
    }

    function invariant(
            uint256 reserveX, 
            uint256 reserveY,
            uint256 totalLiquidity
    ) public returns (int256) {
        bytes16Quad = ABDKMATHQuad.fromUInt(x);

        uint256 scaleX = uint256(int256(rX.divWadDown(L)).powWad(int256(params.wX)));
        uint256 scaleY = uint256(int256(rY.divWadDown(L)).powWad(int256(params.wY)));


      
    }

    function initialize(
            uint256 priceX,
            uint256 amountX,
            uint256 strike_,
            uint256 fee_
    ) external lock {
        if (strike != 0) revert AlreadyInitialized();
        if (strike_ < 1e18) revert InvalidStrike();

        return value;
    }
}

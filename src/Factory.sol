// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.7;

import { Exponential } from "./Exponential.sol";

contract Factory {
    event NewPool(address indexed caller, address indexed pool, string name, string symbol);

    address public immutable WETH;

    address[] public pools;

    constructor(address weth_) {
        WETH = weth_;
    }

    function createExponential(
                string memory poolName, 
                string memory poolSymbol
    ) external returns (Exponential) {
        Exponential cfmm = new Exponential(WETH, poolName, poolSymbol);
        emit NewPool(msg.sender, address(cfmm), poolName, poolSymbol);
        pools.push(address(cfmm));
        return cfmm;
    }
}
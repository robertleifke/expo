// SPDX-License-Identifier: GPL
pragma solidity ^0.8.7;

import "forge-std/src/Script.sol";
import {Quintic} from "../src/Quintic.sol";

contract DeployInvariantChecker is Script {
    function run() external {
        // Start broadcasting transactions
        vm.startBroadcast();

        // Deploy the InvariantChecker contract
        Quintic invariant = new Quintic();

        // Stop broadcasting transactions
        vm.stopBroadcast();

        // Log the address of the deployed contract
        console.log("InvariantChecker deployed at:", address(invariant));
    }
}
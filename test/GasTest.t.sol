pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/invariant.sol";

contract GasTest is Test {
    Invariant checker;

    function setUp() public {
        checker = new Invariant();
    }

    function testGasCost() public {
        uint256 strike = 2e18; // Example value

        uint256 gasBefore = gasleft();
        // Execute the calculation
        uint256 strikeTo22 = checker.fixedPointSquare(strike, 1e18);
        for (uint256 i = 0; i < 20; i++) {
            strikeTo22 = FullMath.mulDiv(strikeTo22, strike, 1e18);
        }
        uint256 gasAfter = gasleft();
        
        uint256 gasUsed = gasBefore - gasAfter;
        emit log_named_uint("Gas used for strike^22 calculation", gasUsed);
    }
}

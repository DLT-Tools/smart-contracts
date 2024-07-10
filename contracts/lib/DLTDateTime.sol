// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.24;

library DLTDateTime {
    // Helper function to get the current year
    function getYear(uint256 timestamp) public pure returns (uint256) {
        uint256 ORIGIN_YEAR = 1970;
        uint256 SECONDS_PER_DAY = 24 * 60 * 60;
        uint256 DAYS_PER_YEAR = 365;
        
        // Número total de días desde 1970
        uint256 daysSinceEpoch = timestamp / SECONDS_PER_DAY;

        uint256 year;
        uint256 daysRemaining = daysSinceEpoch;
        
        for (year = ORIGIN_YEAR; daysRemaining >= DAYS_PER_YEAR; year++) {
            uint256 daysInYear = DAYS_PER_YEAR;

            // Si el año actual en el bucle es un año bisiesto, entonces tiene 366 días
            if (year % 4 == 0) {
                if (year % 100 != 0 || year % 400 == 0) {
                    daysInYear = DAYS_PER_YEAR + 1; // Año bisiesto
                }
            }
            
            daysRemaining -= daysInYear;
        }
        
        return year;
    }
}

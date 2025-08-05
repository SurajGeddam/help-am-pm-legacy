package com.helpampm.common;

public class CommonUtils {

    /**
     * Convert to double value upto 2 digits
     *
     */
    public static Double formatDouble(double number) {
        return Double.valueOf(HelpConstants.decimalFormat2Digit.format(number));
    }
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.pricing;

/**
 * @author kuldeep
 */
public enum Currency {
    DOLLAR("Dollar", "$"),
    GBP("Sterling Pound", "£"),
    INR("Indian Rupee", "₹");

    private final String name;
    private final String symbol;
    Currency(String name, String symbol) {
        this.name = name;
        this.symbol = symbol;
    }

    public String getName() {
        return name;
    }

    public String getSymbol() {
        return symbol;
    }
}

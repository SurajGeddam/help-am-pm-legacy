/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.pricing;

/**
 * @author kuldeep
 */
public enum PricingType {
    HOURLY(1, "Hourly"),
    FIXED(2, "Fixed");

    private final String type;
    private final int id;

    PricingType(int id, String type) {
        this.id = id;
        this.type = type;
    }

    public String getType() {
        return type;
    }

    public int getId() {
        return id;
    }
}

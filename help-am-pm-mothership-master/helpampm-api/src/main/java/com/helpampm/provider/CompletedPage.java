package com.helpampm.provider;

public enum CompletedPage {
    SIGNUP("SIGNUP", "Signup"),
    INDIVIDUAL("INDIVIDUAL", "Personal Details"),
    INSURANCE("INSURANCE", "Insurance Setup"),
    BUSINESS_LICENSE("BUSINESS_LICENSE", "Business License Setup"),
    TRADE_LICENSE("TRADE_LICENSE", "Trade License Setup"),
    VEHICLE("VEHICLE", "Vehicle Setup"),
    CATEGORY("CATEGORY", "Category Added"),
    BANK("BANK", "Bank Details Added");

    private final String name;
    private final String description;

    CompletedPage(String name, String description) {
        this.name = name;
        this.description = description;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }
}
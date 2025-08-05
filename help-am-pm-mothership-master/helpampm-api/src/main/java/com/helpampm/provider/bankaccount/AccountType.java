/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.bankaccount;

/**
 * @author kuldeep
 */
public enum AccountType {

    PERSONAL("Personal Account"),
    BUSINESS("Business Account");
    private final String name;

    AccountType(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}

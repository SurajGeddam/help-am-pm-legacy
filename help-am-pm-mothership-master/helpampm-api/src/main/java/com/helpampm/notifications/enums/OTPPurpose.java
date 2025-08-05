/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.enums;

/**
 * @author kuldeep
 */
public enum OTPPurpose {
    FORGOT_PASSWORD("Forgot Password"),
    DOWNLOAD_REPORT("Download Report");
    private final String name;

    OTPPurpose(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.common;

import java.text.DecimalFormat;

/**
 * @author kuldeep
 */
public class HelpConstants {

    public static final String PROVIDER_DEFAULT_ROLE = "ROLE_PROVIDER_ADMIN";
    public static final String ACTIVE = "active";
    public static final String IN_ACTIVE = "inActive";
    private HelpConstants() {
        throw new IllegalStateException("Utility class");
    }
    public static final DecimalFormat decimalFormat2Digit = new DecimalFormat("#0.00");
    public static final DecimalFormat decimalFormat1Digit = new DecimalFormat("#0.0");


    public static final String INDIVIDUAL = "individual";
    public static final String COMPLETE = "completed";
    public static final String INPROCESS = "inprocess";





}

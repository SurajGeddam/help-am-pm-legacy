/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.common;

import java.util.Objects;
import java.util.Optional;

/**
 * @author kuldeep
 */
public class StringUtils {

    private StringUtils() {
        throw new IllegalStateException("Utility class");
    }

    public static String capitalize(String input) {
        if (!isNullOrEmpty(input)) {
            input = input.toLowerCase();
            return input.replace(input.charAt(0), Character.toUpperCase(input.charAt(0)));
        }
        return "";
    }

    public static boolean isNullOrEmpty(String input) {
        return Objects.isNull(input) || Objects.equals("", input.trim());
    }

    public static boolean setDefaultBoolean(Boolean value) {
        return Optional.ofNullable(value).orElse(false);
    }

    public static String setDefaultString(String value) {
        return isNullOrEmpty(value) ? "" : value;
    }
}

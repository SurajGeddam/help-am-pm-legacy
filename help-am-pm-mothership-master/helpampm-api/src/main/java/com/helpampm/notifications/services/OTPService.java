/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.services;

import com.helpampm.notifications.entities.OneTimePassword;
import com.helpampm.notifications.enums.OTPPurpose;

/**
 * @author kuldeep
 */
public interface OTPService {
    OneTimePassword save(OneTimePassword otp);

    OneTimePassword findByUsername(String username);

    void checkOtpUsed(OneTimePassword otp);

    void markOTPUsed(Long id);

    void checkOtpExpired(OneTimePassword otp);

    void checkOtpValue(String oneTimePassword, OneTimePassword otp);

    OneTimePassword findByUsernameAndValueAndIsUsedAndType(String username, String otp,
                                                           Boolean isUsed, OTPPurpose forgotPassword);
}

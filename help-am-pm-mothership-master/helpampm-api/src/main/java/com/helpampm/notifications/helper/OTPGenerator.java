/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.helper;

import com.bastiaanjansen.otp.HMACAlgorithm;
import com.bastiaanjansen.otp.SecretGenerator;
import com.bastiaanjansen.otp.TOTP;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.time.Duration;

@Slf4j
@Component
/*
  @author kuldeep
 */
public class OTPGenerator {
    @Value("${notifications.otp.length}")
    private int length;
    @Value("${notifications.otp.new-codes-after-interval}")
    private int interval;

    public String generateOTP() {
        TOTP totp = new TOTP.Builder(SecretGenerator.generate())
                .withPasswordLength(length)
                .withAlgorithm(HMACAlgorithm.SHA1)
                .withPeriod(Duration.ofSeconds(interval)).build();
        return totp.now();
    }
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.repositories;

import com.helpampm.notifications.entities.OneTimePassword;
import com.helpampm.notifications.enums.OTPPurpose;
import com.helpampm.notifications.enums.OTPTarget;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

/**
 * @author kuldeep
 */
public interface OTPRepository extends JpaRepository<OneTimePassword, Long> {
    OneTimePassword findByUsername(String username);

    OneTimePassword findByUsernameAndValueAndIsUsedAndType(String username, String otp, boolean isUsed, OTPPurpose purpose);

    Optional<OneTimePassword> findByUsernameAndTypeAndTarget(String username, OTPPurpose type, OTPTarget target);
}

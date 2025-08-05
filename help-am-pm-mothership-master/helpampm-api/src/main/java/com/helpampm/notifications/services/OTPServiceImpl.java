/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.services;

import com.helpampm.notifications.NotificationException;
import com.helpampm.notifications.entities.OneTimePassword;
import com.helpampm.notifications.enums.OTPPurpose;
import com.helpampm.notifications.repositories.OTPRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Objects;
import java.util.Optional;

@Service
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class OTPServiceImpl implements OTPService {
    private final OTPRepository repository;

    @Override
    public OneTimePassword save(OneTimePassword otp) {
        assert Objects.nonNull(otp);
        Optional<OneTimePassword> optionOtp = repository
                .findByUsernameAndTypeAndTarget(otp.getUsername(), otp.getType(), otp.getTarget());
        if (optionOtp.isPresent()) {
            OneTimePassword oldOtp = optionOtp.get();
            oldOtp.setValue(otp.getValue());
            oldOtp.setCreatedAt(LocalDateTime.now());
            oldOtp.setLastUpdateAt(LocalDateTime.now());
            oldOtp.setExpiresAt(otp.getExpiresAt());
            oldOtp.setIsUsed(false);
            oldOtp.validate();
            return repository.save(oldOtp);
        }
        otp.setCreatedAt(LocalDateTime.now());
        otp.setLastUpdateAt(LocalDateTime.now());
        otp.validate();
        return repository.save(otp);
    }

    @Override
    public OneTimePassword findByUsername(String username) {
        return repository.findByUsername(username);
    }

    public void checkOtpUsed(OneTimePassword otp) {
        if (Boolean.TRUE.equals(otp.getIsUsed())) {
            throw new NotificationException("OTP is already used, please get a new one");
        }
    }

    public void checkOtpValue(String oneTimePassword, OneTimePassword otp) {
        if (!otp.getValue().equalsIgnoreCase(oneTimePassword)) {
            throw new NotificationException("OTP is invalid");
        }
    }

    @Override
    public OneTimePassword findByUsernameAndValueAndIsUsedAndType(String username, String otp,
                                                                  Boolean isUsed, OTPPurpose purpose) {
        return repository.findByUsernameAndValueAndIsUsedAndType(username, otp, isUsed, purpose);
    }

    public void checkOtpExpired(OneTimePassword otp) {
        LocalDateTime expiryTime = otp.getCreatedAt().plus(15, ChronoUnit.MINUTES);
        if (expiryTime.isBefore(LocalDateTime.now())) {
            throw new NotificationException("OTP is expired, please get a new one");
        }
    }

    public void markOTPUsed(Long id) {
        OneTimePassword oneTimePassword = repository.findById(id)
                .orElseThrow(() -> new NotificationException("OTP not found."));
        oneTimePassword.setIsUsed(true);
        repository.save(oneTimePassword);
    }
}

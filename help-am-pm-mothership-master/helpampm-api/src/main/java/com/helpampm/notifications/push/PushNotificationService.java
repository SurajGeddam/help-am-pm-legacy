/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.push;

import com.helpampm.notifications.entities.MobileDevice;
import com.helpampm.notifications.repositories.MobileDeviceRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class PushNotificationService {
    private final MobileDeviceRepository mobileDeviceRepository;
    private final PushNotificationSender pushNotificationSender;

    public MobileDevice registerDeviceToken(DeviceRegistrationPayload deviceRegistrationPayload) {
        log.debug("Register device token {} for {}.",
                deviceRegistrationPayload.getDeviceId(), deviceRegistrationPayload.getUsername());
        log.info("Register device token.");
        Optional<MobileDevice> mobileDeviceOptional = mobileDeviceRepository.findByDeviceId(deviceRegistrationPayload.getDeviceId());
        if (mobileDeviceOptional.isEmpty()) {
            log.info("Device id not found, saving to database.");
            MobileDevice mobileDevice = new MobileDevice();
            mobileDevice.setDeviceType(deviceRegistrationPayload.getDeviceType());
            mobileDevice.setDeviceId(deviceRegistrationPayload.getDeviceId());
            mobileDevice.setUsername(deviceRegistrationPayload.getUsername());
            mobileDevice.setCreatedAt(LocalDateTime.now());
            return mobileDeviceRepository.save(mobileDevice);
        }
        log.info("Device token is already exists.");
        return mobileDeviceOptional.get();
    }

    public void send(PushNotificationMessage pushNotificationMessage, String username) {
        pushNotificationSender.send(pushNotificationMessage, username);
    }
}

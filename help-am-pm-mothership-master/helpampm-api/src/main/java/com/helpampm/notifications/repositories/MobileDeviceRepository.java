/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.notifications.repositories;

import com.helpampm.notifications.entities.MobileDevice;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface MobileDeviceRepository extends JpaRepository<MobileDevice, Long> {
    Optional<MobileDevice> findByDeviceId(String token);
    List<MobileDevice> findByUsername(String recipient);
    Optional<MobileDevice> findByDeviceIdAndUsername(String deviceId, String username);
}


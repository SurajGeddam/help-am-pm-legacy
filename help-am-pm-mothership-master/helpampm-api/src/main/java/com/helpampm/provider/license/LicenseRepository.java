/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.license;

import com.helpampm.metadata.license.LicenseType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface LicenseRepository extends JpaRepository<License, Long> {
    Optional<License> findByProviderUniqueIdAndLicenseTypeAndLicenseNumber(String providerUniqueId,
                                                                           LicenseType licenseType,
                                                                           String licenseNumber);

    List<License> findByProviderUniqueId(String providerUniqueId);
}

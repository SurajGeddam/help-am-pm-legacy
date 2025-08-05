/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.license;

import java.util.List;

/**
 * @author kuldeep
 */
public interface LicenseService {
    List<License> saveAll(List<License> licenses);

    License save(License license);

    License update(License license);

    License findById(Long id);

    List<License> findAllByIds(List<Long> licenseIds);

    List<License> findByProviderUniqueId(String providerUniqueId);
}

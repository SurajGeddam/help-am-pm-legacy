/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.metadata.license;

import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface LicenseTypeService {
    List<LicenseType> findAllActive();
    List<LicenseType> findAll();

    LicenseType save(LicenseType licenseType);
    LicenseType update(LicenseType insuranceType);

    Optional<LicenseType> findByName(String name);
}

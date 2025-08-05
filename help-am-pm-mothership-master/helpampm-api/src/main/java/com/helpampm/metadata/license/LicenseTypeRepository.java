/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.metadata.license;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface LicenseTypeRepository extends JpaRepository<LicenseType, Integer> {
    List<LicenseType> findByIsActive(boolean isActive);
    Optional<LicenseType> findByName(String name);
}

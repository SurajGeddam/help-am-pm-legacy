/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.metadata.insurance;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface InsuranceTypeRepository extends JpaRepository<InsuranceType, Integer> {
    List<InsuranceType> findByIsActive(boolean isActive);

    Optional<InsuranceType> findByName(String name);
}

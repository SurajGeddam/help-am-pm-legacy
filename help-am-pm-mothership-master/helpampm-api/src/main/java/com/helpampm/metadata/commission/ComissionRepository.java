/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.commission;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface ComissionRepository extends JpaRepository<Commission, Integer> {
    List<Commission> findByIsActive(boolean isActive);

    Optional<Commission> findByCountyAndIsActive(String location, boolean isActitve);

    Optional<Commission> findByCountyAndRateAndIsActive(String location, Double taxName, boolean isActitve);

}

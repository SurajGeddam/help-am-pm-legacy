/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.commission;

import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface CommissionService {
    Commission create(Commission tax);

    Commission update(Commission tax);

    List<Commission> findAll();

    Commission findById(Integer id);

    List<Commission> findActiveAll();

    Optional<Commission> findByCountyAndIsActive(String county, boolean isActive);

    Commission findByCountyAndRateAndIsActive(String county, Double rate, boolean isActive);
}

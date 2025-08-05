/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.metadata.insurance;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface InsuranceTypeService {
    List<InsuranceType> findAllActive();
    List<InsuranceType> findAll();


    @Transactional
    InsuranceType save(InsuranceType insuranceType);

    @Transactional
    InsuranceType update(InsuranceType insuranceType);

    Optional<InsuranceType> findByName(String name);
}

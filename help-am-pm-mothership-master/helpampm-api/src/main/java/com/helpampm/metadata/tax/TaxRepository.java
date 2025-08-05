/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.tax;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface TaxRepository extends JpaRepository<Tax, Integer> {
    List<Tax> findByIsActive(boolean isActive);

    Optional<Tax> findByTaxCountyAndTaxNameAndTaxPeriod(String location, String taxName, String taxPeriod);

    Tax findByTaxCounty(String county);
}

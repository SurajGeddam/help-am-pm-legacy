/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.tax;

import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface TaxService {
    Tax create(Tax tax);

    Tax update(Tax tax);

    List<Tax> findAll();

    Tax findById(Integer id);

    List<Tax> findActiveAll();

    Optional<Tax> findByTaxLocationAndTaxNameAndTaxPeriod(String location, String taxName, String taxPeriod);

    Tax findByTaxCounty(String county);
}

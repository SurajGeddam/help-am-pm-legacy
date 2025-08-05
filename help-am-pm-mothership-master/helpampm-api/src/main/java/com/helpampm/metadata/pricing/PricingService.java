/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.pricing;

import java.util.List;

/**
 * @author kuldeep
 */
public interface PricingService {
    Pricing create(Pricing pricing);

    List<Pricing> findAll();

    Pricing findById(Integer id);

    Pricing update(Integer timeslotId, Pricing pricing);

    List<Pricing> findAllActive();
}

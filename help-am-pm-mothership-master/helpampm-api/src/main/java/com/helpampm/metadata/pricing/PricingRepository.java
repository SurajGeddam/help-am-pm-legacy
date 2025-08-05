/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.pricing;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * @author kuldeep
 */
public interface PricingRepository extends JpaRepository<Pricing, Integer> {
    List<Pricing> findByIsActive(boolean isActive);
}

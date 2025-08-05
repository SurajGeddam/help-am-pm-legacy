/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.vehicle;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * @author kuldeep
 */
public interface VehicleRepository extends JpaRepository<Vehicle, Long> {
    List<Vehicle> findByProviderUniqueId(String providerUniqueId);

}

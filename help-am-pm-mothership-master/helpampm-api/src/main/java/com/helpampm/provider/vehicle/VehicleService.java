/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.vehicle;

import java.util.List;

/**
 * @author kuldeep
 */
public interface VehicleService {
    List<Vehicle> findAll();

    Vehicle findById(Long id);

    List<Vehicle> saveAll(List<Vehicle> vehicles);

    Vehicle save(Vehicle vehicle);

    Vehicle update(Vehicle vehicle);

    List<Vehicle> findAllByIds(List<Long> vehicleIds);

    List<Vehicle>  findByProviderUniqueId(String providerUniqueId);
}

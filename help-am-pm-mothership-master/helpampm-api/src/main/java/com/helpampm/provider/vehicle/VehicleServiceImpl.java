/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.vehicle;

import com.helpampm.provider.ProviderException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.NotImplementedException;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;

@Service
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class VehicleServiceImpl implements VehicleService {
    private final VehicleRepository repository;

    @Override
    public List<Vehicle> findAll() {
        return repository.findAll();
    }

    @Override
    public Vehicle findById(Long id) {
        return repository.findById(id).orElseThrow(() -> new ProviderException("Unable to find employee.", HttpStatus.NOT_FOUND));
    }

    @Override
    public List<Vehicle> saveAll(List<Vehicle> vehicles) {
        return repository.saveAll(vehicles);
    }

    @Override
    public Vehicle save(Vehicle vehicle) {
        assert Objects.nonNull(vehicle);
        vehicle.setCreatedAt(LocalDateTime.now());
        vehicle.setLastUpdatedAt(LocalDateTime.now());
        vehicle.validate();
        return repository.save(vehicle);
    }

    @Override
    public Vehicle update(Vehicle vehicle) {
        throw new NotImplementedException("Waiting for implementation");
    }

    @Override
    public List<Vehicle> findAllByIds(List<Long> vehicleIds) {
        return repository.findAllById(vehicleIds);
    }

    @Override
    public List<Vehicle> findByProviderUniqueId(String providerUniqueId) {
        return repository.findByProviderUniqueId(providerUniqueId);
    }
}

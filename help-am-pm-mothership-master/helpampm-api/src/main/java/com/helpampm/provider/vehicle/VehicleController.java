/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.vehicle;

import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("vehicle")
@Tag(name = "Vehicle Management")
/*
  @author kuldeep
 */
public class VehicleController {
    private final VehicleService service;

    @PostMapping("")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE"})
    public ResponseEntity<Vehicle> create(@RequestBody Vehicle vehicle) {
        return ResponseEntity.ok(service.save(vehicle));
    }

    @PutMapping("")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE"})
    public ResponseEntity<Vehicle> update(@RequestBody Vehicle vehicle) {
        return ResponseEntity.ok(service.update(vehicle));
    }

    @GetMapping("{providerUniqueId}")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE"})
    public ResponseEntity<List<Vehicle>> getAll(@PathVariable("providerUniqueId") String providerUniqueId) {
        return ResponseEntity.ok(service.findByProviderUniqueId(providerUniqueId));
    }

}

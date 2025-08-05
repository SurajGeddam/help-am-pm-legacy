/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.license;

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
@RequestMapping("license")
@Tag(name = "License Management")
/*
  @author kuldeep
 */
public class LicenseController {
    private final LicenseService service;

    @PostMapping("")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE"})
    public ResponseEntity<License> create(@RequestBody License license) {
        return ResponseEntity.ok(service.save(license));
    }

    @PutMapping("")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE"})
    public ResponseEntity<License> update(@RequestBody License license) {
        return ResponseEntity.ok(service.update(license));
    }

    @GetMapping("{providerUniqueId}")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE"})
    public ResponseEntity<List<License>> getAll(@PathVariable("providerUniqueId") String providerUniqueId) {
        return ResponseEntity.ok(service.findByProviderUniqueId(providerUniqueId));
    }

}

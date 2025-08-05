/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.insurance;

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
@RequestMapping("insurance")
@Tag(name = "insurance Management")
/*
  @author kuldeep
 */
public class InsuranceController {
    private final InsuranceService service;

    @PostMapping("")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "`ROLE_PROVIDER_EMPLOYEE`"})
    public ResponseEntity<Insurance> create(@RequestBody Insurance insurance) {
        return ResponseEntity.ok(service.save(insurance));
    }

    @PutMapping("")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE"})
    public ResponseEntity<Insurance> update(@RequestBody Insurance insurance) {
        return ResponseEntity.ok(service.update(insurance));
    }

    @GetMapping("{providerUniqueId}")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE"})
    public ResponseEntity<List<Insurance>> getAll(@PathVariable("providerUniqueId") String providerUniqueId) {
        return ResponseEntity.ok(service.findByProviderUniqueId(providerUniqueId));
    }

}

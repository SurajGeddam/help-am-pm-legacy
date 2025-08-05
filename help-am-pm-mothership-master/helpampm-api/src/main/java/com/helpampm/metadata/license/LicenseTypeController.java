/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.metadata.license;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @author kuldeep
 */
@RestController
@RequestMapping(value = "license-type")
@Slf4j
@RequiredArgsConstructor
public class LicenseTypeController {
    private final LicenseTypeService service;
    //called from mobile
    @GetMapping
    public ResponseEntity<List<LicenseType>> getAllActive() {
        return ResponseEntity.ok(service.findAllActive());
    }

    @GetMapping("all")
    public ResponseEntity<List<LicenseType>> getAll() {
        return ResponseEntity.ok(service.findAll());
    }

    @PostMapping
    public ResponseEntity<LicenseType> create(@RequestBody LicenseType licenseType) {
        return ResponseEntity.ok(service.save(licenseType));
    }

    @PutMapping
    public ResponseEntity<LicenseType> update(@RequestBody LicenseType licenseType) {
        return ResponseEntity.ok(service.update(licenseType));
    }
}

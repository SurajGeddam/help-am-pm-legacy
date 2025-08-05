/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.metadata.insurance;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @author kuldeep
 */
@RestController
@RequestMapping(value = "insurance-type")
@Slf4j
@RequiredArgsConstructor
public class InsuranceTypeController {
    private final InsuranceTypeService service;

    //called from mobile
    @GetMapping
    public ResponseEntity<List<InsuranceType>> getAllActive() {
        return ResponseEntity.ok(service.findAllActive());
    }

    @GetMapping("all")
    public ResponseEntity<List<InsuranceType>> getAll() {
        return ResponseEntity.ok(service.findAll());
    }

    @PostMapping
    public ResponseEntity<InsuranceType> create(@RequestBody InsuranceType insuranceType) {
        return ResponseEntity.ok(service.save(insuranceType));
    }

    @PutMapping
    public ResponseEntity<InsuranceType> update(@RequestBody InsuranceType insuranceType) {
        return ResponseEntity.ok(service.update(insuranceType));
    }
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.info.controllers;

import com.helpampm.metadata.info.entities.HelpAndSupport;
import com.helpampm.metadata.info.services.HelpAndSupportService;
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
@RequestMapping("help/support_info")
@Tag(name = "Help and Support Info")
/*
  @author kuldeep
 */
public class HelpAndSupportController {
    private final HelpAndSupportService service;

    @PostMapping("")
    @Secured({"ROLE_SUPERADMIN"})
    public ResponseEntity<HelpAndSupport> create(@RequestBody HelpAndSupport helpAndSupport) {
        return ResponseEntity.ok(service.create(helpAndSupport));
    }

    @PutMapping("")
    @Secured({"ROLE_SUPERADMIN"})
    public ResponseEntity<HelpAndSupport> update(@RequestBody HelpAndSupport helpAndSupport) {
        return ResponseEntity.ok(service.update(helpAndSupport));
    }

    @GetMapping("")
    @Secured({"ROLE_PROVIDER_EMPLOYEE",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_CUSTOMER",
            "ROLE_SUPERADMIN"})
    public ResponseEntity<List<HelpAndSupport>> getActive() {
        return ResponseEntity.ok(service.getByActive(true));
    }

    @GetMapping("all")
    public ResponseEntity<List<HelpAndSupport>> getAll() {
        return ResponseEntity.ok(service.getAll());
    }
}

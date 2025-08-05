/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.category;

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
@RequestMapping("category")
@Tag(name = "Categories Management")
/*
  @author kuldeep
 */
public class CategoryController {
    private final CategoryService service;

    @PostMapping("")
    @Secured({"ROLE_SUPERADMIN"})
    public ResponseEntity<Category> create(@RequestBody Category category) {
        return ResponseEntity.ok(service.create(category));
    }

    @PutMapping("")
    @Secured({"ROLE_SUPERADMIN"})
    public ResponseEntity<Category> update(@RequestBody Category category) {
        return ResponseEntity.ok(service.update(category));
    }

    @GetMapping("{id}")
    @Secured({"ROLE_PROVIDER_EMPLOYEE",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_CUSTOMER",
            "ROLE_SUPERADMIN"})
    public ResponseEntity<Category> getById(@PathVariable("id") Integer id) {
        return ResponseEntity.ok(service.getById(id));
    }

    @GetMapping("")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_CUSTOMER",
            "ROLE_PROVIDER_EMPLOYEE"})
    public ResponseEntity<List<Category>> getAll() {
        return ResponseEntity.ok(service.getAll());
    }

    @GetMapping("active")
    @Secured({"ROLE_PROVIDER_EMPLOYEE",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_CUSTOMER",
            "ROLE_SUPERADMIN"})
    public ResponseEntity<List<Category>> getAllActive() {
        return ResponseEntity.ok(service.getAllActive());
    }
}

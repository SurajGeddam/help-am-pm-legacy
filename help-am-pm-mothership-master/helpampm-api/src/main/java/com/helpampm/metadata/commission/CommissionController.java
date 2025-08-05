/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.commission;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
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
@RequestMapping("commission")
@Tag(name = "Commission Management")
/*
  @author rakesh
 */
public class CommissionController {
    private final CommissionService service;

    @PostMapping("")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Create a tax entry for state")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Commission.class)))})
    public ResponseEntity<Commission> create(@RequestBody Commission commission) {
        return ResponseEntity.ok(service.create(commission));
    }

    @PutMapping("")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Update a commission entry for state")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Commission.class)))})
    public ResponseEntity<Commission> update(@RequestBody Commission commission) {
        return ResponseEntity.ok(service.update(commission));
    }

    @GetMapping("")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "List all commissiones")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = Commission.class))))})
    public ResponseEntity<List<Commission>> findAll() {
        return ResponseEntity.ok(service.findAll());
    }

    @GetMapping("active")
    @Secured({"ROLE_PROVIDER_EMPLOYEE",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_CUSTOMER",
            "ROLE_SUPERADMIN"})
    @Operation(summary = "List all active commissiones")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = Commission.class))))})
    public ResponseEntity<List<Commission>> findActiveAll() {
        return ResponseEntity.ok(service.findActiveAll());
    }

    @GetMapping("{id}")
    @Secured({"ROLE_PROVIDER_EMPLOYEE",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_CUSTOMER",
            "ROLE_SUPERADMIN"})
    @Operation(summary = "Find a commission entry by id")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Commission.class)))})
    public ResponseEntity<Commission> findById(@PathVariable("id") Integer id) {
        return ResponseEntity.ok(service.findById(id));
    }

    @GetMapping("county/{name}")
    @Secured({"ROLE_PROVIDER_EMPLOYEE",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_CUSTOMER",
            "ROLE_SUPERADMIN"})
    @Operation(summary = "Find a latest commission entry for county")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Commission.class)))})
    public ResponseEntity<Commission> findById(@PathVariable("name") String stateName) {
        return ResponseEntity.ok(service.findByCountyAndIsActive(stateName, true).orElse(null));
    }
}

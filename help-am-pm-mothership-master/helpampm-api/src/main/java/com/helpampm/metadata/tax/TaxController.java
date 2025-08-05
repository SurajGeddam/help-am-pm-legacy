/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.tax;

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
@RequestMapping("tax")
@Tag(name = "Tax Management")
/*
  @author kuldeep
 */
public class TaxController {
    private final TaxService service;

    @PostMapping("")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Create a tax entry for state")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Tax.class)))})
    public ResponseEntity<Tax> create(@RequestBody Tax tax) {
        return ResponseEntity.ok(service.create(tax));
    }

    @PutMapping("")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Update a tax entry for state")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Tax.class)))})
    public ResponseEntity<Tax> update(@RequestBody Tax tax) {
        return ResponseEntity.ok(service.update(tax));
    }

    @GetMapping("")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "List all taxes")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = Tax.class))))})
    public ResponseEntity<List<Tax>> findAll() {
        return ResponseEntity.ok(service.findAll());
    }

    @GetMapping("active")
    @Secured({"ROLE_PROVIDER_EMPLOYEE",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_CUSTOMER",
            "ROLE_SUPERADMIN"})
    @Operation(summary = "List all active taxes")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = Tax.class))))})
    public ResponseEntity<List<Tax>> findActiveAll() {
        return ResponseEntity.ok(service.findActiveAll());
    }

    @GetMapping("{id}")
    @Secured({"ROLE_PROVIDER_EMPLOYEE",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_CUSTOMER",
            "ROLE_SUPERADMIN"})
    @Operation(summary = "Find a tax entry by id")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Tax.class)))})
    public ResponseEntity<Tax> findById(@PathVariable("id") Integer id) {
        return ResponseEntity.ok(service.findById(id));
    }

    @GetMapping("county/{name}")
    @Secured({"ROLE_PROVIDER_EMPLOYEE",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_CUSTOMER",
            "ROLE_SUPERADMIN"})
    @Operation(summary = "Find a latest tax entry for county")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Tax.class)))})
    public ResponseEntity<Tax> findById(@PathVariable("name") String stateName) {
        return ResponseEntity.ok(service.findByTaxCounty(stateName));
    }
}

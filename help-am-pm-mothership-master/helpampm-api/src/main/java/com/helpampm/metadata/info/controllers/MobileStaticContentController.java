/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.info.controllers;

import com.helpampm.metadata.info.entities.MobileStaticContent;
import com.helpampm.metadata.info.services.MobileStaticContentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("mobile/static-content")
@RequiredArgsConstructor
@Slf4j
@Tag(name = "Mobile static content management")
/*
  @author kuldeep
 */
public class MobileStaticContentController {

    private final MobileStaticContentService service;

    @PostMapping("")
    @Operation(summary = "Create Mobile static content key value")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = MobileStaticContent.class)))})
    public ResponseEntity<MobileStaticContent> create(@RequestBody MobileStaticContent mobileStaticContent) {
        return ResponseEntity.ok(service.create(mobileStaticContent));
    }

    @PutMapping("")
    @Operation(summary = "Update Mobile static content key value")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = MobileStaticContent.class)))})
    public ResponseEntity<MobileStaticContent> update(@RequestBody MobileStaticContent mobileStaticContent) {
        return ResponseEntity.ok(service.update(mobileStaticContent));
    }

    @GetMapping("")
    @Operation(summary = "List All Mobile static content key value")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = MobileStaticContent.class)))})
    public ResponseEntity<List<MobileStaticContent>> getAll() {
        return ResponseEntity.ok(service.listAll());
    }

    @GetMapping("{id}")
    @Operation(summary = "Get mobile static key value by Id")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = MobileStaticContent.class)))})
    public ResponseEntity<MobileStaticContent> getById(@PathVariable("id") Long id) {
        return ResponseEntity.ok(service.findByIs(id));
    }

    @GetMapping("key/{key}")
    @Operation(summary = "Get mobile static key value by key")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = MobileStaticContent.class)))})
    public ResponseEntity<MobileStaticContent> getById(@PathVariable("key") String key,
                                                       @RequestHeader("lang_code") String langCode) {
        return ResponseEntity.ok(service.findByKey(key, langCode));
    }
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.livelocation;

import com.helpampm.common.GeneralResponse;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("location")

@Tag(name = "Location Management")
/*
  @author kuldeep
 */
public class LocationController {
    private final LocationService service;

    @PostMapping("provider")
    @Operation(summary = "Save live location data from provider app.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Location.class)))})
    @Secured({"ROLE_PROVIDER_ADMIN", "ROLE_PROVIDER_EMPLOYEE"})
    public ResponseEntity<GeneralResponse> create(@RequestBody Location location) {
        service.save(location);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(200).withMessage("Save location success").build());
    }
}

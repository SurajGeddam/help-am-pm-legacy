/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.settings;

import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.services.AuthenticationService;
import com.helpampm.common.GeneralResponse;
import com.helpampm.customer.CustomerService;
import com.helpampm.notifications.SettingsUpdateDto;
import com.helpampm.provider.ProviderUpdateService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author kuldeep
 */
@RestController
@RequestMapping(value = "settings")
@Slf4j
@AllArgsConstructor
@Tag(name = "System Settings")
public class SettingsController {
    private final SettingsService settingsService;

    @PostMapping("notification")
    @Operation(summary = "Get Notification by id")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Notification Settings updated",
                    content = @Content(schema = @Schema(implementation = GeneralResponse.class)))})
    public ResponseEntity<GeneralResponse> settings(@RequestBody SettingsUpdateDto settingsUpdateDto) {
        settingsService.updateSettings(settingsUpdateDto);
        return ResponseEntity.ok(GeneralResponse.builder().withMessage("Notification settings updated").build());
    }
}

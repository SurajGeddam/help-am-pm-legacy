/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications;

import com.helpampm.notifications.dtos.NotificationDto;
import com.helpampm.notifications.dtos.NotificationFilterRequestPayload;
import com.helpampm.notifications.dtos.NotificationPageableResponse;
import com.helpampm.notifications.entities.Notification;
import com.helpampm.notifications.enums.NotificationType;
import com.helpampm.notifications.services.NotificationService;
import com.stripe.model.Transfer;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping(value = "notification")
@Slf4j
@AllArgsConstructor
@Tag(name = "Notification Management")
/*
  @author kuldeep
 */
public class NotificationController {
    private final NotificationService notificationService;

    @GetMapping
    @Operation(summary = "List all Notifications")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = Notification.class))))})
    public ResponseEntity<NotificationPageableResponse> findAll() {
        List<Notification> notifications = notificationService.findAll();
        return ResponseEntity.ok(new NotificationPageableResponse(notifications.size(), notifications));
    }

    @GetMapping("/type")
    @Operation(summary = "List all Notifications")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = Notification.class))))})
    public ResponseEntity<NotificationPageableResponse> findAllByNotificationType() {
        List<Notification> notifications = notificationService.findAllNotificationType(NotificationType.PUSH);
        return ResponseEntity.ok(new NotificationPageableResponse(notifications.size(), notifications));
    }

    @PostMapping("pageableNotifications")
    @Operation(summary = "List all Notifications as pageable")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = Notification.class))))})
    public ResponseEntity<NotificationPageableResponse> findAllPageable(@RequestBody NotificationFilterRequestPayload notificationFilterRequestPayload) {
        List<Notification> notifications = notificationService.findAll();
        return ResponseEntity.ok(new NotificationPageableResponse(notifications.size(), notifications));
    }


    @GetMapping("{id}")
    @Operation(summary = "Get Notification by id")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Notification.class)))})
    public ResponseEntity<Notification> findById(@PathVariable("id") Long id) {
        return ResponseEntity.ok(notificationService.findById(id));
    }

    @GetMapping("user/{username}")
    @Operation(summary = "Get Notification by id")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Notification.class)))})
    public ResponseEntity<List<NotificationDto>> findByUsername(@PathVariable("username") String username) {
        List<Notification> notifications = notificationService.findByUsernameAndNotificationType(username, NotificationType.PUSH);
        List<NotificationDto> response = notifications.stream().map(NotificationDto::buildFromNotification).collect(Collectors.toList());
        return ResponseEntity.ok(response);
    }

}

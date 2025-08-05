/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.push;

import com.fasterxml.jackson.databind.JsonNode;
import com.helpampm.common.GeneralResponse;
import com.helpampm.quote.QuoteStatus;
import lombok.Builder;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@Slf4j
@RequiredArgsConstructor
@RequestMapping("pushnotification")
/*
  @author kuldeep
 */
public class PushNotificationController {
    private final PushNotificationService notificationService;
    private final PushNotificationSender pushNotificationSender;

    @PostMapping("")
    public ResponseEntity<GeneralResponse> registerDeviceToken(@RequestBody DeviceRegistrationPayload deviceRegistrationPayload) {
        notificationService.registerDeviceToken(deviceRegistrationPayload);
        return ResponseEntity.ok(GeneralResponse.builder().withMessage("Registered Success").withStatus(200).build());
    }

    @PostMapping("test/{username}")
    //TODO: Delete it after testing push notifications
    public ResponseEntity<SampleResponse> testPushNotification(@PathVariable("username") String username,
                                                               @RequestBody JsonNode jsonNode) {
        Map<String, Object> data = new HashMap<>();
        jsonNode.fieldNames().forEachRemaining(f -> data.put(f, jsonNode.get(f).asText()));
        pushNotificationSender.send(PushNotificationMessage.builder()
                .withData(data)
                .withBody("Testing push notification body")
                .withTitle("Testing push notification title")
                .withStatus(QuoteStatus.ACCEPTED_BY_PROVIDER.name())
                .build(), username);
        return ResponseEntity.ok(SampleResponse.builder()
                .withStatus(HttpStatus.ACCEPTED.value())
                .withMessage("Successfully send push notification")
                .build());
    }


    @Data
    @Builder(setterPrefix = "with")
    static class SampleResponse {
        private String message;
        private int status;
    }
}

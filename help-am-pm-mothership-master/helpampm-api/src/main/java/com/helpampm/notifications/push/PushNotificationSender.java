/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.push;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.helpampm.common.StringUtils;
import com.helpampm.notifications.NotificationException;
import com.helpampm.notifications.entities.MobileDevice;
import com.helpampm.notifications.entities.Notification;
import com.helpampm.notifications.enums.NotificationType;
import com.helpampm.notifications.helper.NotificationHelper;
import com.helpampm.notifications.push.firebase.ClientMessageService;
import com.helpampm.notifications.repositories.MobileDeviceRepository;
import com.helpampm.notifications.repositories.NotificationRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class PushNotificationSender {
    private final ClientMessageService clientMessageService;
    private final MobileDeviceRepository mobileDeviceRepository;
    private final NotificationRepository notificationRepository;
    private static final ObjectMapper objectMapper = new ObjectMapper();

    public void send(PushNotificationMessage notificationMessage, String username) {
        if (StringUtils.isNullOrEmpty(username)) {
            throw new NotificationException("Sending push notification failed, Recipient can not be null");
        }
        List<MobileDevice> deviceTokens = mobileDeviceRepository.findByUsername(username); //User can logged in with multiple devices.
        log.debug(String.format("Sending push notification to %s and Device ID's %s", username, deviceTokens));
        deviceTokens.stream().filter(mobileDevice -> !StringUtils.isNullOrEmpty(mobileDevice.getDeviceId()))
                .forEach(deviceToken -> {
                    log.debug("Sending push notification for user {}", username);
                    String response = clientMessageService
                            .send(deviceToken.getDeviceId(), notificationMessage.toMap());
                    try {
                        String notificationData = objectMapper.writeValueAsString(notificationMessage.getData());
                        log.debug("Creating system notification: push");
                        Notification notification = NotificationHelper.createNotification(username,
                                notificationData, NotificationType.PUSH);
                        notificationRepository.save(notification);
                        log.debug("System notification saved: push");
                    } catch (Exception e) {
                        log.error(e.getMessage());
                    }
                    log.debug(response);
                });
    }
}

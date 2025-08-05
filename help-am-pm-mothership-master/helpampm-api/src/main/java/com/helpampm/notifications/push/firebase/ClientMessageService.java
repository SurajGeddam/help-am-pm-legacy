/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.push.firebase;

import com.google.firebase.messaging.*;
import com.helpampm.notifications.NotificationException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Component
@RequiredArgsConstructor
@Slf4j
/*
  @author kuldeep
 */
public class ClientMessageService {
    private final FirebaseMessaging firebaseMessaging;
    @Value("${help.company.logo}")
    private String logoPath;

    public String send(String clientRegistrationToken, Map<String, Object> data) {
        Map<String, String> firebaseData = new HashMap<>();
        data.forEach((k, v) -> firebaseData.put(k, Objects.toString(v)));

        try {
            Message msg = Message.builder()
                    .setApnsConfig(createApnsConfig(data))
                    .setAndroidConfig(createAndroidNotification(firebaseData))
                    .setWebpushConfig(createWebPushConfigs(firebaseData))
                    .putAllData(firebaseData)
                    .setToken(clientRegistrationToken)
                    .setNotification(Notification.builder()
                            .setBody(firebaseData.get("body"))
                            .setImage(logoPath)
                            .setTitle(Objects.nonNull(firebaseData.get("title")) ? firebaseData.get("title") : "New Notification from HELP.")
                            .build())
                    .build();
            return firebaseMessaging.send(msg);
        } catch (FirebaseMessagingException e) {
            e.printStackTrace();
            log.error(e.getMessage());
            //throw new NotificationException("Sending push notification failed.");
        }
        return firebaseData.get("body");
    }

    private static WebpushConfig createWebPushConfigs(Map<String, String> firebaseData) {
        return WebpushConfig.builder()
                .putAllData(firebaseData)
                .build();
    }

    private static ApnsConfig createApnsConfig(Map<String, Object> data) {
        return ApnsConfig.builder()
                .putAllHeaders(new HashMap<>() {{
                    put("apns-priority", String.valueOf(5));
                }})
                .putAllCustomData(data)
                .setAps(Aps.builder()
                        .putAllCustomData(data)
                        .setCategory("NEW_MESSAGE_CATEGORY")
                        .setSound("bingbong.aiff")
                        .build())
                .build();
    }

    private AndroidConfig createAndroidNotification(Map<String, String> firebaseData) {
        return AndroidConfig.builder()
                .putAllData(firebaseData)
                .setNotification(AndroidNotification.builder()
                        .setBody(firebaseData.get("body"))
                        .setImage(logoPath)
                        .setTitle(Objects.nonNull(firebaseData.get("title")) ? firebaseData.get("title") : "New Notification from HELP.")
                        .setDefaultSound(true)
                        .setSound("bingbong.aiff")
                        .setIcon(logoPath)
                        .setPriority(AndroidNotification.Priority.DEFAULT)
                        .build())
                .build();
    }

    public BatchResponse send(List<String> clientRegistrationTokens, Map<String, String> data) {
        try {
            MulticastMessage msg = MulticastMessage.builder()
                    .addAllTokens(clientRegistrationTokens)
                    .putAllData(data)
                    .build();
            return firebaseMessaging.sendMulticast(msg);
        } catch (FirebaseMessagingException e) {
            log.error(Objects.toString(e.getStackTrace()));
            throw new NotificationException("Sending push notification failed.");
        }
    }
}

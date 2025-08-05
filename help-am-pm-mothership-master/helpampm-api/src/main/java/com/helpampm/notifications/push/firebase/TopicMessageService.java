/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.push.firebase;

import com.google.firebase.messaging.FirebaseMessaging;
import com.google.firebase.messaging.FirebaseMessagingException;
import com.google.firebase.messaging.Message;
import com.google.firebase.messaging.TopicManagementResponse;
import com.helpampm.notifications.NotificationException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
@Slf4j
/*
  @author kuldeep
 */
public class TopicMessageService {
    private final FirebaseMessaging firebaseMessaging;

    public String send(String topic, Map<String, String> data) {
        try {
            Message msg = Message.builder()
                    .setTopic(topic)
                    .putAllData(data)
                    .build();
            return firebaseMessaging.send(msg);
        } catch (FirebaseMessagingException e) {
            throw new NotificationException("Unable to send message to the topic " + topic);
        }
    }

    public TopicManagementResponse subscribeToTopic(List<String> registrationTokens, String topic) {
        try {
            return firebaseMessaging.subscribeToTopic(registrationTokens, topic);
        } catch (FirebaseMessagingException e) {
            throw new NotificationException("Unable to subscribe "
                    + String.join(",", registrationTokens)
                    + " to the topic " + topic);
        }
    }

    public TopicManagementResponse subscribeToTopic(String registrationToken, String topic) {
        return subscribeToTopic(List.of(registrationToken), topic);
    }
}

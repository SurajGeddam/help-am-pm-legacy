/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.push.firebase;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.messaging.FirebaseMessaging;
import com.helpampm.notifications.NotificationException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.io.InputStream;

@Component
@Slf4j
/*
  @author kuldeep
 */
public class FirebaseConfiguration {
    @Bean
    FirebaseMessaging firebaseMessaging(FirebaseApp firebaseApp) {
        return FirebaseMessaging.getInstance(firebaseApp);
    }

    @Bean
    FirebaseApp firebaseApp(GoogleCredentials credentials) {
        return FirebaseApp.initializeApp(FirebaseOptions.builder()
                .setCredentials(credentials)
                .build());
    }

    @Bean
    GoogleCredentials googleCredentials() {
        try (InputStream is = new ClassPathResource("firebase/service-account.json").getInputStream()) {
            return GoogleCredentials.fromStream(is);
        } catch (IOException e) {
            throw new NotificationException("Firebase service account file is missing.");
        }
    }

}

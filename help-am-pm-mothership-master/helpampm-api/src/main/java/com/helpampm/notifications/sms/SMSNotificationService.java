/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.sms;

import com.helpampm.notifications.entities.Notification;
import com.helpampm.notifications.enums.NotificationType;
import com.helpampm.notifications.helper.NotificationHelper;
import com.helpampm.notifications.repositories.NotificationRepository;
import com.helpampm.notifications.sms.provider.SMSNotificationProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.Objects;

@Service
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class SMSNotificationService {
    private final SMSNotificationProvider smsNotificationProvider;
    @Value("${notifications.sms.isEnabled}")
    private boolean isSMSNotificationEnabled;
    private final NotificationRepository notificationRepository;

    public void send(SMSNotificationMessage notificationMessage, String phone, String username) {
        if (Objects.isNull(phone) || Objects.equals("", phone.trim())) {
            throw new RuntimeException("Empty Recipient.");
        }
        if (isSMSNotificationEnabled) {
            log.info("Sending SMS notification to username {} and phone {}", username, phone);
            smsNotificationProvider.send(notificationMessage, phone);
            // Create and Save notification Data into Database
            log.info("Creating system notification: sms");
            Notification notification = NotificationHelper.createNotification(username, notificationMessage.getMessage(), NotificationType.SMS );
            notificationRepository.save(notification);
            log.info("System notification saved: sms");
        } else {
            log.warn("SKIPPED: Sending SMS is disabled.");
        }
    }

    public void sendForgotPasswordSms(String phone, String name, String otp, String username) {
        SMSNotificationMessage smsNotificationMessage = SMSNotificationMessage.builder()
                .withMessage("Hi " + name + "!\nYour OTP for forgot password from HELPAMPM is " + otp + ".\nThanks\nHELP Support Team")
                .withIsTransactional(true).withSubject("OTP: Forgot Password")
                .withRecipientName(name)
                .build();
        send(smsNotificationMessage, phone, username);
    }
}

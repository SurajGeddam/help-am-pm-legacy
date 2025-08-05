package com.helpampm.notifications.helper;

import com.helpampm.notifications.entities.Notification;
import com.helpampm.notifications.enums.NotificationType;

import java.time.LocalDateTime;

public class NotificationHelper {

    public static Notification createNotification(String username, String message, NotificationType notificationType) {
        Notification notification = new Notification();
        notification.setMessage(message);
        notification.setIsRead(false);
        notification.setUsername(username);
        notification.setNotificationType(notificationType);
        notification.setCreatedAt(LocalDateTime.now());
        notification.setLastUpdateAt(LocalDateTime.now());
        notification.validate();
        return notification;
    }



}

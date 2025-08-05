/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.email;

import com.helpampm.notifications.entities.Notification;
import com.helpampm.notifications.enums.NotificationType;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;
import java.util.Map;

@Data
@Builder(setterPrefix = "with")
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class EmailNotificationMessage {
    private String recipientEmail;
    private String recipientName;
    private String subject;
    private String emailTemplateName;
    private Map<String, Object> modelData;

    public Notification toNotification() {
        Notification notification = new Notification();
        notification.setMessage(subject);
        notification.setIsRead(false);
        notification.setNotificationType(NotificationType.EMAIL);
        notification.setCreatedAt(LocalDateTime.now());
        notification.setLastUpdateAt(LocalDateTime.now());
        return notification;
    }
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.entities;

import com.helpampm.notifications.NotificationException;
import com.helpampm.notifications.enums.NotificationType;
import lombok.Data;
import org.springframework.util.StringUtils;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Objects;


@Entity
@Table(name = "tb_notifications")
@Data
/*
  @author kuldeep
 */
public class Notification implements Serializable, Comparable<Notification> {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Lob
    @Column(name = "message")
    private String message;
    @Column(name = "notification_type")
    @Enumerated(EnumType.STRING)
    private NotificationType notificationType;
    @Column(name = "is_read")
    private Boolean isRead;
    @Column(name = "username")
    private String username;
    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "last_updated_at")
    private LocalDateTime lastUpdateAt;

    public void validate() {
        if (Objects.isNull(message) || !StringUtils.hasText(message)) {
            throw new NotificationException("Message can not be null or empty.");
        }
        if (Objects.isNull(username) || !StringUtils.hasText(username)) {
            throw new NotificationException("User name can not be null or empty.");
        }
        if (Objects.isNull(notificationType)) {
            throw new NotificationException("Notification type can not be null.");
        }
        if (Objects.isNull(createdAt)) {
            createdAt = LocalDateTime.now();
        }
        if (Objects.isNull(isRead)) {
            isRead = false;
        }
    }

    @Override
    public int compareTo(Notification notification) {
        return this.id.compareTo(notification.id);
    }
}

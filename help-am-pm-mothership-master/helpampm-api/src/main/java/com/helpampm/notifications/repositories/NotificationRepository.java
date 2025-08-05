/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.repositories;


import com.helpampm.notifications.entities.Notification;
import com.helpampm.notifications.enums.NotificationType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * @author kuldeep
 */
public interface NotificationRepository extends JpaRepository<Notification, Long> {
    List<Notification> findByUsername(String username);

    List<Notification> findAllByNotificationType(NotificationType type);

    List<Notification> findByUsernameAndNotificationTypeOrderByCreatedAtAsc(String username, NotificationType notificationType);

}

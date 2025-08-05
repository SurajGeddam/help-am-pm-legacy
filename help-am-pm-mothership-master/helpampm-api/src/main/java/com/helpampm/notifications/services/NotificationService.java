/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.services;

import com.helpampm.notifications.entities.Notification;
import com.helpampm.notifications.enums.NotificationType;

import java.util.List;

/**
 * @author kuldeep
 */
public interface NotificationService {
    Notification save(Notification notification);
    Notification updateReadFlag(Long id);
    List<Notification> findAll();
    List<Notification> findAllNotificationType(NotificationType type);
    Notification findById(Long id);
    List<Notification> findByUsername(String username);
    List<Notification> findByUsernameAndNotificationType(String username,NotificationType notificationType);

}

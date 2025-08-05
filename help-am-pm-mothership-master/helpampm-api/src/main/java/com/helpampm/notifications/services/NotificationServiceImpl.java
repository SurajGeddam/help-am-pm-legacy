/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.services;

import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.services.AuthenticationService;
import com.helpampm.notifications.NotificationException;
import com.helpampm.notifications.entities.Notification;
import com.helpampm.notifications.enums.NotificationType;
import com.helpampm.notifications.repositories.NotificationRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
/*
  @author kuldeep
 */
public class NotificationServiceImpl implements NotificationService {
    private final NotificationRepository notificationRepository;
    private final AuthenticationService authenticationService;

    @Override
    public Notification save(Notification notification) {
        assert Objects.nonNull(notification);
        notification.setCreatedAt(LocalDateTime.now());
        notification.setLastUpdateAt(LocalDateTime.now());
        notification.validate();
        return notificationRepository.save(notification);
    }

    // Only isRead update allowed
    @Override
    public Notification updateReadFlag(Long id) {
        Notification notification = findById(id);
        UserLoginDetails userLoginDetails = authenticationService.findLoggedInUser();
        if (Objects.equals(userLoginDetails.getUsername(), notification.getUsername())) {
            notification.setIsRead(true);
            notification.setLastUpdateAt(LocalDateTime.now());
            return notificationRepository.save(notification);
        }
        throw new NotificationException("Unauthorized to mark notification read.");
    }

    @Override
    public List<Notification> findAll() {
        UserLoginDetails userLoginDetails = authenticationService.findLoggedInUser();
        if (userLoginDetails.isSuperAdmin()) {
            return notificationRepository.findAll();
        }
        return notificationRepository.findByUsername(userLoginDetails.getUsername());
    }

    @Override
    public List<Notification> findAllNotificationType(NotificationType type) {
        UserLoginDetails userLoginDetails = authenticationService.findLoggedInUser();
        if (userLoginDetails.isSuperAdmin()) {
            return notificationRepository.findAllByNotificationType(type);
        }
        return notificationRepository.findByUsernameAndNotificationTypeOrderByCreatedAtAsc(userLoginDetails.getUsername(), NotificationType.PUSH);
    }

    @Override
    public Notification findById(Long id) {
        UserLoginDetails userLoginDetails = authenticationService.findLoggedInUser();
        Optional<Notification> optionalNotification = notificationRepository.findById(id);
        if (optionalNotification.isPresent() && (userLoginDetails.isSuperAdmin()
                || Objects.equals(optionalNotification.get().getUsername(), userLoginDetails.getUsername()))) {

            return optionalNotification.get();
        }
        throw new NotificationException("Unauthorized to access notification");
    }

    @Override
    public List<Notification> findByUsername(String username) {
        return notificationRepository.findByUsername(username);
    }

    @Override
    public List<Notification> findByUsernameAndNotificationType(String username, NotificationType notificationType) {
        return notificationRepository.findByUsernameAndNotificationTypeOrderByCreatedAtAsc(username, notificationType);
    }
}

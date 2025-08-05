/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.sms.provider;

import com.helpampm.notifications.sms.SMSNotificationMessage;

/**
 * @author kuldeep
 */
public interface SMSNotificationProvider {
    void send(SMSNotificationMessage notificationMessage, String phone);
}

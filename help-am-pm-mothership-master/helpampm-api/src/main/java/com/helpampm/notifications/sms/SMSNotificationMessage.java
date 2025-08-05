/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.sms;

import lombok.Builder;
import lombok.Data;

@Data
@Builder(setterPrefix = "with")
/*
  @author kuldeep
 */
public class SMSNotificationMessage {
    private String recipientName;
    private String message;
    private String subject;
    private boolean isTransactional;
}

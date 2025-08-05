/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.sms.provider;

import com.helpampm.notifications.sms.SMSNotificationMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;


@Service("twilioSmsSender")
@ConditionalOnProperty(
        value = "notifications.sms.provider.activeName",
        havingValue = "twilio")
@Slf4j
/*
  @author kuldeep
 */
public class TwilioSMSNotificationSender implements SMSNotificationProvider {
    @Value("${notifications.sms.provider.twilio.apiKey}")
    private String apiKey;

    @Override
    public void send(SMSNotificationMessage notificationMessage, String recipient) {
        log.info(notificationMessage.toString());
    }
}

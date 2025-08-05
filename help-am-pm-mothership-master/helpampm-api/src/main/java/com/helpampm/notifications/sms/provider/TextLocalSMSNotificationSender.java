/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.sms.provider;

import com.helpampm.notifications.NotificationException;
import com.helpampm.notifications.sms.SMSNotificationMessage;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

@Service("textLocalSmsSender")
@ConditionalOnProperty(
        value = "notifications.sms.provider.activeName",
        havingValue = "textLocal")
@Slf4j
/*
  @author kuldeep
 */
public class TextLocalSMSNotificationSender implements SMSNotificationProvider {

    @Value("${notifications.sms.provider.textLocal.apiKey}")
    private String apiKey;

    @Override
    public void send(SMSNotificationMessage notificationMessage, String recipient) {
        try {
            String key = apiKey;
            // Construct data
            String apiKey = "apikey=" + key;
            String message = "&message=" + "This is your message";
            String sender = "&sender=" + "HELP AMPM";
            String numbers = "&numbers=" + recipient;

            // Send data
            HttpURLConnection conn = (HttpURLConnection) new URL("https://api.txtlocal.com/send/?").openConnection();
            String data = apiKey + numbers + message + sender;
            conn.setDoOutput(true);
            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Length", Integer.toString(data.length()));
            conn.getOutputStream().write(data.getBytes(StandardCharsets.UTF_8));
            final BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
            final StringBuilder stringBuffer = new StringBuilder();
            String line;
            while ((line = rd.readLine()) != null) {
                stringBuffer.append(line);
            }
            rd.close();
            log.info(stringBuffer.toString());
        } catch (Exception e) {
            log.error("Error SMS " + e);
            throw new NotificationException("Could not send OTP SMS, please try again");
        }
        log.info(notificationMessage.toString());
    }
}

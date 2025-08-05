/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.sms.provider;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.helpampm.notifications.NotificationException;
import com.helpampm.notifications.sms.SMSNotificationMessage;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.codec.binary.Base64;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.nio.charset.StandardCharsets;


@Service("clickSendSmsSender")
@ConditionalOnProperty(
        value = "notifications.sms.provider.activeName",
        havingValue = "clickSend")
@Slf4j
/*
  @author kuldeep
 */
public class ClickSendSMSNotificationSender implements SMSNotificationProvider {
    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();
    @Value("${notifications.sms.provider.clickSend.username}")
    private String username;
    @Value("${notifications.sms.provider.clickSend.password}")
    private String password;
    @Value("${notifications.sms.provider.clickSend.url}")
    private String smsGatewayUrl;
    @Value("${notifications.sms.provider.clickSend.sendFrom}")
    private String sendFromPhone;

    @Override
    public void send(SMSNotificationMessage notificationMessage, String phone) {
        try {
            RestTemplate restTemplate = new RestTemplate();
            ObjectNode message = OBJECT_MAPPER.createObjectNode();
            message.put("body", notificationMessage.getMessage());
            message.put("to", phone);
            message.put("from", sendFromPhone);

            ArrayNode messages = OBJECT_MAPPER.createArrayNode();
            messages.add(message);
            ObjectNode requestBody = OBJECT_MAPPER.createObjectNode();
            requestBody.set("messages", messages);
            HttpEntity<JsonNode> httpEntity = new HttpEntity<>(requestBody, createBasicAuthHeaders());
            ResponseEntity<JsonNode> response = restTemplate.exchange
                    (smsGatewayUrl, HttpMethod.POST, httpEntity, JsonNode.class);
            log.info("Sms sent successfully. " + response.getBody());
        } catch (Exception exception) {
            throw new NotificationException("Unable to send SMS, please check your email or try again after some time.");
        }
    }

    HttpHeaders createBasicAuthHeaders() {
        return new HttpHeaders() {{
            String auth = username + ":" + password;
            byte[] encodedAuth = Base64.encodeBase64(
                    auth.getBytes(StandardCharsets.US_ASCII));
            String authHeader = "Basic " + new String(encodedAuth, StandardCharsets.US_ASCII);
            set("Authorization", authHeader);
        }};
    }
}

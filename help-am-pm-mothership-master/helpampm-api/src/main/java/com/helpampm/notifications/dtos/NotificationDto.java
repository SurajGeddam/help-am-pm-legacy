package com.helpampm.notifications.dtos;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.helpampm.notifications.entities.Notification;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;

import java.time.LocalDateTime;
import java.util.Map;

@Data
@Slf4j
@SuppressFBWarnings("EI_EXPOSE_REP")
@Builder(setterPrefix = "with")
public class NotificationDto {
    String header;//: "Today",
    String title;//: "Lorem Ipsum",
    String description;//: "Sed ut perspiciatis unde omnis error sit voluptatem",
    LocalDateTime delayTime;//: "3 min ago",
    String notificationPic;
    boolean isRead;//: false,


    public static NotificationDto buildFromNotification(Notification notification) {
        ObjectMapper mapper = new ObjectMapper();
        try {
            Map<String, String> map = mapper.readValue(notification.getMessage(), Map.class);
            return NotificationDto.builder().withDescription(notification.getMessage())
                    .withIsRead(notification.getIsRead())
                    .withDelayTime(notification.getCreatedAt())
                    .withDescription(map.get("body"))
                    .withHeader(map.get("quoteUniqueId"))
                    .withTitle(map.get("title")).build();
        } catch (JsonProcessingException e) {
            log.error("Error notification conversion");
        }

        return null;

    }

}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.push;

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;

import java.util.Collections;
import java.util.Map;

@Data
@Builder(setterPrefix = "with")
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class PushNotificationMessage {
    private Map<String, Object> data;
    private String title;
    private String status;
    private String body;

    public Map<String, Object> toMap() {
        data.put("title", title);
        data.put("status", status);
        data.put("body", body);
        return Collections.unmodifiableMap(data);
    }
}

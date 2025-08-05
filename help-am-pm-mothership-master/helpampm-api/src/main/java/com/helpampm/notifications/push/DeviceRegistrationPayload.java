/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.push;

import lombok.Data;
import lombok.ToString;

@Data
@ToString
/*
  @author kuldeep
 */
public class DeviceRegistrationPayload {
    private String deviceId;
    private String username;
    private DeviceType deviceType;
}

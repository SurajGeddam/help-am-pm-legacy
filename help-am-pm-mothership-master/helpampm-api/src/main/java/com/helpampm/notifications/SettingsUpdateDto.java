/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.notifications;

import com.helpampm.notifications.enums.NotificationType;
import lombok.Data;

/**
 * @author kuldeep
 */
@Data
public class SettingsUpdateDto {
    private NotificationType type;
    private boolean enabled;
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.notifications.dtos;

import lombok.Builder;
import lombok.Data;

/**
 * @author kuldeep
 */
@Data
@Builder(setterPrefix = "with")
public class NotificationFilterRequestPayload {
    private int pageSize;
    private int pageNumber;
    private String orderDir;
    private String orderColumn;
    private String searchText;
}

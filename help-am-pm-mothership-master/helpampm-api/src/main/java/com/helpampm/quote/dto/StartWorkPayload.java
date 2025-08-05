/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote.dto;

import lombok.Data;

import java.time.LocalDateTime;

@Data
/*
  @author kuldeep
 */
public class StartWorkPayload {
    private Double latitude;
    private Double longitude;
    private Double altitude;
    private LocalDateTime workStartTime;
}

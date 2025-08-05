/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.dto;

import lombok.Data;

@Data
/*
  @author kuldeep
 */
public class ProviderSearchDto {
    private String category;
    private Boolean isResidential;
    private Double latitude;
    private Double longitude;
    private Double altitude;
    private Double radius;
}

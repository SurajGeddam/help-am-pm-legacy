/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.dto;

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;

@Data
@Builder(setterPrefix = "with")
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class ProviderSearchResponseDto {
    private String providerUniqueId;
    private String name;
    private String username;
    private String email;
    private double latitude;
    private double longitude;
    private double altitude;
    private String phone;
    private double customerAverageRating;
    private long totalCustomerRatings;
    private String companyUniqueId;
    private String parentCompanyUniqueId;
    private boolean smsNotification;
    private boolean emailNotification;
    private boolean pushNotification;
}

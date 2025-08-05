/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.dto;

import com.helpampm.provider.license.License;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@Data
@Builder(setterPrefix = "with")
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class LicenseDto implements Serializable {
    private long id;
    private String licenseNumber;
    private String licenseHolderName;
    private boolean isActive;
    private byte[] image;
    private String imagePath;

    public static LicenseDto buildWithLicense(License license) {
        return LicenseDto.builder().withId(license.getId())
                .withLicenseNumber(license.getLicenseNumber())
                .withIsActive(license.getIsActive())
                .withLicenseHolderName(license.getLicenseHolderName())
                .withImagePath(license.getImagePath())
                .build();
    }
}

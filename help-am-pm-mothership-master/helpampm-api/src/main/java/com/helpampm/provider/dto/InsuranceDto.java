/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.dto;

import com.helpampm.provider.insurance.Insurance;
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
public class InsuranceDto implements Serializable {
    private long id;
    private String insurerName;
    private String policyNumber;
    private boolean isActive;
    private String providerUniqueId;
    private byte[] image;
    private String imagePath;

    public static InsuranceDto buildWithInsurance(Insurance insurance) {
        return InsuranceDto.builder().withId(insurance.getId())
                .withInsurerName(insurance.getInsurerName())
                .withProviderUniqueId(insurance.getProviderUniqueId())
                .withPolicyNumber(insurance.getPolicyNumber())
                .withIsActive(insurance.getIsActive())
                .withImagePath(insurance.getImagePath())
                .build();
    }
}

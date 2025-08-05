/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.dtos;


import com.helpampm.address.Address;
import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.common.StringUtils;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;

/**
 * @author rakesh
 */


@Data
@Builder(setterPrefix = "with")
@SuppressFBWarnings("EI_EXPOSE_REP")
public class UserDetailsDto {
    private String username;
    private boolean enabled;
    private boolean isSuperAdmin;
    private String authority;
    private String customerUniqueId;
    private String companyUniqueId;
    private String providerUniqueId;
    private String parentCompanyUniqueId;
    private String phone;
    private String email;
    private String name;
    private byte[] profileBytes;
    private Address userAddress;
    private String profilePicture;

    public static UserDetailsDto buildWithUserDetails(UserLoginDetails loginDetails) {
        String authority = loginDetails.getAuthorities()
                .stream().findFirst().orElseGet(null)
                .getAuthority();
        return UserDetailsDto.builder()
                .withUsername(StringUtils.setDefaultString(loginDetails.getUsername()))
                .withEnabled(loginDetails.isEnabled())
                .withAuthority(StringUtils.setDefaultString(authority))
                .withProfilePicture(loginDetails.getProfileImagePath())
                .withCustomerUniqueId(StringUtils.setDefaultString(loginDetails.getCustomerUniqueId()))
                .withProviderUniqueId(StringUtils.setDefaultString(loginDetails.getProviderUniqueId()))
                .withIsSuperAdmin(loginDetails.isSuperAdmin())
                .build();
    }
}

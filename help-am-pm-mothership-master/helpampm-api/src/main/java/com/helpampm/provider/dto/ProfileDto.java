/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.dto;

import com.helpampm.customer.Customer;
import com.helpampm.provider.Provider;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;

@Data
@Builder(setterPrefix = "with")
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author ajay
 */
public class ProfileDto {
    private long id;
    private String providerUniqueId;
    private String customerUniqueId;
    private String profilePicture;
    private String name;
    private String firstName;
    private String lastName;
    private String email;
    private String mobileNumber;
    private String dateOfBirth;
    private boolean isActive;
    private byte[] imageBytes;
    private boolean smsEnable;
    private boolean emailEnable;


    public static ProfileDto buildWithProviderDto(Provider provider) {
        return ProfileDto.builder()
                .withId(provider.getId())
                .withProviderUniqueId(provider.getProviderUniqueId())
                .withProfilePicture(provider.getProfileImagePath())
                .withName(provider.getName())
                .withEmail(provider.getEmail())
                .withMobileNumber(provider.getPhone())
                .withDateOfBirth("")
                .withSmsEnable(provider.isSmsNotificationEnabled())
                .withEmailEnable(provider.isEmailNotificationEnabled())
                .withIsActive(provider.getIsActive())
                .build();
    }

    public static ProfileDto buildWithCustomerDto(Customer customer) {
        return ProfileDto.builder()
                .withId(customer.getId())
                .withCustomerUniqueId(customer.getCustomerUniqueId())
                .withProfilePicture(customer.getProfileImagePath())
                .withFirstName(customer.getFirstName())
                .withLastName(customer.getLastName())
                .withEmail(customer.getEmail())
                .withMobileNumber(customer.getPhone())
                .withSmsEnable(customer.isSmsNotificationEnabled())
                .withEmailEnable(customer.isEmailNotificationEnabled())
                .withDateOfBirth("")
                .withIsActive(customer.getIsActive())
                .build();
    }
}

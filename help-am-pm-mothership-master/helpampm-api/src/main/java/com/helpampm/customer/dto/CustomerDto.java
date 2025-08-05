/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.customer.dto;

import com.helpampm.customer.Customer;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@SuppressFBWarnings("EI_EXPOSE_REP2")
@Data
@Builder
/*
  @author kuldeep
 */
public class CustomerDto implements Serializable {
    private Long id;
    private String firstName;
    private String lastName;
    private String phone;
    private String email;
    private Double averageProviderRating;
    private Long totalProviderRatings;
    private Boolean isActive;
    private String customerUniqueId;
    private byte[] customerImage;

    public static CustomerDto buildWithCustomerDto(Customer customer) {
        return CustomerDto.builder()
                .customerUniqueId(customer.getCustomerUniqueId())
                .id(customer.getId())
                .firstName(customer.getFirstName())
                .lastName(customer.getLastName())
                .email(customer.getEmail())
                .phone(customer.getPhone())
                .isActive(customer.getIsActive())
                .averageProviderRating(customer.getAverageProviderRating())
                .totalProviderRatings(customer.getTotalProviderRatings())
                .build();
    }
}

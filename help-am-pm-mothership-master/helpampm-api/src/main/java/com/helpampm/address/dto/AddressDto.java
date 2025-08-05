/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.address.dto;

import com.helpampm.address.Address;
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
public class AddressDto implements Serializable {
    private long id;
    private String name;
    private String house;
    private String building;
    private String street;
    private String district;
    private String county;
    private String country;
    private String zipcode;
    private double latitude;
    private double longitude;
    private double altitude;
    private String customerUniqueId;
    private String providerUniqueId;

    public static AddressDto buildWithAddress(Address address) {
        if (address != null) {
            return AddressDto.builder()
                    .withId(address.getId())
                    .withName(address.getName())
                    .withProviderUniqueId(address.getProviderUniqueId())
                    .withBuilding(address.getBuilding())
                    .withAltitude(address.getAltitude())
                    .withCountry(address.getCountry())
                    .withDistrict(address.getDistrict())
                    .withHouse(address.getHouse())
                    .withLatitude(address.getLatitude())
                    .withStreet(address.getStreet())
                    .withZipcode(address.getZipcode())
                    .withCounty(address.getCounty())
                    .withLongitude(address.getLongitude())
                    .withCustomerUniqueId(address.getCustomerUniqueId())
                    .build();
        } else {
            return null;
        }

    }
}

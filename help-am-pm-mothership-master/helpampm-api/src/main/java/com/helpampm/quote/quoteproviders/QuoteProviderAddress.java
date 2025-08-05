/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.quote.quoteproviders;

import com.helpampm.address.Address;
import lombok.Builder;
import lombok.Data;
import lombok.ToString;

import java.io.Serializable;
import java.util.Optional;

/**
 * @author kuldeep
 */
@Builder(setterPrefix = "with")
@Data
@ToString
public class QuoteProviderAddress implements Serializable {
    private String house;
    private String building;
    private String street;
    private String district;
    private String county;
    private String country;
    private String zipcode;
    private Double latitude;
    private Double longitude;
    private Double altitude;
    private String providerUniqueId;

    public static QuoteProviderAddress buildFromAddress(Optional<Address> optionalAddress) {
        if(optionalAddress.isPresent()) {
           Address address = optionalAddress.get();
           return QuoteProviderAddress.builder()
                   .withHouse(address.getHouse())
                   .withBuilding(address.getBuilding())
                   .withStreet(address.getStreet())
                   .withCounty(address.getCounty())
                   .withDistrict(address.getDistrict())
                   .withCountry(address.getCountry())
                   .withZipcode(address.getZipcode())
                   .withLatitude(address.getLatitude())
                   .withLongitude(address.getLongitude())
                   .withAltitude(address.getAltitude())
                   .withProviderUniqueId(address.getProviderUniqueId())
                   .build();
        } else {
            return QuoteProviderAddress.builder()
                    .withHouse("")
                    .withBuilding("")
                    .withStreet("")
                    .withCounty("")
                    .withDistrict("")
                    .withCountry("")
                    .withZipcode("")
                    .withLatitude(0.0)
                    .withLongitude(0.0)
                    .withAltitude(0.0)
                    .build();
        }
    }
}

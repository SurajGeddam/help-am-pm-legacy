/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.address;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface AddressRepository extends JpaRepository<Address, Long> {
    Optional<Address> findByCustomerUniqueIdAndHouseAndCountyAndCountryAndZipcode(String customerUniqueId,
                                                                                  String house,
                                                                                  String county,
                                                                                  String country,
                                                                                  String zipcode);

    Optional<Address> findByProviderUniqueIdAndHouseAndCountyAndCountryAndZipcode(String customerUniqueId,
                                                                                  String house,
                                                                                  String county,
                                                                                  String country,
                                                                                  String zipcode);

    Optional<Address> findByProviderUniqueId(String providerUniqueId);
    List<Address> findByCustomerUniqueId(String customerUniqueId);

    Optional<Address> findByNameAndHouseAndBuildingAndStreetAndDistrictAndCustomerUniqueIdAndHouseAndCountyAndCountryAndZipcode(String name, String house, String building, String street, String district, String customerUniqueId, String house1, String county, String country, String zipcode);
}

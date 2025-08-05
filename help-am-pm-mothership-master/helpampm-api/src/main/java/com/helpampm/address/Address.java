/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.address;

import lombok.Data;
import lombok.ToString;
import org.springframework.http.HttpStatus;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Objects;

@Entity
@Table(name = "tb_addresses")
@Data
@ToString
/*
  @author kuldeep
 */
public class Address implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    @Column(name = "house")
    private String house;
    @Column(name = "building")
    private String building;
    @Column(name = "street")
    private String street;
    @Column(name = "district")
    private String district;
    @Column(name = "county")
    private String county;
    @Column(name = "country")
    private String country;
    @Column(name = "zipcode")
    private String zipcode;
    @Column(name = "latitude")
    private Double latitude;
    @Column(name = "longitude")
    private Double longitude;
    @Column(name = "altitude")
    private Double altitude;
    @Column(name = "customer_unique_id")
    private String customerUniqueId;
    @Column(name = "provider_unique_id")
    private String providerUniqueId;

    @Column(name = "create_at")
    private LocalDateTime createdAt;
    @Column(name = "last_updated_at")
    private LocalDateTime lastUpdatedAt;
    @Column(name = "name")
    private String name;
    @Column(name = "address_type")
    private String addressType;
    @Column(name = "is_default")
    private boolean isDefault;

    public void copyNonNullValues(Address address) {
        if (Objects.isNull(address.getHouse()) || Objects.equals("", address.getHouse())) {
            address.setHouse(house);
        }
        setBuildingDetails(address);

        if (Objects.isNull(address.getCounty()) || Objects.equals("", address.getCounty())) {
            address.setCounty(county);
        }
        if (Objects.isNull(address.getCountry()) || Objects.equals("", address.getCountry())) {
            address.setCountry(country);
        }

        setCoordinates(address);

        if (Objects.isNull(address.getZipcode()) || Objects.equals("", address.getZipcode())) {
            address.setZipcode(zipcode);
        }
        if (Objects.isNull(address.getCreatedAt())) {
            address.setCreatedAt(createdAt);
        }

        setUniqueIds(address);
    }

    private void setUniqueIds(Address address) {
        if (Objects.isNull(address.getCustomerUniqueId()) || Objects.equals("", address.getCustomerUniqueId())) {
            address.setCustomerUniqueId(customerUniqueId);
        }
        if (Objects.isNull(address.getProviderUniqueId()) || Objects.equals("", address.getProviderUniqueId())) {
            address.setProviderUniqueId(providerUniqueId);
        }
    }

    private void setCoordinates(Address address) {
        if (Objects.isNull(address.getAltitude()) || Objects.equals(0.0, address.getAltitude())) {
            address.setAltitude(altitude);
        }
        if (Objects.isNull(address.getLongitude()) || Objects.equals(0.0, address.getLongitude())) {
            address.setLongitude(longitude);
        }
        if (Objects.isNull(address.getLatitude()) || Objects.equals(0.0, address.getLatitude())) {
            address.setLatitude(latitude);
        }
    }

    private void setBuildingDetails(Address address) {
        if (Objects.isNull(address.getBuilding()) || Objects.equals("", address.getBuilding())) {
            address.setBuilding(building);
        }
        if (Objects.isNull(address.getStreet()) || Objects.equals("", address.getStreet())) {
            address.setStreet(street);
        }
        if (Objects.isNull(address.getDistrict()) || Objects.equals("", address.getDistrict())) {
            address.setDistrict(district);
        }
    }

    public void validate() {
       
        if (Objects.isNull(county) || Objects.equals("", county.trim())) {
            throw new AddressException("County can not be null or empty.", HttpStatus.BAD_REQUEST);
        }
        if (Objects.isNull(country) || Objects.equals("", country.trim())) {
            throw new AddressException("Country can not be null or empty.", HttpStatus.BAD_REQUEST);
        }
        if (Objects.isNull(zipcode) || Objects.equals("", zipcode.trim())) {
            throw new AddressException("Zipcode can not be null or empty.", HttpStatus.BAD_REQUEST);
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Address address = (Address) o;
        return id.equals(address.id);
    }

    @Override
    public int hashCode() {
        return id.hashCode();
    }

    public Address copy() {
        Address address = new Address();
        address.setHouse(house);
        address.setBuilding(building);
        address.setStreet(street);
        address.setDistrict(district);
        address.setCounty(county);
        address.setCountry(country);
        address.setZipcode(zipcode);
        address.setLatitude(latitude);
        address.setLongitude(longitude);
        address.setAltitude(altitude);
        address.setName(name);
        address.setDefault(isDefault);
        address.setAddressType(addressType);
        return address;
    }
}

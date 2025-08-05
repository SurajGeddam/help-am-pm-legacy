/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote.quoteaddress;

import com.helpampm.address.AddressException;
import lombok.Data;
import lombok.ToString;
import org.springframework.http.HttpStatus;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Objects;

@Entity
@Table(name = "tb_quote_addresses")
@Data
@ToString
/*
  @author kuldeep
 */
public class QuoteAddress implements Serializable {
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

    @Column(name = "quote_id")
    private Long quoteId;

    @Column(name = "name")
    private String name;
    @Column(name = "address_type")
    private String addressType;
    @Column(name = "is_default")
    private boolean isDefault;


    public void copyNonNullValues(QuoteAddress quoteAddress) {
        if (Objects.isNull(quoteAddress.getHouse()) || Objects.equals("", quoteAddress.getHouse())) {
            quoteAddress.setHouse(house);
        }
        setBuildingDetails(quoteAddress);

        if (Objects.isNull(quoteAddress.getCounty()) || Objects.equals("", quoteAddress.getCounty())) {
            quoteAddress.setCounty(county);
        }
        if (Objects.isNull(quoteAddress.getCountry()) || Objects.equals("", quoteAddress.getCountry())) {
            quoteAddress.setCountry(country);
        }

        setCoordinates(quoteAddress);

        if (Objects.isNull(quoteAddress.getZipcode()) || Objects.equals("", quoteAddress.getZipcode())) {
            quoteAddress.setZipcode(zipcode);
        }
    }


    private void setCoordinates(QuoteAddress quoteAddress) {
        if (Objects.isNull(quoteAddress.getAltitude()) || Objects.equals(0.0, quoteAddress.getAltitude())) {
            quoteAddress.setAltitude(altitude);
        }
        if (Objects.isNull(quoteAddress.getLongitude()) || Objects.equals(0.0, quoteAddress.getLongitude())) {
            quoteAddress.setLongitude(longitude);
        }
        if (Objects.isNull(quoteAddress.getLatitude()) || Objects.equals(0.0, quoteAddress.getLatitude())) {
            quoteAddress.setLatitude(latitude);
        }
    }

    private void setBuildingDetails(QuoteAddress quoteAddress) {
        if (Objects.isNull(quoteAddress.getBuilding()) || Objects.equals("", quoteAddress.getBuilding())) {
            quoteAddress.setBuilding(building);
        }
        if (Objects.isNull(quoteAddress.getStreet()) || Objects.equals("", quoteAddress.getStreet())) {
            quoteAddress.setStreet(street);
        }
        if (Objects.isNull(quoteAddress.getDistrict()) || Objects.equals("", quoteAddress.getDistrict())) {
            quoteAddress.setDistrict(district);
        }
    }

    public void validate() {
        if (Objects.isNull(house) || Objects.equals("", house.trim())) {
            throw new AddressException("House can not be null or empty.", HttpStatus.BAD_REQUEST);
        }
        if (Objects.isNull(building) || Objects.equals("", building.trim())) {
            throw new AddressException("Building can not be null or empty.", HttpStatus.BAD_REQUEST);
        }
        if (Objects.isNull(street) || Objects.equals("", street.trim())) {
            throw new AddressException("Street can not be null or empty.", HttpStatus.BAD_REQUEST);
        }
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

        QuoteAddress address = (QuoteAddress) o;
        return id.equals(address.id);
    }

    @Override
    public int hashCode() {
        return id.hashCode();
    }

    public QuoteAddress copy() {
        QuoteAddress address = new QuoteAddress();
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

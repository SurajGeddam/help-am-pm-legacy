/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.address;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class AddressServiceImpl implements AddressService {
    private final AddressRepository repository;

    @Transactional
    @Override
    public Address save(Address address) {
        assert Objects.nonNull(address);
        log.info("Saving address for provider/Customer {}" + address.getProviderUniqueId() != null
                ? address.getProviderUniqueId() : address.getCustomerUniqueId());
        address.setLastUpdatedAt(LocalDateTime.now());
        address.setCreatedAt(LocalDateTime.now());
        checkDuplicates(address);
        address.validate();
        return repository.save(address);
    }

    @Override
    @Transactional
    public Address update(Address address) {
        log.info("Updating address for provider " + address.getProviderUniqueId());
        address.setLastUpdatedAt(LocalDateTime.now());
        populateNullValuesFromPreviousValues(address);
        address.validate();
        checkDuplicates(address);
        return repository.save(address);
    }

    private void checkDuplicates(Address address) {
        if (Objects.nonNull(address.getCustomerUniqueId())) {
            if (repository.findByNameAndHouseAndBuildingAndStreetAndDistrictAndCustomerUniqueIdAndHouseAndCountyAndCountryAndZipcode(
                    address.getName(),
                    address.getHouse(),
                    address.getBuilding(),
                    address.getStreet(),
                    address.getDistrict(),
                    address.getCustomerUniqueId(),
                    address.getHouse(),
                    address.getCounty(), address.getCountry(),
                    address.getZipcode()).isPresent()) {
                log.error("Customer address already exists: " + address);
                throw new AddressException("Address already exists", HttpStatus.BAD_REQUEST);
            }
        } else if (Objects.nonNull(address.getProviderUniqueId()) && repository.findByProviderUniqueIdAndHouseAndCountyAndCountryAndZipcode(
                address.getProviderUniqueId(),
                address.getHouse(),
                address.getCounty(), address.getCountry(),
                address.getZipcode()).isPresent()) {
            log.error("Provider address already exists: " + address);
            throw new AddressException("Address already exists", HttpStatus.BAD_REQUEST);

        }
    }

    private void populateNullValuesFromPreviousValues(Address address) {
        Optional<Address> oldAddress = repository.findById(address.getId());
        oldAddress.ifPresent(value -> value.copyNonNullValues(address));
    }

    @Override
    public Address findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new AddressException("Unable to find address with id=" + id, HttpStatus.NOT_FOUND));
    }

    @Override
    public List<Address> findByCustomerUniqueId(String customerUniqueId) {
        return repository.findByCustomerUniqueId(customerUniqueId);
    }

    @Override
    public Optional<Address> findByProviderUniqueId(String uniqueId) {
        return repository.findByProviderUniqueId(uniqueId);
    }
}

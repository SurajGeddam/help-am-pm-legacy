/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.country;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Objects;

@Service
@Slf4j
@RequiredArgsConstructor
/*
 * @author Ajay
 */
public class CountryServiceImpl implements CountryService {
    private final CountryRepository repository;

    @Override
    public List<Country> getAll() {
        return repository.findAll();
    }


    @Transactional
    @Override
    public Country create(Country country) {
        log.info("Creating country");
        Country databaseCountry = repository.findByCode(country.getCode());
        assert Objects.nonNull(country);
        if (databaseCountry == null) {
            return repository.save(country);
        } else {
            return databaseCountry;
        }
    }

    @Override
    public Country update(Country country) {
        assert Objects.nonNull(country);
        assert Objects.nonNull(country.getId());
        return repository.save(country);
    }

}

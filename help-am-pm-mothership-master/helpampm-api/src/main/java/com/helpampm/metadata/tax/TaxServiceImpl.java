/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.tax;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
public class TaxServiceImpl implements TaxService {

    private final TaxRepository repository;

    @Override
    @Transactional
    public Tax create(Tax tax) {
        assert Objects.nonNull(tax);
        checkDuplicates(tax);
        tax.setCreatedAt(LocalDateTime.now());
        tax.setLastUpdatedAt(LocalDateTime.now());
        tax.validate();
        return repository.save(tax);
    }

    private void checkDuplicates(Tax tax) {
        if (repository.findByTaxCountyAndTaxNameAndTaxPeriod(tax.getTaxCounty(),
                tax.getTaxName(), tax.getTaxPeriod()).isPresent()) {
            throw new TaxException("Tax configuration already exists. " +
                    "Only one tax rate per county per tax period allow for specif type of tax.");
        }
    }

    @Override
    @Transactional
    public Tax update(Tax tax) {
        assert Objects.nonNull(tax);
        assert Objects.nonNull(tax.getId());
        updateNullValues(tax);
        tax.setLastUpdatedAt(LocalDateTime.now());
        tax.validate();
        return repository.save(tax);
    }

    private void updateNullValues(Tax tax) {
        Optional<Tax> existingTax = repository.findById(tax.getId());
        existingTax.ifPresent(value -> value.copyNonNullValues(tax));
    }

    @Override
    public List<Tax> findAll() {
        return repository.findAll();
    }

    @Override
    public Tax findById(Integer id) {
        return repository.findById(id).orElse(null);
    }

    @Override
    public List<Tax> findActiveAll() {
        return repository.findByIsActive(true);
    }

    @Override
    public Optional<Tax> findByTaxLocationAndTaxNameAndTaxPeriod(String location, String taxName, String taxPeriod) {
        return repository.findByTaxCountyAndTaxNameAndTaxPeriod(location, taxName, taxPeriod);
    }

    @Override
    public Tax findByTaxCounty(String county) {
        return repository.findByTaxCounty(county);
    }
}

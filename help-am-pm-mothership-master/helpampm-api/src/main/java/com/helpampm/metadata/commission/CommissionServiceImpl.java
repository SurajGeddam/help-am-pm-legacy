/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.commission;

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
  @author rakesh
 */
public class CommissionServiceImpl implements CommissionService {
    private final ComissionRepository repository;

    @Override
    @Transactional
    public Commission create(Commission tax) {
        assert Objects.nonNull(tax);
        checkDuplicates(tax);
        tax.setCreatedAt(LocalDateTime.now());
        tax.setLastUpdatedAt(LocalDateTime.now());
        return repository.save(tax);
    }

    private void checkDuplicates(Commission tax) {
        if (repository.findByCountyAndRateAndIsActive(tax.getCounty(),
                tax.getRate(), tax.getIsActive()).isPresent()) {
            throw new CommissionException("Tax configuration already exists. " +
                    "Only one tax rate per county per tax period allow for specif type of tax.");
        }
    }

    @Override
    @Transactional
    public Commission update(Commission commission) {
        if(Objects.nonNull(commission)
                && Objects.nonNull(commission.getId())) {
            Commission oldCommission = repository.findById(commission.getId())
                    .orElseThrow(() -> new CommissionException("Commission record not found."));
            commission.setLastUpdatedAt(LocalDateTime.now());
            commission.updateNullValues(oldCommission);
            return repository.save(commission);
        }
        return commission;
    }

    @Override
    public List<Commission> findAll() {
        return repository.findAll();
    }

    @Override
    public Commission findById(Integer id) {
        return repository.findById(id).orElse(null);
    }

    @Override
    public List<Commission> findActiveAll() {
        return repository.findByIsActive(true);
    }

    @Override
    public Optional<Commission> findByCountyAndIsActive(String county, boolean isActive) {
        return repository.findByCountyAndIsActive(county, isActive);
    }

    @Override
    public Commission findByCountyAndRateAndIsActive(String county, Double rate, boolean isActive) {
        return repository.findByCountyAndRateAndIsActive(county, rate, isActive).orElse(null);
    }
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.metadata.insurance;

import com.helpampm.metadata.info.MetadataException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.Optional;

/**
 * @author kuldeep
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class InsuranceTypeServiceImpl implements InsuranceTypeService {
    private final InsuranceTypeRepository repository;
    @Override
    public List<InsuranceType> findAllActive() {
        return repository.findByIsActive(true);
    }

    @Override
    public List<InsuranceType> findAll() {
        return repository.findAll();
    }

    @Override
    public InsuranceType save(InsuranceType insuranceType) {
        assert Objects.nonNull(insuranceType) && Objects.isNull(insuranceType.getId());
        if(repository.findByName(insuranceType.getName()).isPresent()) {
            throw new MetadataException("Insurance Type already exists.");
        }
        return repository.save(insuranceType);
    }

    @Override
    public InsuranceType update(InsuranceType insuranceType) {
        assert Objects.nonNull(insuranceType) && Objects.nonNull(insuranceType.getId());
        Optional<InsuranceType> oldInsuranceTypeOptional = repository.findByName(insuranceType.getName());
        if(oldInsuranceTypeOptional.isPresent()) {
            InsuranceType old = oldInsuranceTypeOptional.get();
            if(!old.getId().equals(insuranceType.getId())) {
                throw new MetadataException("Insurance Type already exists.");
            }
        }
        return repository.save(insuranceType);
    }

    @Override
    public Optional<InsuranceType> findByName(String name) {
        return repository.findByName(name);
    }
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.metadata.license;

import com.helpampm.metadata.info.MetadataException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

/**
 * @author kuldeep
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class LicenseTypeServiceImpl implements LicenseTypeService {
    private final LicenseTypeRepository repository;
    @Override
    public List<LicenseType> findAllActive() {
        return repository.findByIsActive(true);
    }

    @Override
    public List<LicenseType> findAll() {
        return repository.findAll();
    }

    @Override
    @Transactional
    public LicenseType save(LicenseType licenseType) {
        assert Objects.nonNull(licenseType) && Objects.isNull(licenseType.getId());
        if(repository.findByName(licenseType.getName()).isPresent()) {
            throw new MetadataException("License Type already exists.");
        }
        return repository.save(licenseType);
    }

    @Override
    public LicenseType update(LicenseType licenseType) {
        assert Objects.nonNull(licenseType) && Objects.nonNull(licenseType.getId());
        Optional<LicenseType> oldLicenseTypeOptional = repository.findByName(licenseType.getName());
        if(oldLicenseTypeOptional.isPresent()) {
            LicenseType old = oldLicenseTypeOptional.get();
            if(!old.getId().equals(licenseType.getId())) {
                throw new MetadataException("License Type already exists.");
            }
        }
        return repository.save(licenseType);
    }

    @Override
    public Optional<LicenseType> findByName(String name) {
        return repository.findByName(name);
    }
}

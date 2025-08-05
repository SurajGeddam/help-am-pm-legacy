/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.license;

import com.helpampm.metadata.license.LicenseType;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

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
public class LicenseServiceImpl implements LicenseService {
    private final LicenseRepository repository;

    @Override
    public List<License> saveAll(List<License> licenses) {
        return repository.saveAll(licenses);
    }

    @Override
    public License save(License license) {
        assert Objects.nonNull(license);
        license.setCreatedAt(LocalDateTime.now());
        license.setLastUpdatedAt(LocalDateTime.now());
        checkDuplicates(license);
        license.validate();
        return repository.save(license);
    }

    @Override
    public License update(License license) {
        assert Objects.nonNull(license) && Objects.nonNull(license.getId());
        license.setLastUpdatedAt(LocalDateTime.now());
        license.validate();
        return repository.save(license);
    }

    @Override
    public License findById(Long id) {
        return repository.findById(id).orElseThrow(() -> new LicenseException("Unable to find license with id=" + id));
    }

    @Override
    public List<License> findAllByIds(List<Long> licenseIds) {
        return repository.findAllById(licenseIds);
    }

    @Override
    public List<License> findByProviderUniqueId(String providerUniqueId) {
        return repository.findByProviderUniqueId(providerUniqueId);
    }

    private void checkDuplicates(License license) {
        if (findByProviderUniqueIdAndLicenseTypeAndLicenseNumber(license.getProviderUniqueId(),
                license.getLicenseType(), license.getLicenseNumber()).isPresent()) {
            throw new LicenseException("License already exists");
        }
    }

    public Optional<License> findByProviderUniqueIdAndLicenseTypeAndLicenseNumber(String providerUniqueId,
                                                                                  LicenseType licenseType,
                                                                                  String licenseNumber) {
        return repository.findByProviderUniqueIdAndLicenseTypeAndLicenseNumber(providerUniqueId,
                licenseType,
                licenseNumber);
    }
}

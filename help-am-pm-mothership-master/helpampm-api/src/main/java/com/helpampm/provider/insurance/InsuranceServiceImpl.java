/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.insurance;

import com.helpampm.metadata.insurance.InsuranceType;
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
public class InsuranceServiceImpl implements InsuranceService {
    private final InsuranceRepository repository;

    @Override
    @Transactional
    public List<Insurance> saveAll(List<Insurance> insurances) {
        insurances.forEach(insurance -> {
            assert Objects.nonNull(insurance);
            insurance.setCreatedAt(LocalDateTime.now());
            insurance.setLastUpdatedAt(LocalDateTime.now());
            checkDuplicates(insurance);
            insurance.validate();
        });
        return repository.saveAll(insurances);
    }

    @Override
    public Insurance findById(Long id) {
        return repository.findById(id).orElseThrow(() -> new InsuranceException("Unable to find Insurance with id=" + id));
    }

    @Override
    public List<Insurance> findByProviderUniqueId(String providerUniqueId) {
        return repository.findByProviderUniqueId(providerUniqueId);
    }

    @Override
    public Insurance save(Insurance insurance) {
        assert Objects.nonNull(insurance);
        insurance.setCreatedAt(LocalDateTime.now());
        insurance.setLastUpdatedAt(LocalDateTime.now());
        checkDuplicates(insurance);
        insurance.validate();
        return repository.save(insurance);
    }

    @Override
    public Insurance update(Insurance insurance) {
        assert Objects.nonNull(insurance) && Objects.nonNull(insurance.getId());
        insurance.setLastUpdatedAt(LocalDateTime.now());
        Insurance oldInsurance = findById(insurance.getId());
        oldInsurance.copyNonNullValues(insurance);
        insurance.validate();
        return repository.save(insurance);
    }

    @Override
    public List<Insurance> findByIds(List<Long> insuranceIds) {
        return repository.findAllById(insuranceIds);
    }

    private void checkDuplicates(Insurance insurance) {
        if (findByProviderUniqueIdAndPolicyTypeAndPolicyNumber(insurance.getProviderUniqueId(),
                insurance.getPolicyType(), insurance.getPolicyNumber()).isPresent()) {
            throw new InsuranceException("Insurance already exists");
        }
    }

    public Optional<Insurance> findByProviderUniqueIdAndPolicyTypeAndPolicyNumber(String providerUniqueId, InsuranceType insuranceType, String policyNumber) {
        return repository.findByProviderUniqueIdAndPolicyTypeAndPolicyNumber(providerUniqueId,
                insuranceType,
                policyNumber);
    }
}

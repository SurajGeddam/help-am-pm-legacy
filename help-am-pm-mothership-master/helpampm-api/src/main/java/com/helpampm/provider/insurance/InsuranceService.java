/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.insurance;

import com.helpampm.metadata.insurance.InsuranceType;

import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface InsuranceService {
    List<Insurance> saveAll(List<Insurance> insurances);

    Insurance findById(Long id);

    List<Insurance> findByProviderUniqueId(String providerUniqueId);

    Insurance save(Insurance insurance);

    Insurance update(Insurance insurance);

    List<Insurance> findByIds(List<Long> insuranceIds);

    Optional<Insurance> findByProviderUniqueIdAndPolicyTypeAndPolicyNumber(String providerUniqueId,
                                                                           InsuranceType policyType,
                                                                           String policyNumber);
}

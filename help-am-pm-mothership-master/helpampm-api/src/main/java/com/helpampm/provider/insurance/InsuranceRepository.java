/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.insurance;

import com.helpampm.metadata.insurance.InsuranceType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface InsuranceRepository extends JpaRepository<Insurance, Long> {
    List<Insurance> findByProviderUniqueId(String providerUniqueId);

    Optional<Insurance> findByProviderUniqueIdAndPolicyTypeAndPolicyNumber(String providerUniqueId, InsuranceType policyType, String policyNumber);
}

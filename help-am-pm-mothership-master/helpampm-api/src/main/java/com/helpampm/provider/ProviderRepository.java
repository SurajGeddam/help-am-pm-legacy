/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider;

import com.helpampm.dashboard.dtos.ActiveInactiveQueryCount;
import com.helpampm.dashboard.dtos.MonthlyCountDto;
import com.helpampm.provider.categories.ProviderCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.Set;

/**
 * @author kuldeep
 */
public interface ProviderRepository extends JpaRepository<Provider, Long> {
    List<Provider> findByCategories(ProviderCategory category);

    Optional<Provider> findByProviderUniqueId(String providerId);

    Optional<Provider> findByStripAccountId(String stripeAccountId);

    Optional<Provider> findByCompanyUniqueId(String companyUniqueId);

    List<Provider> findByParentCompanyUniqueId(String companyUniqueId);

    @Query(value = "SELECT new com.helpampm.dashboard.dtos.ActiveInactiveQueryCount(COUNT(p) as empCount, " +
            "p.isActive as isActive) FROM Provider p WHERE p.parentCompanyUniqueId = :parentCompanyUniqueId " +
            "GROUP by p.isActive")
    List<ActiveInactiveQueryCount> employeesCount(@Param("parentCompanyUniqueId") String parentCompanyUniqueId);

    @Query(value = "SELECT new com.helpampm.dashboard.dtos.ActiveInactiveQueryCount(COUNT(p) as recordCount, " +
            "p.isActive as isActive) " +
            "FROM Provider p " +
            "GROUP by p.isActive")
    List<ActiveInactiveQueryCount> providerCount();

    @Query(value = "SELECT new com.helpampm.dashboard.dtos.MonthlyCountDto(COUNT(p), MONTH(p.createdAt)) " +
            "FROM Provider p " +
            "WHERE (p.createdAt >= :startDate AND p.createdAt < :endDate) " +
            "GROUP by MONTH(p.createdAt)")
    List<MonthlyCountDto> findNewProvidersGroupByMonthOverCurrentYear(LocalDateTime startDate, LocalDateTime endDate);

    List<Provider> findAllByProviderUniqueIdIn(Set<String> providerIds);
}

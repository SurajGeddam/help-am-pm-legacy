/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.customer;

import com.helpampm.dashboard.dtos.ActiveInactiveQueryCount;
import com.helpampm.dashboard.dtos.MonthlyCountDto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface CustomerRepository extends JpaRepository<Customer, Long> {
    Optional<Customer> findByCustomerUniqueId(String customerId);

    @Query(value = "SELECT new com.helpampm.dashboard.dtos.ActiveInactiveQueryCount(COUNT(c) as recordCount, c.isActive as isActive) " +
            "FROM Customer c " +
            "GROUP by c.isActive")
    List<ActiveInactiveQueryCount> customerCount();

    @Query("SELECT COUNT(c) FROM Customer c WHERE (createdAt >= :startDate AND createdAt < :endDate)")
    Long getCustomerSignupCountBySuperAdmin(@Param("startDate") LocalDateTime startDate,
                                              @Param("endDate") LocalDateTime endDate);

    @Query(value = "SELECT new com.helpampm.dashboard.dtos.MonthlyCountDto(COUNT(c), MONTH(c.createdAt)) " +
            "FROM Customer c " +
            "WHERE (c.createdAt >= :startDate AND c.createdAt < :endDate) " +
            "GROUP by MONTH(c.createdAt)")
    List<MonthlyCountDto> findNewCustomerGroupByMonthOverCurrentYear(@Param("startDate") LocalDateTime startDate,
                                                                     @Param("endDate") LocalDateTime endDate);

    Customer findByEmail(String s);
}

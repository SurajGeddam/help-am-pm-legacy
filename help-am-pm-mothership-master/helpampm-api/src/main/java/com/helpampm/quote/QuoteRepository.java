/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote;

import com.helpampm.dashboard.dtos.MonthlyCountDto;
import com.helpampm.dashboard.dtos.SaleDataByCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface QuoteRepository extends JpaRepository<Quote, Long> {
    @Query(value = "SELECT new com.helpampm.dashboard.dtos.KeyValueQueryCount(COUNT(q) " +
            "as recordCount, CAST(q.status as string) as status)  FROM Quote q " +
            "GROUP by q.status having q.status='COMPLETED'\n" +
            "            or q.status='RECEIVED'")
    Double quoteCountBySuperAdmin(String status);

    List<Quote> findTop10QuoteByOrderByCreatedAtDesc();

    Quote findByQuoteUniqueId(String quoteUniqueId);

    Optional<Quote> findByQuoteUniqueIdAndQuoteProviderUniqueId(String quoteUniqueId, String providerUniqueId);

    List<Quote> findByQuoteCustomerUniqueId(String customerUniqueId);

    List<Quote> findByQuoteProviderUniqueIdIn(List<String> providerIds);

    List<Quote> findByQuoteProviderUniqueId(String providerUniqueId);

    List<Quote> findByScheduledTimeLessThanEqualAndScheduledTimeGreaterThanEqual(LocalDateTime startTime, LocalDateTime endTime);

    List<Quote> getQuoteByQuoteCustomerUniqueIdAndStatus(String customerUniqueId, QuoteStatus status);

    List<Quote> getQuoteByQuoteProviderUniqueIdAndStatus(String providerUniqueId, QuoteStatus status);

    List<Quote> getQuoteByQuoteProviderUniqueIdInAndStatus(Iterable<String> collect, QuoteStatus status);

    @Query("SELECT COUNT(q) FROM Quote q WHERE q.quoteProvider.uniqueId IN (:providerIds)")
    long countByQuoteProviderUniqueIdIn(@Param("providerIds") List<String> providerIds);

    @Query("SELECT COUNT(q) FROM Quote q WHERE q.quoteProvider.uniqueId IN (:providerIds) and status = :status")
    long countByQuoteProviderUniqueIdInAndStatus(@Param("providerIds") List<String> providerIds, @Param("status") QuoteStatus status);

    @Query("SELECT COUNT(q) FROM Quote q WHERE q.quoteProvider.uniqueId IN (:providerIds) and status = :status AND " +
            "(createdAt >= :startDate AND createdAt >= :endDate)")
    long countByQuoteProviderUniqueIdInAndStatus(@Param("providerIds") List<String> providerIds, @Param("status") QuoteStatus status,
                                                 @Param("startDate") LocalDateTime startDate,
                                                 @Param("endDate") LocalDateTime endDate);

    @Query("SELECT COUNT(q) FROM Quote q WHERE q.quoteProvider.uniqueId IN (:providerIds) AND " +
            "(createdAt >= :startDate AND createdAt >= :endDate)")
    long countByQuoteProviderUniqueIdIn(@Param("providerIds") List<String> providerIds,
                                        @Param("startDate") LocalDate startDate,
                                        @Param("endDate") LocalDate endDate);

    @Query("SELECT case when SUM(q.invoice.totalPrice) is not null then SUM(q.invoice.totalPrice) else 0 end FROM Quote q WHERE q.quoteProvider.uniqueId IN (:providerIds) " +
            "AND (createdAt >= :startDate AND createdAt <= :endDate) " +
            "AND q.invoice IS NOT NULL")
    long totalEarningsByProviderIds(List<String> providerIds, LocalDateTime startDate, LocalDateTime endDate);

    @Query("SELECT case when SUM(q.invoice.totalPrice) is not null then SUM(q.invoice.totalPrice) else 0 end FROM Quote q WHERE q.quoteProvider.uniqueId IN (:providerIds) " +
            "AND q.invoice IS NOT NULL")
    long totalEarningsByProviderIds(List<String> providerIds);

    @Query("SELECT SUM(q.invoice.totalPrice) FROM Quote q WHERE q.invoice IS NOT NULL")
    Double totalEarningsBySuperAdmin();

    @Query("SELECT SUM(q.invoice.totalPrice) FROM Quote q " +
            "WHERE (createdAt >= :startDate AND createdAt < :endDate) " +
            "AND q.invoice IS NOT NULL")
    Double totalEarningsBySuperAdmin(LocalDateTime startDate, LocalDateTime endDate);

    @Query("SELECT COUNT(q) FROM Quote q WHERE (createdAt >= :startDate AND createdAt < :endDate)")
    long quotesCountBySuperAdmin(LocalDateTime startDate, LocalDateTime endDate);

    @Query("SELECT COUNT(q) FROM Quote q WHERE status IN :status")
    long findByStatusIn(@Param("status") List<QuoteStatus> status);


    @Query("SELECT new com.helpampm.dashboard.dtos.SaleDataByCategory(" +
            "SUM(q.invoice.totalPrice) as total, " +
            "MONTH(q.createdAt) as month, " +
            "q.categoryName) FROM Quote q " +
            "WHERE q.invoice IS NOT NULL " +
            "AND q.createdAt >= :startDate " +
            "AND q.createdAt < :endDate " +
            "AND categoryName = :categoryName " +
            "GROUP BY MONTH(q.createdAt), :categoryName")
    List<SaleDataByCategory> findEarningSumByCategoryAndGroupByMonthOverCurrentYear(
            @Param("categoryName") String categoryName,
            @Param("startDate") LocalDateTime startDate,
            @Param("endDate") LocalDateTime endDate);

    @Query(value = "SELECT new com.helpampm.dashboard.dtos.MonthlyCountDto(COUNT(q), MONTH(q.createdAt)) " +
            "FROM Quote q " +
            "WHERE (q.createdAt >= :startDate AND q.createdAt < :endDate) " +
            "GROUP by MONTH(q.createdAt)")
    List<MonthlyCountDto> findNewQuotesGroupByMonthOverCurrentYear(LocalDateTime startDate, LocalDateTime endDate);


    @Query("SELECT new com.helpampm.dashboard.dtos.MonthlyCountDto(" +
            "SUM(q.invoice.totalPrice), " +
            "MONTH(q.createdAt)) FROM Quote q " +
            "WHERE q.invoice IS NOT NULL " +
            "AND q.createdAt >= :startDate " +
            "AND q.createdAt < :endDate " +
            "GROUP BY MONTH(q.createdAt)")
    List<MonthlyCountDto> findRevenueGroupByMonthOverCurrentYear(LocalDateTime startDate, LocalDateTime endDate);

    List<Quote> findByScheduledTimeBetween(LocalDateTime startTime, LocalDateTime endTime);
}

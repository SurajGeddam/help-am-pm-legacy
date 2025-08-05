/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.dashboard;

import com.helpampm.common.CountResponse;
import com.helpampm.dashboard.dtos.*;
import com.helpampm.quote.Quote;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * @author kuldeep
 */
public interface DashboardService {

    CountResponse customersCount();
    CountResponse providersCount();
    CountResponse totalOrderCount();
    CountResponse employeesCount(String providerUniqueId);
    CountResponse totalOrderCount(String providerUniqueId, LocalDate startDate, LocalDate endDate);
    CountResponse totalOrderCount(String providerUniqueId);
    CountResponse earningsCount(String providerUniqueId, LocalDateTime startDate, LocalDateTime endDate);
    CountResponse earningsCount(String providerUniqueId);
    CountResponse earningsCount();
    CountResponse earningsCount(LocalDateTime startDate, LocalDateTime endDate);
    List<Quote> latestOrders();
    CountResponse quotesCount(LocalDateTime startDate, LocalDateTime endDate);
    CountResponse getCustomerSignupCount(LocalDateTime startDate, LocalDateTime endDate);

    SalesChartDataResponse getSalesChartData();
    CustomersSignupChartDataResponse getCustomersSignupChartData();
    ProvidersSignupChartDataResponse getProvidersSignupChartData();
    OrdersChartDataResponse getOrdersChartData();
    RevenueChartDataResponse getRevenueChartData();

    List<ProviderDashboardModel> mobileDashboard(String providerUniqueId);
    Map<String, Boolean> fetchProviderAccountSetup(String providerUniqueId);

    }

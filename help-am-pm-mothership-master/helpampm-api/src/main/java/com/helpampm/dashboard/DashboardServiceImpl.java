/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.dashboard;

import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.services.AuthenticationService;
import com.helpampm.common.CountResponse;
import com.helpampm.common.HelpConstants;
import com.helpampm.common.StringUtils;
import com.helpampm.common.UnauthorizedException;
import com.helpampm.customer.CustomerRepository;
import com.helpampm.dashboard.dtos.*;
import com.helpampm.metadata.category.Category;
import com.helpampm.metadata.category.CategoryService;
import com.helpampm.provider.Provider;
import com.helpampm.provider.ProviderException;
import com.helpampm.provider.ProviderRepository;
import com.helpampm.quote.Quote;
import com.helpampm.quote.QuoteRepository;
import com.helpampm.quote.QuoteStatus;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class DashboardServiceImpl implements DashboardService {
    private static final Map<Integer, String> MONTHS = new HashMap<>() {{
        put(1, "JAN");
        put(2, "FEB");
        put(3, "MAR");
        put(4, "APR");
        put(5, "MAY");
        put(6, "JUN");
        put(7, "JUL");
        put(8, "AUG");
        put(9, "SEP");
        put(10, "OCT");
        put(11, "NOV");
        put(12, "DEC");
    }};
    private final CustomerRepository customerRepository;
    private final ProviderRepository providerRepository;
    private final QuoteRepository quoteRepository;

    private final CategoryService categoryService;
    private final AuthenticationService authenticationService;

    private static HashMap<String, Number> buildResponseMap(List<ActiveInactiveQueryCount> response) {
        HashMap<String, Number> responseCount = new HashMap<>();
        for (ActiveInactiveQueryCount activeInactiveQueryCount : response) {
            if (activeInactiveQueryCount.isActive()) {
                responseCount.put(HelpConstants.ACTIVE, activeInactiveQueryCount.getRecordCount());
            } else {
                responseCount.put(HelpConstants.IN_ACTIVE, activeInactiveQueryCount.getRecordCount());
            }
        }
        responseCount.putIfAbsent(HelpConstants.IN_ACTIVE, 0);
        responseCount.putIfAbsent(HelpConstants.ACTIVE, 0);
        return responseCount;
    }

    @Override
    public CountResponse customersCount() {
        List<ActiveInactiveQueryCount> response = customerRepository.customerCount();
        HashMap<String, Number> customerCount = buildResponseMap(response);
        return CountResponse.builder()
                .withData(customerCount)
                .build();
    }

    @Override
    public CountResponse providersCount() {
        List<ActiveInactiveQueryCount> response = providerRepository.providerCount();
        HashMap<String, Number> providerCount = buildResponseMap(response);
        return CountResponse.builder()
                .withData(providerCount)
                .build();
    }

    @Override
    public CountResponse totalOrderCount() {
        HashMap<String, Number> quoteCount = new HashMap<>();
        // order we have completed till now
        quoteCount.putIfAbsent("COMPLETED",
                quoteRepository.findByStatusIn(List.of(
                        QuoteStatus.PAYMENT_DONE,
                        QuoteStatus.ORDER_CANCELLED
                )));
        quoteCount.putIfAbsent("PENDING", quoteRepository.findByStatusIn(List.of(QuoteStatus.STARTED,
                QuoteStatus.SCHEDULED,
                QuoteStatus.PAYMENT_PENDING,
                QuoteStatus.ACCEPTED_BY_PROVIDER)));

        quoteCount.putIfAbsent("RECEIVED", quoteRepository.count());

        return CountResponse.builder()
                .withData(quoteCount)
                .build();
    }

    @Override
    public CountResponse employeesCount(String providerUniqueId) {
        Provider provider = providerRepository.findByProviderUniqueId(providerUniqueId)
                .orElseThrow(() -> new ProviderException("Unable to find provider with providerUniqueId " + providerUniqueId, HttpStatus.NOT_FOUND));
        validateProvider(provider.getProviderUniqueId());
        if (StringUtils.isNullOrEmpty(provider.getCompanyUniqueId())) {
            return CountResponse.builder()
                    .withData(Map.of())
                    .build();
        }
        List<ActiveInactiveQueryCount> response = providerRepository.employeesCount(provider.getCompanyUniqueId());
        HashMap<String, Number> empCountMap = buildResponseMap(response);
        return CountResponse.builder()
                .withData(empCountMap)
                .build();
    }

    private void validateProvider(String providerUniqueId) {
        UserLoginDetails userLoginDetails = authenticationService.findLoggedInUser();
        if (userLoginDetails.isSuperAdmin()) {
            return;
        }
        if (Objects.isNull(userLoginDetails.getProviderUniqueId())
                || !Objects.equals(providerUniqueId, userLoginDetails.getProviderUniqueId())) {
            log.error("Invalid provider tried to access the application data with providerUniqueId" + providerUniqueId);
            throw new UnauthorizedException("You don't have a permission to access this. Please contact our system admin.");
        }
    }

    @Override
    public CountResponse totalOrderCount(String providerUniqueId, LocalDate startDate, LocalDate endDate) {
        List<String> providerIds = fetchProviderIds(providerUniqueId);
        long count = quoteRepository.countByQuoteProviderUniqueIdIn(providerIds, startDate, endDate);
        HashMap<String, Number> quoteCount = new HashMap<>();
        quoteCount.put("totalOrders", count);
        return CountResponse.builder()
                .withData(quoteCount)
                .build();
    }

    @Override
    public CountResponse totalOrderCount(String providerUniqueId) {
        List<String> providerIds = fetchProviderIds(providerUniqueId);
        long count = quoteRepository.countByQuoteProviderUniqueIdIn(providerIds);
        HashMap<String, Number> quoteCount = new HashMap<>();
        quoteCount.put("totalOrders", count);
        return CountResponse.builder()
                .withData(quoteCount)
                .build();
    }

    @Override
    public CountResponse earningsCount(String providerUniqueId, LocalDateTime startDate, LocalDateTime endDate) {
        List<String> providerIds = fetchProviderIds(providerUniqueId);

        long count = quoteRepository.totalEarningsByProviderIds(providerIds, startDate, endDate);
        HashMap<String, Number> quoteCount = new HashMap<>();
        quoteCount.put("totalEarnings", count);
        return CountResponse.builder()
                .withData(quoteCount)
                .build();
    }

    @Override
    public CountResponse earningsCount(String providerUniqueId) {
        List<String> providerIds = fetchProviderIds(providerUniqueId);
        long count = quoteRepository.totalEarningsByProviderIds(providerIds);
        HashMap<String, Number> quoteCount = new HashMap<>();
        quoteCount.put("totalEarnings", count);
        return CountResponse.builder()
                .withData(quoteCount)
                .build();
    }

    @Override
    public CountResponse earningsCount() {
        Double count = quoteRepository.totalEarningsBySuperAdmin();
        HashMap<String, Number> earnings = new HashMap<>();
        earnings.put("totalEarnings", Objects.isNull(count) ? 0D : count);
        return CountResponse.builder()
                .withData(earnings)
                .build();
    }

    @Override
    public CountResponse earningsCount(LocalDateTime startDate, LocalDateTime endDate) {
        Double count = quoteRepository.totalEarningsBySuperAdmin(startDate, endDate);
        HashMap<String, Number> earnings = new HashMap<>();
        earnings.put("totalEarnings", Objects.isNull(count) ? 0D : count);
        return CountResponse.builder()
                .withData(earnings)
                .build();
    }

    @Override
    public List<Quote> latestOrders() {
        UserLoginDetails userLoginDetails = authenticationService.findLoggedInUser();
        if (userLoginDetails.isSuperAdmin()) {
            return quoteRepository.findTop10QuoteByOrderByCreatedAtDesc();
        }
        return quoteRepository.findByQuoteProviderUniqueId(userLoginDetails.getProviderUniqueId());
    }

    @Override
    public CountResponse quotesCount(LocalDateTime startDate, LocalDateTime endDate) {
        long count = quoteRepository.quotesCountBySuperAdmin(startDate, endDate);
        HashMap<String, Number> earnings = new HashMap<>();
        earnings.put("count", count);
        return CountResponse.builder()
                .withData(earnings)
                .build();
    }

    @Override
    public CountResponse getCustomerSignupCount(LocalDateTime startDate, LocalDateTime endDate) {
        Long count = customerRepository.getCustomerSignupCountBySuperAdmin(startDate, endDate);
        HashMap<String, Number> earnings = new HashMap<>();
        earnings.put("count", Objects.isNull(count) ? 0L : count);
        return CountResponse.builder()
                .withData(earnings)
                .build();
    }

    @Override
    public SalesChartDataResponse getSalesChartData() {
        List<Category> categories = categoryService.getAllActive();
        LocalDateTime endDate = LocalDateTime.now();
        LocalDateTime startDate = LocalDateTime.now()
                .withMonth(1).withDayOfMonth(1)
                .withHour(0).withMinute(0)
                .withSecond(0);
        SalesChartDataResponse salesChartDataResponse = new SalesChartDataResponse();
        for (Category category : categories) {
            List<SaleDataByCategory> saleDataByCategories = quoteRepository
                    .findEarningSumByCategoryAndGroupByMonthOverCurrentYear(category.getName(),
                            startDate, endDate);
            addMissingMonthDataForSalesChart(saleDataByCategories, category.getName());
            Map<String, SalesChartData> map = salesChartDataResponse.getData();
            map.put(category.getName(), SalesChartData.from(saleDataByCategories, category.getName()));
        }
        return salesChartDataResponse;
    }

    private void addMissingMonthDataForSalesChart(List<SaleDataByCategory> saleDataByCategories, String categoryName) {
        for (Integer key : MONTHS.keySet()) {
            if (checkIfMonthSalesNotExists(key, saleDataByCategories)) {
                SaleDataByCategory saleDataByCategory = new SaleDataByCategory(0, key, categoryName);
                saleDataByCategories.add(saleDataByCategory);
            }
        }
    }

    private boolean checkIfMonthSalesNotExists(Integer key, List<SaleDataByCategory> saleDataByCategories) {
        for (SaleDataByCategory saleDataByCategory : saleDataByCategories) {
            if (Objects.equals(key, saleDataByCategory.getMonth())) {
                return false;
            }
        }
        return true;
    }

    @Override
    public CustomersSignupChartDataResponse getCustomersSignupChartData() {
        LocalDateTime endDate = LocalDateTime.now();
        LocalDateTime startDate = LocalDateTime.now()
                .withMonth(1).withDayOfMonth(1)
                .withHour(0).withMinute(0).withSecond(0);
        List<MonthlyCountDto> monthlyCountDtos = customerRepository.findNewCustomerGroupByMonthOverCurrentYear(startDate, endDate);
        Set<MonthlyCountDto> set = addMissingDataForMonth(monthlyCountDtos);
        return CustomersSignupChartDataResponse.from(set);
    }

    private Set<MonthlyCountDto> addMissingDataForMonth(List<MonthlyCountDto> monthlyCountDtos) {
        Set<MonthlyCountDto> set = new TreeSet<>(monthlyCountDtos);
        for (Integer key : MONTHS.keySet()) {
            if (checkIfMonthsDataNotExists(monthlyCountDtos, key)) {
                MonthlyCountDto monthlyCountDto = new MonthlyCountDto(0, key);
                set.add(monthlyCountDto);
            }
        }
        return set;
    }

    private boolean checkIfMonthsDataNotExists(List<MonthlyCountDto> monthlyCountDtos, Integer key) {
        for (MonthlyCountDto monthlyCountDto : monthlyCountDtos) {
            if (Objects.equals(monthlyCountDto.getMonth(), key)) {
                return false;
            }
        }
        return true;
    }

    @Override
    public ProvidersSignupChartDataResponse getProvidersSignupChartData() {
        LocalDateTime endDate = LocalDateTime.now();
        LocalDateTime startDate = LocalDateTime.now()
                .withMonth(1).withDayOfMonth(1)
                .withHour(0).withMinute(0).withSecond(0);
        List<MonthlyCountDto> monthlyCountDtos = providerRepository.findNewProvidersGroupByMonthOverCurrentYear(startDate, endDate);
        Set<MonthlyCountDto> set = addMissingDataForMonth(monthlyCountDtos);
        return ProvidersSignupChartDataResponse.from(set);
    }

    @Override
    public OrdersChartDataResponse getOrdersChartData() {
        LocalDateTime endDate = LocalDateTime.now();
        LocalDateTime startDate = LocalDateTime.now()
                .withMonth(1).withDayOfMonth(1)
                .withHour(0).withMinute(0).withSecond(0);
        List<MonthlyCountDto> monthlyCountDtos = quoteRepository.findNewQuotesGroupByMonthOverCurrentYear(startDate, endDate);
        Set<MonthlyCountDto> set = addMissingDataForMonth(monthlyCountDtos);
        return OrdersChartDataResponse.from(set);
    }

    @Override
    public RevenueChartDataResponse getRevenueChartData() {
        LocalDateTime endDate = LocalDateTime.now();
        LocalDateTime startDate = LocalDateTime.now()
                .withMonth(1).withDayOfMonth(1)
                .withHour(0).withMinute(0).withSecond(0);
        List<MonthlyCountDto> monthlyCountDtos = quoteRepository.findRevenueGroupByMonthOverCurrentYear(startDate, endDate);
        Set<MonthlyCountDto> set = addMissingDataForMonth(monthlyCountDtos);
        return RevenueChartDataResponse.from(set);
    }

    @Override
    public List<ProviderDashboardModel> mobileDashboard(String providerUniqueId) {
        LocalDateTime startDate = LocalDateTime.now().toLocalDate().atTime(0, 0, 0);
        LocalDateTime endDate = LocalDateTime.now().toLocalDate().plusDays(1).atTime(23, 59, 59);
        CountResponse earningTotal = earningsCount(providerUniqueId);
        CountResponse earningWeek = earningsCount(providerUniqueId, startDate, endDate);
        CountResponse completedQUotes = countCompletedQuotes(providerUniqueId);
        CountResponse todaysCompletedQuotes = countTodaysCompletedQuotes(providerUniqueId, startDate, endDate);

        List<ProviderDashboardModel> providerDashboardModelList = new ArrayList<>();
        providerDashboardModelList.add(ProviderDashboardModel.builder().value(HelpConstants.decimalFormat2Digit
                        .format(earningTotal.getData().get("totalEarnings"))).text("Total Earning").bgColor("#FFAF00").
                amount(true).build());
        providerDashboardModelList.add(ProviderDashboardModel.builder().value(HelpConstants.decimalFormat2Digit
                        .format(earningWeek.getData().get("totalEarnings"))).text("Today's Earning").bgColor("#414141")
                .amount(true).build());
        providerDashboardModelList.add(ProviderDashboardModel.builder().value(HelpConstants.decimalFormat2Digit
                        .format(completedQUotes.getData().get("allCompletedQuotes"))).text("Total Completed Orders")
                .bgColor("#9195FF")
                .amount(false).build());
        providerDashboardModelList.add(ProviderDashboardModel.builder().value(HelpConstants.decimalFormat2Digit
                        .format(todaysCompletedQuotes.getData().get("todayCompletedQuotes"))).text("Today's Completed Orders")
                .bgColor("#00A100").amount(false).build());
        return providerDashboardModelList;
    }

    public CountResponse countCompletedQuotes(String providerUniqueId) {
        List<String> providerIds = fetchProviderIds(providerUniqueId);
        long completedQuotes = quoteRepository.countByQuoteProviderUniqueIdInAndStatus(providerIds, QuoteStatus.PAYMENT_DONE);
        HashMap<String, Number> quoteCount = new HashMap<>();
        quoteCount.put("allCompletedQuotes", completedQuotes);
        return CountResponse.builder()
                .withData(quoteCount)
                .build();
    }


    public CountResponse countTodaysCompletedQuotes(String providerUniqueId, LocalDateTime startDate, LocalDateTime endDate) {
        List<String> providerIds = fetchProviderIds(providerUniqueId);
        long todaysCompletedQuotes = quoteRepository.countByQuoteProviderUniqueIdInAndStatus(providerIds, QuoteStatus.PAYMENT_DONE, startDate, endDate);
        HashMap<String, Number> quoteCount = new HashMap<>();
        quoteCount.put("todayCompletedQuotes", todaysCompletedQuotes);
        return CountResponse.builder()
                .withData(quoteCount)
                .build();
    }

    private List<String> fetchProviderIds(String providerUniqueId) {
        Provider provider = providerRepository.findByProviderUniqueId(providerUniqueId)
                .orElseThrow(() -> new ProviderException("Provider not found", HttpStatus.NOT_FOUND));
        List<String> providerIds = new ArrayList<>();
        providerIds.add(provider.getProviderUniqueId());

        if (Objects.nonNull(provider.getCompanyUniqueId())) {
            providerIds.addAll(providerRepository
                    .findByParentCompanyUniqueId(provider.getCompanyUniqueId())
                    .stream().map(Provider::getProviderUniqueId).toList());
        }
        return providerIds;
    }

    public Map<String, Boolean> fetchProviderAccountSetup(String providerUniqueId) {
        Provider provider = providerRepository.findByProviderUniqueId(providerUniqueId).get();
        Map<String, Boolean> account = new HashMap<>();
        account.put("isAccountCompleted", provider.getAccountSetupCompleted());
        account.put("stripeSetupDone", provider.isStripeSetupDone());
        return account;
    }

}
/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.dashboard;

import com.helpampm.common.CountResponse;
import com.helpampm.customer.CustomerService;
import com.helpampm.dashboard.dtos.*;
import com.helpampm.quote.dto.QuoteDTO;
import com.helpampm.reviews.ReviewDTO;
import com.helpampm.reviews.ReviewService;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("dashboard")
@Tag(name = "System Dashboard Management")
@SuppressFBWarnings("EI_EXPOSE_REP")

/*
  @author kuldeep
 */
public class SystemDashboardController {
    private final CustomerService service;
    private final DashboardService dashboardService;
    private final ReviewService reviewService;
    @GetMapping("")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Fetch dashboard data")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = DashboardDto.class)))})
    public ResponseEntity<DashboardDto> getAll() {
        DashboardDto dashboardDto = new DashboardDto();
        dashboardDto.setCustomerCount(service.countCustomer());
        return ResponseEntity.ok(dashboardDto);
    }

    @GetMapping("count/providers")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Fetch dashboard data: Providers")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = CountResponse.class)))})
    public ResponseEntity<CountResponse> providers() {
        return ResponseEntity.ok(dashboardService.providersCount());
    }

    @GetMapping("count/customers")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Fetch dashboard data: Customers")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = CountResponse.class)))})
    public ResponseEntity<CountResponse> customersCount() {
        return ResponseEntity.ok(dashboardService.customersCount());
    }

    @GetMapping("count/quotes")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Fetch dashboard data: Orders")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = CountResponse.class)))})
    public ResponseEntity<CountResponse> totalOrders() {
        return ResponseEntity.ok(dashboardService.totalOrderCount());
    }

    @GetMapping("quotes/latest")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Fetch dashboard data: Latest Orders")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = QuoteDTO.class))))})
    public ResponseEntity<List<QuoteDTO>> latestQuotes() {
        return ResponseEntity.ok(dashboardService.latestOrders().stream().map(QuoteDTO::buildFromQuote).collect(Collectors.toList()));
    }

    @GetMapping("count/earnings")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Fetch dashboard data: Total Earnings")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = CountResponse.class)))})
    public ResponseEntity<CountResponse> totalEarnings() {
        return ResponseEntity.ok(dashboardService.earningsCount());
    }

    @GetMapping("count/earnings-by-duration")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Fetch dashboard data: Total Earnings by duration")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = CountResponse.class)))})
    public ResponseEntity<CountResponse> totalEarningsByDuration(@RequestParam("startDate") String startDateString,
                                                                 @RequestParam("endDate") String endDateString) {
        LocalDateTime startDate = LocalDate.parse(startDateString, DateTimeFormatter.ofPattern("MM-dd-yyyy")).atTime(0, 0, 0);
        LocalDateTime endDate = LocalDate.parse(endDateString, DateTimeFormatter.ofPattern("MM-dd-yyyy")).atTime(23, 59, 59);

        return ResponseEntity.ok(dashboardService.earningsCount(startDate, endDate));
    }

    @GetMapping("count/quotes-by-duration")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Fetch dashboard data: Total Orders by duration")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = CountResponse.class)))})
    public ResponseEntity<CountResponse> getOrdersByDuration(@RequestParam("startDate") String startDateString,
                                                                 @RequestParam("endDate") String endDateString) {
        LocalDateTime startDate = LocalDate.parse(startDateString, DateTimeFormatter.ofPattern("MM-dd-yyyy")).atTime(0, 0, 0);
        LocalDateTime endDate = LocalDate.parse(endDateString, DateTimeFormatter.ofPattern("MM-dd-yyyy")).atTime(23, 59, 59);

        return ResponseEntity.ok(dashboardService.quotesCount(startDate, endDate));
    }

    @GetMapping("count/customers-signup-by-duration")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Fetch dashboard data: Total Customer Signup by duration")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = CountResponse.class)))})
    public ResponseEntity<CountResponse> getCustomersByDuration(@RequestParam("startDate") String startDateString,
                                                                 @RequestParam("endDate") String endDateString) {
        LocalDateTime startDate = LocalDate.parse(startDateString, DateTimeFormatter.ofPattern("MM-dd-yyyy")).atTime(0, 0, 0);
        LocalDateTime endDate = LocalDate.parse(endDateString, DateTimeFormatter.ofPattern("MM-dd-yyyy")).atTime(23, 59, 59);

        return ResponseEntity.ok(dashboardService.getCustomerSignupCount(startDate, endDate));
    }

    @GetMapping("reviews/latest")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Fetch dashboard data: Latest Reviews")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = ReviewDTO.class))))})
    public ResponseEntity<List<ReviewDTO>> getLatestReviews() {
        return ResponseEntity.ok(reviewService.getLatestReviews());
    }

    @GetMapping("chart/sales")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Fetch dashboard data: Sales chart data")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = SalesChartDataResponse.class)))})
    public ResponseEntity<SalesChartDataResponse> getSalesChartData() {
        return ResponseEntity.ok(dashboardService.getSalesChartData());
    }

    @GetMapping("chart/customers")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Fetch dashboard data: Customers chart data")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = CustomersSignupChartDataResponse.class)))})
    public ResponseEntity<CustomersSignupChartDataResponse> getCustomersSignupChartData() {
        return ResponseEntity.ok(dashboardService.getCustomersSignupChartData());
    }

    @GetMapping("chart/providers")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Fetch dashboard data: Providers chart data")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = ProvidersSignupChartDataResponse.class)))})
    public ResponseEntity<ProvidersSignupChartDataResponse> getProvidersSignupChartData() {
        return ResponseEntity.ok(dashboardService.getProvidersSignupChartData());
    }

    @GetMapping("chart/orders")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Fetch dashboard data: Orders chart data")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = OrdersChartDataResponse.class)))})
    public ResponseEntity<OrdersChartDataResponse> getOrdersChartData() {
        return ResponseEntity.ok(dashboardService.getOrdersChartData());
    }

    @GetMapping("chart/revenue")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Fetch dashboard data: Revenue chart data")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = RevenueChartDataResponse.class)))})
    public ResponseEntity<RevenueChartDataResponse> getRevenueChartData() {
        return ResponseEntity.ok(dashboardService.getRevenueChartData());
    }


}

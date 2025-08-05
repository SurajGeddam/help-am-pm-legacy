/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.dashboard;

import com.helpampm.common.CountResponse;
import com.helpampm.common.MobileDashBoardResponse;
import com.helpampm.common.StringUtils;
import com.helpampm.dashboard.dtos.ProviderDashboardModel;
import com.helpampm.quote.dto.QuoteDTO;
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
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("dashboard/provider")
@Tag(name = "Provider's Dashboard Management")
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class ProviderDashboardController {
    private final DashboardService dashboardService;

    @GetMapping("mobile/{providerUniqueId}")
    @Secured({"ROLE_PROVIDER_ADMIN", "ROLE_PROVIDER_EMPLOYEE"})
    @Operation(summary = "Fetch dashboard data")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = CountResponse.class)))})
    public ResponseEntity<MobileDashBoardResponse> providerMobileDashboard(@PathVariable("providerUniqueId") String providerUniqueId) {
        List<ProviderDashboardModel> countResponse = dashboardService.mobileDashboard(providerUniqueId);
        Map<String, Boolean> accountSetup = dashboardService.fetchProviderAccountSetup(providerUniqueId);
        MobileDashBoardResponse response = MobileDashBoardResponse.builder().withCountModel(countResponse)
                .withIsAccountCompleted(accountSetup.get("isAccountCompleted"))
                .withIsStripeAccountCompleted(accountSetup.get("stripeSetupDone")).build();
        return ResponseEntity.ok(response);
    }

    @GetMapping("{providerUniqueId}/total-earnings")
    @Secured({"ROLE_PROVIDER_ADMIN", "ROLE_PROVIDER_EMPLOYEE"})
    @Operation(summary = "Fetch dashboard data: Total Earnings by provider")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = CountResponse.class)))})
    public ResponseEntity<CountResponse> totalEarnings(@PathVariable("providerUniqueId") String providerUniqueId) {
        return ResponseEntity.ok(dashboardService.earningsCount(providerUniqueId));
    }

    @GetMapping("{providerUniqueId}/earnings-by-duration")
    @Secured({"ROLE_PROVIDER_ADMIN", "ROLE_PROVIDER_EMPLOYEE"})
    @Operation(summary = "Fetch dashboard data: Total Earnings by provider over a period")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = CountResponse.class)))})
    public ResponseEntity<CountResponse> earningByDuration(@PathVariable("providerUniqueId") String providerUniqueId,
                                                           @RequestParam("start") LocalDate startDate,
                                                           @RequestParam("end") LocalDate endDate) {

        LocalDateTime sDate = startDate.atTime(0, 0, 0);
        LocalDateTime eDate = endDate.atTime(23, 59, 59);
        return ResponseEntity.ok(dashboardService.earningsCount(providerUniqueId, sDate, eDate));
    }

    @GetMapping("{providerUniqueId}/total-orders-received")
    @Secured({"ROLE_PROVIDER_ADMIN", "ROLE_PROVIDER_EMPLOYEE"})
    @Operation(summary = "Fetch dashboard data: Total Order Received by provider")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = CountResponse.class)))})
    public ResponseEntity<CountResponse> totalOrders(@PathVariable("providerUniqueId") String providerUniqueId) {
        return ResponseEntity.ok(dashboardService.totalOrderCount(providerUniqueId));
    }

    @GetMapping("{providerUniqueId}/orders-received-by-duration")
    @Secured({"ROLE_PROVIDER_ADMIN", "ROLE_PROVIDER_EMPLOYEE"})
    @Operation(summary = "Fetch dashboard data: Total orders by provider over a period")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = CountResponse.class)))})
    public ResponseEntity<CountResponse> ordersByDuration(@PathVariable("providerUniqueId") String providerUniqueId,
                                                          @RequestParam("start") LocalDate startDate,
                                                          @RequestParam("end") LocalDate endDate) {
        return ResponseEntity.ok(dashboardService.totalOrderCount(providerUniqueId, startDate, endDate));
    }

    @GetMapping("{providerUniqueId}/employees")
    @Secured({"ROLE_PROVIDER_ADMIN"})
    @Operation(summary = "Fetch dashboard data: Total Employee by provider")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = CountResponse.class)))})
    public ResponseEntity<CountResponse> employees(@PathVariable("providerUniqueId") String providerUniqueId) {
        return ResponseEntity.ok(dashboardService.employeesCount(providerUniqueId));
    }

    @GetMapping("quotes/latest")
    @Secured({"ROLE_PROVIDER_ADMIN","ROLE_PROVIDER_EMPLOYEE"})
    @Operation(summary = "Fetch dashboard data: Latest Orders")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = QuoteDTO.class))))})
    public ResponseEntity<List<QuoteDTO>> latestQuotes() {
        return ResponseEntity.ok(dashboardService.latestOrders().stream().map(QuoteDTO::buildFromQuote).collect(Collectors.toList()));
    }
}

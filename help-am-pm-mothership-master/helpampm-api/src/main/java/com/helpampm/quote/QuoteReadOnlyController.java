/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote;

import com.helpampm.address.AddressService;
import com.helpampm.common.StringUtils;
import com.helpampm.common.services.FileService;
import com.helpampm.quote.dto.*;
import com.helpampm.quote.quoteproviders.QuoteProviderAddress;
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
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;

@SuppressFBWarnings("EI_EXPOSE_REP")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("quote")
@Tag(name = "Quote Management: Read", description = "All read operations on Quote.")
/*
  @author kuldeep
 */
public class QuoteReadOnlyController {
    private final QuoteReadOnlyService service;
    private final PageableQuoteFilterRequestHelper pageableQuoteFilterRequestHelper;
    private final AddressService addressService;
    private final FileService fileService;

    @Value("${aws.s3.profile-photos}")
    private String uploadBucket;

    @GetMapping("")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Get all quotes")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = QuoteDTO.class))))})
    public ResponseEntity<List<QuoteDTO>> getAll() {
        List<QuoteDTO> response = new ArrayList<>();
        for (Quote quote : service.findAll()) {
            QuoteDTO quoteDTO = QuoteDTO.buildFromQuote(quote);
            quoteDTO.setProviderAddress(QuoteProviderAddress
                    .buildFromAddress(addressService
                            .findByProviderUniqueId(quote.getQuoteProvider().getUniqueId())));
            response.add(quoteDTO);
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("provider/{providerUniqueId}")
    @Secured({"ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE"})
    @Operation(summary = "Get all quotes served by provider")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = QuoteDTO.class))))})
    public ResponseEntity<List<QuoteDTO>> getQuoteDetails(@PathVariable("providerUniqueId") String providerUniqueId) {

        List<QuoteDTO> response = new ArrayList<>();
        for (Quote quote : service.getQuotesProvider(providerUniqueId)) {
            QuoteDTO quoteDTO = QuoteDTO.buildFromQuote(quote);
            quoteDTO.setProviderAddress(QuoteProviderAddress
                    .buildFromAddress(addressService
                            .findByProviderUniqueId(providerUniqueId)));
            response.add(quoteDTO);
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("company/{companyUniqueId}")
    @Secured({"ROLE_PROVIDER_ADMIN"})
    @Operation(summary = "Get all quotes served by provider as a company: " +
            "Group data by company, if one company has 10 providers, " +
            "this is show the data from all 10 providers.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = QuoteDTO.class))))})
    public ResponseEntity<List<QuoteDTO>> getCompanyOrder(@PathVariable("companyUniqueId") String companyUniqueId) {
        List<QuoteDTO> response = new ArrayList<>();
        for (Quote quote : service.getQuotesForCompany(companyUniqueId)) {
            QuoteDTO quoteDTO = QuoteDTO.buildFromQuote(quote);
            quoteDTO.setProviderAddress(QuoteProviderAddress
                    .buildFromAddress(addressService
                            .findByProviderUniqueId(quote.getQuoteProvider().getUniqueId())));
            response.add(quoteDTO);
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("customer/{customerUniqueId}")
    @Secured({"ROLE_CUSTOMER"})
    @Operation(summary = "Get all quotes created by a customer")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = QuoteDTO.class))))})
    public ResponseEntity<List<QuoteMobileResponseDTO>> getCustomerOrder(@PathVariable("customerUniqueId") String customerUniqueId) {
        List<QuoteMobileResponseDTO> response = new ArrayList<>();
        for (Quote quote : service.getCustomerQuote(customerUniqueId)) {
            QuoteMobileResponseDTO quoteMobileResponseDTO = QuoteMobileResponseDTO.buildFromQuote(quote);
            quoteMobileResponseDTO.setProviderAddress(QuoteProviderAddress
                    .buildFromAddress(addressService
                            .findByProviderUniqueId(quote.getQuoteProvider().getUniqueId())));
            quoteMobileResponseDTO.updateQuoteImage(fileService, quote.getImagePath(), uploadBucket);
            response.add(quoteMobileResponseDTO);
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("{quoteUniqueId}")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE",
            "ROLE_CUSTOMER"})
    @Operation(summary = "Find order by quoteUniqueId")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = QuoteDTO.class)))})
    public ResponseEntity<QuoteMobileResponseDTO> findByOrderUniqueId(@PathVariable("quoteUniqueId") String quoteUniqueId) {
        Quote quote = service.findByQuoteUniqueId(quoteUniqueId);
        QuoteMobileResponseDTO quoteMobileResponseDTO = QuoteMobileResponseDTO.buildFromQuote(quote);
        if (quote.getQuoteProvider() != null) {
            quoteMobileResponseDTO.setProviderAddress(QuoteProviderAddress
                    .buildFromAddress(addressService
                            .findByProviderUniqueId(quote.getQuoteProvider().getUniqueId())));
            if (!StringUtils.isNullOrEmpty(quote.getQuoteProvider().getProviderImage())) {
                quoteMobileResponseDTO.getQuoteProvider()
                        .setProviderImage(fileService.downloadAsBytes(quote.getQuoteProvider().getProviderImage(), uploadBucket));
            }
        }
        quoteMobileResponseDTO.updateQuoteImage(fileService, quote.getImagePath(), uploadBucket);
        return ResponseEntity.ok(quoteMobileResponseDTO);
    }
    @GetMapping("web/{quoteUniqueId}")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE",
            "ROLE_CUSTOMER"})
    @Operation(summary = "Find order by quoteUniqueId")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = QuoteDTO.class)))})
    public ResponseEntity<QuoteDTO> getQuoteByQuoteUniqueId(@PathVariable("quoteUniqueId") String quoteUniqueId) {
        Quote quote = service.findByQuoteUniqueId(quoteUniqueId);
        QuoteDTO quoteDTO = QuoteDTO.buildFromQuote(quote);
            if (!StringUtils.isNullOrEmpty(quoteDTO.getImagePath())) {
                quoteDTO.setImage(fileService.downloadAsBytes(quoteDTO.getImagePath(), uploadBucket));
            }
            return ResponseEntity.ok(quoteDTO);
    }

    @GetMapping("customer/{customerUniqueId}/{status}")
    @Secured({"ROLE_CUSTOMER"})
    @Operation(summary = "Get all quotes by status for customer")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = QuoteDTO.class))))})
    public ResponseEntity<List<QuoteMobileResponseDTO>> getCustomerOrderByStatus(
            @PathVariable("status") String status,
            @PathVariable("customerUniqueId") String customerUniqueId) {
        List<QuoteMobileResponseDTO> response = new ArrayList<>();
        for (Quote quote : service.getQuoteByQuoteCustomerUniqueIdAndStatus(customerUniqueId, status)) {
            QuoteMobileResponseDTO quoteMobileResponseDTO = QuoteMobileResponseDTO.buildFromQuote(quote);
            if (quote.getQuoteProvider() != null) {
                quoteMobileResponseDTO.setProviderAddress(QuoteProviderAddress
                        .buildFromAddress(addressService
                                .findByProviderUniqueId(quote.getQuoteProvider().getUniqueId())));
            }
            quoteMobileResponseDTO.updateQuoteImage(fileService, quote.getImagePath(), uploadBucket);
            response.add(quoteMobileResponseDTO);
        }
        return ResponseEntity.ok(response);
    }

    @GetMapping("provider/{providerUniqueId}/{status}")
    @Secured({"ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE"})
    @Operation(summary = "Get all quotes by status for provider")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = QuoteDTO.class))))})
    public ResponseEntity<List<QuoteMobileResponseDTO>> getProviderOrderByStatus(
            @PathVariable("status") QuoteStatus status,
            @PathVariable("providerUniqueId") String providerUniqueId) {
        List<QuoteMobileResponseDTO> response = new ArrayList<>();
        for (Quote quote : service.getQuoteByQuoteProviderUniqueIdAndStatus(providerUniqueId, status)) {
            QuoteMobileResponseDTO quoteMobileResponseDTO = QuoteMobileResponseDTO.buildFromQuote(quote);
            quoteMobileResponseDTO.setProviderAddress(QuoteProviderAddress
                    .buildFromAddress(addressService
                            .findByProviderUniqueId(quote.getQuoteProvider().getUniqueId())));
            quoteMobileResponseDTO.updateQuoteImage(fileService, quote.getImagePath(), uploadBucket);
            response.add(quoteMobileResponseDTO);
        }
        return ResponseEntity.ok(response);

    }

    @GetMapping("company/{companyUniqueId}/{status}")
    @Secured({"ROLE_PROVIDER_ADMIN"})
    @Operation(summary = "Get all quotes by status for company ")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = QuoteDTO.class))))})
    public ResponseEntity<List<QuoteDTO>> getCompanyOrderByStatus(
            @PathVariable("status") QuoteStatus status,
            @PathVariable("companyUniqueId") String companyUniqueId) {
        List<QuoteDTO> response = new ArrayList<>();
        for (Quote quote : service.getQuoteByQuoteCompanyUniqueIdAndStatus(companyUniqueId, status)) {
            QuoteDTO quoteDTO = QuoteDTO.buildFromQuote(quote);
            quoteDTO.setProviderAddress(QuoteProviderAddress
                    .buildFromAddress(addressService
                            .findByProviderUniqueId(quote.getQuoteProvider().getUniqueId())));
            response.add(quoteDTO);
        }
        return ResponseEntity.ok(response);
    }


    @PostMapping("mobile/pageable-orders/{status}")
    @Secured({"ROLE_SUPERADMIN", "ROLE_PROVIDER_ADMIN"})
    @Operation(summary = "Load History Orders list as pageable")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = PageableQuoteResponse.class)))})
    public ResponseEntity<PageableQuoteMobileResponse> findPageableAllByStatusMobile(
            @RequestBody QuoteFilterRequestPayload filterRequestPayload,
            @PathVariable("status") String status) {
        PageableQuoteMobileResponse pageableLeadsResponse = service
                .findPageableAllByStatusMobile(pageableQuoteFilterRequestHelper
                        .buildPageableFilterRequest(filterRequestPayload, status));
        return ResponseEntity.ok(pageableLeadsResponse);
    }

    @PostMapping("/pageable-orders/{status}")
    @Secured({"ROLE_SUPERADMIN", "ROLE_PROVIDER_ADMIN","ROLE_PROVIDER_EMPLOYEE"})
    @Operation(summary = "Load History Orders list as pageable")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = PageableQuoteResponse.class)))})
    public ResponseEntity<PageableQuoteResponse> findPageableAllByStatus(
            @RequestBody QuoteFilterRequestPayload filterRequestPayload,
            @PathVariable("status") String status) {
        PageableQuoteResponse pageableLeadsResponse = service
                .findPageableAllByStatus(pageableQuoteFilterRequestHelper
                        .buildPageableFilterRequest(filterRequestPayload, status));
        return ResponseEntity.ok(pageableLeadsResponse);
    }
}

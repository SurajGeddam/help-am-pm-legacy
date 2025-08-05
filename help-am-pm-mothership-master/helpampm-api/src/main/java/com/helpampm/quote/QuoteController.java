/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote;

import com.helpampm.address.AddressService;
import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.services.AuthenticationService;
import com.helpampm.common.GeneralResponse;
import com.helpampm.common.QuoteAcceptedResponse;
import com.helpampm.common.StringUtils;
import com.helpampm.common.services.FileService;
import com.helpampm.customer.Customer;
import com.helpampm.customer.CustomerService;
import com.helpampm.quote.dto.*;
import com.helpampm.quote.quoteitems.QuoteItem;
import com.helpampm.quote.quoteproviders.QuoteProviderAddress;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.*;

import java.time.LocalTime;
import java.util.Objects;


@SuppressFBWarnings("EI_EXPOSE_REP")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("quote")
@Tag(name = "Quote Management: Write", description = "All write operations on quote: A Quote will " +
        "convert to and Invoice once it is paid.")
/*
  @author kuldeep
 */
public class QuoteController {
    private final QuoteService service;
    private final AddressService addressService;
    private final FileService fileService;
    private final CustomerService customerService;
    private final AuthenticationService authenticationService;

    @Value("${aws.s3.profile-photos}")
    private String profileBucket;


    @PostMapping("")
    @Secured({"ROLE_CUSTOMER", "ROLE_SUPERADMIN"})
    @Operation(summary = "Create Quote: Customer submit his/her requirement")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = QuoteDTO.class)))})
    public ResponseEntity<GeneralResponse> create(@RequestBody QuoteDTO quoteDTO) {
        UserLoginDetails userLoginDetails = authenticationService.findLoggedInUser();
        Customer customer = customerService
                .findByCustomerUniqueId(userLoginDetails.getCustomerUniqueId());
        Quote quote = service.create(quoteDTO,customer);
        service.handleSendNewOrderNotification(customer, quote, quoteDTO.isScheduled());
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Order created successfully").build());
    }

    @PutMapping("{quoteUniqueId}/cancel")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE",
            "ROLE_CUSTOMER"})
    @Operation(summary = "Cancel order by quoteUniqueId")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = QuoteDTO.class)))})
    public ResponseEntity<GeneralResponse> cancelOrder(@PathVariable("quoteUniqueId") String quoteUniqueId) {
        Quote quote = service.cancelQuote(quoteUniqueId);
        QuoteDTO quoteDTO = QuoteDTO.buildFromQuote(quote);
        if (Objects.nonNull(quote.getQuoteProvider())) {
            quoteDTO.setProviderAddress(QuoteProviderAddress
                    .buildFromAddress(addressService
                            .findByProviderUniqueId(quote.getQuoteProvider().getUniqueId())));
        }
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Order cancelled successfully").build());
    }

    @PutMapping("{quoteUniqueId}/{providerUniqueId}/{eta}/confirm")
    @Secured({"ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE"})
    @Operation(summary = "Accept order by providerUniqueId")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = QuoteDTO.class)))})
    public ResponseEntity<QuoteAcceptedResponse> confirmQuote(@PathVariable("quoteUniqueId") String quoteUniqueId,
                                                              @PathVariable("providerUniqueId") String providerUniqueId,
                                                              @PathVariable("eta") String etaString) {
        LocalTime eta = LocalTime.parse(etaString);
        QuoteAcceptedResponse.QuoteAcceptedResponseBuilder acceptedResponse = QuoteAcceptedResponse.builder();
        Quote quote = service.confirmQuote(quoteUniqueId, providerUniqueId, eta);
        if (!StringUtils.isNullOrEmpty(quote.getQuoteProvider().getProviderImage())) {
            acceptedResponse.withProfileImage(fileService.downloadAsBytes(quote.getQuoteProvider().getProviderImage(), profileBucket));
        }
        return ResponseEntity.ok(acceptedResponse.withStatus(HttpStatus.OK.value()).withMessage("Order Confirm successfully").build());
    }

    @PutMapping("{quoteUniqueId}/{providerUniqueId}/start-work")
    @Secured({"ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE"})
    @Operation(summary = "Start work at Customer's place")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = StartWorkResponse.class)))})
    public ResponseEntity<GeneralResponse> startWork(@PathVariable("quoteUniqueId") String quoteUniqueId,
                                                     @PathVariable("providerUniqueId") String providerUniqueId,
                                                     @RequestBody StartWorkPayload startWorkPayload) {
        StartWorkResponse workResponse = service.startWork(quoteUniqueId, providerUniqueId, startWorkPayload);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage(workResponse.getMessage()).build());
    }

    @PutMapping("{quoteUniqueId}/{providerUniqueId}/add-quote-item")
    @Secured({"ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE"})
    @Operation(summary = "Add new item to quote for additional work or material used.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = QuoteItemResponse.class)))})
    public ResponseEntity<QuoteItemResponse> addQuoteItem(@PathVariable("quoteUniqueId") String quoteUniqueId,
                                                          @PathVariable("providerUniqueId") String providerUniqueId,
                                                          @RequestBody QuoteItem quoteItem) {
        return ResponseEntity.ok(service.addQuoteItem(quoteUniqueId, providerUniqueId, quoteItem));
    }

    @PutMapping("{quoteUniqueId}/{providerUniqueId}/{itemId}/remove-quote-item")
    @Secured({"ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE"})
    @Operation(summary = "remove item from quote ")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = QuoteItemResponse.class)))})
    public ResponseEntity<QuoteItemResponse> removeQuoteItem(@PathVariable("quoteUniqueId") String quoteUniqueId,
                                                             @PathVariable("providerUniqueId") String providerUniqueId,
                                                             @PathVariable("itemId") long itemId) {
        return ResponseEntity.ok(service.removeQuoteItem(quoteUniqueId, providerUniqueId, itemId));
    }

    @PutMapping("{quoteUniqueId}/{providerUniqueId}/complete")
    @Secured({"ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE"})
    @Operation(summary = "Mark order complete, automatically raise invoice to customer.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = CompleteQuoteResponse.class)))})
    public ResponseEntity<GeneralResponse> completeOrder(@PathVariable("quoteUniqueId") String quoteUniqueId,
                                                         @PathVariable("providerUniqueId") String providerUniqueId) {
        CompleteQuoteResponse completeQuoteResponse = service.completeOrder(quoteUniqueId, providerUniqueId);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage(completeQuoteResponse.getMessage()).build());
    }
}

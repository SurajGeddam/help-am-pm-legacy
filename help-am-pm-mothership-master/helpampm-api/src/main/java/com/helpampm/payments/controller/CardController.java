/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.payments.controller;

import com.helpampm.customer.Customer;
import com.helpampm.payments.card.Card;
import com.helpampm.payments.card.CardDeleteResponse;
import com.helpampm.payments.card.CardService;
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
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * @author kuldeep
 */
@SuppressFBWarnings("EI_EXPOSE_REP2")
@RestController
@RequestMapping("payment/card")
@Slf4j
@RequiredArgsConstructor
@Tag(name = "Payment Card Management")
public class CardController {
    private final CardService service;

    @Secured({"ROLE_CUSTOMER"})
    @Operation(summary = "Add card")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Card.class)))})
    @PostMapping
    public ResponseEntity<Card> create(@RequestBody Card card) {
        return ResponseEntity.ok(service.create(card));
    }

    @Secured({"ROLE_CUSTOMER"})
    @Operation(summary = "Remove card")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = CardDeleteResponse.class)))})
    @DeleteMapping("{id}")
    public ResponseEntity<CardDeleteResponse> remove(Long id) {
        service.remove(id);
        return ResponseEntity.ok(new CardDeleteResponse("Card deleted", HttpStatus.OK.value()));
    }

    @Secured({"ROLE_CUSTOMER"})
    @Operation(summary = "List cards")
    @GetMapping("{customerUniqueId}")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = Customer.class))))})
    public ResponseEntity<List<Card>> get(String customerUniqueId) {
        return ResponseEntity.ok(service.getByCustomerUniqueId(customerUniqueId));
    }
}

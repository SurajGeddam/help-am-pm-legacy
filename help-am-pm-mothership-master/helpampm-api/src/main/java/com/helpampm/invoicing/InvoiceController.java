/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.invoicing;

import com.helpampm.quote.QuoteReadOnlyService;
import io.swagger.v3.oas.annotations.Operation;
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
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.io.IOException;
import java.util.Base64;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("invoice")
@Tag(name = "Invoice Management")
/*
  @author kuldeep
 */
public class InvoiceController {
    private final InvoiceService invoiceService;
    private final QuoteReadOnlyService quoteReadOnlyService;

    @GetMapping("{orderUniqueId}")
    @Operation(summary = "Generate invoice after work done by provider")
    @Secured({"ROLE_PROVIDER_ADMIN", "ROLE_PROVIDER_EMPLOYEE"})
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Invoice.class)))})
    public ResponseEntity<Invoice> generateInvoice(@PathVariable("orderUniqueId") String orderUniqueId) {
        return ResponseEntity.ok(invoiceService.create(quoteReadOnlyService
                .findByQuoteUniqueId(orderUniqueId)));
    }

    @GetMapping("generateinvoice/{quoteUniqueId}")
    @Operation(summary = "Generate invoice pdf")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation")})
    public byte[] generateInvoicePdf(@PathVariable("quoteUniqueId") String quoteUniqueId) throws IOException {
        byte[] generatedFile = invoiceService.generateInvoicePdf(quoteUniqueId);
        return Base64.getEncoder().encode(generatedFile);
    }
}

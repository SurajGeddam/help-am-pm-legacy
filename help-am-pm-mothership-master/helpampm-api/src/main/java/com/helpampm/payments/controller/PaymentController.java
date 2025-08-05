package com.helpampm.payments.controller;

import com.helpampm.notifications.dtos.NotificationDto;
import com.helpampm.notifications.entities.Notification;
import com.helpampm.notifications.enums.NotificationType;
import com.helpampm.payments.Payment;
import com.helpampm.payments.PaymentResponse;
import com.helpampm.payments.PaymentService;
import com.helpampm.provider.ProviderService;
import com.helpampm.quote.Quote;
import com.stripe.model.PaymentIntent;
import com.stripe.model.Transfer;
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
import java.util.stream.Collectors;


@SuppressFBWarnings("EI_EXPOSE_REP")
@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("payment")
@Tag(name = "Payment Controller", description = "All payments options.")
public class PaymentController {
    private final PaymentService service;
    private final ProviderService providerService;

    @GetMapping("")
    @Secured({"ROLE_SUPERADMIN", "ROLE_PROVIDER_ADMIN","ROLE_PROVIDER_EMPLOYEE"})
    @Operation(summary = "return all payments")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = PaymentIntent.class))))})

    public ResponseEntity<List<Payment>> getAllPayments() {
        return ResponseEntity.ok(service.getAllPayments());
    }

    @GetMapping("create-intent/{quoteUniqueId}")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE",
            "ROLE_CUSTOMER"})
    @Operation(summary = "Create and return payment Intent")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = PaymentIntent.class))))})

    public ResponseEntity<String> createIntent(@PathVariable("quoteUniqueId") String quoteUniqueId) {
        return ResponseEntity.ok(service.createPaymentIntent(quoteUniqueId));
    }


    @PutMapping("add/{quoteUniqueId}/{paymentIntentId}")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE",
            "ROLE_CUSTOMER"})
    @Operation(summary = "Create and return payment Intent")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = PaymentIntent.class))))})

    public ResponseEntity<PaymentResponse> addPaymentInformation(@PathVariable("quoteUniqueId") String quoteUniqueId,
                                                                 @PathVariable("paymentIntentId") String paymentIntentId) {

        Quote quote = service.addPaymentInformation(quoteUniqueId, paymentIntentId);
        return ResponseEntity.ok(PaymentResponse.builder().withStatus(HttpStatus.OK.value())
                .withMessage("Payment Confirm successfully")
                .withTransactionNumber(quote.getPayment().getPaymentId()).build());
    }

    @GetMapping("transfers")
    @Operation(summary = "Get all transfers")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Notification.class)))})
    public ResponseEntity<List<Transfer>> findByUsername(@PathVariable("username") String username) {
        List<Transfer> transferList = service.fetchAllTransfers();
        return ResponseEntity.ok(transferList);
    }

    @GetMapping("transfers/{id}")
    @Operation(summary = "Get transfers detail")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Notification.class)))})
    public ResponseEntity<Transfer> findTransferDetails(@PathVariable("id") String id) {
        Transfer transfer = service.fetchTransferDetails(id);
        return ResponseEntity.ok(transfer);
    }

}
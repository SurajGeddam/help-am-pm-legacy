/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.payments;

import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity
@Table(name = "tb_payments")
@Data
/*
  @author kuldeep
 */
public class Payment implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;
    @Column(name = "status")
    @Enumerated(EnumType.STRING)
    private PaymentStatus status;
    @Column(name = "create_at")
    private LocalDateTime createdAt;
    //Stripe payment data
    @Column(name = "stipe_payment_status")
    private String paymentStatus;
    @Column(name = "stipe_payment_id")
    private String paymentId;
    @Column(name = "confirmation_method")
    private String confirmationMethod;

    @Column(name = "currency")
    private String currency;
    @Column(name = "amount")
    private Long totalAmount;
    @Column(name = "payment_method")
    private String paymentMethod;

    @Column(name = "provider_amount")
    private long providerAmount;
    @Column(name = "stripe_accountId")
    private String stripeAccountId;
    @Column(name = "quote_unique_id")
    private String quoteUniqueId;
    @Column(name = "provider_unique_id")
    private String providerUniqueId;

    @Column(name = "transfer_destination")
    private String transferDestination;
    @Column(name = "amount_payout")
    private double payoutAmount;
    @Column(name = "amount_received")
    private double amountReceived;
    @Column(name = "application_fee_amount")
    private double applicationFeeAmount;
    @Column(name = "canceled_at")
    private long canceledAt;
    @Column(name = "cancellation_reason")
    private String cancellationReason;
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.payments;

import com.helpampm.notifications.entities.Notification;
import com.helpampm.quote.Quote;
import com.stripe.model.Transfer;

import java.util.List;

/**
 * @author kuldeep
 */
public interface PaymentService {

    List<Payment> getAllPayments();
    String createPaymentIntent(String orderUniqueId);

    Quote addPaymentInformation(String quoteUniqueId, String paymentIntentId);

    List<Transfer> fetchAllTransfers();

    Transfer fetchTransferDetails(String id);
}

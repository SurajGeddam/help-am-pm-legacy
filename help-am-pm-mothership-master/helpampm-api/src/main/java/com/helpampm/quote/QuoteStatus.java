/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote;

/**
 * @author kuldeep
 *
 */
public enum QuoteStatus {
    SCHEDULED, // New order (Scheduled for future or now)
    ACCEPTED_BY_PROVIDER, // Provider assigned to order
    STARTED, //Provider work started
    PAYMENT_DONE, // Payment by customer
    PAYMENT_PENDING, //Provider raise invoice
    ORDER_CANCELLED, // Order cancelled
}

// customer orderHistory -- > PAYMENT_DONE,ORDER_CANCELLED,PAYMENT_PENDING
// Provider orderHistory -- > PAYMENT_DONE,ORDER_CANCELLED,PAYMENT_PENDING
// Customer OngoingOrder -- > STARTED
// Provider OngoingOrder -- > STARTED
// customer Scheduled Order --> SCHEDULED,ACCEPTED_BY_PROVIDER
// provider Scheduled Order --> SCHEDULED,ACCEPTED_BY_PROVIDER
// provider new Order --> SCHEDULED


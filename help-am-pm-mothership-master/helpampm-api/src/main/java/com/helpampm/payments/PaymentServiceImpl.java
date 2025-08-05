/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.payments;

import com.google.gson.Gson;
import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.services.AuthenticationService;
import com.helpampm.common.HelpConstants;
import com.helpampm.metadata.commission.CommissionService;
import com.helpampm.notifications.entities.Notification;
import com.helpampm.provider.Provider;
import com.helpampm.provider.ProviderService;
import com.helpampm.provider.ProviderStripeAccountHelper;
import com.helpampm.quote.Quote;
import com.helpampm.quote.QuoteNotificationService;
import com.helpampm.quote.QuoteRepository;
import com.helpampm.quote.QuoteStatus;
import com.stripe.exception.StripeException;
import com.stripe.model.PaymentIntent;
import com.stripe.model.Transfer;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.List;

@Service
@Slf4j
@RequiredArgsConstructor
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
@Transactional
public class PaymentServiceImpl implements PaymentService {
    private final QuoteRepository quoteRepository;
    private final AuthenticationService authenticationService;

    private final QuoteNotificationService quoteNotificationService;
    private final ProviderStripeAccountHelper providerStripeAccountHelper;
    private final CommissionService commissionService;
    private final ProviderService providerService;
    private final PaymentRepository paymentRepository;


    @Value("${stripe.secretKey}")
    private String secretKey;
    private static final Gson gson = new Gson();

    @Override
    public List<Payment> getAllPayments() {
        UserLoginDetails userLoginDetails = authenticationService.findLoggedInUser();
        if (userLoginDetails.isSuperAdmin()) {
            return paymentRepository.findAll();
        }
        return paymentRepository.findAllByProviderUniqueId(userLoginDetails.getProviderUniqueId());
    }

    @Override
    public String createPaymentIntent(String orderUniqueId) {
        Quote quote = quoteRepository.findByQuoteUniqueId(orderUniqueId);
        Provider provider = providerService.findByProviderUniqueId(quote.getQuoteProvider().getUniqueId());
        long totalAmount = calculateOrderAmount(quote.getInvoice().getTotalPrice());
        return providerStripeAccountHelper.createPaymentIntent(totalAmount,
                quote,
                provider
        );
    }

    @Override
    public Quote addPaymentInformation(String quoteUniqueId, String paymentIntentId) {
        Quote quote = quoteRepository.findByQuoteUniqueId(quoteUniqueId);
        try {
            PaymentIntent customerPayment = PaymentIntent.retrieve(paymentIntentId);
            Payment payment = new Payment();
            payment.setPaymentId(paymentIntentId);
            payment.setPaymentStatus(customerPayment.getStatus());
            payment.setPaymentMethod(providerStripeAccountHelper.retrievePaymentMethod(customerPayment.getPaymentMethod()).getType());
            payment.setConfirmationMethod(customerPayment.getConfirmationMethod());
            payment.setCurrency(customerPayment.getCurrency());
            payment.setCreatedAt(LocalDateTime.now());
            payment.setStripeAccountId(customerPayment.getTransferData().getDestination());
            payment.setQuoteUniqueId(quoteUniqueId);
            payment.setProviderUniqueId(quote.getQuoteProvider().getUniqueId());
            payment.setTransferDestination(customerPayment.getTransferData().getDestination());

            payment.setAmountReceived(customerPayment.getAmountReceived() / 100);
            payment.setPayoutAmount((customerPayment.getAmount() - customerPayment.getApplicationFeeAmount()) / 100);
            payment.setApplicationFeeAmount(customerPayment.getApplicationFeeAmount() / 100);

            if ("succeeded".equals(customerPayment.getStatus())) {
                quote.setStatus(QuoteStatus.PAYMENT_DONE);
                payment.setStatus(PaymentStatus.PAID);
            } else {
                // in case of not able to retrieve payment details
                quote.setStatus(QuoteStatus.PAYMENT_PENDING);
                payment.setStatus(PaymentStatus.PENDING);
            }
            long totalProviderAmount = customerPayment.getAmount() - customerPayment.getApplicationFeeAmount();
            payment.setProviderAmount(totalProviderAmount);
            payment.setTotalAmount(customerPayment.getAmount());
            quote.setPayment(payment);
            quote.setLastUpdatedAt(LocalDateTime.now());
            Quote saveQuote = quoteRepository.save(quote);
            quoteNotificationService.sendPaymentReceivedOrderNotifications(quote, customerPayment.getAmount());
            return saveQuote;

        } catch (StripeException e) {
            log.error("Error {}", e.getMessage());
            throw new PaymentException("Error is finalizing payment");
        }
    }

    @Override
    public List<Transfer> fetchAllTransfers() {
        return providerStripeAccountHelper.fetchAllTransfers();
    }

    @Override
    public Transfer fetchTransferDetails(String id) {
        return providerStripeAccountHelper.fetchTransfer(id);
    }

    /**
     * We need to convert double amount into long value as per Stripe standard
     */
    static Long calculateOrderAmount(Double amount) {
        String amountDouble = HelpConstants.decimalFormat2Digit.format(amount);
        return (long) (Double.parseDouble(amountDouble) * 100);
    }
}

package com.helpampm.common.stripe;

import com.google.gson.Gson;
import com.helpampm.payments.PaymentException;
import com.stripe.Stripe;
import com.stripe.exception.*;
import com.stripe.model.*;
import com.stripe.param.CustomerCreateParams;
import com.stripe.param.PaymentIntentCreateParams;
import com.stripe.param.TransferCreateParams;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.Base64;
import java.util.HashMap;
import java.util.Map;


@Service
@Slf4j
@RequiredArgsConstructor
@SuppressFBWarnings({"EI_EXPOSE_REP", "ST_WRITE_TO_STATIC_FROM_INSTANCE_METHOD"})
public class StripeService {
    @Value("${stripe.secretKey}")
    private String secretKey;
    @Value("${stripe.returnUrl}")
    private String returnUrl;
    @Value("${stripe.refreshUrl}")
    private String refreshUrl;
    private static final Gson gson = new Gson();

    private void decodedStripeKey() {
        byte[] decodedBytes = Base64.getDecoder().decode(secretKey);
        Stripe.apiKey = new String(decodedBytes);
    }

    public Account retrieveAccount(String accountId) {
        decodedStripeKey();
        Account account;
        try {
            account = Account.retrieve(accountId);
        } catch (StripeException e) {
            throw new RuntimeException(e);
        }
        return account;
    }

    public String createPaymentIntent(PaymentIntentCreateParams paymentIntentCreateParams) {
        decodedStripeKey();
        PaymentIntent paymentIntent = null;
        try {
            paymentIntent = PaymentIntent.create(paymentIntentCreateParams);
            // Use Stripe's library to make requests...
        } catch (CardException e) {
            // Since it's a decline, CardException will be caught
            log.error("Status is: " + e.getCode());
            log.error("Message is: " + e.getMessage());
            throw new PaymentException("Since it's a decline, CardException");
        } catch (RateLimitException e) {
            log.error("Too many requests made to the API too quickly");
            throw new PaymentException(e.getMessage());
        } catch (InvalidRequestException e) {
            log.error("Invalid parameters were supplied to Stripe's API");
            throw new PaymentException(e.getMessage());
        } catch (AuthenticationException e) {
            log.error("YOU MIGHT HAVE CHANGED YOUR API KEY ,Authentication with Stripe's API failed");
            throw new PaymentException(e.getMessage());
        } catch (StripeException e) {
            // Display a very generic error to the user, and maybe send
            // yourself an email
            throw new PaymentException(e.getMessage());
        } catch (Exception e) {
            log.error("");
            log.info(e.getMessage());
        }
        return gson.toJson(paymentIntent);
    }


    public Account updateAccount(Account account, Map<String, Object> accountUpdateParams) {
        Account updateAccount = null;
        try {
            // Use Stripe's library to make requests...
            updateAccount = account.update(accountUpdateParams);
        } catch (CardException e) {
            // Since it's a decline, CardException will be caught
            log.error("Status is: " + e.getCode());
            log.error("Message is: " + e.getMessage());
            throw new PaymentException("Since it's a decline, CardException");
        } catch (RateLimitException e) {
            log.error("Too many requests made to the API too quickly");
            throw new PaymentException(e.getMessage());
        } catch (InvalidRequestException e) {
            log.error("Invalid parameters were supplied to Stripe's API");
            throw new PaymentException(e.getMessage());
        } catch (AuthenticationException e) {
            log.error("YOU MIGHT HAVE CHANGED YOUR API KEY ,Authentication with Stripe's API failed");
            throw new PaymentException(e.getMessage());
        } catch (StripeException e) {
            // Display a very generic error to the user, and maybe send
            // yourself an email
            throw new PaymentException(e.getMessage());
        } catch (Exception e) {
            log.error(e.getMessage());
        }
        return updateAccount;
    }

    /**
     * Create User account
     * Required input email , country in map
     */
    public Account createStripeAccount(Map<String, Object> createAccountParams) {
        decodedStripeKey();
        Account account = null;
        try {
            // Use Stripe's library to make requests...
            account = Account.create(createAccountParams);

        } catch (CardException e) {
            // Since it's a decline, CardException will be caught
            log.error("Status is: " + e.getCode());
            log.error("Message is: " + e.getMessage());
            throw new PaymentException("Since it's a decline, CardException");
        } catch (RateLimitException e) {
            log.error("Too many requests made to the API too quickly");
            throw new PaymentException(e.getMessage());
        } catch (InvalidRequestException e) {
            log.error("Invalid parameters were supplied to Stripe's API");
            throw new PaymentException(e.getMessage());
        } catch (AuthenticationException e) {
            log.error("YOU MIGHT HAVE CHANGED YOUR API KEY ,Authentication with Stripe's API failed");
            throw new PaymentException(e.getMessage());
        } catch (StripeException e) {
            // Display a very generic error to the user, and maybe send
            // yourself an email
            throw new PaymentException(e.getMessage());
        } catch (Exception e) {
            log.error(e.getMessage());
        }
        return account;
    }


    public PaymentMethod retrievePaymentMethod(String paymentMethodId) {
        decodedStripeKey();
        PaymentMethod paymentMethod = null;
        try {
            // Use Stripe's library to make requests...
            paymentMethod = PaymentMethod.retrieve(paymentMethodId);
        } catch (StripeException e) {
            // Display a very generic error to the user, and maybe send
            // yourself an email
            throw new PaymentException(e.getMessage());
        } catch (Exception e) {
            log.error(e.getMessage());
        }
        return paymentMethod;
    }


    /**
     * Create account verification link for the provider to onboard
     */
    public AccountLink createAccountVerificationLink(String accountId,
                                                     String providerUniqueId,
                                                     String stripeSecretHash) {
        decodedStripeKey();
        Map<String, Object> accountLinkVerification = new HashMap<>();
        accountLinkVerification.put("account", accountId);
        StringBuilder stringBuilderRefresh = new StringBuilder(refreshUrl);
        StringBuilder stringBuilderReturn = new StringBuilder(returnUrl);

        String refreshUrl = createQueryParamsForUrl(accountId, providerUniqueId, stripeSecretHash, stringBuilderRefresh);
        String returnUrl = createQueryParamsForUrl(accountId, providerUniqueId, stripeSecretHash, stringBuilderReturn);

        accountLinkVerification.put(
                "refresh_url",
                refreshUrl
        );
        accountLinkVerification.put(
                "return_url",
                returnUrl);
        accountLinkVerification.put("type", "account_onboarding");
        AccountLink accountLink = null;
        try {
            // Use Stripe's library to make requests...
            accountLink = AccountLink.create(accountLinkVerification);
        } catch (CardException e) {
            // Since it's a decline, CardException will be caught
            log.error("Status is: " + e.getCode());
            log.error("Message is: " + e.getMessage());
            throw new PaymentException("Since it's a decline, CardException");
        } catch (RateLimitException e) {
            log.error("Too many requests made to the API too quickly");
            throw new PaymentException(e.getMessage());
        } catch (InvalidRequestException e) {
            log.error("Invalid parameters were supplied to Stripe's API");
            throw new PaymentException(e.getMessage());
        } catch (AuthenticationException e) {
            log.error("YOU MIGHT HAVE CHANGED YOUR API KEY ,Authentication with Stripe's API failed");
            throw new PaymentException(e.getMessage());
        } catch (StripeException e) {
            // Display a very generic error to the user, and maybe send
            // yourself an email
            throw new PaymentException(e.getMessage());
        } catch (Exception e) {
            log.error(e.getMessage());
        }
        return accountLink;
    }

    private static String createQueryParamsForUrl(String accountId, String providerUniqueId, String stripeSecretHash, StringBuilder stringBuilderRefresh) {
        return stringBuilderRefresh.append("?")
                .append("stripeAccountId=")
                .append(accountId).append("&")
                .append("providerUniqueId=")
                .append(providerUniqueId).append("&")
                .append("hash=")
                .append(stripeSecretHash).toString();
    }


    public TransferCollection fetchAllTransfers(Map<String, Object> params) {
        try {
            // Use Stripe's library to make requests...
            TransferCollection transfers = Transfer.list(params);
            return transfers;
        } catch (CardException e) {
            // Since it's a decline, CardException will be caught
            log.error("Status is: " + e.getCode());
            log.error("Message is: " + e.getMessage());
            throw new PaymentException("Since it's a decline, CardException");
        } catch (RateLimitException e) {
            log.error("Too many requests made to the API too quickly");
            throw new PaymentException(e.getMessage());
        } catch (InvalidRequestException e) {
            log.error("Invalid parameters were supplied to Stripe's API");
            throw new PaymentException(e.getMessage());
        } catch (AuthenticationException e) {
            log.error("YOU MIGHT HAVE CHANGED YOUR API KEY ,Authentication with Stripe's API failed");
            throw new PaymentException(e.getMessage());
        } catch (StripeException e) {
            // Display a very generic error to the user, and maybe send
            // yourself an email
            throw new PaymentException(e.getMessage());
        } catch (Exception e) {
            log.error(e.getMessage());
        }
        return null;
    }

    public Transfer fetchTransferById(String id) {
        try {
            return Transfer.retrieve(id);
        } catch (CardException e) {
            // Since it's a decline, CardException will be caught
            log.error("Status is: " + e.getCode());
            log.error("Message is: " + e.getMessage());
            throw new PaymentException("Since it's a decline, CardException");
        } catch (RateLimitException e) {
            log.error("Too many requests made to the API too quickly");
            throw new PaymentException(e.getMessage());
        } catch (InvalidRequestException e) {
            log.error("Invalid parameters were supplied to Stripe's API");
            throw new PaymentException(e.getMessage());
        } catch (AuthenticationException e) {
            log.error("YOU MIGHT HAVE CHANGED YOUR API KEY ,Authentication with Stripe's API failed");
            throw new PaymentException(e.getMessage());
        } catch (StripeException e) {
            // Display a very generic error to the user, and maybe send
            // yourself an email
            throw new PaymentException(e.getMessage());
        } catch (Exception e) {
            log.error(e.getMessage());
        }
        return null;
    }


    public com.stripe.model.Customer createCustomer(CustomerCreateParams customerCreateParams) {
        decodedStripeKey();
        com.stripe.model.Customer customer = null;
        try {
            // Use Stripe's library to make requests...
            customer = Customer.create(customerCreateParams);
        } catch (CardException e) {
            // Since it's a decline, CardException will be caught
            log.error("Status is: " + e.getCode());
            log.error("Message is: " + e.getMessage());
            throw new PaymentException("Since it's a decline, CardException");
        } catch (RateLimitException e) {
            log.error("Too many requests made to the API too quickly");
            throw new PaymentException(e.getMessage());
        } catch (InvalidRequestException e) {
            log.error("Invalid parameters were supplied to Stripe's API");
            throw new PaymentException(e.getMessage());
        } catch (AuthenticationException e) {
            log.error("YOU MIGHT HAVE CHANGED YOUR API KEY ,Authentication with Stripe's API failed");
            throw new PaymentException(e.getMessage());
        } catch (StripeException e) {
            // Display a very generic error to the user, and maybe send
            // yourself an email
            throw new PaymentException(e.getMessage());
        } catch (Exception e) {
            log.error(e.getMessage());
        }
        return customer;
    }

    public ExternalAccount createBankAccount(Account account, Map<String, Object> bankParms) {
        ExternalAccount bankAccountExternal = null;
        try {
            // Use Stripe's library to make requests...
            bankAccountExternal = account.getExternalAccounts()
                    .create(bankParms);
        } catch (CardException e) {
            // Since it's a decline, CardException will be caught
            log.error("Status is: " + e.getCode());
            log.error("Message is: " + e.getMessage());
            throw new PaymentException("Since it's a decline, CardException");
        } catch (RateLimitException e) {
            log.error("Too many requests made to the API too quickly");
            throw new PaymentException(e.getMessage());
        } catch (InvalidRequestException e) {
            log.error("Invalid parameters were supplied to Stripe's API");
            throw new PaymentException(e.getMessage());
        } catch (AuthenticationException e) {
            log.error("YOU MIGHT HAVE CHANGED YOUR API KEY ,Authentication with Stripe's API failed");
            throw new PaymentException(e.getMessage());
        } catch (StripeException e) {
            // Display a very generic error to the user, and maybe send
            // yourself an email
            throw new PaymentException(e.getMessage());
        } catch (Exception e) {
            log.error(e.getMessage());
        }
        return bankAccountExternal;
    }

    /**
     * Transfer and distribute money to providers and HELP
     */
    public Transfer transferToProvider(long amount, String destinationAccountId, String orderUniqueId) {
        Stripe.apiKey = secretKey;
        Transfer account = null;
        try {

            TransferCreateParams params =
                    TransferCreateParams.builder()
                            .setAmount(amount)
                            .setCurrency("usd")
                            .setDestination(destinationAccountId)
                            .setTransferGroup(orderUniqueId)
                            .build();

            Transfer transfer = Transfer.create(params);
            log.info("Transfer {}", transfer);

        } catch (CardException e) {
            // Since it's a decline, CardException will be caught
            log.error("Status is: " + e.getCode());
            log.error("Message is: " + e.getMessage());
            throw new PaymentException("Since it's a decline, CardException");
        } catch (RateLimitException e) {
            log.error("Too many requests made to the API too quickly");
            throw new PaymentException(e.getMessage());
        } catch (InvalidRequestException e) {
            log.error("Invalid parameters were supplied to Stripe's API");
            throw new PaymentException(e.getMessage());
        } catch (AuthenticationException e) {
            log.error("YOU MIGHT HAVE CHANGED YOUR API KEY ,Authentication with Stripe's API failed");
            throw new PaymentException(e.getMessage());
        } catch (StripeException e) {
            // Display a very generic error to the user, and maybe send
            // yourself an email
            throw new PaymentException(e.getMessage());
        } catch (Exception e) {
            log.error(e.getMessage());
        }
        return account;
    }

    public PaymentIntent retrivePayment(String intentId) {
        decodedStripeKey();
        PaymentIntent paymentIntent;
        try {
            paymentIntent = PaymentIntent.retrieve(intentId);
        } catch (StripeException e) {
            throw new RuntimeException(e);
        }
        return paymentIntent;
    }

}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote;

import com.helpampm.common.StringUtils;
import com.helpampm.customer.Customer;
import com.helpampm.customer.CustomerService;
import com.helpampm.notifications.email.EmailNotificationMessage;
import com.helpampm.notifications.email.EmailNotificationService;
import com.helpampm.notifications.push.PushNotificationMessage;
import com.helpampm.notifications.push.PushNotificationService;
import com.helpampm.notifications.sms.SMSNotificationMessage;
import com.helpampm.notifications.sms.SMSNotificationService;
import com.helpampm.provider.Provider;
import com.helpampm.provider.ProviderService;
import com.helpampm.provider.dto.ProviderSearchResponseDto;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

@Service
@Slf4j
@RequiredArgsConstructor
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class QuoteNotificationService {
    private static final String ORDER_CANCELLED_NOTIFICATION_SUBJECT = "Order Cancelled";
    private static final String ORDER_ACCEPTED_NOTIFICATION_SUBJECT = "Order Accepted";
    private static final String ORDER_STARTED_NOTIFICATION_SUBJECT = "Order Started";

    private static final String NEW_ORDER_RECEIVED_NOTIFICATION_SUBJECT = "Order Received";
    private static final String NEW_ORDER_CREATED_NOTIFICATION_SUBJECT = "Order Created";

    private static final String PAYMENT_RECEIVED_NOTIFICATION_SUBJECT = "Payment Received";
    private final EmailNotificationService emailNotificationService;
    private final SMSNotificationService smsNotificationService;
    private final PushNotificationService pushNotificationService;
    private final ProviderService providerService;
    private final CustomerService customerService;
    @Value("${customers.search.radius}")
    private Double searchRadius;
    @Value("${notifications.email.create-order-provider-template-name}")
    private String newOrderProviderNotificationEmailTemplate;
    @Value("${notifications.email.create-order-customer-template-name}")
    private String newOrderCustomerNotificationEmailTemplate;
    @Value("${notifications.email.provider-cancel-order-template-name}")
    private String providerCancelOrderNotificationEmailTemplate;
    @Value("${notifications.email.customer-cancel-order-template-name}")
    private String customerCancelOrderNotificationEmailTemplate;

    @Value("${notifications.email.customer-order-accepted-template-name}")
    private String customerOrderAcceptedNotificationEmailTemplate;
    @Value("${help.hvac-image}")
    private String hvacimage;
    @Value("${help.electrical-image}")
    private String electricalImage;
    @Value("${help.locksmith-image}")
    private String locksmithimage;
    @Value("${help.plumbing-image}")
    private String plumbingimage;

    @Value("${notifications.email.payment-received-notify-customer}")
    private String paymentReceivedNotificationEmailTemplate;


    public void sendNewOrderNotification(Quote quote,
                                         Customer customer, List<ProviderSearchResponseDto> providersInRange) {
        providersInRange.parallelStream().forEach(providerDto -> sendNotificationsToProvidersInRange(quote, providerDto));
        sendNotificationsToCustomerForNewOrder(quote, customer);
    }

    private void sendNotificationsToProvidersInRange(Quote quote, ProviderSearchResponseDto providerDto) {
        Map<String, Map<String, Object>> notificationProperties = new HashMap<>();

        try {
            if (providerDto.isPushNotification()) {
                Map<String, Object> pushMap = new HashMap<>();
                pushMap.put("body", "You have received a new Order!");
                pushMap.put("title", "New Order");
                notificationProperties.put("push", pushMap);

                sendPushNotification(NEW_ORDER_RECEIVED_NOTIFICATION_SUBJECT, providerDto.getUsername(), quote.getStatus().name(),
                        quote.getQuoteUniqueId(), notificationProperties);
            }
        } catch (Exception e) {
            log.warn("Push notification failed." + e.getMessage());
        }
        try {
            if (providerDto.isSmsNotification()) {
                String message = "You have received a new Order #id " + quote.getQuoteUniqueId();
                sendSmsNotification(message, StringUtils.capitalize(providerDto.getName()),
                        NEW_ORDER_RECEIVED_NOTIFICATION_SUBJECT, providerDto.getPhone(),
                        providerDto.getUsername());
            }
        } catch (Exception e) {
            log.warn("SMS notification failed." + e.getMessage());
        }
        try {
            if (providerDto.isEmailNotification()) {
                Map<String, Object> emailMap = new HashMap<>();
                emailMap.put("body", "You have received a new Order!");
                notificationProperties.put("email", emailMap);
                sendEmailNotification(newOrderProviderNotificationEmailTemplate,
                        StringUtils.capitalize(providerDto.getName()),
                        NEW_ORDER_RECEIVED_NOTIFICATION_SUBJECT, providerDto.getEmail(),
                        notificationProperties);
            }
        } catch (Exception e) {
            log.warn("Email notification failed." + e.getMessage());
        }
    }

    private void sendNotificationsToCustomerForNewOrder(Quote quote, Customer customer) {
        Map<String, Map<String, Object>> notificationProperties = new HashMap<>();


        if (customer.isPushNotificationEnabled()) {
            Map<String, Object> pushMap = new HashMap<>();
            pushMap.put("body", "Congratulations, Your Order has been created!");
            pushMap.put("title", "Congratulations, Your Order has been created!");
            notificationProperties.put("push", pushMap);
            sendPushNotification(NEW_ORDER_CREATED_NOTIFICATION_SUBJECT,
                    customer.getUserLoginDetails().getUsername(), quote.getStatus().name(), quote.getQuoteUniqueId(), notificationProperties);
        }
        if (customer.isSmsNotificationEnabled()) {
            String message = "Congratulations, Your Order has been created, Order Id is - "
                    + quote.getQuoteUniqueId();
            sendSmsNotification(message, StringUtils.capitalize(customer.getFirstName()) +
                            " " + StringUtils.capitalize(customer.getFirstName()),
                    NEW_ORDER_CREATED_NOTIFICATION_SUBJECT, customer.getPhone(),
                    customer.getUserLoginDetails().getUsername());
        }
        if (customer.isEmailNotificationEnabled()) {
            Map<String, Object> emailMap = new HashMap<>();
            emailMap.put("name", customer.getFirstName());
            emailMap.put("orderId", quote.getQuoteUniqueId());
            //define image
            if ("HVAC".equals(quote.getCategoryName())) {
                emailMap.put("providerGenericImage", hvacimage);
            } else if ("ELECTRICAL".equals(quote.getCategoryName())) {
                emailMap.put("providerGenericImage", electricalImage);
            } else if ("LOCKSMITH".equals(quote.getCategoryName())) {
                emailMap.put("providerGenericImage", locksmithimage);
            } else if ("PLUMBING".equals(quote.getCategoryName())) {
                emailMap.put("providerGenericImage", plumbingimage);
            }


            notificationProperties.put("email", emailMap);
            sendEmailNotification(newOrderCustomerNotificationEmailTemplate,
                    StringUtils.capitalize(customer.getFirstName()) +
                            " " + StringUtils.capitalize(customer.getFirstName()),
                    NEW_ORDER_CREATED_NOTIFICATION_SUBJECT, customer.getEmail(), notificationProperties);
        }
    }

    public void sendWorkStartedByProviderNotifications(Quote quote) {
        Map<String, Object> pushMap = new HashMap<>();
        pushMap.put("body", "Service Provider Started work at your location");
        pushMap.put("title", "Service Started");
        Map<String, Object> emailMap = new HashMap<>();
        emailMap.put("body", "Service Provider Started work at your location");
        emailMap.put("name", quote.getQuoteCustomer().getCustomerName());
        emailMap.put("orderUniqueId", quote.getQuoteUniqueId());
        emailMap.put("category", quote.getCategoryName());


        Map<String, Map<String, Object>> notificationProperties = new HashMap<>();
        notificationProperties.put("push", pushMap);
        notificationProperties.put("email", emailMap);

        String message = "Service has been started by Provider for Order Id- "
                + quote.getQuoteUniqueId();

        sendNotificationsToCustomer(quote, ORDER_STARTED_NOTIFICATION_SUBJECT,
                customerOrderAcceptedNotificationEmailTemplate, notificationProperties, message);
    }

    public void sendOrderAcceptedByProviderNotifications(Quote quote) {
        Map<String, Object> pushMap = new HashMap<>();
        pushMap.put("body", "Congratulations, Your Order has been accepted by Provider!");
        pushMap.put("title", "Order Request Accepted");
        Map<String, Object> emailMap = new HashMap<>();
        emailMap.put("body", "Congratulations, Your Order has been accepted by Provider!");
        emailMap.put("name", quote.getQuoteCustomer().getCustomerName());
        emailMap.put("orderUniqueId", quote.getQuoteUniqueId());
        emailMap.put("category", quote.getCategoryName());


        Map<String, Map<String, Object>> notificationProperties = new HashMap<>();
        notificationProperties.put("push", pushMap);
        notificationProperties.put("email", emailMap);

        String message = "Congratulations, Your Order has been accepted by Provider for Order Id- "
                + quote.getQuoteUniqueId();
        sendNotificationsToCustomer(quote, ORDER_ACCEPTED_NOTIFICATION_SUBJECT,
                customerOrderAcceptedNotificationEmailTemplate, notificationProperties, message);
    }

    public void sendPaymentReceivedOrderNotifications(Quote quote, Long amount) {
        Map<String, Object> pushMap = new HashMap<>();
        pushMap.put("body", "Payment of $" + (amount / 100.00) + " has been received!");
        pushMap.put("title", "Order Payment Received");
        Map<String, Map<String, Object>> notificationProperties = new HashMap<>();
        notificationProperties.put("push", pushMap);

        String message = "Payment for the Order Id- " + quote.getQuoteUniqueId() + " has been received.";

        Map<String, Object> emailMap = new HashMap<>();
        emailMap.put("body", "Payment for the Order has been received!");
        emailMap.put("name", quote.getQuoteCustomer().getCustomerName());
        emailMap.put("orderUniqueId", quote.getQuoteUniqueId());
        emailMap.put("paymentAmount", quote.getTotalBill());
        notificationProperties.put("email", emailMap);

        sendNotificationsToProvider(quote, PAYMENT_RECEIVED_NOTIFICATION_SUBJECT,
                paymentReceivedNotificationEmailTemplate, notificationProperties, message);
    }

    public void sendCancelOrderNotifications(Quote quote) {
        Map<String, Object> pushMap = new HashMap<>();
        pushMap.put("body", "Your Order have been cancelled.");
        pushMap.put("title", "Order Cancelled");
        Map<String, Map<String, Object>> notificationProperties = new HashMap<>();
        notificationProperties.put("push", pushMap);

        String message = "Your Order have been cancelled, Order Id- "
                + quote.getQuoteUniqueId();

        Map<String, Object> emailMapProvider = new HashMap<>();
        emailMapProvider.put("body", "Your Order have been cancelled.");
        emailMapProvider.put("customerName", quote.getQuoteCustomer().getCustomerName());
        emailMapProvider.put("orderUniqueId", quote.getQuoteUniqueId());
        notificationProperties.put("email", emailMapProvider);

        sendNotificationsToProvider(quote, ORDER_CANCELLED_NOTIFICATION_SUBJECT,
                providerCancelOrderNotificationEmailTemplate, notificationProperties, message);

        Map<String, Object> emailMapCustomer = new HashMap<>();
        emailMapCustomer.put("body", "Your Order have been cancelled.");
        emailMapCustomer.put("name", quote.getQuoteCustomer().getCustomerName());
        emailMapCustomer.put("orderUniqueId", quote.getQuoteUniqueId());
        notificationProperties.put("email", emailMapCustomer);

        sendNotificationsToCustomer(quote, ORDER_CANCELLED_NOTIFICATION_SUBJECT,
                customerCancelOrderNotificationEmailTemplate, notificationProperties, message);
    }

    private void sendNotificationsToCustomer(Quote quote, String subject, String templateName,
                                             Map<String, Map<String, Object>> notificationProperties,
                                             String message) {
        if (Objects.nonNull(quote.getQuoteCustomer())) {
            Customer customer = customerService.findByCustomerUniqueId(quote.getQuoteCustomer().getUniqueId());
            if (customer.isEmailNotificationEnabled()) {
                sendEmailNotification(templateName,
                        quote.getQuoteCustomer().getCustomerName(),
                        subject, customer.getEmail(), notificationProperties);
            }
            if (customer.isSmsNotificationEnabled()) {
                sendSmsNotification(message, quote.getQuoteCustomer().getCustomerName(),
                        subject, customer.getPhone(), customer.getUserLoginDetails().getUsername());
            }
            if (customer.isPushNotificationEnabled()) {
                sendPushNotification(subject, customer.getUserLoginDetails().getUsername(),
                        quote.getStatus().name(), quote.getQuoteUniqueId(), notificationProperties);
            }
        }
    }

    private void sendNotificationsToProvider(Quote quote, String subject, String templateName,
                                             Map<String, Map<String, Object>> notificationProperties,
                                             String message) {
        if (Objects.nonNull(quote.getQuoteProvider())) {
            Provider provider = providerService.findByProviderUniqueId(quote.getQuoteProvider().getUniqueId());
            if (provider.isEmailNotificationEnabled()) {
                sendEmailNotification(templateName,
                        quote.getQuoteProvider().getProviderName(),
                        subject, provider.getEmail(), notificationProperties);
            }
            if (provider.isSmsNotificationEnabled()) {
                sendSmsNotification(message,
                        quote.getQuoteProvider().getProviderName(),
                        subject, provider.getPhone(), provider.getUserLoginDetails().getUsername());
            }
            if (provider.isPushNotificationEnabled()) {
                sendPushNotification(subject, provider.getUserLoginDetails().getUsername(), quote.getStatus().name(),
                        quote.getQuoteUniqueId(), notificationProperties);
            }
        }
    }

    public void sendPushNotification(String subject, String username, String quoteStatus,
                                     String quoteUniqueId, Map<String, Map<String, Object>> notificationProperties) {
        Map<String, Object> data = notificationProperties.get("push");
        data.put("quoteUniqueId", quoteUniqueId);
        PushNotificationMessage pushNotificationMessage = PushNotificationMessage.builder()
                .withData(data)
                .withBody(Objects.toString(notificationProperties.get("push").get("body")))
                .withTitle(subject)
                .withStatus(quoteStatus)
                .build();
        pushNotificationService.send(pushNotificationMessage, username);
    }

    public void sendSmsNotification(String message, String name, String subject, String phone,
                                    String username) {
        SMSNotificationMessage smsNotificationMessage = SMSNotificationMessage.builder()
                .withIsTransactional(true)
                .withMessage(message)
                .withRecipientName(name)
                .withSubject(subject)
                .build();
        smsNotificationService.send(smsNotificationMessage, phone, username);
    }

    public void sendEmailNotification(String templateName, String name,
                                      String subject, String recipient, Map<String,
            Map<String, Object>> notificationProperties) {
        EmailNotificationMessage emailNotificationMessage = EmailNotificationMessage.builder()
                .withSubject(subject)
                .withEmailTemplateName(templateName)
                .withRecipientName(name)
                .withRecipientEmail(recipient)
                .withModelData(notificationProperties.get("email"))
                .build();
        emailNotificationService.send(emailNotificationMessage, recipient);
    }
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.jobs;

import com.helpampm.address.Address;
import com.helpampm.common.StringUtils;
import com.helpampm.provider.Provider;
import com.helpampm.provider.ProviderException;
import com.helpampm.provider.ProviderRepository;
import com.helpampm.provider.categories.ProviderCategory;
import com.helpampm.provider.categories.ProviderCategoryRepository;
import com.helpampm.provider.helper.ProviderHelper;
import com.helpampm.quote.Quote;
import com.helpampm.quote.QuoteNotificationService;
import com.helpampm.quote.QuoteRepository;
import com.helpampm.quote.QuoteStatus;
import com.helpampm.quote.quoteaddress.QuoteAddress;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Predicate;
import java.util.stream.Collectors;

@Component
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class ScheduledOrderNotifications {
    private static final String NEW_ORDER_RECEIVED_NOTIFICATION_SUBJECT = "Order Received";
    private final QuoteRepository quoteRepository;
    private final ProviderRepository providerRepository;
    private final ProviderCategoryRepository providerCategoryRepository;
    private final ProviderHelper providerHelper;

    private final QuoteNotificationService quoteNotificationService;

    private static final int priorNotificationTime = 60; //min

    @Value("${customers.search.radius}")
    private Double searchRadius;
    @Value("${notifications.email.create-order-provider-template-name}")
    private String newOrderProviderNotificationEmailTemplate;


    // @Scheduled(cron = "0 0/30 * * * *") // Run every 30 mins
    @Scheduled(cron = "0 0/2 * * * *")
    public void sendNotificationsForScheduledOrders() {
        log.info("Executing " + this.getClass().getName());
        LocalDateTime startTime = LocalDateTime.now();
        LocalDateTime endTime = LocalDateTime.now().plus(30, ChronoUnit.MINUTES);
        List<Quote> scheduledQuotes = quoteRepository
                .findByScheduledTimeBetween(startTime, endTime)
                .stream().filter(q -> QuoteStatus.SCHEDULED.equals(q.getStatus()))
                .collect(Collectors.toList());
        log.info("Scheduled Quotes: " + scheduledQuotes.size());
        for(Quote quote : scheduledQuotes) {
            LocalDateTime now = LocalDateTime.now();
            LocalDateTime scheduledTime = quote.getScheduledTime();
            LocalDateTime notificationTime = scheduledTime.minusMinutes(priorNotificationTime);
            if(now.isAfter(notificationTime) || now.equals(notificationTime)) {
                log.info("Sending order received notification to provider");
                sendOrderNotifications(quote);
                log.info("Order received notification sent to provider");
            }
        }
    }

    public void sendOrderNotifications(Quote quote) {

        Set<String> providerIds;
        if(quote.getIsResidenceService()) {
            providerIds = providerCategoryRepository
                    .findByNameAndResidentialService(quote.getCategoryName(),
                            quote.getIsResidenceService()).stream()
                    .map(ProviderCategory::getProviderUniqueId)
                    .collect(Collectors.toSet());
        } else {
            providerIds = providerCategoryRepository
                    .findByNameAndCommercialService(quote.getCategoryName(), quote.getIsCommercialService()).stream()
                    .map(ProviderCategory::getProviderUniqueId)
                    .collect(Collectors.toSet());
        }

        List<Provider> providers = providerRepository.findAllByProviderUniqueIdIn(providerIds);
        if (providers.isEmpty()) {
            throw new ProviderException("No service provider available, " +
                    "please change your search radius or try again after some time. " +
                    "You can use our scheduling service and we will find a service provider for you.", HttpStatus.NOT_FOUND);
        }
        QuoteAddress address = quote.getQuoteCustomer().getQuoteAddress();
        Double latitude = address.getLatitude();
        Double longitude = address.getLongitude();
        Double altitude = address.getLatitude();

        providers.parallelStream().filter(getProviderPredicate(quote, latitude, longitude, altitude))
                .forEach(provider ->
                        sendQuoteCreateNotification(
                                quote.getQuoteUniqueId(),
                                provider.getUserLoginDetails().getUsername(),
                                quote.getStatus().name(),
                                provider.getName(),
                                provider.getPhone(),
                                provider.getEmail(),
                                provider.isPushNotificationEnabled(),
                                provider.isSmsNotificationEnabled(),
                                provider.isEmailNotificationEnabled())
                );
    }


    public void sendQuoteCreateNotification(String quoteUniqueId,
                                            String username,
                                            String quoteStatus,
                                            String providerName,
                                            String providerPhone,
                                            String providerEmail,
                                            boolean pushNotification,
                                            boolean smsNotification,
                                            boolean emailNotification) {

        Map<String, Map<String, Object>> notificationProperties = new HashMap<>();
        String message = "A new Order has been received, Order Id- " + quoteUniqueId;

        if (Boolean.TRUE.equals(pushNotification)) {
            Map<String, Object> pushMap = new HashMap<>();
            pushMap.put("body", "A new Order has been received!");
            notificationProperties.put("push", pushMap);
            quoteNotificationService.sendPushNotification(NEW_ORDER_RECEIVED_NOTIFICATION_SUBJECT,
                    username,quoteStatus, quoteUniqueId,notificationProperties);
        }
        if (Boolean.TRUE.equals(smsNotification)) {
            quoteNotificationService.sendSmsNotification(message,
                    StringUtils.capitalize(providerName),
                    NEW_ORDER_RECEIVED_NOTIFICATION_SUBJECT, providerPhone, username);
        }
        if (Boolean.TRUE.equals(emailNotification)) {
            Map<String, Object> emailMap = new HashMap<>();
            notificationProperties.put("email", emailMap);
            emailMap.put("body", "A new Order has been received!");
            quoteNotificationService.sendEmailNotification(newOrderProviderNotificationEmailTemplate,
                    StringUtils.capitalize(providerName),
                    NEW_ORDER_RECEIVED_NOTIFICATION_SUBJECT, providerEmail, notificationProperties);
        }
    }

    private Predicate<Provider> getProviderPredicate(Quote quote, Double latitude, Double longitude, Double altitude) {
        return provider -> {
            Address providerAddress = provider.getAddress();
            Double providerLatitude = providerAddress.getLatitude();
            Double providerLongitude = providerAddress.getLongitude();
            Double providerAltitude = providerAddress.getLatitude();
            double distance = providerHelper.calculateDistanceBetweenCustomerAndProvider(
                    latitude,
                    longitude,
                    altitude,
                    providerLatitude,
                    providerLongitude,
                    providerAltitude);
            return distance <= quote.getProviderSearchRadius();
        };
    }
}

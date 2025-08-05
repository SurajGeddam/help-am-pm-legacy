/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.setup;

import com.helpampm.customer.Customer;
import com.helpampm.customer.CustomerHelper;
import com.helpampm.customer.CustomerRepository;
import com.helpampm.provider.Provider;
import com.helpampm.provider.ProviderRepository;
import com.helpampm.quote.Quote;
import com.helpampm.quote.QuoteRepository;
import com.helpampm.quote.QuoteStatus;
import com.helpampm.auth.entities.UserLoginDetails;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Objects;

/**
 * @author kuldeep
 * 
 * Application initializer for development/testing purposes
 * This runs when the Spring Boot application starts up
 */
@Component
@Slf4j
public class TestDataInitialization implements ApplicationRunner {
    private final PasswordEncoder passwordEncoder;
    private final CustomerHelper customerHelper;
    private final CustomerRepository customerRepository;
    private final ProviderRepository providerRepository;
    private final QuoteRepository quoteRepository;

    @Autowired
    public TestDataInitialization(final PasswordEncoder passwordEncoder,
                                  final CustomerHelper customerHelper,
                                  final CustomerRepository customerRepository,
                                  final ProviderRepository providerRepository,
                                  final QuoteRepository quoteRepository) {
        this.passwordEncoder = passwordEncoder;
        this.customerHelper = customerHelper;
        this.customerRepository = customerRepository;
        this.providerRepository = providerRepository;
        this.quoteRepository = quoteRepository;
    }

    @Override
    public void run(ApplicationArguments args) throws Exception {
        log.info("Starting application data initialization...");
        
        // Initialize customer data
        Customer existingCustomer = customerRepository.findByEmail("mobile@test.com");
        if(Objects.isNull(existingCustomer)) {
            Customer customer = new Customer();
            customer.setIsActive(true);
            customer.setPhone("+9197867415");
            customer.setEmail("mobile@test.com");
            customer.setFirstName("Mobile");
            customer.setLastName("Inc.");
            customer.setAverageProviderRating(0.0);
            customer.setTotalProviderRatings(0L);
            customer.setEmailNotificationEnabled(true);
            customer.setPushNotificationEnabled(true);
            customer.setSmsNotificationEnabled(false);
            customer.setCustomerUniqueId(customerHelper.createCustomerUniqueId(customerRepository));
            customer.setUserLoginDetails(createCustomerLoginDetails());
            customer.setCreatedAt(LocalDateTime.now());
            customer.setLastUpdatedAt(LocalDateTime.now());
            existingCustomer = customerRepository.save(customer);
            log.info("Created default customer: {}", existingCustomer.getEmail());
        }
        
        if(Objects.isNull(existingCustomer.getCustomerUniqueId())) {
            existingCustomer.setCustomerUniqueId(customerHelper.createCustomerUniqueId(customerRepository));
            customerRepository.save(existingCustomer);
            log.info("Updated customer unique ID for: {}", existingCustomer.getEmail());
        }
        
        // Initialize test providers
        createTestProviders();
        
        // Initialize test quotes/orders
        createTestQuotes(existingCustomer);
        
        log.info("Application data initialization completed successfully!");
    }

    private void createTestProviders() {
        // Create 5 test providers
        for (int i = 1; i <= 5; i++) {
            String providerId = "PROVIDER_" + i;
            Provider existingProvider = providerRepository.findByProviderUniqueId(providerId);
            
            if (existingProvider == null) {
                Provider provider = new Provider();
                provider.setProviderUniqueId(providerId);
                provider.setName("Test Provider " + i);
                provider.setIsActive(true);
                provider.setEmail("provider" + i + "@test.com");
                provider.setPhone("+123456789" + i);
                provider.setCreatedAt(LocalDateTime.now());
                provider.setLastUpdatedAt(LocalDateTime.now());
                provider.setCustomerAverageRating(4.5);
                provider.setTotalCustomerRatings(10L);
                providerRepository.save(provider);
                log.info("Created test provider: {}", providerId);
            }
        }
        log.info("Test providers initialization completed");
    }

    private void createTestQuotes(Customer customer) {
        // Create 10 test quotes/orders
        for (int i = 1; i <= 10; i++) {
            String quoteId = "QUOTE_" + i;
            Quote existingQuote = quoteRepository.findByQuoteUniqueId(quoteId);
            
            if (existingQuote == null) {
                Quote quote = new Quote();
                quote.setQuoteUniqueId(quoteId);
                quote.setCustomer(customer);
                quote.setProvider(providerRepository.findByProviderUniqueId("PROVIDER_" + (i % 5 + 1)));
                quote.setStatus(QuoteStatus.COMPLETED);
                quote.setTotalAmount(new BigDecimal("150.00"));
                quote.setCreatedAt(LocalDateTime.now().minusDays(i));
                quote.setLastUpdatedAt(LocalDateTime.now().minusDays(i));
                quote.setCompletedAt(LocalDateTime.now().minusDays(i).plusHours(2));
                quoteRepository.save(quote);
                log.info("Created test quote: {}", quoteId);
            }
        }
        log.info("Test quotes initialization completed");
    }

    private UserLoginDetails createCustomerLoginDetails() {
        UserLoginDetails loginDetails = new UserLoginDetails();
        loginDetails.setUsername("mobile@test.com");
        loginDetails.setPassword(passwordEncoder.encode("Password@1"));
        loginDetails.setEnabled(true);
        loginDetails.setCredentialsNonExpired(true);
        loginDetails.setEnabled(true);
        loginDetails.setAccountNonExpired(true);
        loginDetails.setAccountNonLocked(true);
        return loginDetails;
    }
}

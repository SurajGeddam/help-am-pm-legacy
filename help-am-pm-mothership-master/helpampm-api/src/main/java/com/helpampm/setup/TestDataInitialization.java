/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.setup;

import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.customer.Customer;
import com.helpampm.customer.CustomerHelper;
import com.helpampm.customer.CustomerRepository;
import com.helpampm.customer.CustomerService;
import com.helpampm.provider.Provider;
import com.helpampm.provider.ProviderRepository;
import com.helpampm.quote.Quote;
import com.helpampm.quote.QuoteRepository;
import com.helpampm.quote.QuoteStatus;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Objects;
import java.util.UUID;

/**
 * @author kuldeep
 */
@Configuration
@Slf4j
public class TestDataInitialization {
    private final PasswordEncoder passwordEncoder;
    @Autowired
    public TestDataInitialization(final PasswordEncoder passwordEncoder,
                                  final CustomerHelper customerHelper,
                                  final CustomerRepository repository,
                                  final ProviderRepository providerRepository,
                                  final QuoteRepository quoteRepository) {
        this.passwordEncoder = passwordEncoder;
        Customer existingCustomer = repository.findByEmail("mobile@test.com");
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
            customer.setCustomerUniqueId(customerHelper.createCustomerUniqueId(repository));
            customer.setUserLoginDetails(createCustomerLoginDetails());
            customer.setCreatedAt(LocalDateTime.now());
            customer.setLastUpdatedAt(LocalDateTime.now());
            existingCustomer = repository.save(customer);
        }
        if(Objects.isNull(existingCustomer.getCustomerUniqueId())) {
            existingCustomer.setCustomerUniqueId(customerHelper.createCustomerUniqueId(repository));
            repository.save(existingCustomer);
        }
        log.info("Customer default data loaded...");
        
        // Add test providers
        createTestProviders(providerRepository);
        
        // Add test quotes/orders
        createTestQuotes(quoteRepository, existingCustomer, providerRepository);
    }

    private void createTestProviders(ProviderRepository providerRepository) {
        // Create 5 test providers
        for (int i = 1; i <= 5; i++) {
            Provider provider = new Provider();
            provider.setProviderUniqueId("PROVIDER_" + i);
            provider.setCompanyName("Test Provider " + i);
            provider.setIsActive(true);
            provider.setEmail("provider" + i + "@test.com");
            provider.setPhone("+123456789" + i);
            provider.setCreatedAt(LocalDateTime.now());
            provider.setLastUpdatedAt(LocalDateTime.now());
            provider.setAverageRating(4.5);
            provider.setTotalRatings(10L);
            provider.setTotalEarnings(new BigDecimal("5000.00"));
            providerRepository.save(provider);
        }
        log.info("Test providers data loaded...");
    }

    private void createTestQuotes(QuoteRepository quoteRepository, Customer customer, ProviderRepository providerRepository) {
        // Create 10 test quotes/orders
        for (int i = 1; i <= 10; i++) {
            Quote quote = new Quote();
            quote.setQuoteUniqueId("QUOTE_" + i);
            quote.setCustomer(customer);
            quote.setProvider(providerRepository.findByProviderUniqueId("PROVIDER_" + (i % 5 + 1)));
            quote.setStatus(QuoteStatus.COMPLETED);
            quote.setTotalAmount(new BigDecimal("150.00"));
            quote.setCreatedAt(LocalDateTime.now().minusDays(i));
            quote.setLastUpdatedAt(LocalDateTime.now().minusDays(i));
            quote.setCompletedAt(LocalDateTime.now().minusDays(i).plusHours(2));
            quoteRepository.save(quote);
        }
        log.info("Test quotes/orders data loaded...");
    }

    public UserLoginDetails createCustomerLoginDetails() {
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

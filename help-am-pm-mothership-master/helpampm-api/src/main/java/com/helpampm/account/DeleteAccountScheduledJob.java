/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.account;

import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.repositories.LoginDetailsRepository;
import com.helpampm.customer.Customer;
import com.helpampm.customer.CustomerRepository;
import com.helpampm.provider.Provider;
import com.helpampm.provider.ProviderRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * @author kuldeep
 */
@Component
@Slf4j
@RequiredArgsConstructor
public class DeleteAccountScheduledJob {
    private final DeleteAccountRequestRepository deleteAccountRequestRepository;
    private final LoginDetailsRepository loginDetailsRepository;
    private final ProviderRepository providerRepository;
    private final CustomerRepository customerRepository;
    @Value("${account.delete.gracePeriod}")
    private int deleteAccountGracePeriod;
    // TODO: Once account is delete, it can not be recovered
    // Take account deletion as a request and execute it after 30 days
    // Account deletions request in a separate table
    // Delete account request entry if reactivated within 30 days
    // Account delete scheduler will run everyday to check and delete account data
    @Scheduled(cron = "0 0/5 * * * *")
    public void deleteUserAccount() {
        try {
            List<DeleteAccountRequest> deleteAccountRequests = getEligibleAccountDeleteRequests();
            deleteAccountRequests.stream().filter(deleteAccountRequest ->
                    LocalDateTime.now().isAfter(deleteAccountRequest.getRequestDate()
                            .plusDays(deleteAccountGracePeriod)))
                    .forEach(deleteAccountRequest -> {
                // Check if user is provider or customer
                // Delete Entry from provider/customer
                // Delete user credentials
                // Delete Refresh tokens if any
                // Delete quotes //Keep invoices and payments details
                // Delete Addresses
                // Delete notifications
                // Delete reviews received by the user
                // Delete live locations of provider

                Optional<UserLoginDetails> userLoginDetailsOptional = getProviderUniqueId(deleteAccountRequest.getUsername());
                if(userLoginDetailsOptional.isPresent()
                        && Objects.nonNull(userLoginDetailsOptional.get().getProviderUniqueId())) {
                    // Delete Provider Stuffs
                    log.info("Deleting Account data...");
                    Optional<Provider> provider = providerRepository
                            .findByProviderUniqueId(userLoginDetailsOptional.get().getProviderUniqueId());
                    provider.ifPresent(providerRepository::delete);
                    log.info("Provider {} deleted.", userLoginDetailsOptional.get().getProviderUniqueId());

                } else {
                    // Delete Customer Stuffs
                    log.info("Deleting Account data...");
                    Optional<Customer> customer = customerRepository
                            .findByCustomerUniqueId(userLoginDetailsOptional.get().getCustomerUniqueId());
                    customer.ifPresent(customerRepository::delete);
                    log.info("Customer {} deleted.", userLoginDetailsOptional.get().getCustomerUniqueId());
                }
            });
        } catch (Throwable throwable) {
            log.warn("Delete account request execution failed. Manual intervention required.");
        }
    }

    private Optional<UserLoginDetails> getProviderUniqueId(String username) {
        return loginDetailsRepository
                .findByUsername(username);
    }

    private List<DeleteAccountRequest> getEligibleAccountDeleteRequests() {
        return deleteAccountRequestRepository.findAll().stream().filter(deleteAccountRequest
                -> !deleteAccountRequest.getIsExecuted()
                && deleteAccountRequest
                .getRequestDate()
                .plusDays(deleteAccountGracePeriod)
                .isAfter(LocalDateTime.now()))
                .collect(Collectors.toList());
    }
}

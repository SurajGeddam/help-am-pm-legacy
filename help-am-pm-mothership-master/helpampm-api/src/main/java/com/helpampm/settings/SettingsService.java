/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.settings;

import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.services.AuthenticationService;
import com.helpampm.customer.Customer;
import com.helpampm.customer.CustomerService;
import com.helpampm.notifications.NotificationException;
import com.helpampm.notifications.SettingsUpdateDto;
import com.helpampm.provider.Provider;
import com.helpampm.provider.ProviderService;
import com.helpampm.provider.ProviderUpdateService;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Objects;

/**
 * @author kuldeep
 */
@SuppressFBWarnings("EI_EXPOSE_REP2")
@Service
@Slf4j
@RequiredArgsConstructor
public class SettingsService {
    private final AuthenticationService authenticationService;
    private final ProviderUpdateService providerUpdateService;
    private final ProviderService providerService;
    private final CustomerService customerService;

    public void updateSettings(SettingsUpdateDto settingsUpdateDto) {
        UserLoginDetails userLoginDetails = authenticationService.findLoggedInUser();
        if(Objects.nonNull(userLoginDetails.getProviderUniqueId())) {
            updateProviderNotificationSettings(settingsUpdateDto, userLoginDetails);
        } else if(Objects.nonNull(userLoginDetails.getCustomerUniqueId())) {
            updateCustomerNotificationSettings(settingsUpdateDto, userLoginDetails);
        }
    }

    private void updateCustomerNotificationSettings(SettingsUpdateDto settingsUpdateDto, UserLoginDetails userLoginDetails) {
        Customer customer = customerService.findByCustomerUniqueId(userLoginDetails.getCustomerUniqueId());
        switch (settingsUpdateDto.getType()) {
            case EMAIL -> customer.setEmailNotificationEnabled(settingsUpdateDto.isEnabled());
            case SMS -> customer.setSmsNotificationEnabled(settingsUpdateDto.isEnabled());
            default -> throw new NotificationException("Operation not allowed");
        }
        customerService.update(customer, userLoginDetails.getCustomerUniqueId());
    }

    private void updateProviderNotificationSettings(SettingsUpdateDto settingsUpdateDto, UserLoginDetails userLoginDetails) {
        Provider provider = providerService.findByProviderUniqueId(userLoginDetails.getProviderUniqueId());
        switch (settingsUpdateDto.getType()) {
            case EMAIL -> provider.setEmailNotificationEnabled(settingsUpdateDto.isEnabled());
            case SMS -> provider.setSmsNotificationEnabled(settingsUpdateDto.isEnabled());
            default -> throw new NotificationException("Operation not allowed");
        }
        providerUpdateService.updateProvider(provider);
    }
}

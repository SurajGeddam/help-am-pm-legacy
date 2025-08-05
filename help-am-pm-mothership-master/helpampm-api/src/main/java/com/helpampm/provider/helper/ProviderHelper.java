/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.helper;

import com.helpampm.auth.entities.Role;
import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.services.RoleService;
import com.helpampm.auth.services.UserService;
import com.helpampm.common.HelpConstants;
import com.helpampm.provider.Provider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.*;

@Slf4j
@RequiredArgsConstructor
@Component
/*
  @author kuldeep
 */
public class ProviderHelper {
    private static final int EARTH_RADIUS = 6371;
    private static final Random RANDOM = new Random();
    private final UserService userService;
    private final RoleService roleService;

    @Value("${notifications.email.create-order-provider-template-name}")
    private String newOrderProviderNotificationEmailTemplate;

    public void updateLoginCredentials(Provider provider) {
        UserLoginDetails userLoginDetails = provider.getUserLoginDetails();
        if (Objects.isNull(userLoginDetails.getRoles())
                || userLoginDetails.getRoles().isEmpty()) {
            Role role = roleService.findByName(HelpConstants.PROVIDER_DEFAULT_ROLE);
            userLoginDetails.setRoles(Set.of(role));
        }
        userLoginDetails.setEnabled(true);
        userLoginDetails.setCredentialsNonExpired(true);
        userLoginDetails.setAccountNonExpired(true);
        userLoginDetails.setAccountNonLocked(true);
        userLoginDetails.setProviderUniqueId(provider.getProviderUniqueId());
        userLoginDetails.setCreatedAt(LocalDateTime.now());
        userLoginDetails.setLastUpdatedAt(LocalDateTime.now());
        userLoginDetails = userService.create(userLoginDetails);
        provider.setUserLoginDetails(userLoginDetails);
    }

    public void updateProviderId(Provider provider) {
        provider.setProviderUniqueId(generateRandomBoundedString());
    }

    public String generateRandomBoundedString() {
        char[] chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".toCharArray();
        StringBuilder sb = new StringBuilder((100000 + RANDOM.nextInt(900000)) + "-");
        for (int i = 0; i < 5; i++) {
            sb.append(chars[RANDOM.nextInt(chars.length)]);
        }
        return sb.toString();
    }

    public Boolean checkIfAccountSetupDone(Provider provider) {
        return Objects.nonNull(provider.getBankAccount())
                && Objects.nonNull(provider.getInsurances())
                && !provider.getInsurances().isEmpty()
                && Objects.nonNull(provider.getVehicles())
                && !provider.getVehicles().isEmpty()
                && Objects.nonNull(provider.getLicenses())
                && !provider.getLicenses().isEmpty()
                && Objects.nonNull(provider.getAddress())
                && provider.isStripeSetupDone()
                && Objects.nonNull(provider.getCategories())
                && !provider.getCategories().isEmpty();
    }

    public double calculateDistanceBetweenCustomerAndProvider(Double sourceLatitude,
                                                              Double sourceLongitude,
                                                              Double sourceAltitude,
                                                              Double destinationLatitude,
                                                              Double destinationLongitude,
                                                              Double destinationAltitude) {
        double latDistance = Math.toRadians(destinationLatitude - sourceLatitude);
        double lonDistance = Math.toRadians(destinationLongitude - sourceLongitude);
        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(sourceLatitude)) * Math.cos(Math.toRadians(destinationLongitude))
                * Math.sin(lonDistance / 2) * Math.sin(lonDistance / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        double distance = EARTH_RADIUS * c * 1000; // convert to meters
        if (Objects.nonNull(sourceAltitude) || Objects.nonNull(destinationAltitude)) {
            double height = sourceAltitude - destinationAltitude;
            distance = Math.pow(distance, 2) + Math.pow(height, 2);
        }
        return Math.sqrt(distance);
    }

    public String createStripeSecretHash(String providerUniqueId) {
        return UUID.nameUUIDFromBytes((providerUniqueId + LocalDateTime.now()).getBytes(StandardCharsets.UTF_8)).toString();
    }
}

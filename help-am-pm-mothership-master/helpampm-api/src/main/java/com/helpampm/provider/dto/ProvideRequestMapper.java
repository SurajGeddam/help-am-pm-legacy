/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.dto;

import com.helpampm.common.StringUtils;
import com.helpampm.livelocation.Location;
import com.helpampm.livelocation.ProviderLocationLookup;
import com.helpampm.provider.Provider;

/**
 * @author kuldeep
 */
public class ProvideRequestMapper {
    public static ProviderSearchResponseDto mapToProviderDto(Provider provider, ProviderLocationLookup locationLookup) {
        Location location = locationLookup.get(provider.getProviderUniqueId());
        return ProviderSearchResponseDto.builder()
                .withParentCompanyUniqueId(StringUtils.setDefaultString(provider.getParentCompanyUniqueId()))
                .withUsername(provider.getUserLoginDetails().getUsername())
                .withName(provider.getName())
                .withEmail(provider.getEmail())
                .withPhone(provider.getPhone())
                .withProviderUniqueId(provider.getProviderUniqueId())
                .withCompanyUniqueId(provider.getCompanyUniqueId())
                .withCustomerAverageRating(provider.getCustomerAverageRating())
                .withLongitude(location.getLongitude())
                .withLatitude(location.getLatitude())
                .withAltitude(location.getAltitude())
                .withSmsNotification(provider.isSmsNotificationEnabled())
                .withPushNotification(provider.isPushNotificationEnabled())
                .withEmailNotification(provider.isEmailNotificationEnabled())
                .build();
    }
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.dto;

import com.helpampm.address.dto.AddressDto;
import com.helpampm.common.StringUtils;
import com.helpampm.metadata.dto.CategoryDto;
import com.helpampm.metadata.dto.TimeslotDto;
import com.helpampm.provider.CompletedPage;
import com.helpampm.provider.Provider;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;

import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@Data
@Builder(setterPrefix = "with")
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class ProviderDto {
    private long id;
    private String providerUniqueId;
    private String name;
    private String email;
    private double latitude;
    private double longitude;
    private double altitude;
    private String phone;
    private double customerAverageRating;
    private long totalCustomerRatings;
    private String companyUniqueId;
    private String parentCompanyUniqueId;
    private boolean isIndividual;
    private boolean smsNotification;
    private boolean emailNotification;
    private boolean pushNotification;
    private boolean isActive;
    private boolean accountSetupCompleted;
    private String username;
    private AddressDto address;
    private BankAccountDto bankAccount;
    private CompletedPage completedPage;


    private Set<LicenseDto> licenses;
    private Set<InsuranceDto> insurances;
    private Set<VehicleDto> vehicles;
    private Set<TimeslotDto> timeslots;
    private Set<CategoryDto> categories;


    public static ProviderDto buildWithProvider(Provider provider) {
        return ProviderDto.builder()
                .withId(provider.getId())
                .withParentCompanyUniqueId(StringUtils.setDefaultString(provider.getParentCompanyUniqueId()))
                .withName(provider.getName())
                .withEmail(provider.getEmail())
                .withPhone(provider.getPhone())
                .withVehicles(
                        Objects.nonNull(provider.getVehicles()) ?
                                provider.getVehicles().stream().map(VehicleDto::buildWithVehicle).collect(Collectors.toSet()) : Set.of())
                .withInsurances(Objects.nonNull(provider.getInsurances()) ? provider.getInsurances().stream().map(InsuranceDto::buildWithInsurance).collect(Collectors.toSet()) : Set.of())
                .withLicenses(Objects.nonNull(provider.getLicenses()) ? provider.getLicenses().stream().map(LicenseDto::buildWithLicense).collect(Collectors.toSet()) : Set.of())
                .withCategories(Objects.nonNull(provider.getCategories())
                        ? provider.getCategories().stream().map(CategoryDto::buildWithCategory).collect(Collectors.toSet())
                        : Set.of())
                .withTimeslots(Objects.nonNull(provider.getTimeslots()) ? provider.getTimeslots().stream().map(TimeslotDto::buildWithTimeslot).collect(Collectors.toSet()) : Set.of())
                .withProviderUniqueId(provider.getProviderUniqueId())
                .withCompanyUniqueId(provider.getCompanyUniqueId())
                .withAddress(AddressDto.buildWithAddress(provider.getAddress()))
                .withBankAccount(BankAccountDto.buildWithBankAccount(provider.getBankAccount()))
                .withIsActive(provider.getIsActive())
                .withAccountSetupCompleted(StringUtils.setDefaultBoolean(provider.getAccountSetupCompleted()))
                .withEmailNotification(StringUtils.setDefaultBoolean(provider.isEmailNotificationEnabled()))
                .withSmsNotification(StringUtils.setDefaultBoolean(provider.isSmsNotificationEnabled()))
                .withPushNotification(StringUtils.setDefaultBoolean(provider.isPushNotificationEnabled()))
                .withIsIndividual(StringUtils.setDefaultBoolean(provider.isIndividual()))
                .withCustomerAverageRating(provider.getCustomerAverageRating())
                .withUsername(provider.getUserLoginDetails().getUsername())
                .withCompletedPage(provider.getLastCompletedPage())
                .withLongitude(Objects.nonNull(provider.getAddress())
                        ? provider.getAddress().getLongitude()
                        : 0.0)
                .withLatitude(Objects.nonNull(provider.getAddress())
                        ? provider.getAddress().getLatitude()
                        : 0.0)
                .withAltitude(Objects.nonNull(provider.getAddress())
                        ? provider.getAddress().getAltitude()
                        : 0.0)
                .build();
    }
}

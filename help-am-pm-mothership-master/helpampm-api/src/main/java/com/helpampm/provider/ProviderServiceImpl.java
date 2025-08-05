/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider;

import com.helpampm.auth.services.RoleService;
import com.helpampm.config.EmailTemplateConfig;
import com.helpampm.livelocation.Location;
import com.helpampm.livelocation.ProviderLocationLookup;
import com.helpampm.notifications.email.EmailNotificationMessage;
import com.helpampm.notifications.email.EmailNotificationService;
import com.helpampm.provider.categories.ProviderCategory;
import com.helpampm.provider.categories.ProviderCategoryRepository;
import com.helpampm.provider.dto.*;
import com.helpampm.provider.helper.PageableProviderFilterRequestHelper;
import com.helpampm.provider.helper.ProviderHelper;
import com.stripe.model.Account;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.retry.annotation.Backoff;
import org.springframework.retry.annotation.Retryable;
import org.springframework.stereotype.Service;

import javax.persistence.TypedQuery;
import javax.transaction.Transactional;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@SuppressFBWarnings("EI_EXPOSE_REP2")
@Service
@Slf4j
@RequiredArgsConstructor

/*
  @author kuldeep
 */
public class ProviderServiceImpl implements ProviderService {
    private final EmailNotificationService emailNotificationService;
    private final EmailTemplateConfig emailTemplateConfig;
    private final ProviderRepository repository;
    private final ProviderLocationLookup locationLookup;
    private final ProviderHelper providerHelper;
    private final RoleService roleService;
    private final PageableProviderFilterRequestHelper providerFilterRequestHelper;
    private final ProviderCategoryRepository providerCategoryRepository;
    private final ProviderStripeAccountHelper providerStripeAccountHelper;

    @Value("${help.company.logo}")
    private String logo;
    @Value("${help.company.termAndConditionPageUrl}")
    private String termAndConditionPageUrl;

    @Override
    @Transactional
    public Provider signupProviderAsCompanyOrIndividual(Provider provider) {

        assert Objects.nonNull(provider);
        if (!provider.isIndividual()) {
            updateCompanyUniqueIdentifierIdentifier(provider);
        }
        providerHelper.updateProviderId(provider);
        providerHelper.updateLoginCredentials(provider);
        provider.setAccountSetupCompleted(providerHelper.checkIfAccountSetupDone(provider));
        provider.setCreatedAt(LocalDateTime.now());
        provider.setLastUpdatedAt(LocalDateTime.now());
        provider.setCustomerAverageRating(0D);
        provider.setTotalCustomerRatings(0L);
        provider.setIsActive(true);
        provider.setLastCompletedPage(CompletedPage.SIGNUP);
        provider.validate();
        provider.setStripeSecretHash(providerHelper.createStripeSecretHash(provider.getProviderUniqueId()));
        provider = repository.save(provider);
        sendProviderSignupNotification(provider);
        return provider;
    }

    private void sendProviderSignupNotification(Provider provider) {
        Map<String, Object> modelData = new HashMap<>();
        modelData.put("name", provider.getName());
        modelData.put("companyUniqueId", provider.getCompanyUniqueId());
        modelData.put("termAndConditionPageUrl", termAndConditionPageUrl);
        modelData.put("logo", logo);
        EmailNotificationMessage emailNotificationMessage = EmailNotificationMessage.builder()
                .withSubject(String.format("HELP: Welcome %s!", provider.getName()))
                .withRecipientEmail(provider.getEmail())
                .withRecipientName(provider.getName())
                .withModelData(modelData)
                .withEmailTemplateName(emailTemplateConfig.getProviderSignupEmailTemplateName())
                .build();
        emailNotificationService.send(emailNotificationMessage, provider.getEmail());
    }

    private void updateCompanyUniqueIdentifierIdentifier(Provider provider) {
        String uniqueIdentifier = providerHelper.generateRandomBoundedString();
        while (findByCompanyUniqueId(uniqueIdentifier).isPresent()) {
            uniqueIdentifier = providerHelper.generateRandomBoundedString();
        }
        provider.setCompanyUniqueId(uniqueIdentifier);
    }


    @Override
    public List<Provider> findByParentCompanyUniqueId(String companyUniqueId) {
        return repository.findByParentCompanyUniqueId(companyUniqueId);
    }

    @Override
    public PageableProviderResponse findPageableAll(ProviderFilterRequestPayload pageableFilterDto) {
        TypedQuery<Provider> query = providerFilterRequestHelper.createExecutableQuery(pageableFilterDto);
        List<Provider> providers = query.getResultList();
        List<ProviderDto> providerDtos = providers.stream()
                .map(ProviderDto::buildWithProvider).collect(Collectors.toList());
        return new PageableProviderResponse(providerFilterRequestHelper.getCountOfAvailableItems(pageableFilterDto), providerDtos);
    }


    @Override
    @Transactional
    public Provider signupProviderAsEmployee(String companyUniqueId, Provider provider) {
        assert Objects.nonNull(companyUniqueId);
        Provider parentCompanyProvider = findByCompanyUniqueId(companyUniqueId)
                .orElseThrow(() -> new ProviderException("Unable to find Provider with companyUniqueId " + companyUniqueId, HttpStatus.NOT_FOUND));
        providerHelper.updateProviderId(provider);
        provider.setParentCompanyUniqueId(companyUniqueId);

        copyParentVehicles(provider, parentCompanyProvider);
        copyParentInsurances(provider, parentCompanyProvider);
        copyParentLicenses(provider, parentCompanyProvider);
        copyParentCategories(provider, parentCompanyProvider);
        copyParentTimeslots(provider, parentCompanyProvider);
        copyParentBankAccount(provider, parentCompanyProvider);
        copyParentAddress(provider, parentCompanyProvider);

        provider.setCreatedAt(LocalDateTime.now());
        provider.setLastUpdatedAt(LocalDateTime.now());
        provider.setCustomerAverageRating(0D);
        provider.setTotalCustomerRatings(0L);
        provider.setIsActive(true);

        provider.getUserLoginDetails().setRoles(Set.of(roleService.findByName("ROLE_PROVIDER_EMPLOYEE")));
        providerHelper.updateLoginCredentials(provider);
        provider.validate();
        provider.setAccountSetupCompleted(parentCompanyProvider.getAccountSetupCompleted());
        return repository.save(provider);
    }

    private void copyParentAddress(Provider provider, Provider parentCompanyProvider) {
        if (Objects.nonNull(parentCompanyProvider.getAddress())) {
            provider.setAddress(parentCompanyProvider.getAddress());
        }
    }

    private void copyParentBankAccount(Provider provider, Provider parentCompanyProvider) {
        if (Objects.nonNull(parentCompanyProvider.getBankAccount())) {
            provider.setBankAccount(parentCompanyProvider.getBankAccount());
        }
    }

    private void copyParentTimeslots(Provider provider, Provider parentCompanyProvider) {
        provider.setTimeslots(new HashSet<>(parentCompanyProvider.getTimeslots()));
    }

    private void copyParentCategories(Provider provider, Provider parentCompanyProvider) {
        provider.setCategories(new HashSet<>(parentCompanyProvider.getCategories()));
    }

    private void copyParentLicenses(Provider provider, Provider parentCompanyProvider) {
        provider.setLicenses(new HashSet<>(parentCompanyProvider.getLicenses()));
    }

    private void copyParentInsurances(Provider provider, Provider parentCompanyProvider) {
        provider.setInsurances(new HashSet<>(parentCompanyProvider.getInsurances()));
    }

    private void copyParentVehicles(Provider provider, Provider parentCompanyProvider) {
        provider.setVehicles(new HashSet<>(parentCompanyProvider.getVehicles()));
    }

    @Override
    @Retryable(value = Exception.class, maxAttempts = 5, backoff = @Backoff(delay = 10000))
    public List<ProviderSearchResponseDto> search(ProviderSearchDto payload) {
        Set<String> providerIds;
        if(payload.getIsResidential()) {
            log.info("Search Provider for residential category");
            providerIds = providerCategoryRepository
                    .findByNameAndResidentialService(payload.getCategory(),
                            payload.getIsResidential()).stream()
                    .map(ProviderCategory::getProviderUniqueId)
                    .collect(Collectors.toSet());
        } else {
            log.info("Search Provider for commercial category");
            providerIds = providerCategoryRepository
                    .findByNameAndCommercialService(payload.getCategory(), !payload.getIsResidential()).stream()
                    .map(ProviderCategory::getProviderUniqueId)
                    .collect(Collectors.toSet());
        }
        log.info("Matched Provider Ids: " + providerIds);
        return repository.findAllByProviderUniqueIdIn(providerIds)
                .stream()
                .filter(Provider::getAccountSetupCompleted)
                .filter(provider -> filterByRadius(payload, provider))
                .map(provider -> ProvideRequestMapper.mapToProviderDto(provider, locationLookup))
                .collect(Collectors.toList());
    }

    @Override
    public List<Provider> findAll() {
        return repository.findAll();
    }

    @Override
    public Provider findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new ProviderException("Unable to find Provider with id " + id, HttpStatus.NOT_FOUND));
    }

    @Override
    public Provider findByProviderUniqueId(String providerUniqueId) {
        return repository.findByProviderUniqueId(providerUniqueId)
                .orElseThrow(() -> new ProviderException("Unable to find Provider with providerUniqueId " + providerUniqueId, HttpStatus.NOT_FOUND));
    }

    @Override
    public Provider findByStripAccountId(String stripeAccountId) {
        return repository.findByStripAccountId(stripeAccountId).orElse(null);
    }

    @Override
    @Transactional
    public Provider updateProvider(Provider provider) {
        return repository.save(provider);
    }

    @Override
    public Optional<Provider> findByCompanyUniqueId(String companyUniqueId) {
        return repository.findByCompanyUniqueId(companyUniqueId);
    }

    private boolean filterByRadius(ProviderSearchDto payload, Provider provider) {
        try {
            Location location = locationLookup.get(provider.getProviderUniqueId());
            double distance = providerHelper.calculateDistanceBetweenCustomerAndProvider(payload.getLatitude(),
                    payload.getLongitude(),
                    payload.getAltitude(),
                    location.getLatitude(),
                    location.getLongitude(),
                    location.getAltitude());
            return distance <= payload.getRadius();
        } catch (Exception exception) {
            log.error(exception.getMessage());
        }
        return false;
    }

    @Override
    public Provider updateProviderProfile(ProfileDto profileDto) {
        Provider provider = findByProviderUniqueId(profileDto.getProviderUniqueId());
        provider.setProfileImagePath(profileDto.getProfilePicture());
        provider.setName(profileDto.getName());
        provider.setPhone(profileDto.getMobileNumber());
        return updateProvider(provider);
    }

    @Override
    public Provider disablePayouts(Provider provider, boolean isEnable) {
        //payout enable
        Account stripeAccount = providerStripeAccountHelper.retrieveAccount(provider.getStripAccountId());
        // update Stripe
        Account updatedAccount = providerStripeAccountHelper.payoutEnableDisableForProvider(stripeAccount, isEnable);
        // update HELP
        provider.setPayoutEnable(updatedAccount.getPayoutsEnabled());
        updateProvider(provider);

        return provider;
    }

    public void validateProviderStripeSecretHash(Provider provider, String secretHash) {
        assert Objects.nonNull(provider);
        if (!Objects.equals(provider.getStripeSecretHash(), secretHash)) {
            throw new ProviderException("Invalid Secret hash code", HttpStatus.UNAUTHORIZED);
        }
        String newSecretHash = UUID.nameUUIDFromBytes((provider.getProviderUniqueId() + LocalDateTime.now()).getBytes(StandardCharsets.UTF_8)).toString();
        provider.setStripeSecretHash(newSecretHash);
    }

}

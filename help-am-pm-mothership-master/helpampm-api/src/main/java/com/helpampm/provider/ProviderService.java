/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider;

import com.helpampm.provider.dto.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface ProviderService {
    Provider signupProviderAsEmployee(String companyUniqueId, Provider provider);

    List<ProviderSearchResponseDto> search(ProviderSearchDto payload);

    List<Provider> findAll();

    Provider findById(Long id);

    Provider findByProviderUniqueId(String providerUniqueId);

    Provider findByStripAccountId(String stripeAccountId);

    Optional<Provider> findByCompanyUniqueId(String companyUniqueId);

    Provider signupProviderAsCompanyOrIndividual(Provider provider);

    List<Provider> findByParentCompanyUniqueId(String companyUniqueId);

    PageableProviderResponse findPageableAll(ProviderFilterRequestPayload pageableFilterDto);

	Provider updateProvider(Provider provider);
	
	Provider updateProviderProfile(ProfileDto profileDto);

    Provider disablePayouts(Provider provider,boolean isEnable);
    void validateProviderStripeSecretHash(Provider provider,String secretHash);
}

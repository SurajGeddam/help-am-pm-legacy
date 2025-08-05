/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote;

import com.helpampm.address.AddressService;
import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.services.AuthenticationService;
import com.helpampm.common.UnauthorizedException;
import com.helpampm.common.services.FileService;
import com.helpampm.provider.Provider;
import com.helpampm.provider.ProviderException;
import com.helpampm.provider.ProviderService;
import com.helpampm.quote.dto.*;
import com.helpampm.quote.quoteproviders.QuoteProviderAddress;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class QuoteReadOnlyService {
    private final QuoteRepository repository;
    private final AuthenticationService authenticationService;
    private final ProviderService providerService;
    private final EntityManager entityManager;
    private final PageableQuoteFilterRequestHelper pageableQuoteFilterRequestHelper;
    private final AddressService addressService;
    private final FileService fileService;

    @Value("${aws.s3.profile-photos}")
    private String uploadBucket;
    public Quote findByQuoteUniqueId(String orderUniqueId) {
        return repository.findByQuoteUniqueId(orderUniqueId);
    }

    public List<Quote> findAll() {
        return repository.findAll();
    }

    public List<Quote> getQuotesProvider(String providerUniqueId) {
        UserLoginDetails userLoginDetails = authenticationService.findLoggedInUser();
        if (userLoginDetails.getProviderUniqueId().equalsIgnoreCase(providerUniqueId)) {
            return repository.findByQuoteProviderUniqueId(providerUniqueId);
        }
        throw new UnauthorizedException("You need to be logged in before getting list of our orders.");
    }

    public List<Quote> getQuotesForCompany(String companyUniqueId) {
        UserLoginDetails userLoginDetails = authenticationService.findLoggedInUser();
        Provider provider = providerService.findByCompanyUniqueId(companyUniqueId)
                .orElseThrow(() -> new ProviderException("Unable to find Provider with companyUniqueId " + companyUniqueId, HttpStatus.NOT_FOUND));
        if (userLoginDetails.getProviderUniqueId().equalsIgnoreCase(provider.getProviderUniqueId())) {
            List<String> providerIds = providerService.findByParentCompanyUniqueId(companyUniqueId)
                    .stream().map(Provider::getProviderUniqueId).collect(Collectors.toList());
            return repository.findByQuoteProviderUniqueIdIn(providerIds);
        }
        throw new UnauthorizedException(String.format("You don't have an access to get the orders. " +
                "Please make sure %s is your companyUniqueId.", companyUniqueId));
    }

    public List<Quote> getCustomerQuote(String customerUniqueId) {
        UserLoginDetails userLoginDetails = authenticationService.findLoggedInUser();
        if (userLoginDetails.getCustomerUniqueId().equalsIgnoreCase(customerUniqueId)) {
            return repository.findByQuoteCustomerUniqueId(customerUniqueId);
        }
        throw new UnauthorizedException(String.format("You don't have an access to get the orders. " +
                "Please make sure %s is your customerUniqueId.", customerUniqueId));
    }

    public List<Quote> getQuoteByQuoteCustomerUniqueIdAndStatus(String customerUniqueId, String status) {
        validateAuthority(customerUniqueId);
        TypedQuery<Quote> query =
                entityManager.createQuery("select q from Quote q WHERE q.quoteCustomer.uniqueId=:customerUniqueId and status IN "
                        + QuoteHelper.createStatusInClause(status), Quote.class);
        query.setParameter("customerUniqueId", customerUniqueId).getResultList();

        return query.getResultList();
    }

    public List<Quote> getQuoteByQuoteProviderUniqueIdAndStatus(String providerUniqueId, QuoteStatus status) {
        validateAuthority(providerUniqueId);
        return repository.getQuoteByQuoteProviderUniqueIdAndStatus(providerUniqueId, status);
    }

    public List<Quote> getQuoteByQuoteCompanyUniqueIdAndStatus(String companyUniqueId, QuoteStatus status) {
        validateAuthority(companyUniqueId);
        List<Provider> providers = providerService.findByParentCompanyUniqueId(companyUniqueId);
        Optional<Provider> companyAdmin = providerService.findByCompanyUniqueId(companyUniqueId);
        companyAdmin.ifPresent(providers::add);
        return repository.getQuoteByQuoteProviderUniqueIdInAndStatus(providers.stream()
                .map(Provider::getProviderUniqueId).collect(Collectors.toSet()), status);
    }

    public void validateAuthority(String uniqueId) {
        UserLoginDetails userLoginDetails = authenticationService.findLoggedInUser();
        if (Objects.nonNull(userLoginDetails.getProviderUniqueId())) {
            Provider provider = providerService.findByProviderUniqueId(userLoginDetails.getProviderUniqueId());
            if (!(Objects.equals(userLoginDetails.getProviderUniqueId(), uniqueId)
                    || Objects.equals(provider.getCompanyUniqueId(), uniqueId))) {
                throw new UnauthorizedException("You are not authorised to perform this operation, please check with our help and support team");
            }
        } else if (Objects.nonNull(userLoginDetails.getCustomerUniqueId())) {
            if (!Objects.equals(userLoginDetails.getCustomerUniqueId(), uniqueId)) {
                throw new UnauthorizedException("You are not authorised to perform this operation, please check with our help and support team");
            }
        }
    }

    public PageableQuoteResponse findPageableAllByStatus(QuoteFilterRequestPayload pageableFilterDto) {
        TypedQuery<Quote> query = pageableQuoteFilterRequestHelper.createExecutableQuery(pageableFilterDto);
        List<Quote> quotes = query.getResultList();
        List<QuoteDTO> response = new ArrayList<>();
        for(Quote quote : quotes) {
            QuoteDTO quoteDTO = QuoteDTO.buildFromQuote(quote);
            if(Objects.nonNull(quote.getQuoteProvider())) {
                quoteDTO.setProviderAddress(QuoteProviderAddress
                        .buildFromAddress(addressService
                                .findByProviderUniqueId(quote.getQuoteProvider().getUniqueId())));
            }
            response.add(quoteDTO);
        }

        return new PageableQuoteResponse(pageableQuoteFilterRequestHelper.getCountOfAvailableItems(pageableFilterDto), response);
    }

    public PageableQuoteMobileResponse findPageableAllByStatusMobile(QuoteFilterRequestPayload pageableFilterDto) {
        TypedQuery<Quote> query = pageableQuoteFilterRequestHelper.createExecutableQuery(pageableFilterDto);
        List<Quote> quotes = query.getResultList();
        List<QuoteMobileResponseDTO> response = new ArrayList<>();
        for(Quote quote : quotes) {
            QuoteMobileResponseDTO quoteMobileResponseDTO = QuoteMobileResponseDTO.buildFromQuote(quote);
            if(Objects.nonNull(quote.getQuoteProvider()))
            {
                quoteMobileResponseDTO.setProviderAddress(QuoteProviderAddress
                        .buildFromAddress(addressService
                                .findByProviderUniqueId(quote.getQuoteProvider().getUniqueId())));
            }
            quoteMobileResponseDTO.updateQuoteImage(fileService, quote.getImagePath(), uploadBucket);
            response.add(quoteMobileResponseDTO);
        }
        return new PageableQuoteMobileResponse(pageableQuoteFilterRequestHelper.getCountOfAvailableItems(pageableFilterDto), response);
    }
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote;

import com.helpampm.address.Address;
import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.services.AuthenticationService;
import com.helpampm.common.StringUtils;
import com.helpampm.common.UnauthorizedException;
import com.helpampm.customer.Customer;
import com.helpampm.customer.CustomerService;
import com.helpampm.invoicing.Invoice;
import com.helpampm.invoicing.InvoiceService;
import com.helpampm.metadata.category.Category;
import com.helpampm.metadata.category.CategoryService;
import com.helpampm.metadata.tax.Tax;
import com.helpampm.metadata.tax.TaxService;
import com.helpampm.metadata.timeslot.Timeslot;
import com.helpampm.metadata.timeslot.TimeslotRepository;
import com.helpampm.provider.Provider;
import com.helpampm.provider.ProviderException;
import com.helpampm.provider.ProviderService;
import com.helpampm.provider.dto.ProviderSearchDto;
import com.helpampm.provider.dto.ProviderSearchResponseDto;
import com.helpampm.quote.dto.*;
import com.helpampm.quote.quoteaddress.QuoteAddressRepository;
import com.helpampm.quote.quotecustomers.QuoteCustomer;
import com.helpampm.quote.quotecustomers.QuoteCustomerRepository;
import com.helpampm.quote.quoteitems.QuoteItem;
import com.helpampm.quote.quoteitems.QuoteItemRepository;
import com.helpampm.quote.quoteproviders.QuoteProvider;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;

@Service
@Slf4j
@RequiredArgsConstructor
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
@Transactional
public class QuoteServiceImpl implements QuoteService {
    public static final String NIGHT_HOURS = "Night hours";
    private final QuoteRepository repository;
    private final QuoteItemRepository quoteItemRepository;
    private final CustomerService customerService;
    private final AuthenticationService authenticationService;
    private final QuoteNotificationService quoteNotificationService;
    private final TaxService taxService;
    private final ProviderService providerService;
    private final InvoiceService invoiceService;
    private final CategoryService categoryService;
    private final QuoteCustomerRepository quoteCustomerRepository;
    private final QuoteAddressRepository quoteAddressRepository;
    private final TimeslotRepository timeslotRepository;

    @Value("${customers.search.radius}")
    private Double searchRadius;

    private QuoteCustomer createQuoteCustomer(Customer customer, Address address) {
        QuoteCustomer quoteCustomer = new QuoteCustomer();
        quoteCustomer.setCustomerName(StringUtils.capitalize(customer.getFirstName())
                + " "
                + StringUtils.capitalize(customer.getLastName()));
        quoteCustomer.setUniqueId(customer.getCustomerUniqueId());
        quoteCustomer.setEmail(customer.getEmail());
        quoteCustomer.setPhone(customer.getPhone());
        quoteCustomer.setProfileImagePath(customer.getProfileImagePath());
        quoteCustomer.setQuoteAddress(quoteAddressRepository.save(QuoteCustomer.fromAddress(address)));
        return quoteCustomer;
    }

    @Override
    public Quote create(QuoteDTO quoteDTO, Customer customer) {
        log.info("Creating Quote: customer name: " + quoteDTO.getCustomerName()
                + " category: " + quoteDTO.getCategoryName()
                + " search radius: " + quoteDTO.getSearchRadius());

        Quote quote = new Quote();
        addCustomerDetailsToOrder(quote, quoteDTO, customer);
        quote.setCategoryName(quoteDTO.getCategoryName());
        quote.setIsResidenceService(quoteDTO.isResidentialService());
        quote.setIsCommercialService(quoteDTO.isCommercialService());
        quote.setServiceDescription(quoteDTO.getServiceDescription());
        quote.setTimeSlot(prepareTimeslot(quoteDTO, quote));
        quote.setServiceCharge(Boolean.TRUE.equals(quoteDTO.isResidentialService())
                ? quote.getTimeSlot().getPricing().getResidentialPrice()
                : quote.getTimeSlot().getPricing().getCommercialPrice());
        quote.setCreatedAt(LocalDateTime.now());
        quote.setLastUpdatedAt(LocalDateTime.now());
        quote.setTax(setTaxData(quoteDTO.getAddress()));
        addQuoteUniqueId(quote, customer);
        quote.setImagePath(quoteDTO.getImagePath());
        quote.setProviderSearchRadius(quoteDTO.getSearchRadius() > 0
                ? quoteDTO.getSearchRadius()
                : searchRadius);
        quote.setStatus(QuoteStatus.SCHEDULED);
        quote.setLastUpdatedAt(LocalDateTime.now());
        quote.validate();
        try {
            Quote quoteCreated = repository.saveAndFlush(quote);
            //repository.
            log.info("Quote created quote id " + quoteCreated.getQuoteUniqueId()
                    + " customer " + quoteDTO.getCustomerName()
                    + " category " + quoteDTO.getCategoryName());
            return quoteCreated;

        } catch (Exception ex) {
            throw new QuoteException("Unable to create order " + ex.getMessage(), HttpStatus.BAD_REQUEST.value());
        }

    }

    public void handleSendNewOrderNotification(Customer customer,
                                               Quote quote,
                                               boolean isScheduledOrder) {
        Set<String> providerNotified = new HashSet<>();

        //  is scheduled time is available and it's not for today, scheduled job will pick and send the notification
        if (!isScheduledOrder) {
            List<ProviderSearchResponseDto> providersInRange =
                    providerService.search(createProviderSearchPayload(quote));
            if (providersInRange.isEmpty()) {
                throw new ProviderException("No service provider available, " +
                        "please change your search radius or try again after some time. " +
                        "You can use our scheduling service and we will find a service " +
                        "provider for you.", HttpStatus.NOT_FOUND);
            }
            providerNotified.addAll(providersInRange.stream()
                    .map(ProviderSearchResponseDto::getProviderUniqueId).toList());
            quoteNotificationService.sendNewOrderNotification(quote, customer, providersInRange);
        }
        quote.setNotifiedProviders(providerNotified);
    }

    private ProviderSearchDto createProviderSearchPayload(Quote quote) {
        ProviderSearchDto providerSearchDto = new ProviderSearchDto();
        if (quote.getProviderSearchRadius() <= 0) {
            providerSearchDto.setRadius(searchRadius);
        } else {
            providerSearchDto.setRadius(quote.getProviderSearchRadius());
        }
        providerSearchDto.setIsResidential(quote.getIsResidenceService());
        providerSearchDto.setCategory(quote.getCategoryName());
        providerSearchDto.setLatitude(quote.getQuoteCustomer().getQuoteAddress().getLatitude());
        providerSearchDto.setLongitude(quote.getQuoteCustomer().getQuoteAddress().getLongitude());
        providerSearchDto.setAltitude(quote.getQuoteCustomer().getQuoteAddress().getAltitude());
        return providerSearchDto;
    }

    private Tax setTaxData(Address address) {
        Tax tax = taxService.findByTaxCounty(address.getCounty());
        if (Objects.nonNull(tax)) {
            return tax;
        }
        return taxService.findByTaxCounty("DEFAULT");
    }

    private Timeslot prepareTimeslot(QuoteDTO quoteDTO, Quote quote) {
        Optional<Category> category = categoryService.findByName(quoteDTO.getCategoryName());
        if (category.isPresent()) {
            if (quoteDTO.isScheduled()) {
                Timeslot timeslot = category.get()
                        .getTimeslots().stream()
                        .filter(t -> t.getId().equals(quoteDTO.getTimeslot().getId()))
                        .findFirst()
                        .orElseThrow(() -> new QuoteException("Timeslots not available, please try again with valid timeslots",
                                HttpStatus.NO_CONTENT.value()));
                quote.setScheduledTime(quoteDTO.getServiceDate().atTime(timeslot.getStartTime()));
            }
            Optional<Timeslot> timeslotOptional = timeslotRepository
                    .findById(quoteDTO.getTimeslot().getId());
            if (timeslotOptional.isPresent()) {
                return timeslotOptional.get();
            }
            return getTimeslot(category, LocalTime.now());
        }
        throw new QuoteException("Timeslot not available for service",
                HttpStatus.NO_CONTENT.value());
    }

    public Timeslot getTimeslot(Optional<Category> category, LocalTime time) {
        for (Timeslot timeslot : category.get().getTimeslots()) {
            LocalTime ct = time;
            LocalTime slotStartTime = timeslot.getStartTime();
            LocalTime slotEndTime = timeslot.getEndTime();
            if (NIGHT_HOURS.equalsIgnoreCase(timeslot.getName())) {
                if ((ct.isAfter(LocalTime.of(21, 0, 0))
                        || ct.equals(LocalTime.of(21, 0, 0)))
                        || ct.isBefore(LocalTime.of(9, 0, 0))) {
                    return timeslot;
                }
            }
            if ((ct.isAfter(slotStartTime) || ct.equals(slotStartTime))
                    && ct.isBefore(slotEndTime)) {
                return timeslot;
            }
        }
        throw new QuoteException("Timeslot not available for service",
                HttpStatus.NO_CONTENT.value());
    }

    @Override
    public Quote cancelQuote(String orderUniqueId) {
        Quote quote = repository.findByQuoteUniqueId(orderUniqueId);
        UserLoginDetails userLoginDetails = authenticationService.findLoggedInUser();
        if (isAuthorizedToCancel(quote, userLoginDetails)) {
            if (Objects.equals(quote.getStatus(), QuoteStatus.SCHEDULED)
                    || Objects.equals(quote.getStatus(), QuoteStatus.ACCEPTED_BY_PROVIDER)) {
                quote.setStatus(QuoteStatus.ORDER_CANCELLED);
                quote.setLastUpdatedAt(LocalDateTime.now());
                quoteNotificationService.sendCancelOrderNotifications(quote);
                return repository.save(quote);
            }
            throw new QuoteException("Order is already " +
                    quote.getStatus().name().toLowerCase() + ", It can not be cancelled. " +
                    "If you have any concerns, please contact our help and support.",
                    HttpStatus.FORBIDDEN.value());
        }
        throw new UnauthorizedException("You don't have an permissions to cancel the orders. " +
                "Please make sure you created this order or contact our help and support.");
    }

    @Override
    public Quote confirmQuote(String orderUniqueId, String providerUniqueId,
                              LocalTime eta) {
        Provider provider = providerService.findByProviderUniqueId(providerUniqueId);
        authorizeProvider(providerUniqueId);
        Quote quote = repository.findByQuoteUniqueId(orderUniqueId);
        if (QuoteStatus.SCHEDULED.equals(quote.getStatus())) {
            QuoteProvider quoteProvider = new QuoteProvider();
            quoteProvider.setProviderName(provider.getName());
            quoteProvider.setProviderImage(provider.getProfileImagePath());
            quoteProvider.setUniqueId(providerUniqueId);
            quote.setLastUpdatedAt(LocalDateTime.now());
            quote.setStatus(QuoteStatus.ACCEPTED_BY_PROVIDER);
            quote.setQuoteProvider(quoteProvider);
            quote.setEta(eta);
            Quote saveQuote = repository.save(quote);
            quoteNotificationService.sendOrderAcceptedByProviderNotifications(quote);
            return saveQuote;
        }
        throw new QuoteException("Order already accepted.",
                HttpStatus.EXPECTATION_FAILED.value());
    }

    private void authorizeProvider(String providerUniqueId) {
        if (!Objects.equals(providerUniqueId,
                authenticationService.findLoggedInUser().getProviderUniqueId())) {
            throw new QuoteException("You are not authorized to accept this order.",
                    HttpStatus.UNAUTHORIZED.value());
        }
    }

    @Override
    public QuoteItemResponse addQuoteItem(String quoteUniqueId,
                                          String providerUniqueId,
                                          QuoteItem quoteItem) {
        Quote quote = repository
                .findByQuoteUniqueIdAndQuoteProviderUniqueId(quoteUniqueId, providerUniqueId)
                .orElseThrow(() -> new QuoteException("No quote exists for quoteUniqueId "
                        + quoteUniqueId + " and providerId " + providerUniqueId,
                        HttpStatus.NO_CONTENT.value()));
        quoteItem.validate();
        quoteItem = quoteItemRepository.save(quoteItem);
        quote.getItems().add(quoteItem);
        log.info("Item Added successfully :{}", quoteItem.getId());
        return QuoteItemResponse.buildFromQuote(repository.save(quote), quoteItem);
    }

    @Override
    public QuoteItemResponse removeQuoteItem(String quoteUniqueId,
                                             String providerUniqueId, long itemId) {
        log.info("Trying to remove :{}", itemId);
        QuoteItem quoteItem = quoteItemRepository.findById(itemId)
                .orElseThrow(() -> new QuoteException("Item not found in quote",
                        HttpStatus.NO_CONTENT.value()));
        Quote quote = repository
                .findByQuoteUniqueIdAndQuoteProviderUniqueId(quoteUniqueId, providerUniqueId)
                .orElseThrow(() -> new QuoteException("No quote exists for quoteUniqueId "
                        + quoteUniqueId + " and providerId " + providerUniqueId,
                        HttpStatus.NO_CONTENT.value()));
        quote.getItems().remove(quoteItem);
        log.info("Item removed successfully :{}", itemId);
        return QuoteItemResponse.buildFromQuote(repository.save(quote), quoteItem);
    }

    @Override
    public StartWorkResponse startWork(String quoteUniqueId,
                                       String providerUniqueId,
                                       StartWorkPayload startWorkPayload) {
        Quote quote = repository
                .findByQuoteUniqueIdAndQuoteProviderUniqueId(quoteUniqueId, providerUniqueId)
                .orElseThrow(() -> new QuoteException("No quote exists for quoteUniqueId "
                        + quoteUniqueId + " and providerId "
                        + providerUniqueId, HttpStatus.NO_CONTENT.value()));
        if (quote.getStatus().equals(QuoteStatus.ACCEPTED_BY_PROVIDER)) {
            quote.setStatus(QuoteStatus.STARTED);
            quote.setLastUpdatedAt(LocalDateTime.now());
            repository.save(quote);
            quoteNotificationService.sendWorkStartedByProviderNotifications(quote);
            return StartWorkResponse.builder().withMessage("Work started successfully").build();
        }
        throw new QuoteException("Work is already started on this order.",
                HttpStatus.BAD_REQUEST.value());
    }

    @Override
    public CompleteQuoteResponse completeOrder(String quoteUniqueId, String providerUniqueId) {
        Quote quote = repository
                .findByQuoteUniqueIdAndQuoteProviderUniqueId(quoteUniqueId, providerUniqueId)
                .orElseThrow(() -> new QuoteException("No quote exists for quoteUniqueId "
                        + quoteUniqueId + " and providerId " + providerUniqueId,
                        HttpStatus.NO_CONTENT.value()));
        if (quote.getStatus().equals(QuoteStatus.STARTED)) {
            quote.setStatus(QuoteStatus.PAYMENT_PENDING);
            quote.setLastUpdatedAt(LocalDateTime.now());
            repository.save(quote);
            Invoice invoice = invoiceService.create(quote);
            return CompleteQuoteResponse.builder().withMessage("Order completed successfully. " +
                    "Invoice is raised to customer. " +
                    "Please followup and get it paid. InvoiceId = " + invoice.getUniqueId()).build();
        }
        throw new QuoteException("Order is already completed and invoice is generated.",
                HttpStatus.BAD_REQUEST.value());
    }

    private boolean isAuthorizedToCancel(Quote quote, UserLoginDetails userLoginDetails) {
        boolean isOwnerCustomer = Objects.nonNull(userLoginDetails.getCustomerUniqueId())
                && userLoginDetails.getCustomerUniqueId()
                .equalsIgnoreCase(quote.getQuoteCustomer().getUniqueId());
        boolean isSuperadmin = userLoginDetails.getRoles()
                .stream().anyMatch(r -> "ROLE_SUPERADMIN".equalsIgnoreCase(r.getName()));
        boolean isAssociatedProvider = Objects.nonNull(quote.getQuoteProvider())
                && Objects.nonNull(userLoginDetails.getProviderUniqueId())
                && quote.getQuoteProvider().getUniqueId()
                .equalsIgnoreCase(userLoginDetails.getProviderUniqueId());
        return isSuperadmin || isOwnerCustomer || isAssociatedProvider;
    }

    private void addQuoteUniqueId(Quote quote, Customer customer) {
        quote.setQuoteUniqueId(quote.getCategoryName() +
                "-" +
                customer.getCustomerUniqueId() +
                "-" +
                Instant.now().getNano());
    }

    private void addCustomerDetailsToOrder(Quote quote, QuoteDTO quoteDTO, Customer customer) {
        quote.setQuoteCustomer(
                quoteCustomerRepository.save(createQuoteCustomer(customer, quoteDTO.getAddress())));
    }
}

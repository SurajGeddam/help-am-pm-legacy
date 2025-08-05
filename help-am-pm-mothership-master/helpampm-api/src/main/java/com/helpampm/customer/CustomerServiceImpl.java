/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.customer;

import com.helpampm.address.Address;
import com.helpampm.address.AddressException;
import com.helpampm.address.AddressService;
import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.exceptions.UserException;
import com.helpampm.auth.services.AuthenticationService;
import com.helpampm.auth.services.RoleService;
import com.helpampm.auth.services.UserService;
import com.helpampm.common.UnauthorizedException;
import com.helpampm.config.EmailTemplateConfig;
import com.helpampm.customer.dto.CustomerDto;
import com.helpampm.customer.dto.CustomerFilterRequestPayload;
import com.helpampm.customer.dto.PageableCustomerFilterRequestHelper;
import com.helpampm.customer.dto.PageableCustomerResponse;
import com.helpampm.notifications.email.EmailNotificationMessage;
import com.helpampm.notifications.email.EmailNotificationService;
import com.helpampm.provider.dto.ProfileDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import javax.persistence.TypedQuery;
import javax.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class CustomerServiceImpl implements CustomerService {
    private final EmailTemplateConfig emailTemplateConfig;
    private final CustomerRepository repository;
    private final AddressService addressService;
    private final RoleService roleService;
    private final UserService userService;

    private final CustomerHelper customerHelper;
    private final PageableCustomerFilterRequestHelper pageableCustomerFilterRequestHelper;
    private final AuthenticationService authenticationService;
    private final EmailNotificationService emailNotificationService;
    @Value("${customers.number-of-address-allowed}")
    private int numberOfAllowedAddress;
    @Value("${help.company.termAndConditionPageUrl}")
    private String termAndConditionPageUrl;
    @Value("${help.company.logo}")
    private String logo;

    @Transactional
    @Override
    public Customer create(Customer customer) {
        log.info("Creating customer");
        assert Objects.nonNull(customer);
        String uniqueId = customerHelper.createCustomerUniqueId(repository);
        customer.setCustomerUniqueId(uniqueId);
        customer.setCreatedAt(LocalDateTime.now());
        customer.setLastUpdatedAt(LocalDateTime.now());
        setupCustomerLoginCredentials(customer);
        customer.setTotalProviderRatings(0L);
        customer.setAverageProviderRating(0D);
        customer.validate();
        customer = repository.save(customer);
        sendCustomerSignupNotification(customer);
        return customer;
    }

    private void sendCustomerSignupNotification(Customer customer) {
        Map<String, Object> modelData = new HashMap<>();
        modelData.put("name", customer.getFirstName());
        modelData.put("termAndConditionPageUrl", termAndConditionPageUrl);
        modelData.put("logo", logo);
        EmailNotificationMessage emailNotificationMessage = EmailNotificationMessage.builder()
                .withSubject(String.format("HELP: Welcome %s!", customer.getFirstName()))
                .withRecipientEmail(customer.getEmail())
                .withRecipientName(customer.getFirstName())
                .withModelData(modelData)
                .withEmailTemplateName(emailTemplateConfig.getCustomerSignupEmailTemplateName())
                .build();
        emailNotificationService.send(emailNotificationMessage, customer.getEmail());
    }

    private void setupCustomerLoginCredentials(Customer customer) {
        UserLoginDetails userLoginDetails = customer.getUserLoginDetails();
        log.info("Create customer's login credentials with username " + userLoginDetails.getUsername());
        checkDuplicates(userLoginDetails);
        userLoginDetails.setEnabled(true);
        userLoginDetails.setAccountNonExpired(true);
        userLoginDetails.setCredentialsNonExpired(true);
        userLoginDetails.setAccountNonLocked(true);
        userLoginDetails.setRoles(Set.of(roleService
                .findByName("ROLE_CUSTOMER")));
        userLoginDetails.setCustomerUniqueId(customer.getCustomerUniqueId());
        customer.setUserLoginDetails(userService.create(userLoginDetails));
    }

    @Override
    @Transactional
    public Customer update(Customer customer, String customerUniqueId) {
        assert Objects.nonNull(customer);
        assert Objects.nonNull(customer.getId());
        customer.setLastUpdatedAt(LocalDateTime.now());
        populateNullValuesFromPreviousValues(customer, customerUniqueId);
        customer.validate();
        return repository.save(customer);
    }

    private void checkDuplicates(UserLoginDetails userLoginDetails) {
        Optional<UserLoginDetails> oldUser = userService.findByUsername(userLoginDetails.getUsername());
        if (oldUser.isPresent()) {
            throw new UserException("Username already exist, please try with some other username.");
        }
    }

    private void populateNullValuesFromPreviousValues(Customer customer, String customerUniqueId) {
        Optional<Customer> oldCustomer = repository.findByCustomerUniqueId(customerUniqueId);
        oldCustomer.ifPresent(value -> value.copyNonNullValues(customer));
    }

    @Override
    public Customer findById(Long id) {
        return repository.findById(id).orElse(null);
    }

    @Override
    public List<Customer> getAll() {
        return repository.findAll();
    }

    @Override
    @Transactional
    public Address addAddress(String customerUniqueId, Address address) {
        UserLoginDetails userLoginDetails = authenticationService.findLoggedInUser();
        if (Objects.equals(userLoginDetails.getCustomerUniqueId(), customerUniqueId)) {
            Customer customer = repository.findByCustomerUniqueId(customerUniqueId)
                    .orElseThrow(() -> new CustomerException(String.format("Unable to find customer with id {%s} " +
                            "Address can not be added.", customerUniqueId)));
            if (numberOfAllowedAddress == customer.getAddresses().size()) {
                throw new AddressException("You have reached maximum limit of allowed address in your account.", HttpStatus.FORBIDDEN);
            }
            address.setCustomerUniqueId(customer.getCustomerUniqueId());
            address = addressService.save(address);
            if (Objects.isNull(customer.getAddresses())) {
                customer.setAddresses(Set.of());
            }
            customer.getAddresses().add(address);
            repository.save(customer);
            return address;
        }
        throw new UnauthorizedException("Make sure you have enough permissions and logged in to add address.");
    }

    @Override
    @Transactional
    public Address updateAddress(String customerUniqueId, Address address) {
        assert Objects.nonNull(address);
        assert Objects.nonNull(address.getId());
        Customer customer = repository.findByCustomerUniqueId(customerUniqueId)
                .orElseThrow(() -> new CustomerException(String.format("Unable to find customer with customerUniqueId %s. " +
                        "Address can not be updated.", customerUniqueId)));
        Address oldAddress = addressService.findById(address.getId());
        validateAddressIsAttachedToCustomer(customer, oldAddress);
        address = addressService.update(address);
        if (Objects.isNull(customer.getAddresses())) {
            customer.setAddresses(Set.of());
        }
        customer.getAddresses().add(address);
        repository.save(customer);
        return address;
    }

    @Override
    public Customer findByCustomerUniqueId(String customerUniqueId) {
        return repository.findByCustomerUniqueId(customerUniqueId)
                .orElseThrow(() -> new CustomerException(String.format("Unable to find customer with customerUniqueId = %s", customerUniqueId)));
    }

    @Override
    public PageableCustomerResponse findPageableAll(CustomerFilterRequestPayload pageableFilterDto) {
        TypedQuery<Customer> query = pageableCustomerFilterRequestHelper.createExecutableQuery(pageableFilterDto);
        List<Customer> customers = query.getResultList();
        List<CustomerDto> customerDtos = customers.stream()
                .map(CustomerDto::buildWithCustomerDto).collect(Collectors.toList());
        return new PageableCustomerResponse(pageableCustomerFilterRequestHelper.getCountOfAvailableItems(pageableFilterDto), customerDtos);
    }

    @Override
    public Long countCustomer() {
        return repository.count();
    }

    private void validateAddressIsAttachedToCustomer(Customer customer, Address address) {
        if (Objects.isNull(customer.getAddresses()) || !customer.getAddresses().contains(address)) {
            throw new CustomerException("Address does not belong to specified customer. " +
                    "You are not allowed to update.");
        }
    }

    @Override
    @Transactional
    public Customer updateProfile(ProfileDto profileDto) {
        Customer customer = findByCustomerUniqueId(profileDto.getCustomerUniqueId());
        customer.setProfileImagePath(profileDto.getProfilePicture());
        customer.setFirstName(Objects.nonNull(profileDto.getFirstName()) ? profileDto.getFirstName() : customer.getFirstName());
        customer.setLastName(Objects.nonNull(profileDto.getLastName()) ? profileDto.getLastName() : customer.getLastName());
        customer.setPhone(Objects.nonNull(profileDto.getMobileNumber()) ? profileDto.getMobileNumber() : customer.getPhone());
        customer.setIsActive(profileDto.isActive() ? profileDto.isActive() : customer.getIsActive());
        customer.getUserLoginDetails().setEnabled(profileDto.isActive() ? profileDto.isActive() : customer.getIsActive());
        return repository.save(customer);
    }
}

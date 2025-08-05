/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.customer;

import com.helpampm.address.Address;
import com.helpampm.address.AddressService;
import com.helpampm.address.dto.AddressDto;
import com.helpampm.common.GeneralResponse;
import com.helpampm.common.services.FileService;
import com.helpampm.customer.dto.*;
import com.helpampm.provider.dto.ProfileDto;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("customer")
@Tag(name = "Customer Management")
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class CustomerController {
    private final CustomerService service;
    private final AddressService addressService;
    private final FileService fileService;
    @Value("${aws.s3.profile-photos}")
    private String uploadBucket;

    private final PageableCustomerFilterRequestHelper pageableCustomerFilterRequestHelper;

    @PostMapping("signup")
    @Operation(summary = "Customer Signup")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Customer.class)))})
    public ResponseEntity<GeneralResponse> customerSignup(@RequestBody Customer customer) {
        CustomerDto.buildWithCustomerDto(service.create(customer));
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Customer signup success").build());

    }

    @PutMapping("{customerUniqueId}")
    @Secured({"ROLE_CUSTOMER", "ROLE_SUPERADMIN"})
    @Operation(summary = "Update Customer Details")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Customer.class)))})
    public ResponseEntity<GeneralResponse> update(@RequestBody Customer customer, @PathVariable("customerUniqueId") String customerUniqueId) {
        CustomerDto.buildWithCustomerDto(service.update(customer, customerUniqueId));
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Customer update success").build());
    }


    @PostMapping("/pageableCustomer")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "Load customer list as pageable")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = PageableCustomerResponse.class)))})
    public ResponseEntity<PageableCustomerResponse> findPageableAll(@RequestBody CustomerFilterRequestPayload filterRequestPayload) {
        PageableCustomerResponse pageableLeadsResponse = service
                .findPageableAll(pageableCustomerFilterRequestHelper.buildPageableFilterRequest(filterRequestPayload));
        return ResponseEntity.ok(pageableLeadsResponse);
    }

    @PostMapping("{customerUniqueId}/address")
    @Secured({"ROLE_CUSTOMER"})
    @Operation(summary = "Add Customer Address")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Address.class)))})
    public ResponseEntity<GeneralResponse> addAddress(@PathVariable("customerUniqueId") String customerUniqueId,
                                                      @RequestBody Address address) {
        service.addAddress(customerUniqueId, address);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Customer Address added successfully").build());
    }

    @GetMapping("{customerUniqueId}/address")
    @Secured({"ROLE_CUSTOMER"})
    @Operation(summary = "fetch all Customer Address")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Address.class)))})
    public ResponseEntity<List<AddressDto>> allAddress(@PathVariable("customerUniqueId") String customerUniqueId) {
        List<AddressDto> addressDtos = addressService.findByCustomerUniqueId(customerUniqueId).stream().map(AddressDto::buildWithAddress).collect(Collectors.toList());
        return ResponseEntity.ok(addressDtos);
    }

    @PutMapping("{customerUniqueId}/address")
    @Secured({"ROLE_CUSTOMER"})
    @Operation(summary = "Update Customer Address")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Address.class)))})
    public ResponseEntity<GeneralResponse> updateAddress(@PathVariable("customerUniqueId") String customerUniqueId,
                                                         @RequestBody Address address) {
        service.updateAddress(customerUniqueId, address);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value()).withMessage("Customer Updated added successfully").build());

    }

    @GetMapping("")
    @Secured({"ROLE_SUPERADMIN"})
    @Operation(summary = "List all Customers")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(array = @ArraySchema(schema = @Schema(implementation = Customer.class))))})
    public ResponseEntity<List<CustomerDto>> getAll() {
        log.info("Retrieve all customers");
        List<CustomerDto> customerDtos = service.getAll().stream()
                .map(CustomerDto::buildWithCustomerDto).collect(Collectors.toList());
        return ResponseEntity.ok(customerDtos);
    }

    @GetMapping("{customerUniqueId}")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE",
            "ROLE_CUSTOMER"})
    @Operation(summary = "Get Customer by Id")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = Customer.class)))})
    public ResponseEntity<CustomerDto> getById(@PathVariable("customerUniqueId") String customerUniqueId) {
        log.info("Retrieve customer by customerUniqueId " + customerUniqueId);
        return ResponseEntity.ok(CustomerDto.buildWithCustomerDto(service.findByCustomerUniqueId(customerUniqueId)));
    }

    @GetMapping("profile/{customerUniqueId}")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE",
            "ROLE_CUSTOMER"})
    @Operation(summary = "Get Customer by Id")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = ProfileDto.class)))})
    public ResponseEntity<ProfileDto> getCustomerProfileById(@PathVariable("customerUniqueId") String customerUniqueId) {
        log.info("Retrieve customer by customerUniqueId " + customerUniqueId);
        Customer customer = service.findByCustomerUniqueId(customerUniqueId);
        ProfileDto profileDto = ProfileDto.buildWithCustomerDto(customer);
        if (customer.getProfileImagePath() != null) {
            profileDto.setImageBytes(fileService.downloadAsBytes(customer.getProfileImagePath(), uploadBucket));
        }
        return ResponseEntity.ok(profileDto);
    }

    @PutMapping("profile")
    @Secured({"ROLE_CUSTOMER", "ROLE_SUPERADMIN"})
    @Operation(summary = "Update Customer Profile")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = GeneralResponse.class)))})
    public ResponseEntity<CustomerGeneralResponse> updateCustomerProfile(@RequestBody ProfileDto profileDto) {
        Customer customer = service.updateProfile(profileDto);
        CustomerGeneralResponse.CustomerGeneralResponseBuilder customerGeneralResponse = CustomerGeneralResponse.builder();
        if (customer.getProfileImagePath() != null) {
            customerGeneralResponse.withProfilePath(fileService.downloadAsBytes(customer.getProfileImagePath(), uploadBucket));
        }
        return ResponseEntity.ok(customerGeneralResponse
                .withStatus(HttpStatus.OK.value()).withMessage("Customer profile updated successfully").build());
    }
}

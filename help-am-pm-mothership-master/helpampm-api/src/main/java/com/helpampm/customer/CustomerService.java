/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.customer;

import com.helpampm.address.Address;
import com.helpampm.customer.dto.CustomerFilterRequestPayload;
import com.helpampm.customer.dto.PageableCustomerResponse;
import com.helpampm.provider.dto.ProfileDto;

import java.util.List;

/**
 * @author kuldeep
 */
public interface CustomerService {
    Customer create(Customer customer);

    Customer update(Customer customer, String customerUniqueId);

    Customer findById(Long id);

    List<Customer> getAll();

    Address addAddress(String customerUniqueId, Address address);

    Address updateAddress(String customerUniqueId, Address address);

    Customer findByCustomerUniqueId(String customerUniqueId);

    PageableCustomerResponse findPageableAll(CustomerFilterRequestPayload pageableFilterDto);

    Long countCustomer();
    
    Customer updateProfile(ProfileDto profileDto);
}

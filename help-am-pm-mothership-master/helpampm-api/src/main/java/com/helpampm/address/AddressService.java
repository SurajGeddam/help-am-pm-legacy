/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.address;

import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface AddressService {
    Address save(Address address);

    Address update(Address address);

    Address findById(Long id);
    List<Address> findByCustomerUniqueId(String id);
    Optional<Address> findByProviderUniqueId(String uniqueId);
}

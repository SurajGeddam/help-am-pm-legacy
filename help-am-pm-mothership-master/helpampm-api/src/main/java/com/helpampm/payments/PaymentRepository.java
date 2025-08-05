/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.payments;


import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * @author rakesh
 */
public interface PaymentRepository extends JpaRepository<Payment, Long> {
    List<Payment> findAllByProviderUniqueId(String providerUniqueId);

}

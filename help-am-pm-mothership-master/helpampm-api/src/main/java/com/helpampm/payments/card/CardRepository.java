/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.payments.card;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface CardRepository extends JpaRepository<Card, Long> {
    Optional<Card> findByCardNumber(String cardNumber);

    List<Card> findByCustomerUniqueId(String customerUniqueId);
}

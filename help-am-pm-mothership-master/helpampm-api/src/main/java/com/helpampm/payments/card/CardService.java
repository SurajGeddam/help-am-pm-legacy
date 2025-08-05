/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.payments.card;

import java.util.List;

/**
 * @author kuldeep
 */
public interface CardService {
    Card create(Card card);
    void remove(Long id);
    Card getById(Long id);
    Card getByCardNumber(String cardNumber);
    List<Card> getByCustomerUniqueId(String customerUniqueId);
}

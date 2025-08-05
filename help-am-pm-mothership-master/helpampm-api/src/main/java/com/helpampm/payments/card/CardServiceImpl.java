/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.payments.card;

import com.helpampm.customer.CustomerService;
import com.helpampm.payments.PaymentException;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

/**
 * @author kuldeep
 */
@SuppressFBWarnings("EI_EXPOSE_REP2")
@Service
@Slf4j
@RequiredArgsConstructor
public class CardServiceImpl implements CardService {
    private final CardRepository repository;
    private final CustomerService customerService;
    @Override
    public Card create(Card card) {
        card.validate();
        validateCustomer(card.getCustomerUniqueId());
        return repository.save(card);
    }

    private void validateCustomer(String customerId) {
        if(Objects.isNull(customerService.findByCustomerUniqueId(customerId))) {
            throw new PaymentException("Unable to add card, Invalid customer Id");
        }
    }

    @Override
    public void remove(Long id) {
        repository.deleteById(id);
    }

    @Override
    public Card getById(Long id) {
        return repository.findById(id).orElseThrow(() -> new PaymentException("Unable to find card."));
    }

    @Override
    public Card getByCardNumber(String cardNumber) {
        return repository.findByCardNumber(cardNumber).orElseThrow(() -> new PaymentException("Unable to find card."));
    }

    @Override
    public List<Card> getByCustomerUniqueId(String customerUniqueId) {
        return repository.findByCustomerUniqueId(customerUniqueId);
    }
}

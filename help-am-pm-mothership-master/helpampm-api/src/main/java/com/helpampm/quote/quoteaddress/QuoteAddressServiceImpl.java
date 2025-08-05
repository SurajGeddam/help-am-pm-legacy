/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote.quoteaddress;

import com.helpampm.address.AddressException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.util.Objects;
import java.util.Optional;

@Service
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class QuoteAddressServiceImpl implements QuoteAddressService {
    private final QuoteAddressRepository repository;

    @Transactional
    @Override
    public QuoteAddress save(QuoteAddress address) {
        assert Objects.nonNull(address);
        address.validate();
        return repository.save(address);
    }

    @Override
    @Transactional
    public QuoteAddress update(QuoteAddress address) {
        populateNullValuesFromPreviousValues(address);
        address.validate();
        return repository.save(address);
    }

    private void populateNullValuesFromPreviousValues(QuoteAddress address) {
        Optional<QuoteAddress> oldQuoteAddress = repository.findById(address.getId());
        oldQuoteAddress.ifPresent(value -> value.copyNonNullValues(address));
    }

    @Override
    public QuoteAddress findById(Long id) {
        return repository.findById(id)
                .orElseThrow(() -> new AddressException("Unable to find address with id=" + id, HttpStatus.NOT_FOUND));
    }
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.pricing;

import com.helpampm.metadata.timeslot.Timeslot;
import com.helpampm.metadata.timeslot.TimeslotService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;

@Service
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class PricingServiceImpl implements PricingService {
    private final PricingRepository repository;
    private final TimeslotService timeslotService;

    @Override
    @Transactional
    public Pricing create(Pricing pricing) {
        assert Objects.nonNull(pricing);
        pricing.setCreatedAt(LocalDateTime.now());
        pricing.setLastUpdatedAt(LocalDateTime.now());
        pricing.validate();
        return repository.save(pricing);
    }

    @Override
    @Transactional
    public Pricing update(Integer timeslotId, Pricing pricing) {
        assert Objects.nonNull(timeslotId) &&
                Objects.nonNull(pricing) &&
                Objects.nonNull(pricing.getId());
        Timeslot timeslot = timeslotService.findById(timeslotId);
        Pricing oldPricing = timeslot.getPricing();
        pricing.setLastUpdatedAt(LocalDateTime.now());
        oldPricing.copyNonNullValues(pricing);
        pricing.validate();
        pricing = repository.save(pricing);
        timeslotService.update(timeslot);
        return pricing;
    }

    @Override
    public List<Pricing> findAllActive() {
        return repository.findByIsActive(true);
    }

    @Override
    public List<Pricing> findAll() {
        return repository.findAll();
    }

    @Override
    public Pricing findById(Integer id) {
        return repository.findById(id).orElse(null);
    }
}
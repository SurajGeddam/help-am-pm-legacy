/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.timeslot;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class TimeslotServiceImpl implements TimeslotService {
    private final TimeslotRepository repository;

    @Override
    @Transactional
    public List<Timeslot> saveAll(List<Timeslot> timeslots) {
        return repository.saveAll(timeslots);
    }

    @Override
    @Transactional
    public Timeslot create(Timeslot timeslot) {
        assert Objects.nonNull(timeslot);
        timeslot.setCreatedAt(LocalDateTime.now());
        timeslot.setLastUpdatedAt(LocalDateTime.now());
        timeslot.validate();
        return repository.save(timeslot);
    }

    public Optional<Timeslot> findByStartEndTime(Timeslot timeslot) {
        return repository.findByStartTimeAndEndTime(timeslot.getStartTime(), timeslot.getEndTime());
    }

    @Override
    public List<Timeslot> findByIds(List<Integer> timeslotIds) {
        return repository.findAllById(timeslotIds);
    }

    @Override
    @Transactional
    public Timeslot update(Timeslot timeslot) {
        assert Objects.nonNull(timeslot);
        assert Objects.nonNull(timeslot.getId());
        timeslot.setLastUpdatedAt(LocalDateTime.now());
        copyNonNullValues(timeslot);
        timeslot.validate();
        return repository.save(timeslot);
    }

    private void copyNonNullValues(Timeslot timeslot) {
        Optional<Timeslot> oldTimeslot = repository.findById(timeslot.getId());
        oldTimeslot.ifPresent(value -> value.copyNonNullValues(timeslot));
    }

    @Override
    public List<Timeslot> findAll() {
        return repository.findAll();
    }

    @Override
    public Timeslot findById(Integer id) {
        return repository.findById(id).orElse(null);
    }
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.timeslot;

import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface TimeslotRepository extends JpaRepository<Timeslot, Integer> {
    List<Timeslot> findByIsActive(boolean isActive);

    Optional<Timeslot> findByStartTimeAndEndTime(LocalTime startTime, LocalTime endTime);

    Timeslot findByName(String timeslotName);
}

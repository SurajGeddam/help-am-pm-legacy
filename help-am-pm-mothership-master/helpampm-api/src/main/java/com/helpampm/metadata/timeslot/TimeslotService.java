/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.timeslot;

import java.util.List;

/**
 * @author kuldeep
 */
public interface TimeslotService {
    List<Timeslot> saveAll(List<Timeslot> timeslots);

    Timeslot findById(Integer timeslotId);

    Timeslot create(Timeslot timeslot);

    Timeslot update(Timeslot timeslot);

    List<Timeslot> findAll();

    List<Timeslot> findByIds(List<Integer> timeslotIds);
}

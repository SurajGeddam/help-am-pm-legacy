/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.dto;

import com.helpampm.metadata.timeslot.Timeslot;
import lombok.Builder;
import lombok.Data;

import java.time.LocalTime;

@Data
@Builder(setterPrefix = "with")
/*
  @author kuldeep
 */
public class TimeslotDto {
    private int id;
    private String name;
    private LocalTime startTime;
    private LocalTime endTime;

    public static TimeslotDto buildWithTimeslot(Timeslot category) {
        return TimeslotDto.builder().withId(category.getId())
                .withName(category.getName())
                .withEndTime(category.getEndTime())
                .withStartTime(category.getStartTime())
                .build();
    }
}

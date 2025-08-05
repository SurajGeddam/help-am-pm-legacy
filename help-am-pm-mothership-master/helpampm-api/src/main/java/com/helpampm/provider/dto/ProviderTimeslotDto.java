/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.dto;

import com.helpampm.provider.bankaccount.timeslots.ProviderTimeslot;
import lombok.Builder;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalTime;

@Data
@Builder(setterPrefix = "with")
/*
  @author kuldeep
 */
public class ProviderTimeslotDto implements Serializable {
    private int id;
    private String name;
    private LocalTime startTime;
    private LocalTime endTime;
    private Integer categoryId;

    public static ProviderTimeslotDto buildWithProviderTimeslot(ProviderTimeslot timeslot) {
        return ProviderTimeslotDto.builder().withId(timeslot.getId())
                .withName(timeslot.getName())
                .withEndTime(timeslot.getEndTime())
                .withCategoryId(timeslot.getId())
                .withStartTime(timeslot.getStartTime())
                .build();
    }
}

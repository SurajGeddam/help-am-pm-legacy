/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.provider.bankaccount.timeslots;

import com.helpampm.metadata.pricing.Pricing;
import com.helpampm.metadata.timeslot.Timeslot;
import com.helpampm.metadata.timeslot.TimeslotException;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Data;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Objects;

/**
 * @author kuldeep
 */
@SuppressFBWarnings({"EI_EXPOSE_REP"})
@Entity
@Table(name = "tb_provider_timeslots")
@Data
public class ProviderTimeslot {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;

    @Column(name = "slot_name")
    private String name;
    @Column(name = "start_time")
    private LocalTime startTime;
    @Column(name = "end_time")
    private LocalTime endTime;
    @Column(name = "is_active")
    private Boolean isActive;
    @OneToOne(cascade = CascadeType.MERGE, fetch = FetchType.EAGER, orphanRemoval = true)
    private Pricing pricing;

    @Column(name = "category_id")
    private Integer categoryId;
    @Column(name = "create_at")
    private LocalDateTime createdAt;
    @Column(name = "last_updated_at")
    private LocalDateTime lastUpdatedAt;

    public void validate() {
        if (Objects.isNull(startTime) || Objects.isNull(endTime)) {
            throw new TimeslotException("Timeslot start and end time must be present");
        }
        if (Objects.isNull(name) || Objects.equals("", name.trim())) {
            throw new TimeslotException("Timeslot name can't be null or empty.");
        }
    }

    public void copyNonNullValues(Timeslot timeslot) {
        if (Objects.isNull(timeslot.getStartTime())) {
            timeslot.setStartTime(startTime);
        }
        if (Objects.isNull(timeslot.getEndTime())) {
            timeslot.setEndTime(endTime);
        }
        if (Objects.isNull(timeslot.getCreatedAt())) {
            timeslot.setCreatedAt(createdAt);
        }
        if (Objects.isNull(timeslot.getIsActive())) {
            timeslot.setIsActive(isActive);
        }
        if (Objects.isNull(timeslot.getName()) || Objects.equals("", timeslot.getName().trim())) {
            timeslot.setName(name);
        }
    }
    public static ProviderTimeslot from(Timeslot timeslot) {
        ProviderTimeslot providerTimeslot = new ProviderTimeslot();
        providerTimeslot.setName(timeslot.getName());
        providerTimeslot.setStartTime(timeslot.getStartTime());
        providerTimeslot.setEndTime(timeslot.getEndTime());
        providerTimeslot.setIsActive(true);
        providerTimeslot.setPricing(timeslot.getPricing());
        providerTimeslot.setCreatedAt(LocalDateTime.now());
        providerTimeslot.setLastUpdatedAt(LocalDateTime.now());
        return providerTimeslot;
    }
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.dto;

import com.helpampm.provider.vehicle.Vehicle;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@Data
@Builder(setterPrefix = "with")
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class VehicleDto implements Serializable {
    private long id;
    private String model;
    private String vin;
    private String numberPlate;
    private String providerUniqueId;

    public static VehicleDto buildWithVehicle(Vehicle vehicle) {
        return VehicleDto.builder().withId(vehicle.getId())
                .withModel(vehicle.getModel())
                .withVin(vehicle.getVin())
                .withNumberPlate(vehicle.getNumberPlate())
                .withProviderUniqueId(vehicle.getProviderUniqueId())
                .build();
    }
}

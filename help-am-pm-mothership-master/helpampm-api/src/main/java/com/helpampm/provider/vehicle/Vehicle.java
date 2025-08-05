/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.vehicle;

import com.helpampm.provider.insurance.Insurance;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Data;
import org.springframework.http.HttpStatus;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Objects;

@Entity
@Data
@Table(name = "tb_vehicles")
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class Vehicle implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "manufacturer")
    private String manufacturer;
    @Column(name = "model")
    private String model;
    @Column(name = "vin")
    private String vin;
    @Column(name = "year_of_making")
    private Integer yearOfMaking;
    @Column(name = "number_plate")
    private String numberPlate;
    @OneToOne(fetch = FetchType.EAGER, cascade = CascadeType.MERGE,
            targetEntity = Insurance.class, orphanRemoval = true)
    @JoinColumn(name = "insurance")
    private Insurance insurance;
    @Column(name = "provider_unique_id")
    private String providerUniqueId;
    @Column(name = "is_active")
    private Boolean isActive;

    @Column(name = "create_at")
    private LocalDateTime createdAt;
    @Column(name = "last_updated_at")
    private LocalDateTime lastUpdatedAt;

    public void validate() {
        if (Objects.isNull(manufacturer) || Objects.equals("", manufacturer.trim())) {
            throw new VehicleException("Manufactures can not be null or empty", HttpStatus.BAD_REQUEST);
        }
        if (Objects.isNull(model) || Objects.equals("", model.trim())) {
            throw new VehicleException("Model can not be null or empty", HttpStatus.BAD_REQUEST);
        }
//        if (Objects.isNull(yearOfMaking)) {
//            throw new VehicleException("Year of making can not be null or empty", HttpStatus.BAD_REQUEST);
//        }
        if (Objects.isNull(numberPlate) || Objects.equals("", numberPlate.trim())) {
            throw new VehicleException("Number plate can not be null or empty", HttpStatus.BAD_REQUEST);
        }
        if (Objects.isNull(providerUniqueId) || Objects.equals("", providerUniqueId.trim())) {
            throw new VehicleException("Provider Unique Id can not be null or empty", HttpStatus.BAD_REQUEST);
        }
        if (Objects.isNull(isActive)) {
            isActive = true;
        }
        if (Objects.nonNull(insurance)) {
            insurance.validate();
        }
    }

    public void copyNonNullValues(Vehicle vehicle) {
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Vehicle vehicle = (Vehicle) o;
        if (!numberPlate.equals(vehicle.numberPlate)) return false;
        return providerUniqueId.equals(vehicle.providerUniqueId);
    }

    @Override
    public int hashCode() {
        int result = numberPlate.hashCode();
        result = 31 * result + providerUniqueId.hashCode();
        return result;
    }
}
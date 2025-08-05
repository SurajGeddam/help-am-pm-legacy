/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.livelocation;

import com.helpampm.provider.ProviderException;
import lombok.Data;
import org.springframework.http.HttpStatus;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Objects;

@Data
@Entity
@Table(name = "tb_provider_locations")

/*
  @author kuldeep
 */
public class Location {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "provide_id")
    private String providerUniqueId;
    @Column(name = "latitude")
    private Double latitude;
    @Column(name = "longitude")
    private Double longitude;
    @Column(name = "altitude")
    private Double altitude;
    @Column(name = "landmark")
    private String landmark;

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    void validate() {
        if (Objects.isNull(latitude) || Objects.isNull(longitude)) {
            throw new ProviderException("Provider's location not captured. " +
                    "latitude and longitude are mandatory fields", HttpStatus.NOT_FOUND);
        }
    }

    public void copy(Location location) {
        altitude = location.getAltitude();
        landmark = location.getLandmark();
        latitude = location.getLatitude();
        longitude = location.getLongitude();
        providerUniqueId = location.getProviderUniqueId();
        createdAt = LocalDateTime.now();
    }
}

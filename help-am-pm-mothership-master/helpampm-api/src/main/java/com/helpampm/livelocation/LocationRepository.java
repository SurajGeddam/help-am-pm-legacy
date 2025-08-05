/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.livelocation;


import org.springframework.data.jpa.repository.JpaRepository;

/**
 * @author kuldeep
 */
public interface LocationRepository extends JpaRepository<Location, Long> {
    Location findByProviderUniqueId(String provideId);
}

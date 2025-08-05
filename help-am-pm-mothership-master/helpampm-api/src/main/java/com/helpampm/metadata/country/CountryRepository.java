/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.country;

import org.springframework.data.jpa.repository.JpaRepository;

/**
 * @author ajay
 */
public interface CountryRepository extends JpaRepository<Country, Long> {
    
	public Country findByCode(String code);
}

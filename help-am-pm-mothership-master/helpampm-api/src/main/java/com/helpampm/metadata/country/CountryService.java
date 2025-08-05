/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.country;

import java.util.List;

/**
 * @author ajay
 */
public interface CountryService {

    List<Country> getAll();

	Country create(Country customer);
    Country update(Country customer);


}

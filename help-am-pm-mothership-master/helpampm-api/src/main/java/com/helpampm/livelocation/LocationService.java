/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.livelocation;

import java.util.List;

/**
 * @author kuldeep
 */
public interface LocationService {
    Location save(Location location);

    List<Location> findAll();
}

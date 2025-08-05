/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.services;

import com.helpampm.auth.entities.Role;

/**
 * @author kuldeep
 */
public interface RoleService {
    Role create(Role role);

    Role findByName(String roleName);
}

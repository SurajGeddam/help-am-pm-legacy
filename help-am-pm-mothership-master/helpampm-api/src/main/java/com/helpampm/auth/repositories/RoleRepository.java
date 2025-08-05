/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.repositories;

import com.helpampm.auth.entities.Role;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

/**
 * @author kuldeep
 */
public interface RoleRepository extends JpaRepository<Role, Integer> {
    Optional<Role> findByName(String roleName);
}

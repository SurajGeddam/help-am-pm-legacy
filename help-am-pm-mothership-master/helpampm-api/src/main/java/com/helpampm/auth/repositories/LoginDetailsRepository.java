/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.repositories;

import com.helpampm.auth.entities.UserLoginDetails;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

/**
 * @author kuldeep
 */
public interface LoginDetailsRepository extends JpaRepository<UserLoginDetails, Long> {
    Optional<UserLoginDetails> findByUsername(String username);
}

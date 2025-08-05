/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.services;

import com.helpampm.auth.entities.UserLoginDetails;
import org.springframework.security.core.userdetails.UserDetailsService;

import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface UserService extends UserDetailsService {
    Optional<UserLoginDetails> findByUsername(String username);

    UserLoginDetails create(UserLoginDetails userLoginDetails);

    UserLoginDetails update(UserLoginDetails userLoginDetails);

    List<UserLoginDetails> findAll();
}

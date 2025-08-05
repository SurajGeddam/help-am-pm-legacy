/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.repositories;

import com.helpampm.auth.entities.RefreshToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * @author kuldeep
 */
@Repository
public interface RefreshTokenRepository extends JpaRepository<RefreshToken, Long> {
    Optional<RefreshToken> findByToken(String token);
    RefreshToken findByUsername(String username);
}
/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.services;

import com.helpampm.auth.entities.RefreshToken;

import javax.transaction.Transactional;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface RefreshTokenService {
    Optional<RefreshToken> findByToken(String token);

    @Transactional
    RefreshToken createRefreshToken(String username);

    void verifyExpiration(RefreshToken token, String username);
}

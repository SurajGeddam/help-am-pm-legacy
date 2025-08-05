/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.services;

import com.helpampm.auth.entities.RefreshToken;
import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.exceptions.TokenRefreshException;
import com.helpampm.auth.repositories.LoginDetailsRepository;
import com.helpampm.auth.repositories.RefreshTokenRepository;
import com.helpampm.auth.security.jwt.JwtTokenGenerator;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Objects;
import java.util.Optional;

@Service
@Slf4j
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class RefreshTokenServiceImpl implements RefreshTokenService {
    private final JwtTokenGenerator jwtTokenGenerator;
    private final RefreshTokenRepository refreshTokenRepository;
    private final LoginDetailsRepository loginDetailsRepository;
    @Value("${security.refresh_token.expires}")
    private Long tokenExpiryInMinutes;

    public RefreshTokenServiceImpl(final RefreshTokenRepository refreshTokenRepository,
                                   final JwtTokenGenerator jwtTokenGenerator,
                                   final LoginDetailsRepository loginDetailsRepository) {
        this.jwtTokenGenerator = jwtTokenGenerator;
        this.refreshTokenRepository = refreshTokenRepository;
        this.loginDetailsRepository = loginDetailsRepository;
    }

    @Override
    public Optional<RefreshToken> findByToken(String token) {
        return refreshTokenRepository.findByToken(token);
    }

    @Transactional
    @Override
    public RefreshToken createRefreshToken(String username) {
        UserLoginDetails userLoginDetails = loginDetailsRepository.findByUsername(username).orElseThrow(() -> new UsernameNotFoundException("Unable to find user."));
        try {
            RefreshToken refreshToken = new RefreshToken();
            RefreshToken oldRefreshToken = refreshTokenRepository.findByUsername(userLoginDetails.getUsername());
            if (Objects.nonNull(oldRefreshToken)) {
                refreshToken = oldRefreshToken;
            }
            refreshToken.setToken(jwtTokenGenerator.generate(userLoginDetails, true));
            refreshToken.setExpiryDate(LocalDateTime.now().plus(tokenExpiryInMinutes, ChronoUnit.MINUTES));
            refreshToken.setUsername(userLoginDetails.getUsername());
            return refreshTokenRepository.save(refreshToken);
        } catch (Exception e) {
            throw new TokenRefreshException(e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }

    @Override
    public void verifyExpiration(RefreshToken token, String username) {
        if (token.getExpiryDate().compareTo(LocalDateTime.now()) < 0) {
            throw new TokenRefreshException("Refresh token was expired. Please make a new signin request", HttpStatus.UNAUTHORIZED);
        }
        RefreshToken oldToken = refreshTokenRepository.findByUsername(username);
        if(oldToken == null || !Objects.equals(token.getToken(), oldToken.getToken())) {
            throw new TokenRefreshException("Request token is not valid.", HttpStatus.UNAUTHORIZED);
        }
    }
}
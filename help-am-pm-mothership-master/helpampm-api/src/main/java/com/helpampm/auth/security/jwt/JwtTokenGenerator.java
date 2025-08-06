/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.security.jwt;

import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.helpers.SecurityCertificatesManager;
import io.jsonwebtoken.Jwts;
import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;
import java.util.UUID;

@Log4j2
@Component
/*
  @author kuldeep
 */
public class JwtTokenGenerator {
    private static final String USERNAME = "username";
    private static final String ROLES = "roles";
    private final SecurityCertificatesManager securityCertificatesManager;
    private final int tokenExpiryInMinutes;


    public JwtTokenGenerator(final SecurityCertificatesManager securityCertificatesManager,
                             @Value("${security.token.expires}") int tokenExpiryInMinutes) {
        this.tokenExpiryInMinutes = tokenExpiryInMinutes;
        this.securityCertificatesManager = securityCertificatesManager;
    }

    public String generate(UserLoginDetails userLoginDetails, boolean isRefreshToken) throws NoSuchAlgorithmException, InvalidKeySpecException {
        Instant now = Instant.now();
        log.info("Generating security tokens");
        
        // Get the private key
        java.security.PrivateKey privateKey = securityCertificatesManager.getPrivateKey();
        
        return isRefreshToken

                ? Jwts.builder()
                .claim("isRefreshToken", true)
                .signWith(privateKey, io.jsonwebtoken.SignatureAlgorithm.RS256)
                .setSubject(userLoginDetails.getUsername())
                .setIssuedAt(Date.from(now))
                .setExpiration(Date.from(now.plus(tokenExpiryInMinutes, ChronoUnit.MINUTES)))
                .compact()

                : Jwts.builder()
                .claim(USERNAME, userLoginDetails.getUsername())
                .claim(ROLES, userLoginDetails.getRoles())
                .claim("isRefreshToken", false)
                .signWith(privateKey, io.jsonwebtoken.SignatureAlgorithm.RS256)
                .setSubject(userLoginDetails.getUsername())
                .setId(UUID.randomUUID().toString())
                .setIssuedAt(Date.from(now))
                .setExpiration(Date.from(now.plus(tokenExpiryInMinutes, ChronoUnit.MINUTES)))
                .compact();
    }
}

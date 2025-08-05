/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.security.jwt;

import com.helpampm.auth.helpers.SecurityCertificatesManager;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.Jwts;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.security.NoSuchAlgorithmException;
import java.security.PublicKey;
import java.security.spec.InvalidKeySpecException;

@Component
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class JwtTokenParser {
    private final SecurityCertificatesManager securityCertificatesManager;

    public Jws<Claims> parseJwt(String jwtToken) throws InvalidKeySpecException, NoSuchAlgorithmException {
        PublicKey publicKey = securityCertificatesManager.getPublicKey();
        return Jwts.parserBuilder()
                .setSigningKey(publicKey)
                .build()
                .parseClaimsJws(jwtToken);
    }
}

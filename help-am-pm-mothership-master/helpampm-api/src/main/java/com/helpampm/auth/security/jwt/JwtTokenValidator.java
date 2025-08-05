/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.security.jwt;

import com.helpampm.auth.exceptions.InvalidCredentialsException;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;

@Component
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class JwtTokenValidator {
    private final JwtTokenParser jwtTokenParser;

    public void validate(String jwtToken) {
        try {
            Jws<Claims> jwt = jwtTokenParser.parseJwt(jwtToken);
            if (!StringUtils.hasText(jwt.getBody().getSubject())) {
                throw new InvalidCredentialsException("User Token is not valid. Help: Check if token is expired or tempered", HttpStatus.UNAUTHORIZED);
            }
        } catch (InvalidKeySpecException | NoSuchAlgorithmException e) {
            throw new InvalidCredentialsException("Could not validate Json Token. " + e.getMessage(), HttpStatus.BAD_REQUEST);
        }
    }
}

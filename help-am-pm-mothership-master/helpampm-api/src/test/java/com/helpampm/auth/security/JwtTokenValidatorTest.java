package com.helpampm.auth.security;

import com.helpampm.auth.exceptions.InvalidCredentialsException;
import com.helpampm.auth.security.jwt.JwtTokenParser;
import com.helpampm.auth.security.jwt.JwtTokenValidator;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;

import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

@Slf4j
class JwtTokenValidatorTest {
    private final JwtTokenParser jwtTokenParser = mock(JwtTokenParser.class);
    private JwtTokenValidator tokenValidator;

    @BeforeEach
    public void setup() {
        tokenValidator = new JwtTokenValidator(jwtTokenParser);
    }

    @Test
    void validate() {
        try {
            Jws<Claims> claims = mock(Jws.class);
            when(jwtTokenParser.parseJwt(anyString())).thenReturn(claims);
            //tokenValidator.validate("eyJhbGciOiJub25lIn0.eyJ1c2VybmFtZSI6InN1cGVyYWRtaW4iLCJyb2xlcyI6W3siaWQiOjEsIm5hbWUiOiJST0xFX1NVUEVSQURNSU4iLCJhdXRob3JpdHkiOiJST0xFX1NVUEVSQURNSU4ifV0sImlzUmVmcmVzaFRva2VuIjpmYWxzZSwic3ViIjoic3VwZXJhZG1pbiIsImp0aSI6IjM3Y2I0MDgxLWI2MmUtNDYwNi1iZWY3LWU0OGVlNjk2NjUyYSIsImlhdCI6MTY3MDAwNTIxMSwiZXhwIjoxNjcwMDA4ODExfQ.");
        } catch (InvalidCredentialsException | InvalidKeySpecException | NoSuchAlgorithmException exception) {
            log.error(exception.getMessage());
        }
    }

    @Test
    void validate_1() {
        try {
            Jws<Claims> claims = mock(Jws.class);
            Claims body = mock(Claims.class);
            when(body.getSubject()).thenReturn("");
            when(claims.getBody()).thenReturn(body);
            when(jwtTokenParser.parseJwt(anyString())).thenReturn(claims);
            tokenValidator.validate("eyJhbGciOiJub25lIn0.eyJ1c2VybmFtZSI6InN1cGVyYWRtaW4iLCJyb2xlcyI6W3siaWQiOjEsIm5hbWUiOiJST0xFX1NVUEVSQURNSU4iLCJhdXRob3JpdHkiOiJST0xFX1NVUEVSQURNSU4ifV0sImlzUmVmcmVzaFRva2VuIjpmYWxzZSwic3ViIjoic3VwZXJhZG1pbiIsImp0aSI6IjM3Y2I0MDgxLWI2MmUtNDYwNi1iZWY3LWU0OGVlNjk2NjUyYSIsImlhdCI6MTY3MDAwNTIxMSwiZXhwIjoxNjcwMDA4ODExfQ.");
        } catch (InvalidCredentialsException | InvalidKeySpecException | NoSuchAlgorithmException exception) {
            log.error(exception.getMessage());
        }
    }

    @Test
    void validate_2() {
        try {
            Jws<Claims> claims = mock(Jws.class);
            Claims body = mock(Claims.class);
            when(body.getSubject()).thenReturn("testsubject");
            when(body.get("isRefreshToken")).thenReturn("true");
            when(claims.getBody()).thenReturn(body);
            when(jwtTokenParser.parseJwt(anyString())).thenReturn(claims);
            tokenValidator.validate("eyJhbGciOiJub25lIn0.eyJ1c2VybmFtZSI6InN1cGVyYWRtaW4iLCJyb2xlcyI6W3siaWQiOjEsIm5hbWUiOiJST0xFX1NVUEVSQURNSU4iLCJhdXRob3JpdHkiOiJST0xFX1NVUEVSQURNSU4ifV0sImlzUmVmcmVzaFRva2VuIjpmYWxzZSwic3ViIjoic3VwZXJhZG1pbiIsImp0aSI6IjM3Y2I0MDgxLWI2MmUtNDYwNi1iZWY3LWU0OGVlNjk2NjUyYSIsImlhdCI6MTY3MDAwNTIxMSwiZXhwIjoxNjcwMDA4ODExfQ.");
        } catch (InvalidCredentialsException | InvalidKeySpecException | NoSuchAlgorithmException exception) {
            log.error(exception.getMessage());
        }
    }
}
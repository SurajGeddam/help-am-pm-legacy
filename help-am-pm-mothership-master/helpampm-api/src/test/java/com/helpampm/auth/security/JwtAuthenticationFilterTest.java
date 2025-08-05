package com.helpampm.auth.security;

import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.security.jwt.JwtAuthenticationFilter;
import com.helpampm.auth.security.jwt.JwtTokenParser;
import com.helpampm.auth.security.jwt.JwtTokenValidator;
import com.helpampm.auth.services.UserService;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.impl.DefaultClaims;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.security.core.AuthenticationException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.util.List;

import static org.mockito.Mockito.*;

class JwtAuthenticationFilterTest {

    private final JwtTokenValidator jwtTokenValidator = mock(JwtTokenValidator.class);
    private final UserService userService = mock(UserService.class);
    private final JwtTokenParser jwtTokenParser = mock(JwtTokenParser.class);
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    @BeforeEach
    public void setup() {
        this.jwtAuthenticationFilter = new JwtAuthenticationFilter(this.jwtTokenValidator, this.userService,
                jwtTokenParser,
                List.of("auth/token", "hello/greet"));
    }

    @Test
    void shouldNotFilter() {
        HttpServletRequest request = mock(HttpServletRequest.class);
        when(request.getRequestURI()).thenReturn("auth/token");
        Assertions.assertTrue(jwtAuthenticationFilter.shouldNotFilter(request));
    }

    @Test
    void shouldNotFilter_negative() {
        HttpServletRequest request = mock(HttpServletRequest.class);
        when(request.getRequestURI()).thenReturn("secured/token");
        Assertions.assertFalse(jwtAuthenticationFilter.shouldNotFilter(request));
    }

    @Test
    void doFilterInternal() throws InvalidKeySpecException, NoSuchAlgorithmException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        FilterChain filterChain = mock(FilterChain.class);
        Jws claims = mock(Jws.class);
        when(request.getHeader(anyString())).thenReturn("Bearer eyJhbGciOiJub25lIn0.eyJ1c2VybmFtZSI6InN1cGVyYWRtaW4iLCJyb2xlcyI6W3siaWQiOjEsIm5hbWUiOiJST0xFX1NVUEVSQURNSU4iLCJhdXRob3JpdHkiOiJST0xFX1NVUEVSQURNSU4ifV0sImlzUmVmcmVzaFRva2VuIjpmYWxzZSwic3ViIjoic3VwZXJhZG1pbiIsImp0aSI6ImNjNjg0MjA1LTZhZWUtNDU3My1iZThkLTBiMmRmM2MyNzczOCIsImlhdCI6MTY3MDAwNTIxMSwiZXhwIjoxNjcwMDA4ODExfQ.");
        when(jwtTokenParser.parseJwt(anyString())).thenReturn(claims);
        Claims claim = new DefaultClaims();
        claim.setSubject("kdmalviyan");
        when(claims.getBody()).thenReturn(claim);
        when(userService.loadUserByUsername(anyString())).thenReturn(new UserLoginDetails());
        try {
            jwtAuthenticationFilter.doFilterInternal(request, response, filterChain);
        } catch (ServletException | IOException e) {
            throw new RuntimeException(e);
        }
    }

    @Test
    void commence() throws IOException {
        HttpServletRequest request = mock(HttpServletRequest.class);
        HttpServletResponse response = mock(HttpServletResponse.class);
        AuthenticationException authException = mock(AuthenticationException.class);
        ServletOutputStream outputStream = mock(ServletOutputStream.class);
        when(authException.getMessage()).thenReturn("Unit test case");
        when(response.getOutputStream()).thenReturn(outputStream);
        jwtAuthenticationFilter.commence(request, response, authException);
    }
}
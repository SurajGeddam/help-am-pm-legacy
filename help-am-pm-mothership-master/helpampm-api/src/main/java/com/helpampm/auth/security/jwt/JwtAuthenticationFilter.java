/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.security.jwt;


import com.fasterxml.jackson.databind.ObjectMapper;
import com.helpampm.auth.exceptions.InvalidCredentialsException;
import com.helpampm.auth.services.UserService;
import com.helpampm.common.UnauthorizedException;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jws;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.AuthenticationEntryPoint;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Component
@Slf4j
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class JwtAuthenticationFilter extends OncePerRequestFilter implements AuthenticationEntryPoint {
    private static final String AUTHENTICATION_HEADER = "Authorization";
    private static final String BEARER = "Bearer ";
    private final UserService userService;
    private final List<String> publicUrls;
    private final JwtTokenValidator jwtTokenValidator;

    private final JwtTokenParser jwtTokenParser;

    public JwtAuthenticationFilter(final JwtTokenValidator jwtTokenValidator,
                                   final UserService userService,
                                   final JwtTokenParser jwtTokenParser,
                                   @Value("#{'${public.urls}'.split(',')}") final List<String> publicUrls) {
        this.jwtTokenValidator = jwtTokenValidator;
        this.userService = userService;
        this.publicUrls = publicUrls;
        this.jwtTokenParser = jwtTokenParser;
    }

    @Override
    public boolean shouldNotFilter(HttpServletRequest request) {
        for (String publicUrl : publicUrls) {
            if (request.getRequestURI().startsWith(publicUrl)) {
                return true;
            }
        }
        return false;
    }

    @Override
    public void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain) throws ServletException, IOException {
        String jwtToken = getJwtTokenFromRequest(request);
        try {
            jwtTokenValidator.validate(jwtToken);
            setAuthenticationContext(request, jwtToken);
        } catch (ExpiredJwtException ex) {
            String requestURL = request.getRequestURL().toString();
            // allow for Refresh Token creation if following conditions are true.
            if (requestURL.contains("refreshtoken")) {
                allowForRefreshToken(ex, request);
            } else
                request.setAttribute("exception", ex);
        }
        filterChain.doFilter(request, response);
    }

    private void setAuthenticationContext(HttpServletRequest request, String jwtToken) {
        String username = getUserNameFromJwtToken(jwtToken);
        UserDetails userDetails = userService.loadUserByUsername(username);
        validateActiveUser(userDetails);
        UsernamePasswordAuthenticationToken token = new UsernamePasswordAuthenticationToken(
                userDetails, null, userDetails.getAuthorities());
        token.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
        SecurityContextHolder.getContext().setAuthentication(token);
    }

    private void validateActiveUser(UserDetails userDetails) {
        if (!userDetails.isEnabled()) {
            throw new UnauthorizedException(userDetails.getUsername() + " is inactive, please talk to admin.");
        }
    }

    private String getUserNameFromJwtToken(String jwtToken) {
        try {
            Jws<Claims> claims = jwtTokenParser.parseJwt(jwtToken);
            return claims.getBody().getSubject();
        } catch (InvalidKeySpecException | NoSuchAlgorithmException e) {
            throw new InvalidCredentialsException("Parse token failed", HttpStatus.EXPECTATION_FAILED);
        }
    }

    private String getJwtTokenFromRequest(HttpServletRequest request) {
        String bearerToken = request.getHeader(AUTHENTICATION_HEADER);
        if (StringUtils.hasText(bearerToken) && bearerToken.startsWith(BEARER)) {
            return bearerToken.substring(7);
        }
        log.info("Error for  URL {}", request.getRequestURL());
        throw new InvalidCredentialsException("Bearer token can not be null", HttpStatus.UNAUTHORIZED);
    }

    private void allowForRefreshToken(ExpiredJwtException ex, HttpServletRequest request) {

        // create a UsernamePasswordAuthenticationToken with null values.
        UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken = new UsernamePasswordAuthenticationToken(
                null, null, null);
        // After setting the Authentication in the context, we specify
        // that the current user is authenticated. So it passes the
        // Spring Security Configurations successfully.
        SecurityContextHolder.getContext().setAuthentication(usernamePasswordAuthenticationToken);
        // Set the claims so that in controller we will be using it to create
        // new JWT
        request.setAttribute("claims", ex.getClaims());
    }

    @Override
    public void commence(HttpServletRequest request,
                         HttpServletResponse response,
                         AuthenticationException authException)
            throws IOException {
        log.error("Unauthorized error: {}", authException.getMessage());

        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);

        final Map<String, Object> body = new HashMap<>();
        body.put("status", HttpServletResponse.SC_UNAUTHORIZED);
        body.put("error", "Unauthorized");
        body.put("message", authException.getMessage());
        body.put("path", request.getServletPath());

        final ObjectMapper mapper = new ObjectMapper();
        mapper.writeValue(response.getOutputStream(), body);
    }
}

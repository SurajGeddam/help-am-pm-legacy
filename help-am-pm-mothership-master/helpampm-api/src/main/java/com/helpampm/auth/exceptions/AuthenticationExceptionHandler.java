/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.exceptions;

import com.helpampm.common.ExceptionDto;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
/*
  @author kuldeep
 */
public class AuthenticationExceptionHandler {

    @ExceptionHandler(RoleException.class)
    public ResponseEntity<ExceptionDto> handle(RoleException exception) {
        return ResponseEntity.badRequest().body(ExceptionDto.builder().message("Role not found. " + exception.getMessage()).status(400).build());
    }

    @ExceptionHandler(UserException.class)
    public ResponseEntity<ExceptionDto> handle(UserException exception) {
        return ResponseEntity.badRequest().body(ExceptionDto.builder().message(exception.getMessage()).status(400).build());
    }

    @ExceptionHandler(UserDisabledException.class)
    public ResponseEntity<ExceptionDto> handle(UserDisabledException exception) {

        return ResponseEntity.badRequest().body(ExceptionDto.builder().message("User is disabled. " + exception.getMessage()).status(400).build());
    }

    @ExceptionHandler(TokenRefreshException.class)
    public ResponseEntity<ExceptionDto> handle(TokenRefreshException exception) {
        return ResponseEntity.badRequest().body(ExceptionDto.builder().message("Unable to refresh token. " + exception.getMessage()).status(400).build());
    }

    @ExceptionHandler(UsernameNotFoundException.class)
    public ResponseEntity<ExceptionDto> handle(UsernameNotFoundException exception) {
        return ResponseEntity.badRequest().body(ExceptionDto.builder().message("User not found. " + exception.getMessage()).status(400).build());
    }
}

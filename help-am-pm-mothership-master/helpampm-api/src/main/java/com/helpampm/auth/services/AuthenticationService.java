/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.services;

import com.helpampm.auth.dtos.ChangePasswordPayload;
import com.helpampm.auth.dtos.ResetPasswordPayload;
import com.helpampm.auth.entities.RefreshToken;
import com.helpampm.auth.entities.UserLoginDetails;

import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;

/**
 * @author kuldeep
 */
public interface AuthenticationService {
    String generateToken(String username, String password, String loginSource) throws NoSuchAlgorithmException, InvalidKeySpecException;

    UserLoginDetails changePassword(ChangePasswordPayload passwordPayload);

    String generateTokenWithRefreshToken(String username, RefreshToken refreshToken);

    UserLoginDetails findLoggedInUser();

    String sendForgotPasswordOTP(String emailUsername);

    UserLoginDetails resetPassword(ResetPasswordPayload requestPayload);
}

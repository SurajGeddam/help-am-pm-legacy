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
import com.helpampm.auth.exceptions.InvalidCredentialsException;
import com.helpampm.auth.exceptions.UserDisabledException;
import com.helpampm.auth.exceptions.UserException;
import com.helpampm.auth.security.jwt.JwtTokenGenerator;
import com.helpampm.common.StringUtils;
import com.helpampm.common.UnauthorizedException;
import com.helpampm.customer.Customer;
import com.helpampm.customer.CustomerException;
import com.helpampm.customer.CustomerRepository;
import com.helpampm.notifications.email.EmailNotificationService;
import com.helpampm.notifications.entities.OneTimePassword;
import com.helpampm.notifications.enums.OTPPurpose;
import com.helpampm.notifications.helper.OTPGenerator;
import com.helpampm.notifications.services.OTPService;
import com.helpampm.notifications.sms.SMSNotificationService;
import com.helpampm.provider.Provider;
import com.helpampm.provider.ProviderService;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.time.LocalDateTime;
import java.util.Objects;

@Service
@RequiredArgsConstructor
@Slf4j
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class AuthenticationServiceImpl implements AuthenticationService {
    private final String LOGIN_SOURCE_BROWSER = "browser";
    private final UserService userService;
    private final AuthenticationManager authenticationManager;
    private final JwtTokenGenerator jwtTokenGenerator;
    private final RefreshTokenServiceImpl refreshTokenServiceImpl;
    private final BCryptPasswordEncoder bCryptPasswordEncoder;
    private final EmailNotificationService emailNotificationService;
    private final SMSNotificationService smsNotificationService;
    private final CustomerRepository customerRepository;
    private final ProviderService providerService;
    private final OTPService otpService;
    private final OTPGenerator otpGenerator;

    private static boolean isRoleSuperadmin(UserLoginDetails userLoginDetails) {
        return userLoginDetails.getRoles().stream()
                .anyMatch(r -> Objects.equals("ROLE_SUPERADMIN", r.getName()));
    }

    @Override
    public String generateToken(String username, String password, String loginSource)
            throws NoSuchAlgorithmException, InvalidKeySpecException {
        UserDetails userDetails = userService.loadUserByUsername(username);
        UserLoginDetails userLoginDetails = (UserLoginDetails) userDetails;
        if(Objects.nonNull(userLoginDetails.getCustomerUniqueId())
                && Objects.equals(LOGIN_SOURCE_BROWSER, loginSource)) {
            log.info("Customer trying to login from browser");
            throw new InvalidCredentialsException("Customer is not allowed from browser, please use mobile app.", HttpStatus.EXPECTATION_FAILED);
        }
        log.info("Validating user found in database");
        // check user found or not
        checkUserFoundAndNotDisabled(username, userDetails);
        log.info("User is valid");
        UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(username, password);
        log.info("Authenticating user");
        Authentication authentication = authenticationManager.authenticate(authenticationToken);
        log.info("User authenticated");
        SecurityContextHolder.getContext().setAuthentication(authentication);
        return (jwtTokenGenerator.generate((UserLoginDetails) userDetails, false));
    }

    private void checkUserFoundAndNotDisabled(String username, UserDetails userDetails) {
        if (userDetails == null) {
            throw new UsernameNotFoundException("Username " + username + " not found");
        } else {
            if (!userDetails.isEnabled()) {
                throw new UserDisabledException("User account is disabled, please check with your admin team.");
            }
        }
    }

    @Override
    public String generateTokenWithRefreshToken(String username, RefreshToken refreshToken) {
        refreshTokenServiceImpl.verifyExpiration(refreshToken, username);
        UserDetails userDetails = userService.loadUserByUsername(username);
        log.info("Validating user found in database");
        // check user found or not
        checkUserFoundAndNotDisabled(username, userDetails);
        try {
            return jwtTokenGenerator.generate((UserLoginDetails) userDetails, false);
        } catch (NoSuchAlgorithmException | InvalidKeySpecException e) {
            throw new InvalidCredentialsException("Either no Algorithm found for signing token or provided key is invalid", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    public UserLoginDetails findLoggedInUser() {
        try {
            return (UserLoginDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        } catch (Exception e) {
            log.error("Unable to find loggedin user");
        }
        return null;
    }

    @Override
    public UserLoginDetails changePassword(ChangePasswordPayload passwordPayload) {
        UserLoginDetails loggedInUser = findLoggedInUser();
        if (Objects.isNull(loggedInUser)) {
            throw new UserException("You need to login before " +
                    "changing password or please try forget password!");
        }
        if (!Objects.equals(loggedInUser.getUsername(), passwordPayload.getUsername())) {
            throw new UserException("Unable to complete the request. " +
                    "Please make sure you are tyring to change your own password!");
        }
        if (Objects.equals(passwordPayload.getNewPassword(), passwordPayload.getOldPassword())) {
            throw new UserException("Old and new password can't be same!");
        }
        UsernamePasswordAuthenticationToken usernamePasswordAuthenticationToken =
                new UsernamePasswordAuthenticationToken(passwordPayload.getUsername(),
                        passwordPayload.getOldPassword());
        try {
            authenticationManager.authenticate(usernamePasswordAuthenticationToken);
            loggedInUser.setPassword(bCryptPasswordEncoder.encode(passwordPayload.getNewPassword()));
            return userService.update(loggedInUser);
        } catch (Exception e) {
            throw new UserException(e.getMessage() + ". Your old password is invalid!");
        }
    }

    @Override
    public String sendForgotPasswordOTP(String username) {
        UserLoginDetails userLoginDetails = userService.findByUsername(username).orElseThrow(() ->
                new UserException("Unable to find username, please try with correct username."));
        String otp;
        if (isRoleSuperadmin(userLoginDetails)) {
        	otp = otpGenerator.generateOTP();
        	emailNotificationService.sendForgotPasswordEmail(username, userLoginDetails.getUsername(), "Superadmin", otp);
        } else if (Objects.nonNull(userLoginDetails.getCustomerUniqueId())) {
            otp = sendCustomerForgetPasswordOtp(userLoginDetails);
        } else {
            otp = sendProviderForgetPasswordOtp(userLoginDetails);
        }
        return otp;
    }

    @Override
    public UserLoginDetails resetPassword(ResetPasswordPayload requestPayload) {
        UserLoginDetails userLoginDetails = userService.findByUsername(requestPayload.getUsername())
                .orElseThrow(() -> new UserException("Unable to find username, " +
                        "please try with correct username."));
        OneTimePassword oneTimePassword = otpService.findByUsernameAndValueAndIsUsedAndType(
                requestPayload.getUsername(), requestPayload.getOtp(), false, OTPPurpose.FORGOT_PASSWORD);
        if (Objects.isNull(oneTimePassword)
                || LocalDateTime.now().isAfter(oneTimePassword.getExpiresAt())
                || Boolean.TRUE.equals(oneTimePassword.getIsUsed())) {
            throw new UserException("Unable to reset password, either you entered wrong otp or otp is expired.");
        }
        userLoginDetails.setPassword(bCryptPasswordEncoder.encode(requestPayload.getPassword()));
        otpService.markOTPUsed(oneTimePassword.getId());
        return userService.update(userLoginDetails);

    }

    private String sendProviderForgetPasswordOtp(UserLoginDetails userLoginDetails) {
        Provider provider = providerService.findByProviderUniqueId(userLoginDetails.getProviderUniqueId());
        String otp = otpGenerator.generateOTP();
        if (Boolean.TRUE.equals(provider.isEmailNotificationEnabled())) {
            emailNotificationService.sendForgotPasswordEmail(userLoginDetails.getUsername(),
                    provider.getEmail(), StringUtils.capitalize(provider.getName()), otp);
        }
        if (Boolean.TRUE.equals(provider.isSmsNotificationEnabled())) {
            smsNotificationService.sendForgotPasswordSms(provider.getPhone(),
                    StringUtils.capitalize(provider.getName()), otp, userLoginDetails.getUsername());
        }
        return otp;
    }

    private String sendCustomerForgetPasswordOtp(UserLoginDetails userLoginDetails) {
        String otp = otpGenerator.generateOTP();
        Customer customer = customerRepository.findByCustomerUniqueId(userLoginDetails.getCustomerUniqueId())
                .orElseThrow(() -> new CustomerException("Customer not found."));
        if (customer.isEmailNotificationEnabled()) {
            emailNotificationService.sendForgotPasswordEmail(userLoginDetails.getUsername(),
                    customer.getEmail(),
                    StringUtils.capitalize(customer.getFirstName())
                            + " "
                            + StringUtils.capitalize(customer.getLastName()), otp);
        }
        if (Boolean.TRUE.equals(customer.isSmsNotificationEnabled())) {
            smsNotificationService.sendForgotPasswordSms(customer.getPhone(),
                    StringUtils.capitalize(customer.getFirstName())
                            + " "
                            + StringUtils.capitalize(customer.getLastName()), otp, userLoginDetails.getUsername());
        }
        return otp;
    }
}

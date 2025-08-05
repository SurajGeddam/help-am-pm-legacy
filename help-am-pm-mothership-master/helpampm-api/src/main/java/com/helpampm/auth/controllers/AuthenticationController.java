/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.controllers;

import com.helpampm.account.DeleteAccountRequestService;
import com.helpampm.address.Address;
import com.helpampm.auth.dtos.*;
import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.exceptions.UserException;
import com.helpampm.auth.services.AuthenticationService;
import com.helpampm.auth.services.RefreshTokenServiceImpl;
import com.helpampm.auth.services.UserService;
import com.helpampm.common.GeneralResponse;
import com.helpampm.common.HelpConstants;
import com.helpampm.common.StringUtils;
import com.helpampm.common.services.FileService;
import com.helpampm.customer.Customer;
import com.helpampm.customer.CustomerService;
import com.helpampm.notifications.services.MobileDeviceService;
import com.helpampm.provider.Provider;
import com.helpampm.provider.ProviderService;
import com.helpampm.provider.ProviderStripeAccountHelper;
import com.stripe.model.Account;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.nio.charset.StandardCharsets;
import java.security.NoSuchAlgorithmException;
import java.security.spec.InvalidKeySpecException;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

@SuppressFBWarnings("EI_EXPOSE_REP2")
@RestController
@RequestMapping(value = "auth")
@Slf4j
@RequiredArgsConstructor
@Tag(name = "Authentication")
/*
  @author kuldeep
 */
public class AuthenticationController {
    private final AuthenticationService authenticationService;
    private final RefreshTokenServiceImpl refreshTokenServiceImpl;
    private final UserService userService;
    private final ProviderService providerService;
    private final CustomerService customerService;
    private final MobileDeviceService mobileDeviceService;
    private final ProviderStripeAccountHelper providerStripeAccountHelper;
    private final DeleteAccountRequestService deleteAccountRequestService;
    private final FileService fileService;

    @Value("${security.token.expires}")
    private Long tokenExpiryInMinutes;
    @Value("${aws.s3.profile-photos}")
    private String profileBucket;

    @PostMapping("/token")
    @Operation(summary = "Generate a new token")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = AuthResponseDto.class)))})
    public ResponseEntity<AuthResponseDto> generateToken(
            @RequestParam(required = false, name = "loginSource") String loginSource,
            @RequestBody CredentialsPayload credentials) throws NoSuchAlgorithmException, InvalidKeySpecException {
        log.info("Token generation starts");
        AuthResponseDto.AuthResponseDtoBuilder builder = AuthResponseDto.builder();
        builder.withToken(authenticationService
                .generateToken(credentials.getUsername(), credentials.getPassword(), loginSource));
        AuthResponseDto response = getAuthResponseDto(credentials.getUsername(), builder);
        deleteAccountRequestService.delete(credentials.getUsername());
        log.info("Token generated successfully");
        return ResponseEntity.ok(response);
    }

    private AuthResponseDto getAuthResponseDto(String username, AuthResponseDto.AuthResponseDtoBuilder builder) {
        builder.withExpiryDate(LocalDateTime.now().plus(tokenExpiryInMinutes, ChronoUnit.MINUTES));
        UserLoginDetails userLoginDetails = userService.findByUsername(username).orElseThrow(() -> new UserException("User not found"));
        UserDetailsDto userDetailsDto = UserDetailsDto.buildWithUserDetails(userLoginDetails);
        builder.withRefreshToken(RefreshTokenDto
                .buildWithRefreshToken(refreshTokenServiceImpl.createRefreshToken(username)));
        //provider uniqueId
        if (userLoginDetails.getProviderUniqueId() != null) {
            Provider provider = providerService.findByProviderUniqueId(userLoginDetails.getProviderUniqueId());
            userDetailsDto.setCompanyUniqueId(StringUtils.setDefaultString(provider.getCompanyUniqueId()));
            userDetailsDto.setParentCompanyUniqueId(StringUtils.setDefaultString(provider.getParentCompanyUniqueId()));
            builder.withAccountSetupCompleted(provider.getAccountSetupCompleted());
            builder.withStripeSetupDone(provider.isStripeSetupDone());
            userDetailsDto.setEmail(provider.getEmail());
            userDetailsDto.setName(provider.getName());
            userDetailsDto.setPhone(provider.getPhone());
            userDetailsDto.setProfileBytes(!StringUtils.isNullOrEmpty(provider.getProfileImagePath()) ?
                    fileService.downloadAsBytes(provider.getProfileImagePath(), profileBucket) : "".getBytes(StandardCharsets.UTF_8));
            userDetailsDto.setProfilePicture(provider.getProfileImagePath() != null ? provider.getProfileImagePath() : "");
            builder.withCompletedPage(provider.getLastCompletedPage() == null ? "" : provider.getLastCompletedPage().getName());
            builder.withCategories(provider.getCategories()
                    .stream().map(c -> c.getName().charAt(0))
                    .collect(Collectors.toList()));
        } else if (userLoginDetails.getCustomerUniqueId() != null) {
            Customer customer = customerService.findByCustomerUniqueId(userLoginDetails.getCustomerUniqueId());
            userDetailsDto.setEmail(customer.getEmail());
            //set user address
            userDetailsDto.setUserAddress(customer.getAddresses().stream().filter(Address::isDefault).findFirst().orElse(null));
            String name = StringUtils.setDefaultString(customer.getFirstName()) + " " + StringUtils.setDefaultString(customer.getLastName());
            userDetailsDto.setName(name);
            userDetailsDto.setProfileBytes(!StringUtils.isNullOrEmpty(customer.getProfileImagePath()) ?
                    fileService.downloadAsBytes(customer.getProfileImagePath(), profileBucket) : "".getBytes());
            userDetailsDto.setProfilePicture(customer.getProfileImagePath() != null ? customer.getProfileImagePath() : "");
            userDetailsDto.setPhone(customer.getPhone());
        } else {
            userDetailsDto.setCompanyUniqueId("");
            userDetailsDto.setParentCompanyUniqueId("");
        }
        builder.withRole(userDetailsDto.getAuthority());
        builder.withUsername(userDetailsDto.getUsername());
        builder.withUserDetailsDto(userDetailsDto);
        return builder.build();
    }

    @PostMapping("/refreshtoken")
    @Operation(summary = "Generate a refresh token")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = AuthResponseDto.class)))})
    public ResponseEntity<AuthResponseDto> generateTokenWithRefreshToken(@RequestBody CredentialsPayload credentialsPayload) {
        log.info("Token generation with refresh token");
        AuthResponseDto.AuthResponseDtoBuilder builder = AuthResponseDto.builder();
        builder.withToken(authenticationService.
                generateTokenWithRefreshToken(credentialsPayload.getUsername(),
                        credentialsPayload.getRefreshToken()));
        AuthResponseDto response = getAuthResponseDto(credentialsPayload.getUsername(), builder);
        return ResponseEntity.ok(response);
    }

    @PutMapping("password/change")
    @Operation(summary = "Change password")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = UserLoginDetails.class)))})
    public ResponseEntity<UserLoginDetails> changePassword(@RequestBody ChangePasswordPayload passwordPayload) {
        log.info("Changing password for " + passwordPayload.getUsername());
        return ResponseEntity.ok(authenticationService.changePassword(passwordPayload));
    }

    @GetMapping("password/forgot/{username}")
    @Operation(summary = "Send forgot password OTP")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation", content = @Content(schema = @Schema(implementation = String.class)))})
    public ResponseEntity<GeneralResponse> forgotPassword(@PathVariable("username") String username) {
        log.info("Sending password reset OTP for " + username);
        String otp = authenticationService.sendForgotPasswordOTP(username);
        System.out.println("otp:" + otp);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(HttpStatus.OK.value())
                .withMessage(otp).build());
    }

    @PutMapping("password/reset")
    @Operation(summary = "Reset password with OTP")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = UserLoginDetails.class)))})
    public ResponseEntity<UserLoginDetails> resetPassword(@RequestBody ResetPasswordPayload requestPayload) {
        log.info("Resetting password for " + requestPayload.getUsername());
        return ResponseEntity.ok(authenticationService.resetPassword(requestPayload));
    }

    @GetMapping(value = "profile")
    public ResponseEntity<UserDetailsDto> fetchCurrentUserDetails() {

        UserDetailsDto details = UserDetailsDto.buildWithUserDetails(authenticationService.findLoggedInUser());
        if (!StringUtils.isNullOrEmpty(details.getProviderUniqueId())) {
            Provider provider = providerService.findByProviderUniqueId(details.getProviderUniqueId());
            details.setCompanyUniqueId(provider.getCompanyUniqueId());
        }
        return ResponseEntity.ok(details);
    }

    @DeleteMapping("/logout/{username}")
    @Operation(summary = "Log-out user")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = GeneralResponse.class)))})
    public ResponseEntity<GeneralResponse> logOut(@RequestParam String deviceId,
                                                  @PathVariable("username") String username) {
        mobileDeviceService.deleteByDeviceIdAndUserName(deviceId, username);
        return ResponseEntity.ok(GeneralResponse.builder().withStatus(200).
                withMessage("Logged-out Successfully!").build());

    }

    @GetMapping("/provider/refreshUrl")
    @Operation(summary = "Refresh URL link")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = GeneralResponse.class)))})
    public ResponseEntity<?> refreshProviderAccountLinkUrl(
            @RequestParam("stripeAccountId") String stripeAccountId,
            @RequestParam("providerUniqueId") String providerUniqueId,
            @RequestParam("hash") String secretHash) {

        Provider provider = providerService.findByProviderUniqueId(providerUniqueId);
        //validate provider hash
        providerService.validateProviderStripeSecretHash(provider, secretHash);

        Map<String, Object> modelData = providerStripeAccountHelper.sendAccountLinkOnRefreshUrl(stripeAccountId, provider, "refresh");
        return ResponseEntity.ok(modelData);

    }

    @GetMapping("/provider/returnUrl")
    @Operation(summary = "Return URL link")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "202", description = "successful operation",
                    content = @Content(schema = @Schema(implementation = GeneralResponse.class)))})
    public ResponseEntity<?> returnProviderAccountLinkUrl(
            @RequestParam("stripeAccountId") String stripeAccountId,
            @RequestParam("providerUniqueId") String providerUniqueId,
            @RequestParam("hash") String secretHash) {


        Provider provider = providerService.findByProviderUniqueId(providerUniqueId);
        //validate provider hash
        providerService.validateProviderStripeSecretHash(provider, secretHash);

        Account account = providerStripeAccountHelper.retrieveAccount(stripeAccountId);
        Map<String, Object> data = new HashMap<>();

        // verify all fields are filled and no pending errors
        if (account.getFutureRequirements().getErrors().isEmpty() &&
                account.getRequirements().getErrors().isEmpty() &&
                account.getRequirements().getCurrentlyDue().isEmpty()
                && account.getFutureRequirements().getCurrentlyDue().isEmpty()) {
            //no pending changes from Stripe account
            provider.setAccountSetupCompleted(true);
            provider.setStripeSetupDone(true);
            providerService.updateProvider(provider);
            data.put("status", HelpConstants.COMPLETE);
            data.put("message", "We're excited to have you get started. Your account is now linked to Stripe for payments.");
            return ResponseEntity.ok(data);
        }

        // Pending errors in process , Resend link for completing the stripe form
        data = providerStripeAccountHelper.sendAccountLinkOnRefreshUrl(stripeAccountId, provider, "incomplete");
        data.put("status", HelpConstants.INPROCESS);
        data.put("message", "Verification process Incomplete ,You need to fill all required values so we have sent you mail" +
                " for completing the process.");
        return ResponseEntity.ok(data);
    }

    @GetMapping("delete/{username}")
    public ResponseEntity<DeleteAccountResponseDto> deleteAccount(@PathVariable("username") String username) {
        return ResponseEntity
                .accepted()
                .body(DeleteAccountResponseDto
                        .buildFrom(deleteAccountRequestService.save(username)));
    }

}


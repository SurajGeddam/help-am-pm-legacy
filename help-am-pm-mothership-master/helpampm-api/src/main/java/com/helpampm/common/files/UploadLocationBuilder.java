/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.common.files;

import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.services.AuthenticationService;
import com.helpampm.common.services.FileException;
import com.helpampm.customer.Customer;
import com.helpampm.customer.CustomerService;
import com.helpampm.provider.Provider;
import com.helpampm.provider.ProviderService;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * @author kuldeep
 */
@SuppressFBWarnings("EI_EXPOSE_REP2")
@Component
@Slf4j
@RequiredArgsConstructor
public class UploadLocationBuilder {
    private final AuthenticationService authenticationService;
    private final ProviderService providerService;
    private final CustomerService customerService;

    public String createFileUploadLocation(final FileUploadModel fileUploadModel) {
        UserLoginDetails userLoginDetails = authenticationService.findLoggedInUser();
        if(Objects.nonNull(userLoginDetails.getProviderUniqueId())) {
            return createProviderFileUploadLocation(fileUploadModel,
                    providerService.findByProviderUniqueId(userLoginDetails.getProviderUniqueId()));
        } else if(Objects.nonNull(userLoginDetails.getCustomerUniqueId())) {
            return createCustomerFileUploadLocation(fileUploadModel,
                    customerService.findByCustomerUniqueId(userLoginDetails.getCustomerUniqueId()));
        }
        throw new FileException("Invalid user or user not allowed to upload file");
    }

    private String createCustomerFileUploadLocation(FileUploadModel fileUploadModel, Customer customer) {
        StringBuilder location = new StringBuilder("customers/");
        String username = customer.getUserLoginDetails().getUsername();
        switch (fileUploadModel.getPurpose()) {
            case USER_PROFILE -> location.append(username).append("/profile/");
            case CUSTOMER_ORDER -> location.append(username).append("/order/");
            default -> throw new FileException("Invalid file upload purpose");
        }
        return location.append(fileUploadModel.getFileName()).toString();
    }

    private String createProviderFileUploadLocation(FileUploadModel fileUploadModel, Provider provider) {
        StringBuilder location = new StringBuilder("providers/");
        String username = provider.getUserLoginDetails().getUsername();
        switch (fileUploadModel.getPurpose()) {
            case PROVIDER_INSURANCE -> location.append(username).append("/insurance/");
            case PROVIDER_LICENSE -> location.append(username).append("/license/");
            case USER_PROFILE -> location.append(username).append("/profile/");
            default -> throw new FileException("Invalid file upload purpose");
        }

        return location.append(fileUploadModel.getFileName()).toString();
    }
}

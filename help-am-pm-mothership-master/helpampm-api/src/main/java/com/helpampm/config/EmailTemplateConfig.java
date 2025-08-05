/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * @author kuldeep
 */
@Configuration
@ConfigurationProperties(prefix = "notifications.email")
@Data
public class EmailTemplateConfig {
    private String providerCancelOrderTemplateName;
    private String customerCancelOrderTemplateName;
    private String customerOrderAcceptedTemplateName;
    private String paymentReceivedNotifyCustomer;
    private String forgotTemplateName;
    private String createOrderProviderTemplateName;
    private String createOrderCustomerTemplateName;
    private String invoiceTemplateName;
    private String otpTemplateName;
    private String fromEmail;
    private String customerSignupEmailTemplateName;
    private String providerSignupEmailTemplateName;
    private String providerAccountSetupReminderTemplateName;
    private String providerAccountIncompleteTemplate;
}

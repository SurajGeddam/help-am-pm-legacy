/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.email;

import com.helpampm.common.StringUtils;
import com.helpampm.invoicing.pdfgenerator.ThymeleafProcessor;
import com.helpampm.notifications.entities.Notification;
import com.helpampm.notifications.entities.OneTimePassword;
import com.helpampm.notifications.enums.NotificationType;
import com.helpampm.notifications.enums.OTPPurpose;
import com.helpampm.notifications.enums.OTPTarget;
import com.helpampm.notifications.helper.NotificationHelper;
import com.helpampm.notifications.repositories.NotificationRepository;
import com.helpampm.notifications.services.OTPService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Slf4j
@RequiredArgsConstructor
@Service
/*
  @author kuldeep
 */
public class EmailNotificationService {
    private static final ExecutorService executorService = Executors.newFixedThreadPool(5);
    private final JavaMailSender emailSender;
    private final ThymeleafProcessor thymeleafProcessor;
    private final OTPService otpService;
    private final NotificationRepository notificationRepository;

    @Value("${notifications.email.from-email}")
    private String fromEmail;
    @Value("${notifications.email.forgot-template-name}")
    private String forgetPasswordEmailTemplateName;
    @Value("${help.app-admin-host}")
    private String helpAdminUIHost;
    @Value("${notifications.otp.valid-duration}")
    private int otpValidDuration;

    public void send(EmailNotificationMessage notificationMessage, String recipient) {
        log.debug("Sending email notification to user {}", recipient);
        MimeMessage mimeMessage = emailSender.createMimeMessage();
        try {
            if (StringUtils.isNullOrEmpty(recipient)) {
                log.error("Empty Recipients for sending email ");
                throw new RuntimeException("Empty Recipients");
            }
            MimeMessageHelper mimeMessageHelper = new MimeMessageHelper(mimeMessage, true);
            mimeMessageHelper.setSubject(notificationMessage.getSubject());
            mimeMessageHelper.setFrom(fromEmail);
            mimeMessageHelper.setTo(notificationMessage.getRecipientEmail());
            String emailBody = geContentFromTemplate(notificationMessage);
            mimeMessageHelper.setText(emailBody, true);
            emailSender.send(mimeMessageHelper.getMimeMessage());
            // Create and Save notification Data into Database
            log.debug("Creating system notification: email");
            Notification notification = NotificationHelper.createNotification(notificationMessage.getRecipientEmail(), Objects.toString(notificationMessage.getModelData()), NotificationType.EMAIL);
            notificationRepository.save(notification);
            log.debug("System notification saved: email");
        } catch (Exception e) {
            if (log.isDebugEnabled()) {
                e.printStackTrace();
            }
            log.warn(e.getMessage());
        }
        log.debug(String.format("Notification Sent to %s", recipient));
    }


    private String geContentFromTemplate(EmailNotificationMessage notificationMessage) {
        String content = "";
        try {
            content = thymeleafProcessor.process(notificationMessage.getEmailTemplateName(), notificationMessage.getModelData());
        } catch (Exception e) {
            log.error("Unable to process themeleaf email template.");
            e.printStackTrace();
        }
        return content;
    }

    public void sendForgotPasswordEmail(String username, String email, String name, String otp) {
        EmailNotificationMessage emailNotificationMessage = EmailNotificationMessage.builder()
                .withRecipientEmail(email)
                .withRecipientName(name)
                .withSubject("HELP: Forget password")
                .withEmailTemplateName(forgetPasswordEmailTemplateName)
                .withModelData(Map.of(
                        "name", name,
                        "purpose", StringUtils.capitalize(OTPPurpose.FORGOT_PASSWORD.getName()),
                        "otp", otp,
                        "validDuration", otpValidDuration,
                        "host", helpAdminUIHost)).build();
        executorService.submit(() -> {
            send(emailNotificationMessage, email);
            saveOneTimePasswordToDatabase(username, otp);
            saveNotificationToDatabase(username, emailNotificationMessage);
        });
    }

    private void saveOneTimePasswordToDatabase(String username, String otp) {
        OneTimePassword oneTimePassword = new OneTimePassword();
        oneTimePassword.setExpiresAt(LocalDateTime.now().plus(otpValidDuration, ChronoUnit.MINUTES));
        oneTimePassword.setValue(otp);
        oneTimePassword.setIsUsed(false);
        oneTimePassword.setType(OTPPurpose.FORGOT_PASSWORD);
        oneTimePassword.setTarget(OTPTarget.EMAIL);
        oneTimePassword.setUsername(username);
        otpService.save(oneTimePassword);
    }

    private void saveNotificationToDatabase(String username, EmailNotificationMessage emailNotificationMessage) {
        Notification notification = emailNotificationMessage.toNotification();
        notification.setUsername(username);
        notification.setCreatedAt(LocalDateTime.now());
        notification.setLastUpdateAt(LocalDateTime.now());
        notification.validate();
        notificationRepository.save(notification);
    }
}

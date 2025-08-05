/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.notifications.entities;

import com.helpampm.notifications.NotificationException;
import com.helpampm.notifications.enums.OTPPurpose;
import com.helpampm.notifications.enums.OTPTarget;
import lombok.Data;
import org.springframework.util.StringUtils;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Objects;

@Entity
@Table(name = "tb_otp")
@Data
/*
  @author kuldeep
 */
public class OneTimePassword implements Serializable, Comparable<OneTimePassword> {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;
    @Column(name = "otp_value")
    private String value;
    @Enumerated(EnumType.STRING)
    @Column(name = "otp_sent_through")
    private OTPTarget target;
    @Enumerated(EnumType.STRING)
    @Column(name = "otp_purpose")
    private OTPPurpose type;
    @Column(name = "username")
    private String username;
    @Column(name = "otp_is_used")
    private Boolean isUsed;
    @Column(name = "expires_at")
    private LocalDateTime expiresAt;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
    @Column(name = "last_updated_at")
    private LocalDateTime lastUpdateAt;


    @Override
    public int compareTo(OneTimePassword otp) {
        return this.id.compareTo(otp.id);
    }

    public void validate() {
        if (Objects.isNull(value) || !StringUtils.hasText(value)) {
            throw new NotificationException("OTP value can not null or empty.");
        }
        if (Objects.isNull(target)) {
            throw new NotificationException("Target can not null or empty.");
        }
        if (Objects.isNull(type)) {
            throw new NotificationException("Type can not null or empty.");
        }
        if (Objects.isNull(username) || !StringUtils.hasText(username)) {
            throw new NotificationException("username can not null or empty.");
        }
        if (Objects.isNull(expiresAt)) {
            throw new NotificationException("OTP expire time can not be null.");
        }
        if (Objects.isNull(createdAt)) {
            createdAt = LocalDateTime.now();
        }
        if (Objects.isNull(isUsed)) {
            isUsed = false;
        }
    }
}

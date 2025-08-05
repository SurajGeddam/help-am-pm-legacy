/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.info.entities;

import com.helpampm.metadata.info.MetadataException;
import lombok.Data;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Objects;

@Entity
@Table(name = "tb_support_info")
@Data
/*
  @author kuldeep
 */
public class HelpAndSupport {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "help_email")
    private String helpEmail;
    @Column(name = "help_phone")
    private String helpPhone;
    @Column(name = "help_alternate_phone")
    private String helpAlternatePhone;
    @Column(name = "is_active")
    private Boolean isActive;

    @Column(name = "create_at")
    private LocalDateTime createdAt;
    @Column(name = "last_updated_at")
    private LocalDateTime lastUpdatedAt;

    public void validate() {
        if (Objects.isNull(helpEmail) || Objects.equals("", helpEmail.trim())) {
            throw new MetadataException("Email can not be null or empty");
        }

        if (Objects.isNull(helpPhone) || Objects.equals("", helpPhone.trim())) {
            throw new MetadataException("Phone can not be null or empty");
        }
    }

    public void copyNonNullValues(HelpAndSupport helpAndSupport) {
        if (Objects.isNull(helpAndSupport.getHelpEmail())) {
            helpAndSupport.setHelpEmail(helpEmail);
        }
        if (Objects.isNull(helpAndSupport.getHelpPhone())) {
            helpAndSupport.setHelpPhone(helpPhone);
        }
        if (Objects.isNull(helpAndSupport.getHelpAlternatePhone())) {
            helpAndSupport.setHelpAlternatePhone(helpAlternatePhone);
        }
        if (Objects.isNull(helpAndSupport.getIsActive())) {
            helpAndSupport.setIsActive(isActive);
        }
        if (Objects.isNull(helpAndSupport.getCreatedAt())) {
            helpAndSupport.setCreatedAt(createdAt);
        }
    }
}

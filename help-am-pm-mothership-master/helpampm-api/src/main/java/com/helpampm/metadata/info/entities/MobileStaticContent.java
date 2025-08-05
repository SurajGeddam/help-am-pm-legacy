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

@Data
@Entity
@Table(name = "tb_mobile_static_content")
/*
  @author kuldeep
 */
public class MobileStaticContent {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;
    //Format: pageName_field_name
    @Column(name = "content_key")
    private String key;
    @Column(name = "content_value")
    private String value;

    // applied on value only
    @Column(name = "lang_code")
    private String langCode;

    @Column(name = "create_at")
    private LocalDateTime createdAt;
    @Column(name = "last_updated_at")
    private LocalDateTime lastUpdatedAt;

    public void validate() {
        if (Objects.isNull(key) || Objects.equals("", key.trim())) {
            throw new MetadataException("Key can not be null or empty");
        }
        if (Objects.isNull(value) || Objects.equals("", value.trim())) {
            throw new MetadataException("Value can not be null or empty");
        }
        if (Objects.isNull(langCode) || Objects.equals("", langCode.trim())) {
            throw new MetadataException("Please provide the language code, like US_EN, IN_HI");
        }
    }

    public void copyNonNullValues(MobileStaticContent mobileStaticContent) {
        if (Objects.isNull(mobileStaticContent.getKey())) {
            mobileStaticContent.setKey(key);
        }
        if (Objects.isNull(mobileStaticContent.getValue())) {
            mobileStaticContent.setValue(value);
        }
        if (Objects.isNull(mobileStaticContent.getCreatedAt())) {
            mobileStaticContent.setCreatedAt(createdAt);
        }
        if (Objects.isNull(mobileStaticContent.getLangCode())) {
            mobileStaticContent.setLangCode(langCode);
        }
    }
}

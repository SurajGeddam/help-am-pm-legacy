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
@Table(name = "tb_faqs")
@Data
/*
  @author kuldeep
 */
public class FAQ {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    @Column(name = "question")
    private String question;
    @Column(name = "answer")
    private String answer;
    @Column(name = "is_active")
    private Boolean isActive;
    @Column(name = "lang_code")
    private String langCode;

    @Column(name = "create_at")
    private LocalDateTime createdAt;
    @Column(name = "last_updated_at")
    private LocalDateTime lastUpdatedAt;

    public void validate() {
        if (Objects.isNull(question) || Objects.equals("", question.trim())) {
            throw new MetadataException("Question text can not be null");
        }
        if (Objects.isNull(answer) || Objects.equals("", answer.trim())) {
            throw new MetadataException("Question text can not be null");
        }
        if (Objects.isNull(langCode) || Objects.equals("", langCode.trim())) {
            throw new MetadataException("Please provide the language code, like US_EN, IN_HI");
        }
    }

    public void copyNonNullValues(FAQ faq) {
        if (Objects.isNull(faq.getQuestion())) {
            faq.setQuestion(question);
        }
        if (Objects.isNull(faq.getAnswer())) {
            faq.setAnswer(answer);
        }
        if (Objects.isNull(faq.getIsActive())) {
            faq.setIsActive(true);
        }
        if (Objects.isNull(faq.getIsActive())) {
            faq.setIsActive(isActive);
        }
        if (Objects.isNull(faq.getCreatedAt())) {
            faq.setCreatedAt(createdAt);
        }
        if (Objects.isNull(faq.getLangCode())) {
            faq.setLangCode(langCode);
        }
    }
}

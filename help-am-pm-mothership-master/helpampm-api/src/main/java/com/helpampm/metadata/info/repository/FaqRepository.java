/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.info.repository;

import com.helpampm.metadata.info.entities.FAQ;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface FaqRepository extends JpaRepository<FAQ, Integer> {
    List<FAQ> findByIsActiveAndLangCode(boolean isActive, String langCode);

    Optional<FAQ> findByQuestion(String question);
}

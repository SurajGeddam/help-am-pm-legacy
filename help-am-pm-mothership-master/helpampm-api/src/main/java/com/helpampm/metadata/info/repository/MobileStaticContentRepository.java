/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.info.repository;

import com.helpampm.metadata.info.entities.MobileStaticContent;
import org.springframework.data.jpa.repository.JpaRepository;

/**
 * @author kuldeep
 */
public interface MobileStaticContentRepository extends JpaRepository<MobileStaticContent, Long> {
    MobileStaticContent findByKeyAndLangCode(String key, String langCode);
}

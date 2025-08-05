/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.info.repository;

import com.helpampm.metadata.info.entities.HelpAndSupport;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * @author kuldeep
 */
public interface HelpAndSupportRepository extends JpaRepository<HelpAndSupport, Integer> {
    List<HelpAndSupport> findByIsActive(boolean isActive);

    HelpAndSupport findByHelpEmailAndHelpPhone(String email, String phone);

}

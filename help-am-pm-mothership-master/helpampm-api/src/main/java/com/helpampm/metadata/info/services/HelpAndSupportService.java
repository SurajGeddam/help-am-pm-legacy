/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.info.services;

import com.helpampm.metadata.info.entities.HelpAndSupport;

import java.util.List;

/**
 * @author kuldeep
 */
public interface HelpAndSupportService {
    HelpAndSupport create(HelpAndSupport helpAndSupport);

    HelpAndSupport update(HelpAndSupport helpAndSupport);

    List<HelpAndSupport> getByActive(boolean isActive);

    List<HelpAndSupport> getAll();

    HelpAndSupport findByHelpEmailAndHelpPhone(String email, String phone);
}
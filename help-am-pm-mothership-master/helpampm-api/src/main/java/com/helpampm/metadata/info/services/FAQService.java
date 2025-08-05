/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.info.services;

import com.helpampm.metadata.info.entities.FAQ;

import java.util.List;

/**
 * @author kuldeep
 */
public interface FAQService {
    FAQ create(FAQ faq);

    FAQ update(FAQ faq);

    List<FAQ> getByActive(boolean isActive, String langCode);

    List<FAQ> getAll();

    void delete(Integer id);
}

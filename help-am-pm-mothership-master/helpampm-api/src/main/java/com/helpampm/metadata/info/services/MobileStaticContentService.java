/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.info.services;

import com.helpampm.metadata.info.entities.MobileStaticContent;

import java.util.List;

/**
 * @author kuldeep
 */
public interface MobileStaticContentService {
    MobileStaticContent create(MobileStaticContent mobileStaticContent);

    MobileStaticContent update(MobileStaticContent mobileStaticContent);

    List<MobileStaticContent> listAll();

    MobileStaticContent findByIs(Long id);

    MobileStaticContent findByKey(String key, String langCode);
}

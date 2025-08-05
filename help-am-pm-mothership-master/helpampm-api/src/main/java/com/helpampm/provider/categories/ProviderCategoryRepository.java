/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.provider.categories;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Arrays;
import java.util.List;

/**
 * @author kuldeep
 */
public interface ProviderCategoryRepository  extends JpaRepository<ProviderCategory, Integer> {

    List<ProviderCategory> findByNameAndResidentialService(String category, Boolean isResidential);

    List<ProviderCategory> findByNameAndCommercialService(String category, Boolean commertialService);
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.category;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface CategoryRepository extends JpaRepository<Category, Integer> {
    Category findByNameAndResidentialServiceOrCommercialService(String category, boolean residential, boolean commercial);

    Optional<Category> findByName(String categoryName);

    List<Category> findByIsActive(boolean isActive);
}

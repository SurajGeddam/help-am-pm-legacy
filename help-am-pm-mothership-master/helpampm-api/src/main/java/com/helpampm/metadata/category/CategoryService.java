/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.category;

import java.util.List;
import java.util.Optional;

/**
 * @author kuldeep
 */
public interface CategoryService {
    Category create(Category category);

    Category update(Category category);

    Category getById(Integer id);

    List<Category> getAll();

    Category findByNameAndResidentialServiceOrCommercialService(String category, boolean residential, boolean commercial);

    Optional<Category> findByName(String categoryName);

    List<Category> saveAll(List<Category> categories);

    List<Category> getAllActive();

    List<Category> getByIds(List<Integer> categoryIds);
}

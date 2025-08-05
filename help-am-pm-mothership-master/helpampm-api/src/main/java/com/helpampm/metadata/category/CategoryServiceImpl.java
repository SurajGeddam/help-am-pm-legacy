/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.category;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import javax.transaction.Transactional;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class CategoryServiceImpl implements CategoryService {
    private final CategoryRepository repository;

    @Transactional
    @Override
    public Category create(Category category) {
        assert Objects.nonNull(category);
        category.setCreatedAt(LocalDateTime.now());
        category.setLastUpdatedAt(LocalDateTime.now());
        category.validate();
        checkDuplicates(category);
        return repository.save(category);
    }

    private void checkDuplicates(Category category) {
        if (repository.findByName(category.getName()).isPresent()) {
            throw new CategoryException("Category name already exists.");
        }
    }

    @Override
    @Transactional
    public Category update(Category category) {
        assert Objects.nonNull(category);
        assert Objects.nonNull(category.getId());
        category.setLastUpdatedAt(LocalDateTime.now());
        populateNullValuesFromPreviousValues(category);
        category.validate();
        return repository.save(category);
    }

    private void populateNullValuesFromPreviousValues(Category category) {
        Optional<Category> oldCategory = repository.findById(category.getId());
        oldCategory.ifPresent(value -> value.copyNonNullValues(category));
    }

    @Override
    public Category getById(Integer id) {
        return repository.findById(id).orElseThrow(() -> new CategoryException("Unable to find category."));
    }

    @Override
    public List<Category> getAll() {
        return repository.findAll();
    }

    @Override
    public Category findByNameAndResidentialServiceOrCommercialService(String category, boolean residential, boolean commercial) {
        return repository.findByNameAndResidentialServiceOrCommercialService(category, residential, commercial);
    }

    @Override
    public Optional<Category> findByName(String categoryName) {
        return repository.findByName(categoryName);
    }

    @Override
    public List<Category> saveAll(List<Category> categories) {
        return repository.saveAll(categories);
    }

    @Override
    public List<Category> getAllActive() {
        return repository.findByIsActive(true);
    }

    @Override
    public List<Category> getByIds(List<Integer> categoryIds) {
        return repository.findAllById(categoryIds);
    }
}

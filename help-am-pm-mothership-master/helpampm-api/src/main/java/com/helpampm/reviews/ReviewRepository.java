/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.reviews;

import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

/**
 * @author kuldeep
 */
public interface ReviewRepository extends JpaRepository<Review, Long> {
    List<Review> findByGivenToIdAndIsPublished(String providerId, boolean isPublished);

    List<Review> findByGivenByIdAndIsPublished(String customerId, boolean isPublished);

    List<Review> findByIsPublished(boolean isPublished);

    @Query("SELECT r FROM Review r ORDER BY r.createdAt DESC")
    List<Review> findTopNOrderByCreatedAtDesc(PageRequest pageRequest);
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.reviews;

import java.util.List;

/**
 * @author kuldeep
 */
public interface ReviewService {
    Review create(Review review);

    List<ReviewDTO> getReviewsByGivenToId(String id);

    List<ReviewDTO> getReviewsByGivenById(String id);

    List<ReviewDTO> getReviewsGivenByMe();

    List<ReviewDTO> getReviewsReceivedByMe();

    List<ReviewDTO> getReviewsByPublishedStatus(Boolean isPublished);

    List<ReviewDTO> getAllReviews();

    Review publishReview(Long reviewId);

    String getNameById(String givenById);

    List<ReviewDTO> getLatestReviews();
}

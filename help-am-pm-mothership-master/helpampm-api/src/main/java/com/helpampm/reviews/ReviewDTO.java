/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.reviews;

import lombok.Builder;
import lombok.Data;

import java.time.LocalDateTime;

@Builder(setterPrefix = "with")
@Data
/*
  @author kuldeep
 */
public class ReviewDTO {
    private Long id;
    private String reviewComment;
    private String givenBy;
    private String givenTo;
    private int rating;
    private String tags;
    private LocalDateTime createdAt;
    private LocalDateTime publishedAt;

    public static ReviewDTO buildWithReview(Review review, String givenBy, String givenTo) {
        return ReviewDTO.builder()
                .withId(review.getId())
                .withReviewComment(review.getComment())
                .withGivenBy(givenBy)
                .withGivenTo(givenTo)
                .withRating(review.getRating())
                .withCreatedAt(review.getCreatedAt())
                .withPublishedAt(review.getPublishedAt())
                .withTags("")
//                .withTags(review.getTags()
//                        .stream().map(Tag::getTag).distinct()
//                        .collect(Collectors.joining(",")))
                .build();
    }
}

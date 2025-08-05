/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.reviews;

import com.helpampm.common.GeneralResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.annotation.Secured;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Slf4j
@RestController
@RequiredArgsConstructor
@RequestMapping("review")
@Tag(name = "Reviews Management")
/*
  @author kuldeep
 */
public class ReviewController {
    private final ReviewService service;

    @PostMapping("")
    @Secured({"ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE",
            "ROLE_CUSTOMER"})
    public ResponseEntity<GeneralResponse> create(@RequestBody Review review) {
        service.create(review);
        return ResponseEntity.ok(GeneralResponse.builder().withMessage("Review Added successfully").withStatus(HttpStatus.OK.value()).build());
    }

    @GetMapping("provider/{providerUniqueId}/received")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE",
            "ROLE_CUSTOMER"})
    public ResponseEntity<List<ReviewDTO>> getReviewsForProvider(@PathVariable("providerUniqueId") String providerUniqueId) {
        return ResponseEntity.ok(service.getReviewsByGivenToId(providerUniqueId));
    }

    @GetMapping("provider/{providerUniqueId}/given")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE",
            "ROLE_CUSTOMER"})
    public ResponseEntity<List<ReviewDTO>> getReviewsByProvider(@PathVariable("providerUniqueId") String providerUniqueId) {
        return ResponseEntity.ok(service.getReviewsByGivenById(providerUniqueId));
    }

    @GetMapping("customer/{customerUniqueId}/given")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE",
            "ROLE_CUSTOMER"})
    public ResponseEntity<List<ReviewDTO>> getReviewsByCustomer(@PathVariable("customerUniqueId") String customerUniqueId) {
        return ResponseEntity.ok(service.getReviewsByGivenById(customerUniqueId));
    }

    @GetMapping("customer/{customerUniqueId}/received")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE",
            "ROLE_CUSTOMER"})
    public ResponseEntity<List<ReviewDTO>> getReviewsForCustomer(@PathVariable("customerUniqueId") String customerUniqueId) {
        return ResponseEntity.ok(service.getReviewsByGivenToId(customerUniqueId));
    }

    @GetMapping("given")
    @Secured({"ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE",
            "ROLE_CUSTOMER"})
    public ResponseEntity<List<ReviewDTO>> getReviewsSubmittedByMe() {
        return ResponseEntity.ok(service.getReviewsGivenByMe());
    }

    @GetMapping("received")
    @Secured({"ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE",
            "ROLE_CUSTOMER"})
    public ResponseEntity<List<ReviewDTO>> getReviewsReceivedByMe() {
        return ResponseEntity.ok(service.getReviewsReceivedByMe());
    }

    @GetMapping("unpublished")
    @Secured({"ROLE_SUPERADMIN"})
    public ResponseEntity<List<ReviewDTO>> getUnpublishedReviews() {
        return ResponseEntity.ok(service.getReviewsByPublishedStatus(false));
    }

    @GetMapping("published")
    @Secured({"ROLE_SUPERADMIN",
            "ROLE_PROVIDER_ADMIN",
            "ROLE_PROVIDER_EMPLOYEE",
            "ROLE_CUSTOMER"})
    public ResponseEntity<List<ReviewDTO>> getPublishedReviews() {
        return ResponseEntity.ok(service.getReviewsByPublishedStatus(true));
    }

    @GetMapping("all")
    @Secured({"ROLE_SUPERADMIN"})
    public ResponseEntity<List<ReviewDTO>> getAllReviews() {
        return ResponseEntity.ok(service.getAllReviews());
    }

    @GetMapping("publish/{reviewId}")
    @Secured({"ROLE_SUPERADMIN"})
    public ResponseEntity<ReviewDTO> publishReview(@PathVariable("reviewId") Long reviewId) {
        Review review = service.publishReview(reviewId);
        String givenByName = service.getNameById(review.getGivenById());
        String givenToName = service.getNameById(review.getGivenToId());
        return ResponseEntity.ok(ReviewDTO.buildWithReview(review, givenByName, givenToName));
    }
}

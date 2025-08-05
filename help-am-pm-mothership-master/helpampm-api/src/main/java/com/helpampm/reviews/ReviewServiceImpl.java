/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.reviews;

import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.services.AuthenticationService;
import com.helpampm.common.StringUtils;
import com.helpampm.common.tags.TagRepository;
import com.helpampm.customer.Customer;
import com.helpampm.customer.CustomerService;
import com.helpampm.provider.Provider;
import com.helpampm.provider.ProviderException;
import com.helpampm.provider.ProviderService;
import com.helpampm.provider.ProviderUpdateService;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@SuppressFBWarnings("EI_EXPOSE_REP")
@Service
@Slf4j
@RequiredArgsConstructor

/*
  @author kuldeep
 */
public class ReviewServiceImpl implements ReviewService {
    private final ReviewRepository repository;
    private final TagRepository tagRepository;
    private final ProviderService providerService;
    private final ProviderUpdateService providerUpdateService;
    private final CustomerService customerService;
    private final AuthenticationService authenticationService;

    @Override
    @Transactional
    public Review create(Review review) {
        UserLoginDetails userLoginDetails = authenticationService.findLoggedInUser();
        assert Objects.nonNull(review);
        review.validate();
        review.setCreatedAt(LocalDateTime.now());
        //Need to fix this Tag
//        if(review.getTags()!=null){
//            review.setTags(new HashSet<>(tagRepository.saveAll(review.getTags())));
//        }
        if (Objects.nonNull(userLoginDetails.getCustomerUniqueId())) {
            updateCustomerRatings(review);
        } else {
            updateProviderRatings(review);
        }
        return repository.save(review);
    }

    private void updateProviderRatings(Review review) {
        Provider provider = providerService.findByProviderUniqueId(review.getGivenToId());
        provider.setCustomerAverageRating(
                (provider.getCustomerAverageRating() * provider.getTotalCustomerRatings() + review.getRating()) / (provider.getTotalCustomerRatings() + 1));
        provider.setTotalCustomerRatings(provider.getTotalCustomerRatings() + 1);
        providerUpdateService.updateRatings(provider);
    }

    private void updateCustomerRatings(Review review) {
        Customer customer = customerService.findByCustomerUniqueId(review.getGivenToId());
        customer.setAverageProviderRating(
                (customer.getAverageProviderRating() * customer.getTotalProviderRatings() + review.getRating()) / (customer.getTotalProviderRatings() + 1));
        customer.setTotalProviderRatings(customer.getTotalProviderRatings() + 1);
        customerService.update(customer, customer.getCustomerUniqueId());
    }

    @Override
    public List<ReviewDTO> getReviewsByGivenToId(String givenToUniqueId) {
        return repository.findByGivenToIdAndIsPublished(givenToUniqueId, true)
                .stream().map(review ->
                        ReviewDTO.buildWithReview(review, getNameById(review.getGivenById()), getNameById(review.getGivenToId())))
                .collect(Collectors.toList());
    }

    @Override
    public List<ReviewDTO> getReviewsByGivenById(String givenByUniqueId) {
        return repository.findByGivenByIdAndIsPublished(givenByUniqueId, true).stream().map(review ->
                        ReviewDTO.buildWithReview(review, getNameById(review.getGivenById()), getNameById(review.getGivenToId())))
                .collect(Collectors.toList());
    }

    @Override
    public List<ReviewDTO> getReviewsGivenByMe() {
        UserLoginDetails loggedInUser = authenticationService.findLoggedInUser();
        if (Objects.isNull(loggedInUser.getCustomerUniqueId())) {
            return repository.findByGivenByIdAndIsPublished(loggedInUser.getCustomerUniqueId(), true).stream().map(review ->
                            ReviewDTO.buildWithReview(review, getNameById(review.getGivenById()), getNameById(review.getGivenToId())))
                    .collect(Collectors.toList());
        } else {
            return repository.findByGivenByIdAndIsPublished(loggedInUser.getProviderUniqueId(), true).stream().map(review ->
                            ReviewDTO.buildWithReview(review, getNameById(review.getGivenById()), getNameById(review.getGivenToId())))
                    .collect(Collectors.toList());
        }
    }

    @Override
    public List<ReviewDTO> getReviewsReceivedByMe() {
        UserLoginDetails loggedInUser = authenticationService.findLoggedInUser();
        if (Objects.isNull(loggedInUser.getCustomerUniqueId())) {
            return repository.findByGivenToIdAndIsPublished(loggedInUser.getCustomerUniqueId(), true).stream().map(review ->
                            ReviewDTO.buildWithReview(review, getNameById(review.getGivenById()), getNameById(review.getGivenToId())))
                    .collect(Collectors.toList());
        } else {
            return repository.findByGivenToIdAndIsPublished(loggedInUser.getProviderUniqueId(), true).stream().map(review ->
                            ReviewDTO.buildWithReview(review, getNameById(review.getGivenById()), getNameById(review.getGivenToId())))
                    .collect(Collectors.toList());
        }
    }

    @Override
    public List<ReviewDTO> getReviewsByPublishedStatus(Boolean isPublished) {
        return repository.findByIsPublished(isPublished).stream().map(review ->
                        ReviewDTO.buildWithReview(review, getNameById(review.getGivenById()), getNameById(review.getGivenToId())))
                .collect(Collectors.toList());
    }

    @Override
    public List<ReviewDTO> getAllReviews() {
        return repository.findAll().stream().map(review ->
                        ReviewDTO.buildWithReview(review, getNameById(review.getGivenById()), getNameById(review.getGivenToId())))
                .collect(Collectors.toList());
    }

    @Override
    public Review publishReview(Long reviewId) {
        Review review = repository.findById(reviewId).orElseThrow(() ->
                new ReviewException(String.format("No review found with %s Id", reviewId)));
        review.setIsPublished(true);
        review.setPublishedAt(LocalDateTime.now());
        return repository.save(review);
    }

    @Override
    public String getNameById(String uniqueId) {
        try {
            Provider provider = providerService.findByProviderUniqueId(uniqueId);
            return StringUtils.capitalize(provider.getName());
        } catch (ProviderException e) {
            try {
                Customer customer = customerService.findByCustomerUniqueId(uniqueId);
                return StringUtils.capitalize(customer.getFirstName()) + " " + StringUtils.capitalize(customer.getLastName());
            } catch (Exception ex) {
                return "unknown";
            }
        }
    }

    @Override
    public List<ReviewDTO> getLatestReviews() {
        Sort.Direction direction = Sort.Direction.DESC;
        Sort sort = Sort.by(direction, "createdAt");
        PageRequest pageRequest = PageRequest.of(0, 50, sort);

        return repository.findTopNOrderByCreatedAtDesc(pageRequest).stream()
                .map(r -> ReviewDTO.buildWithReview(r, getNameById(r.getGivenToId()), getNameById(r.getGivenToId())))
                .collect(Collectors.toList());
    }
}

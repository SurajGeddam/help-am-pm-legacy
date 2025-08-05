/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote.dto;

import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.auth.services.AuthenticationService;
import com.helpampm.customer.CustomerException;
import com.helpampm.quote.Quote;
import com.helpampm.quote.QuoteHelper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import java.util.Objects;

@Component
@RequiredArgsConstructor
@Slf4j
/*
  @author kuldeep
 */
public class PageableQuoteFilterRequestHelper {

    private final EntityManager entityManager;
    private final AuthenticationService authenticationService;

    public QuoteFilterRequestPayload buildPageableFilterRequest(QuoteFilterRequestPayload payload, String status) {
        validateRequestPayload(payload);
        QuoteFilterRequestPayload pageableFilterBuilder = QuoteFilterRequestPayload.builder()
                .orderColumn(payload.getOrderColumn())
                .orderDir(payload.getOrderDir())
                .pageNumber(payload.getPageNumber())
                .pageSize(payload.getPageSize())
                .providerUniqueId(StringUtils.hasText(payload.getProviderUniqueId()) ? payload.getProviderUniqueId() : null)
                .status(status)
                .build();
        buildWithSearchText(payload.getSearchText(), pageableFilterBuilder);
        return pageableFilterBuilder;
    }


    private void buildWithSearchText(String searchText, QuoteFilterRequestPayload leadPageableFiltersBuilder) {
        if (Objects.nonNull(searchText) && StringUtils.hasText(searchText)) {
            leadPageableFiltersBuilder.setSearchText(searchText);
        }
    }

    public TypedQuery<Quote> createExecutableQuery(QuoteFilterRequestPayload pageableFilterDto) {
        TypedQuery<Quote> query =
                entityManager.createQuery(createSelectQuery("select q from Quote q WHERE status IN " +
                        QuoteHelper.createStatusInClause(pageableFilterDto.getStatus()), pageableFilterDto), Quote.class);
        int pageNumber = pageableFilterDto.getPageNumber();
        int pageSize = pageableFilterDto.getPageSize();
        query.setFirstResult((pageNumber) * pageSize);
        query.setMaxResults(pageSize);
        return query;
    }


    private String createSelectQuery(String query, QuoteFilterRequestPayload pageableFilterDto) {
        StringBuilder queryBuilder = new StringBuilder(query);
        applyTextSearchFilter(pageableFilterDto, queryBuilder);
        if(Objects.equals(pageableFilterDto.getStatus(), "neworder")) {
            applyNotifiedProvidersFilter(pageableFilterDto, queryBuilder);
        } else {
            applyProviderFilter(pageableFilterDto, queryBuilder);
        }
        applyOrderByClause(pageableFilterDto, queryBuilder);
        return queryBuilder.toString();
    }

    private void applyNotifiedProvidersFilter(QuoteFilterRequestPayload pageableFilterDto, StringBuilder queryBuilder) {
        UserLoginDetails userLoginDetails = authenticationService.findLoggedInUser();
        if(Objects.nonNull(userLoginDetails.getProviderUniqueId())) {
            log.debug("Finding new quotes for provider " + userLoginDetails.getProviderUniqueId());
            queryBuilder
                    .append(" AND '")
                    .append(userLoginDetails.getProviderUniqueId())
                    .append("' MEMBER OF q.notifiedProviders");
        }
    }

    private void applyProviderFilter(QuoteFilterRequestPayload pageableFilterDto, StringBuilder queryBuilder) {
        log.debug("Applying provider filter " + pageableFilterDto.getProviderUniqueId());
        if (Objects.nonNull(pageableFilterDto.getProviderUniqueId())) {
            queryBuilder
                    .append(" AND (q.quoteProvider.uniqueId='")
                    .append(pageableFilterDto.getProviderUniqueId())
                    .append("'")
                    .append(")");
        }
    }


    private void applyOrderByClause(QuoteFilterRequestPayload pageableFilterDto, StringBuilder queryBuilder) {
        String sortColumn = "createdAt";
        if (Objects.nonNull(pageableFilterDto.getOrderColumn())) {
            if ("customerName".equalsIgnoreCase(pageableFilterDto.getOrderColumn())) {
                sortColumn = "customer.firstName";
            } else if ("customerPhone".equalsIgnoreCase(pageableFilterDto.getOrderColumn())) {
                sortColumn = "customer.phone";
            }
        }
        queryBuilder.append(" ORDER BY")
                .append(" q.")
                .append(sortColumn)
                .append(" ")
                .append(Objects.nonNull(pageableFilterDto.getOrderDir())
                        ? pageableFilterDto.getOrderDir()
                        : "DESC");
    }


    private void applyTextSearchFilter(QuoteFilterRequestPayload pageableFilterDto, StringBuilder queryBuilder) {
        log.debug("Applying text search filter " + pageableFilterDto.getSearchText());
        if (Objects.nonNull(pageableFilterDto.getSearchText()) && StringUtils.hasText(pageableFilterDto.getSearchText())) {
            queryBuilder
                    .append(" AND (q.firstName like '%")
                    .append(pageableFilterDto.getSearchText())
                    .append("%'").append(" OR q.email like '%")
                    .append(pageableFilterDto.getSearchText())
                    .append("%'")
                    .append(" OR q.lastName like '%")
                    .append(pageableFilterDto.getSearchText())
                    .append("%'")
                    .append(" OR q.phone like '%")
                    .append(pageableFilterDto.getSearchText())
                    .append("%')");
        }
    }

    public void validateRequestPayload(QuoteFilterRequestPayload filterRequestPayload) {
        if (Objects.isNull(filterRequestPayload.getOrderDir())) {
            throw new CustomerException("orderDir value is missing");
        }
        if (Objects.isNull(filterRequestPayload.getOrderColumn())) {
            throw new CustomerException("orderColumn value is missing");
        }
    }

    public long getCountOfAvailableItems(QuoteFilterRequestPayload pageableFilterDto) {
        String queryCount = createSelectQuery("select count(*) from Quote q WHERE status IN " +
                QuoteHelper.createStatusInClause(pageableFilterDto.getStatus()), pageableFilterDto);
        TypedQuery<Long> queryTotal = entityManager.createQuery(queryCount, Long.class);
        return queryTotal.getSingleResult();

    }
}

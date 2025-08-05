/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.customer.dto;

import com.helpampm.customer.Customer;
import com.helpampm.customer.CustomerException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import java.util.Objects;

@Component
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class PageableCustomerFilterRequestHelper {

    private final EntityManager entityManager;

    public CustomerFilterRequestPayload buildPageableFilterRequest(CustomerFilterRequestPayload payload) {
        validateRequestPayload(payload);
        CustomerFilterRequestPayload pageableFilterBuilder = CustomerFilterRequestPayload.builder()
                .orderColumn(payload.getOrderColumn())
                .orderDir(payload.getOrderDir())
                .pageNumber(payload.getPageNumber())
                .pageSize(payload.getPageSize()).build();
        buildWithSearchText(payload.getSearchText(), pageableFilterBuilder);
        return pageableFilterBuilder;
    }


    private void buildWithSearchText(String searchText, CustomerFilterRequestPayload leadPageableFiltersBuilder) {
        if (Objects.nonNull(searchText) && StringUtils.hasText(searchText)) {
            leadPageableFiltersBuilder.setSearchText(searchText);
        }
    }

    public TypedQuery<Customer> createExecutableQuery(CustomerFilterRequestPayload pageableFilterDto) {
        TypedQuery<Customer> query =
                entityManager.createQuery(createSelectQuery("select c from Customer c", pageableFilterDto), Customer.class);
        int pageNumber = pageableFilterDto.getPageNumber();
        int pageSize = pageableFilterDto.getPageSize();
        query.setFirstResult((pageNumber) * pageSize);
        query.setMaxResults(pageSize);
        return query;
    }

    private String createSelectQuery(String query, CustomerFilterRequestPayload pageableFilterDto) {
        StringBuilder queryBuilder = new StringBuilder(query);
        applyTextSearchFilter(pageableFilterDto, queryBuilder);
        applyOrderByClause(pageableFilterDto, queryBuilder);
        return queryBuilder.toString();
    }


    private void applyOrderByClause(CustomerFilterRequestPayload pageableFilterDto, StringBuilder queryBuilder) {
        String sortColumn = "createdAt";
        if (Objects.nonNull(pageableFilterDto.getOrderColumn())) {
            if ("customerName".equalsIgnoreCase(pageableFilterDto.getOrderColumn())) {
                sortColumn = "customer.firstName";
            } else if ("customerPhone".equalsIgnoreCase(pageableFilterDto.getOrderColumn())) {
                sortColumn = "customer.phone";
            }
        }
        queryBuilder.append(" ORDER BY")
                .append(" c.")
                .append(sortColumn)
                .append(" ")
                .append(Objects.nonNull(pageableFilterDto.getOrderDir())
                        ? pageableFilterDto.getOrderDir()
                        : "DESC");
    }


    private void applyTextSearchFilter(CustomerFilterRequestPayload pageableFilterDto, StringBuilder queryBuilder) {
        if (Objects.nonNull(pageableFilterDto.getSearchText()) && StringUtils.hasText(pageableFilterDto.getSearchText())) {
            queryBuilder
                    .append(" WHERE (c.firstName like '%")
                    .append(pageableFilterDto.getSearchText())
                    .append("%'").append(" OR c.email like '%")
                    .append(pageableFilterDto.getSearchText())
                    .append("%'")
                    .append(" OR c.lastName like '%")
                    .append(pageableFilterDto.getSearchText())
                    .append("%'")
                    .append(" OR c.phone like '%")
                    .append(pageableFilterDto.getSearchText())
                    .append("%')");
        }
    }

    public void validateRequestPayload(CustomerFilterRequestPayload filterRequestPayload) {
        if (Objects.isNull(filterRequestPayload.getOrderDir())) {
            throw new CustomerException("orderDir value is missing");
        }
        if (Objects.isNull(filterRequestPayload.getOrderColumn())) {
            throw new CustomerException("orderColumn value is missing");
        }
    }

    public long getCountOfAvailableItems(CustomerFilterRequestPayload pageableFilterDto) {
        TypedQuery<Long> queryTotal =
                entityManager.createQuery(createSelectQuery("select count(*) from Customer c", pageableFilterDto), Long.class);
        return queryTotal.getSingleResult();
    }
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.helper;

import com.helpampm.provider.Provider;
import com.helpampm.provider.ProviderException;
import com.helpampm.provider.dto.ProviderFilterRequestPayload;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
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
public class PageableProviderFilterRequestHelper {

    private final EntityManager entityManager;

    public ProviderFilterRequestPayload buildPageableFilterRequest(ProviderFilterRequestPayload payload) {
        validateRequestPayload(payload);
        ProviderFilterRequestPayload pageableFilterBuilder = ProviderFilterRequestPayload.builder()
                .orderColumn(payload.getOrderColumn())
                .orderDir(payload.getOrderDir())
                .pageNumber(payload.getPageNumber())
                .pageSize(payload.getPageSize()).build();
        buildWithSearchText(payload.getSearchText(), pageableFilterBuilder);
        return pageableFilterBuilder;
    }


    private void buildWithSearchText(String searchText, ProviderFilterRequestPayload leadPageableFiltersBuilder) {
        if (Objects.nonNull(searchText) && StringUtils.hasText(searchText)) {
            leadPageableFiltersBuilder.setSearchText(searchText);
        }
    }

    public TypedQuery<Provider> createExecutableQuery(ProviderFilterRequestPayload pageableFilterDto) {
        TypedQuery<Provider> query =
                entityManager.createQuery(createSelectQuery("select p from Provider p", pageableFilterDto), Provider.class);
        int pageNumber = pageableFilterDto.getPageNumber();
        int pageSize = pageableFilterDto.getPageSize();
        query.setFirstResult((pageNumber) * pageSize);
        query.setMaxResults(pageSize);
        return query;
    }

    private String createSelectQuery(String query, ProviderFilterRequestPayload pageableFilterDto) {
        StringBuilder queryBuilder = new StringBuilder(query);
        applyTextSearchFilter(pageableFilterDto, queryBuilder);
        applyOrderByClause(pageableFilterDto, queryBuilder);
        return queryBuilder.toString();
    }


    private void applyOrderByClause(ProviderFilterRequestPayload pageableFilterDto, StringBuilder queryBuilder) {
        String sortColumn = "createdAt";
        if (Objects.nonNull(pageableFilterDto.getOrderColumn())) {
            if ("name".equalsIgnoreCase(pageableFilterDto.getOrderColumn())) {
                sortColumn = "provider.name";
            } else if ("phone".equalsIgnoreCase(pageableFilterDto.getOrderColumn())) {
                sortColumn = "provider.phone";
            }
        }
        queryBuilder.append(" ORDER BY")
                .append(" p.")
                .append(sortColumn)
                .append(" ")
                .append(Objects.nonNull(pageableFilterDto.getOrderDir())
                        ? pageableFilterDto.getOrderDir()
                        : "DESC");
    }


    private void applyTextSearchFilter(ProviderFilterRequestPayload pageableFilterDto, StringBuilder queryBuilder) {
        if (Objects.nonNull(pageableFilterDto.getSearchText()) && StringUtils.hasText(pageableFilterDto.getSearchText())) {
            queryBuilder
                    .append(" WHERE (p.name like '%")
                    .append(pageableFilterDto.getSearchText())
                    .append("%'").append(" OR p.email like '%")
                    .append(pageableFilterDto.getSearchText())
                    .append("%'")
                    .append(" OR p.phone like '%")
                    .append(pageableFilterDto.getSearchText())
                    .append("%'")
                    .append(" OR p.providerUniqueId like '%")
                    .append(pageableFilterDto.getSearchText())
                    .append("%')");
        }
    }

    public void validateRequestPayload(ProviderFilterRequestPayload filterRequestPayload) {
        if (Objects.isNull(filterRequestPayload.getOrderDir())) {
            throw new ProviderException("orderDir value is missing", HttpStatus.BAD_REQUEST);
        }
        if (Objects.isNull(filterRequestPayload.getOrderColumn())) {
            throw new ProviderException("orderColumn value is missing", HttpStatus.BAD_REQUEST);
        }
    }

    public long getCountOfAvailableItems(ProviderFilterRequestPayload pageableFilterDto) {
        TypedQuery<Long> query =
                entityManager.createQuery(createSelectQuery("select count(*) from Provider p", pageableFilterDto), Long.class);
        return query.getSingleResult();
    }
}

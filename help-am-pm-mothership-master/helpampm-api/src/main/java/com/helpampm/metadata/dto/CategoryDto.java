/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.dto;

import com.helpampm.provider.categories.ProviderCategory;
import com.helpampm.provider.dto.ProviderTimeslotDto;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;

import java.io.Serializable;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

@Data
@Builder(setterPrefix = "with")
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class CategoryDto implements Serializable {
    private int id;
    private String name;
    private boolean residentialService;
    private boolean commercialService;
    private List<ProviderTimeslotDto> timeslots;

    public static CategoryDto buildWithCategory(ProviderCategory category) {
        return CategoryDto.builder().withId(category.getId())
                .withName(category.getName())
                .withResidentialService(category.getResidentialService())
                .withCommercialService(category.getCommercialService())
                .withTimeslots(Objects.nonNull(category.getTimeslots()) ? category.getTimeslots().stream().map(ProviderTimeslotDto::buildWithProviderTimeslot).collect(Collectors.toList()) : List.of())
                .build();
    }
}

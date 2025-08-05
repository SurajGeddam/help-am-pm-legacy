/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.dashboard.dtos;

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Data;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @author kuldeep
 */
@SuppressFBWarnings("EI_EXPOSE_REP")
@Data
public class CustomersSignupChartDataResponse {
    private List<Number> data;

    public static CustomersSignupChartDataResponse from(Set<MonthlyCountDto> monthlyCountDtos) {
        CustomersSignupChartDataResponse response = new CustomersSignupChartDataResponse();
        response.data = monthlyCountDtos.stream().map(MonthlyCountDto::getCount).collect(Collectors.toList());
        return response;
    }
}

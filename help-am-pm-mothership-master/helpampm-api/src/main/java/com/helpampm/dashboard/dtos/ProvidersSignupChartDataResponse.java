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
@Data
@SuppressFBWarnings("EI_EXPOSE_REP")
public class ProvidersSignupChartDataResponse {
    private List<Number> data;
    public static ProvidersSignupChartDataResponse from(Set<MonthlyCountDto> set) {
        ProvidersSignupChartDataResponse response = new ProvidersSignupChartDataResponse();
        response.data = set.stream().map(MonthlyCountDto::getCount).collect(Collectors.toList());
        return response;
    }
}

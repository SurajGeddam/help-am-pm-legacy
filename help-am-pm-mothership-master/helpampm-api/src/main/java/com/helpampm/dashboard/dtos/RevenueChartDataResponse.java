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
public class RevenueChartDataResponse {
    private List<Number> data;
    public static RevenueChartDataResponse from(Set<MonthlyCountDto> set) {
        RevenueChartDataResponse response = new RevenueChartDataResponse();
        response.data = set.stream().map(MonthlyCountDto::getCount).collect(Collectors.toList());
        return response;
    }
}

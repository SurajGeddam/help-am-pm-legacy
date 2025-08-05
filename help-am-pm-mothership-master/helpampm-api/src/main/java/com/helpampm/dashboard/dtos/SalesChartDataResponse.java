/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.dashboard.dtos;

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Data;

import java.util.HashMap;
import java.util.Map;

/**
 * @author kuldeep
 */
@Data
@SuppressFBWarnings("EI_EXPOSE_REP")
public class SalesChartDataResponse {
    private Map<String, SalesChartData> data = new HashMap<>();
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.dashboard.dtos;

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Data;

import java.util.List;

/**
 * @author kuldeep
 */
@Data
@SuppressFBWarnings("EI_EXPOSE_REP")
public class SalesChartData {
    private String name;
    private String type = "column";
    private double[] data = new double[12];
    public static SalesChartData from(List<SaleDataByCategory> saleDataByCategories, String categoryName) {
        SalesChartData salesChartData = new SalesChartData();
        salesChartData.name = categoryName;
        for(SaleDataByCategory saleDataByCategory : saleDataByCategories) {
            salesChartData.data[saleDataByCategory.getMonth()-1] = saleDataByCategory.getTotal();
        }
        return salesChartData;
    }
}

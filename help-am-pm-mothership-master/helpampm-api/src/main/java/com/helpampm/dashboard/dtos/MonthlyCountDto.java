/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.dashboard.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Objects;

/**
 * @author kuldeep
 */
@Data
@AllArgsConstructor
public class MonthlyCountDto implements Comparable<MonthlyCountDto> {
    private Number count;
    private int month;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        MonthlyCountDto that = (MonthlyCountDto) o;

        if (month != that.month) return false;
        return Objects.equals(count, that.count);
    }

    @Override
    public int hashCode() {
        int result = count != null ? count.hashCode() : 0;
        result = 31 * result + month;
        return result;
    }

    @Override
    public int compareTo(MonthlyCountDto o) {
        return Integer.compare(month, o.getMonth());
    }
}

package com.helpampm.dashboard.dtos;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ProviderDashboardModel {
    private String value;
    private String text;
    private String bgColor;
    private boolean amount;
}

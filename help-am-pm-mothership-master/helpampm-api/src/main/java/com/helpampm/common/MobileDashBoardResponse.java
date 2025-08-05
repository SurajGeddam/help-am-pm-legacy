/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.common;

import com.helpampm.dashboard.dtos.ProviderDashboardModel;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@SuppressFBWarnings("EI_EXPOSE_REP")
@Data
@Builder(setterPrefix = "with")
public class MobileDashBoardResponse {
    private List<ProviderDashboardModel> countModel;
    private boolean isAccountCompleted;
    private boolean isStripeAccountCompleted;

}

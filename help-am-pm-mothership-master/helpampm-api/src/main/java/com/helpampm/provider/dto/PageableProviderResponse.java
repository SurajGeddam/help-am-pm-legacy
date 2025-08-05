/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.dto;

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

@Data
@AllArgsConstructor
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class PageableProviderResponse {
    private long count;
    private List<ProviderDto> providers;
}

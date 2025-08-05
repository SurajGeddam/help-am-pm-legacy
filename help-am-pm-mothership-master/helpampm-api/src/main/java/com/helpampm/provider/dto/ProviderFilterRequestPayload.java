/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
/*
  @author kuldeep
 */
public class ProviderFilterRequestPayload {
    private int pageSize;
    private int pageNumber;
    private String orderDir;
    private String orderColumn;
    private String searchText;
}

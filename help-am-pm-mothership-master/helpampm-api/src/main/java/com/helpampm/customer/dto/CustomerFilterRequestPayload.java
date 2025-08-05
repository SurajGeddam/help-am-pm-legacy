/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.customer.dto;

import lombok.Builder;
import lombok.Data;

@Data
@Builder
/*
  @author kuldeep
 */
public class CustomerFilterRequestPayload {
    private int pageSize;
    private int pageNumber;
    private String orderDir;
    private String orderColumn;
    private String searchText;
}

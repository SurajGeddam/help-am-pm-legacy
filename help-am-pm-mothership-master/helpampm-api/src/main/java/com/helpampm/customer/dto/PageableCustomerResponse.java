/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.customer.dto;

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
public class PageableCustomerResponse {
    private long count;
    private List<CustomerDto> customers;
}

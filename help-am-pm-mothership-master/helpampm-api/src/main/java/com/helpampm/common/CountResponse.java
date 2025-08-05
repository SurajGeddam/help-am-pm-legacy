/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.common;

import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Builder;
import lombok.Data;

import java.util.Map;

@SuppressFBWarnings("EI_EXPOSE_REP")
@Data
@Builder(setterPrefix = "with")
/*
  @author kuldeep
 */
public class CountResponse {
    private Map<String, Number> data;
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.dashboard.dtos;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
/*
  @author kuldeep
 */
public class KeyValueQueryCount {
    private long recordCount;
    private String key;
}

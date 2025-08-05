/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.common;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

@Data
@AllArgsConstructor
@Builder
/*
  @author kuldeep
 */
public class ExceptionDto {
    private String message;
    private Integer status;
}

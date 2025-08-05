/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.common.files;

import lombok.Data;

/**
 * @author kuldeep
 */
@Data
public class FileUploadModel {
    private String fileName;
    private FileUploadPurpose purpose;
    private boolean replace;
}

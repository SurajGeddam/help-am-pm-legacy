/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.common.services;

import com.helpampm.common.files.FileUploadModel;
import org.springframework.core.io.Resource;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.InputStream;

/**
 * @author kuldeep
 */
public interface FileService {

    byte[] uploadFileToS3(String path,
                          FileUploadModel fileName,
                          MultipartFile inputStream);

    void uploadFileStreamToS3(String bucketName,
                              String key,
                              InputStream inputStream);

    Resource download(String path, String bucket);
    byte[] downloadAsBytes(String path, String bucket);
    void delete(String path, String bucket);

    void uploadDatabaseBackupFileToS3(File file);
}

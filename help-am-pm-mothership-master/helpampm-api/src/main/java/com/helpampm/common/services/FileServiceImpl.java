/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.common.services;

import com.amazonaws.AmazonServiceException;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.*;
import com.amazonaws.util.IOUtils;
import com.helpampm.common.files.FileUploadModel;
import com.helpampm.common.files.FileUploadPurpose;
import lombok.RequiredArgsConstructor;
import net.coobird.thumbnailator.Thumbnails;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class FileServiceImpl implements FileService {

    private final AmazonS3 amazonS3;
    @Value("${aws.s3.upload-bucket}")
    private String fileUploadBuckets;
    @Value("${aws.s3.profile-photos}")
    private String profileBucket;
    @Value("${aws.s3.database-backup}")
    private String databaseBackupBucket;


    @Override
    public byte[] uploadFileToS3(String key,
                                 FileUploadModel fileUploadModel,
                                 MultipartFile file) {

        //get file metadata
        String bucketName = "";
        Map<String, String> metadata = new HashMap<>();
        metadata.put("Content-Type", file.getContentType());
        metadata.put("Content-Length", String.valueOf(file.getSize()));
        ObjectMetadata objectMetadata = new ObjectMetadata();
        Optional.of(metadata).ifPresent(map -> map.forEach(objectMetadata::addUserMetadata));

        try {
            if (FileUploadPurpose.USER_PROFILE.equals(fileUploadModel.getPurpose())) {
                createThumbnailFile(file, key);
                return downloadAsBytes(key, profileBucket);
            } else {
                bucketName = fileUploadBuckets;
                PutObjectRequest putObjectRequest = new PutObjectRequest(bucketName, key, file.getInputStream(), objectMetadata);
                amazonS3.putObject(putObjectRequest);
                return downloadAsBytes(key, profileBucket);

            }
        } catch (AmazonServiceException | IOException e) {
            throw new FileException("Failed to upload file", e);
        }
    }


    @Override
    public void uploadFileStreamToS3(String bucketName, String key, InputStream inputStream) {
        //get file metadata
        ObjectMetadata objectMetadata = new ObjectMetadata();
        try {
            amazonS3.putObject(bucketName, key, inputStream, objectMetadata);
        } catch (AmazonServiceException e) {
            throw new FileException("Failed to upload file", e);
        }
    }

    @Override

    public Resource download(String key, String bucket) {
        try {
            S3Object object = amazonS3.getObject(bucket, key);
            S3ObjectInputStream objectContent = object.getObjectContent();
            return new InputStreamResource(objectContent);
        } catch (AmazonServiceException e) {
            throw new FileException("Failed to download the file", e);
        }
    }

    public byte[] downloadAsBytes(String key, String bucket) {
        try {
            S3Object object = amazonS3.getObject(bucket, key);
            return IOUtils.toByteArray(object.getObjectContent());
        } catch (AmazonServiceException e) {
            throw new FileException("Failed to download the file", e);
        } catch (IOException e) {
            throw new FileException(e.getMessage());
        }
    }

    @Override
    public void delete(String path, String bucket) {
        amazonS3.deleteObject(new DeleteObjectRequest(bucket, path));
    }

    @Override
    public void uploadDatabaseBackupFileToS3(File file) {
        try (FileInputStream inputStream = new FileInputStream(file)){
            ObjectMetadata metadata = new ObjectMetadata();
            metadata.setContentLength(file.length());
            amazonS3.putObject(databaseBackupBucket, file.getName(), inputStream, metadata);
        } catch (AmazonServiceException | IOException e) {
            throw new FileException("Database backup upload to S3 failed", e);
        }
    }

    private void createThumbnailFile(MultipartFile photo, String key) throws IOException {
        BufferedImage thumbnail = Thumbnails.of(photo.getInputStream())
                .size(50, 50)
                .asBufferedImage();

        ByteArrayOutputStream os = new ByteArrayOutputStream();
        ImageIO.write(thumbnail, "png", os);
        InputStream thumbnail_is = new ByteArrayInputStream(os.toByteArray());
        uploadFileStreamToS3(profileBucket, key, thumbnail_is);

    }

}

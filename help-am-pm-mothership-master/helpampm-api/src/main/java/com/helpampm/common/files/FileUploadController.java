/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.common.files;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.helpampm.common.services.FileService;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import static org.springframework.http.ResponseEntity.ok;

/**
 * @author kuldeep
 */
@SuppressFBWarnings("EI_EXPOSE_REP2")
@RestController
@RequestMapping("files")
@Slf4j
@RequiredArgsConstructor
public class FileUploadController {
    private final UploadLocationBuilder uploadLocationBuilder;
    private final FileService fileService;
    private static final ObjectMapper MAPPER = new ObjectMapper();

    @PostMapping
    public ResponseEntity<FileUploadResponse> uploadFile(@RequestPart("file") MultipartFile file,
                                                         @RequestParam(value = "fileUploadModel") String jsonString)
            throws JsonProcessingException {
        log.info("Purpose " + jsonString);
        FileUploadModel fileUploadModel = MAPPER.readValue(jsonString, FileUploadModel.class);
        String fileUploadedPath = uploadLocationBuilder.createFileUploadLocation(fileUploadModel);
        byte[] fileUploadedBytes = fileService.uploadFileToS3(fileUploadedPath, fileUploadModel, file);

        return ok(FileUploadResponse.builder()
                .withMessage("File uploaded successfully")
                .withStatus(HttpStatus.OK.value())
                .withUploadImageBytes(fileUploadedBytes)
                .withUploadedPath(fileUploadedPath).build());
    }
}

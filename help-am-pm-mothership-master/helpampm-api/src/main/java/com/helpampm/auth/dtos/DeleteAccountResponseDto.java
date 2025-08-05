/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.auth.dtos;

import com.helpampm.account.DeleteAccountRequest;
import lombok.Builder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.time.LocalDateTime;

/**
 * @author kuldeep
 */
@Builder(setterPrefix = "with")
public class DeleteAccountResponseDto {
    private String message;
    private LocalDateTime deletedDate;
    private int status;
    public static DeleteAccountResponseDto buildFrom(DeleteAccountRequest deleteAccountRequest) {
        return DeleteAccountResponseDto.builder().withMessage("You account deletion request has been received, Your account will be deleted after 30 days.")
                .withDeletedDate(deleteAccountRequest.getRequestDate())
                .withStatus(HttpStatus.ACCEPTED.value())
                .build();
    }
}

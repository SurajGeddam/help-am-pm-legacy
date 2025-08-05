/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.account;

import com.helpampm.auth.exceptions.UserException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Objects;

/**
 * @author kuldeep
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class DeleteAccountRequestService {
    private final DeleteAccountRequestRepository repository;

    public DeleteAccountRequest save(String username) {
        DeleteAccountRequest deleteAccountRequest = new DeleteAccountRequest();
        deleteAccountRequest.setRequestDate(LocalDateTime.now());
        deleteAccountRequest.setUsername(username);
        deleteAccountRequest.setIsExecuted(false);
        return repository.save(deleteAccountRequest);
    }

    public void delete(String username) {
        DeleteAccountRequest deleteAccountRequest = findByUsername(username);
        if(Objects.nonNull(deleteAccountRequest)){
            repository.delete(deleteAccountRequest);
        }
    }

    private DeleteAccountRequest findByUsername(String username) {
        return repository
                .findByUsername(username).orElse(null);
    }

    public DeleteAccountRequest setExecuted(String username) {
        DeleteAccountRequest deleteAccountRequest = findByUsername(username);
        deleteAccountRequest.setIsExecuted(true);
        return repository.save(deleteAccountRequest);
    }
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.account;

import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

/**
 * @author kuldeep
 */
public interface DeleteAccountRequestRepository extends JpaRepository<DeleteAccountRequest, Long> {
    Optional<DeleteAccountRequest> findByUsername(String username);
}

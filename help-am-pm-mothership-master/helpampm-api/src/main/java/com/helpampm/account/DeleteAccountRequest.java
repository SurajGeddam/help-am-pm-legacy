/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.account;

import lombok.Data;

import javax.persistence.*;
import java.time.LocalDateTime;

/**
 * @author kuldeep
 */
@Entity
@Table(name = "tb_account_delete_requests")
@Data
public class DeleteAccountRequest {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    @Column(name = "id")
    private Long id;
    @Column(name = "username")
    private String username;
    @Column(name = "request_date")
    private LocalDateTime requestDate;
    @Column(name = "is_executed")
    private Boolean isExecuted;
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.metadata.license;

import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;

/**
 * @author kuldeep
 */
@Entity
@Table(name = "tb_license_types")
@Data
public class LicenseType implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;
    @Column(name = "license_type_name")
    private String name;
    @Column(name = "is_active")
    private Boolean isActive;
}
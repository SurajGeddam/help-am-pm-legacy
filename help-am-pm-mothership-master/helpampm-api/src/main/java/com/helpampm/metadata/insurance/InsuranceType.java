/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.metadata.insurance;

import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;

/**
 * @author kuldeep
 */

@Entity
@Table(name = "tb_insurance_types")
@Data
public class InsuranceType implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;
    @Column(name = "insurance_type_name")
    private String name;
    @Column(name = "is_active")
    private Boolean isActive;
}

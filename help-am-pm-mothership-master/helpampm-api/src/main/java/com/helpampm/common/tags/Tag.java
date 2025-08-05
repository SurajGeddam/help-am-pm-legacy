/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.common.tags;

import lombok.Data;

import javax.persistence.*;

@Table(name = "tb_tags")
@Data
@Entity
/*
  @author kuldeep
 */
public class Tag {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;
    @Column(name = "tag")
    private String tag;
}

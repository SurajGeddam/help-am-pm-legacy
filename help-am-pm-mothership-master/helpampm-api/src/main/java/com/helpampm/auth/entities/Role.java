/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.entities;

import com.helpampm.auth.exceptions.RoleException;
import lombok.Data;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.GrantedAuthority;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Objects;

@Entity
@Table(name = "tb_roles")
@Data
@Slf4j
/*
  @author kuldeep
 */
public class Role implements GrantedAuthority, Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;
    @Column(name = "name")
    private String name;

    @Override
    public String getAuthority() {
        return this.name;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Role role = (Role) o;
        return name.equals(role.name);
    }

    @Override
    public int hashCode() {
        return name.hashCode();
    }

    public void validate() {
        if (Objects.isNull(this.name) || Objects.equals("", name.trim())) {
            throw new RoleException("Role name can not be empty or null.", HttpStatus.BAD_REQUEST);
        }
        if (!this.name.startsWith("ROLE_")) {
            log.warn("Role name will be appended with ROLE_");
            this.name = "ROLE_" + this.name;
        }
    }
}

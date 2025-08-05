/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.entities;

import com.helpampm.auth.exceptions.UserException;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Data;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Collection;
import java.util.Objects;
import java.util.Set;

@Data
@Entity
@Table(name = "tb_users")
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class UserLoginDetails implements UserDetails, Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "username")
    private String username;
    @Column(name = "password")
    private String password;
    @Column(name = "is_enabled", columnDefinition = "boolean default true")
    private boolean enabled;
    @Column(name = "is_account_non_expired", columnDefinition = "boolean default true")
    private boolean accountNonExpired;
    @Column(name = "is_credentials_non_expired", columnDefinition = "boolean default true")
    private boolean credentialsNonExpired;
    @Column(name = "is_account_non_locked", columnDefinition = "boolean default true")
    private boolean accountNonLocked;
    @Column(name = "is_super_admin", columnDefinition = "boolean default false")
    private boolean isSuperAdmin;

    @ManyToMany(fetch = FetchType.EAGER, cascade = CascadeType.MERGE)
    @JoinColumn(name = "role_id")
    private Set<Role> roles;

    @Column(name = "customer_unique_id")
    private String customerUniqueId;

    @Column(name = "provider_unique_id")
    private String providerUniqueId;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
    @Column(name = "last_updated_at")
    private LocalDateTime lastUpdatedAt;
    @Column(name = "profile_image_path")
    private String profileImagePath;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        UserLoginDetails userLoginDetails = (UserLoginDetails) o;
        return Objects.equals(username, userLoginDetails.username);
    }

    @Override
    public int hashCode() {
        return username != null ? username.hashCode() : 0;
    }

    public void validate() {
        if (Objects.isNull(this.username) || Objects.equals("", username.trim())) {
            throw new UserException("Username can not be empty or null.");
        }

        if (Objects.isNull(this.password) || Objects.equals("", password.trim())) {
            throw new UserException("Password can not be empty or null.");
        }

        if (Objects.isNull(this.roles) || this.roles.isEmpty()) {
            throw new UserException("User must have a role assigned.");
        }

        if (Objects.isNull(this.createdAt)) {
            this.createdAt = LocalDateTime.now();
        }
        if (Objects.isNull(this.lastUpdatedAt)) {
            this.lastUpdatedAt = LocalDateTime.now();
        }
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return roles;
    }

    public void copyNonNullValues(UserLoginDetails userLoginDetails) {
        if (Objects.isNull(userLoginDetails.getUsername())
                || Objects.equals("", userLoginDetails.getUsername().trim())) {
            userLoginDetails.setUsername(username);
        }
        if (Objects.isNull(userLoginDetails.getPassword())
                || Objects.equals("", userLoginDetails.getPassword().trim())) {
            userLoginDetails.setPassword(password);
        }
        if (Objects.isNull(userLoginDetails.getRoles())) {
            userLoginDetails.setRoles(roles);
        }
        if (Objects.isNull(userLoginDetails.getCreatedAt())) {
            userLoginDetails.setCreatedAt(createdAt);
        }
        userLoginDetails.setCredentialsNonExpired(true);
        userLoginDetails.setEnabled(true);
        userLoginDetails.setAccountNonLocked(true);
        userLoginDetails.setAccountNonLocked(true);
    }
}

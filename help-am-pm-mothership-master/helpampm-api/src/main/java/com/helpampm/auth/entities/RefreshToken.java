/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.entities;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonIgnore;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;

@Entity(name = "tb_refresh_tokens")
@Data
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class RefreshToken implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private Long id;
    @JsonIgnore
    @Column(name = "username")
    private String username;
    @Column(name = "refresh_token", nullable = false, unique = true)
    @Lob
    private String token;
    @Column(name = "is_used")
    private Boolean isUsed;
    @Column(name = "used_at")
    private LocalDateTime usedAt;
    @Column(name = "expire_date")
    @JsonFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSS")
    private LocalDateTime expiryDate;

    @Column(name = "created_at")
    private LocalDateTime createdAt;
    @Column(name = "last_updated_at")
    private LocalDateTime lastUpdatedAt;

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        RefreshToken that = (RefreshToken) o;

        if (!id.equals(that.id)) return false;
        if (!username.equals(that.username)) return false;
        return token.equals(that.token);
    }

    @Override
    public int hashCode() {
        int result = id.hashCode();
        result = 31 * result + username.hashCode();
        result = 31 * result + token.hashCode();
        return result;
    }
}

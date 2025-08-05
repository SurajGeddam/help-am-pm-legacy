package com.helpampm.metadata.staticContent;

import com.helpampm.metadata.category.CategoryException;
import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Objects;

@Entity
@Table(name = "tb_static_content")
@Data
public class StaticContent implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    @Column(name = "content_key")
    private String contentKey;

    @Column(columnDefinition = "TEXT", name = "content_value")
    private String contentValue;

    @Column(name = "is_active")
    private Boolean isActive;
    @Column(name = "create_at")
    private LocalDateTime createdAt;
    @Column(name = "last_updated_at")
    private LocalDateTime lastUpdatedAt;

    public void validate() {
        if (Objects.isNull(contentKey) || Objects.equals("", contentKey.trim())) {
            throw new CategoryException("Content Key can not be null or empty");
        }
    }

}

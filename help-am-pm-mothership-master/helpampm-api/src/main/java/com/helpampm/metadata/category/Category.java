/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.metadata.category;

import com.helpampm.metadata.timeslot.Timeslot;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Objects;
import java.util.Set;

@SuppressFBWarnings({"EI_EXPOSE_REP"})
@Entity
@Table(name = "tb_categories")
@Data
/*
  @author kuldeep
 */
public class Category implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Integer id;
    @Column(name = "name")
    private String name;
    @Column(name = "description")
    private String description;
    @Column(name = "icon")
    private String icon;
    @Column(name = "residential_service")
    private Boolean residentialService;
    @Column(name = "commercial_service")
    private Boolean commercialService;

    @OneToMany(fetch = FetchType.EAGER, cascade = CascadeType.MERGE)
    @JoinColumn(name = "category_id")
    @OrderBy("id ASC")
    private Set<Timeslot> timeslots;

    @Column(name = "is_active")
    private Boolean isActive;

    @Column(name = "create_at")
    private LocalDateTime createdAt;
    @Column(name = "last_updated_at")
    private LocalDateTime lastUpdatedAt;

    public void copyNonNullValues(Category category) {
        if (Objects.isNull(category.getName())
                || Objects.equals("", category.getName().trim())) {
            category.setName(name);
        }
        if (Objects.isNull(category.getIcon())
                || Objects.equals("", category.getIcon().trim())) {
            category.setIcon(icon);
        }
        if (Objects.isNull(category.getDescription())
                || Objects.equals("", category.getDescription().trim())) {
            category.setDescription(description);
        }
        if (Objects.isNull(category.getCreatedAt())) {
            category.setCreatedAt(createdAt);
        }
        if (Objects.isNull(category.getCommercialService())) {
            category.setCommercialService(commercialService);
        }
        if (Objects.isNull(category.getResidentialService())) {
            category.setResidentialService(residentialService);
        }
        if (Objects.isNull(category.getIsActive())) {
            category.setIsActive(isActive);
        }
        if (Objects.isNull(category.getTimeslots())) {
            category.setTimeslots(timeslots);
        }
    }

    public void validate() {
        if (Objects.isNull(name) || Objects.equals("", name.trim())) {
            throw new CategoryException("Category name can not be null or empty");
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Category category = (Category) o;

        if (!Objects.equals(name, category.name)) return false;
        if (!Objects.equals(residentialService, category.residentialService))
            return false;
        return Objects.equals(commercialService, category.commercialService);
    }

    @Override
    public int hashCode() {
        int result = name != null ? name.hashCode() : 0;
        result = 31 * result + (residentialService != null ? residentialService.hashCode() : 0);
        result = 31 * result + (commercialService != null ? commercialService.hashCode() : 0);
        return result;
    }
}

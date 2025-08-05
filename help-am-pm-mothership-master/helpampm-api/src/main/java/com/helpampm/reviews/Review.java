/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.reviews;

import com.helpampm.customer.CustomerException;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Data;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.util.Objects;

@Entity
@Table(name = "tb_reviews")
@Data
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class Review {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "given_by_id")
    private String givenById;
    @Column(name = "given_to_id")
    private String givenToId;
    @Column(name = "rating")
    private int rating;
    @Column(name = "comment")
    @Lob
    private String comment;
    @Column(name = "is_published")
    private Boolean isPublished;

//    @ManyToMany(fetch = FetchType.EAGER, cascade = CascadeType.MERGE)
//    private Set<Tag> tags;

    @Column(name = "create_at")
    private LocalDateTime createdAt;
    @Column(name = "published_at")
    private LocalDateTime publishedAt;

    public void validate() {
        if (Objects.isNull(givenById)) {
            throw new CustomerException("Review must have reviewer.");
        }
        if (Objects.isNull(givenToId)) {
            throw new CustomerException("Review must have received.");
        }
        if (Objects.isNull(comment) || Objects.equals("", comment.trim())) {
            throw new CustomerException("Review must have reviewer.");
        }
        if (Objects.isNull(isPublished)) {
            isPublished = false;
        }
    }
}

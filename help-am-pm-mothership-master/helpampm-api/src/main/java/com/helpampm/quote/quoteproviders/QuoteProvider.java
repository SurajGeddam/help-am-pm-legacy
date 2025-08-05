/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote.quoteproviders;

import lombok.Data;

import javax.persistence.*;

@Entity
@Table(name = "quote_provider_info")
@Data
/*
  @author kuldeep
 */
public class QuoteProvider {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "provider_unique_id")
    private String uniqueId;
    @Column(name = "provider_name") //this is company name for company
    private String providerName;
    @Column(name = "provider_image") //this is company name for company
    private String providerImage;

    public void validate() {
    }
}

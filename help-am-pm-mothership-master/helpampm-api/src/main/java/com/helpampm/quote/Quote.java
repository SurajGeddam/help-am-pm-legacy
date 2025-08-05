/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.helpampm.common.StringUtils;
import com.helpampm.invoicing.Invoice;
import com.helpampm.metadata.tax.Tax;
import com.helpampm.metadata.timeslot.Timeslot;
import com.helpampm.payments.Payment;
import com.helpampm.quote.quotecustomers.QuoteCustomer;
import com.helpampm.quote.quoteitems.QuoteItem;
import com.helpampm.quote.quoteproviders.QuoteProvider;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Data;
import org.springframework.http.HttpStatus;

import javax.persistence.*;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Objects;
import java.util.Set;

@SuppressFBWarnings("EI_EXPOSE_REP")
@Entity
@Table(name = "tb_customer_quotes")
@Data
/*
  @author kuldeep
 */
public class Quote {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;
    @Column(name = "order_unique_id")
    private String quoteUniqueId; // category + date + count

    @Column(name = "service_desc")
    @Lob
    private String serviceDescription;
    @Column(name = "category_name")
    private String categoryName;
    @Column(name = "service_charges")
    private Double serviceCharge;
    @Column(name = "total_bill")
    private Double totalBill;
    @Column(name = "provider_search_radius")
    private double providerSearchRadius;

    @OneToOne(cascade = CascadeType.MERGE, fetch = FetchType.EAGER, orphanRemoval = true)
    private QuoteProvider quoteProvider;
    @OneToOne(cascade = CascadeType.MERGE, fetch = FetchType.EAGER, orphanRemoval = true)
    private Payment payment;
    @OneToOne(cascade = CascadeType.MERGE, fetch = FetchType.EAGER, orphanRemoval = true)
    private Timeslot timeSlot;
    @OneToOne(cascade = CascadeType.MERGE, fetch = FetchType.EAGER, orphanRemoval = true)
    private Tax tax;
    @OneToMany(fetch = FetchType.EAGER, cascade = CascadeType.MERGE, orphanRemoval = true)
    @JoinColumn(name = "order_id")
    private Set<QuoteItem> items;
    @OneToOne(cascade = CascadeType.MERGE, fetch = FetchType.EAGER, orphanRemoval = true)
    private QuoteCustomer quoteCustomer;
    @OneToOne(cascade = CascadeType.MERGE, fetch = FetchType.EAGER, orphanRemoval = true)
    private Invoice invoice;

    //If order is locked, it can not be modified. Usually it will be locked once invoice is raised and paid.
    @Column(name = "is_order_locked")
    private Boolean isOrderLocked;

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private QuoteStatus status;

    @Column(name = "is_residence_service", columnDefinition = "boolean default false")
    private Boolean isResidenceService;
    @Column(name = "is_commercial_service", columnDefinition = "boolean default false")
    private Boolean isCommercialService;

    @Column(name = "scheduled_time")
    private LocalDateTime scheduledTime;

    @ElementCollection
    @CollectionTable(name="quote_notified_provider_table")
    @JsonIgnore
    private Set<String> notifiedProviders;

    @Column(name = "create_at")
    private LocalDateTime createdAt;
    @Column(name = "last_updated_at")
    private LocalDateTime lastUpdatedAt;
    @Column(name = "image_path")
    private String imagePath;
    @Column(name = "provider_eta")
    private LocalTime eta;

    public void validate() {
        if (StringUtils.isNullOrEmpty(quoteUniqueId)) {
            throw new QuoteException("Unable to accept your order, please try after some time.", HttpStatus.INTERNAL_SERVER_ERROR.value());
        }
        if (Objects.isNull(quoteCustomer)) {
            throw new QuoteException("Customer must not be null", HttpStatus.BAD_REQUEST.value());
        } else {
            quoteCustomer.validate();
        }
        if (Objects.nonNull(quoteProvider)) {
            quoteProvider.validate();
        }
        if (Objects.isNull(tax)) {
            throw new QuoteException("Tax can not be null.", HttpStatus.BAD_REQUEST.value());
        }
        if (StringUtils.isNullOrEmpty(categoryName)) {
            throw new QuoteException("Category can not be null or empty", HttpStatus.BAD_REQUEST.value());
        }
        if (Objects.isNull(timeSlot)) {
            throw new QuoteException("TimeSlot can not be null.", HttpStatus.BAD_REQUEST.value());
        }
        if (Objects.isNull(status)) {
            throw new QuoteException("Order status can not be null", HttpStatus.BAD_REQUEST.value());
        }
        if (Objects.isNull(serviceCharge)) {
            throw new QuoteException("Service charges can not be null", HttpStatus.BAD_REQUEST.value());
        }
        if (Objects.isNull(isOrderLocked)) {
            isOrderLocked = false;
        }
        if (Objects.isNull(isResidenceService)) {
            isResidenceService = true;
        }
    }
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.customer;

import com.helpampm.address.Address;
import com.helpampm.auth.entities.UserLoginDetails;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Objects;
import java.util.Set;

@Entity
@Table(name = "tb_customers")
@Data
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class Customer implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "first_name")
    private String firstName;
    @Column(name = "last_name")
    private String lastName;
    @Column(name = "phone")
    private String phone;
    @Column(name = "email")
    private String email;
    @Column(name = "average_provider_rating")
    private Double averageProviderRating;
    @Column(name = "total_provider_ratings")
    private Long totalProviderRatings;
    @OneToMany(cascade = CascadeType.MERGE, fetch = FetchType.EAGER)
    private Set<Address> addresses;
    @OneToOne(fetch = FetchType.EAGER, orphanRemoval = true,
            cascade = CascadeType.ALL, targetEntity = UserLoginDetails.class)
    @JoinColumn(name = "login_credentials", referencedColumnName = "id")
    private UserLoginDetails userLoginDetails;
    @Column(name = "is_active")
    private Boolean isActive;
    @Column(name = "customer_unique_id")
    private String customerUniqueId;

    @Column(name = "sms_notification_enabled")
    private boolean smsNotificationEnabled = false;
    @Column(name = "email_notification_enabled")
    private boolean emailNotificationEnabled = true;
    @Column(name = "push_notification_enabled")
    private boolean pushNotificationEnabled = true;
    @Column(name = "create_at")
    private LocalDateTime createdAt;
    @Column(name = "last_updated_at")
    private LocalDateTime lastUpdatedAt;
    @Column(name = "profile_image_path")
    private String profileImagePath;

    public void copyNonNullValues(Customer customer) {
        setCustomerBasicDetails(customer);
        setCustomerRatingAndUniqueIdAndActive(customer);
    }

    private void setCustomerRatingAndUniqueIdAndActive(Customer customer) {
        if (Objects.isNull(customer.getAverageProviderRating())
                || Objects.equals(0.0, customer.getAverageProviderRating())) {
            customer.setAverageProviderRating(averageProviderRating);
        }
        if (Objects.isNull(customer.getTotalProviderRatings())
                || Objects.equals(0L, customer.getTotalProviderRatings())) {
            customer.setTotalProviderRatings(totalProviderRatings);
        }

        if (Objects.isNull(customer.getCustomerUniqueId()) || Objects.equals("", customer.getCustomerUniqueId())) {
            customer.setCustomerUniqueId(customerUniqueId);
        }

        if (Objects.isNull(customer.getIsActive())) {
            customer.setIsActive(isActive);
            customer.getUserLoginDetails().setEnabled(isActive);
        }

        if (Objects.isNull(customer.getCreatedAt())) {
            customer.setCreatedAt(createdAt);
        }
    }

    private void setCustomerBasicDetails(Customer customer) {
        if (Objects.isNull(customer.getEmail()) || Objects.equals("", customer.getEmail())) {
            customer.setEmail(email);
        }
        if (Objects.isNull(customer.getFirstName()) || Objects.equals("", customer.getFirstName())) {
            customer.setFirstName(firstName);
        }
        if (Objects.isNull(customer.getLastName()) || Objects.equals("", customer.getLastName())) {
            customer.setLastName(lastName);
        }
        if (Objects.isNull(customer.getPhone()) || Objects.equals("", customer.getPhone())) {
            customer.setPhone(phone);
        }
        if (Objects.isNull(customer.getUserLoginDetails())) {
            customer.setUserLoginDetails(userLoginDetails);
        }
        if (Objects.isNull(customer.getAddresses()) || customer.getAddresses().isEmpty()) {
            customer.setAddresses(addresses);
        }
    }

    public void validate() {
        if ((Objects.isNull(firstName) || Objects.equals("", firstName.trim()))
                && Objects.isNull(lastName) || Objects.equals("", lastName.trim())) {
            throw new CustomerException("First name and Last name both can not be null or empty.");
        }
        if ((Objects.isNull(phone) || Objects.equals("", phone.trim()))
                && Objects.isNull(email) || Objects.equals("", email.trim())) {
            throw new CustomerException("Phone and Email both can not be null or empty.");
        }
        if (Objects.isNull(userLoginDetails)) {
            throw new CustomerException("Customer login details are mandatory.");
        } else {
            userLoginDetails.validate();
        }
        if (Objects.nonNull(addresses)) {
            for (Address address : addresses) {
                address.validate();
            }
        }
        if (Objects.isNull(isActive)) {
            isActive = true;
        }
        if (Objects.isNull(averageProviderRating)) {
            averageProviderRating = 0.0;
        }
        // Always true while signup
        pushNotificationEnabled = true;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Customer customer = (Customer) o;

        if (!id.equals(customer.id)) return false;
        return userLoginDetails.equals(customer.userLoginDetails);
    }

    @Override
    public int hashCode() {
        int result = id.hashCode();
        result = 31 * result + userLoginDetails.hashCode();
        return result;
    }
}

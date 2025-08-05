/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider;

import com.helpampm.address.Address;
import com.helpampm.auth.entities.UserLoginDetails;
import com.helpampm.customer.CustomerException;
import com.helpampm.metadata.timeslot.Timeslot;
import com.helpampm.provider.bankaccount.BankAccount;
import com.helpampm.provider.categories.ProviderCategory;
import com.helpampm.provider.insurance.Insurance;
import com.helpampm.provider.license.License;
import com.helpampm.provider.vehicle.Vehicle;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Data;
import org.springframework.http.HttpStatus;
import org.springframework.util.StringUtils;

import javax.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;
import java.util.Set;

@Entity
@Table(name = "tb_providers")
@Data
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class Provider {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "name")
    private String name;

    @Column(name = "first_name")
    private String firstName;

    @Column(name = "last_name")
    private String lastName;

    @Column(name = "is_individual")
    private boolean isIndividual;
    @Column(name = "website")
    private String website;
    @Column(name = "email")
    private String email;
    @Column(name = "phone")
    private String phone;
    @Column(name = "dob")
    private LocalDate dob;

    @Column(name = "ssn_Last4")
    private String ssnLast4;

    @Column(name = "years_of_experience")
    private int yearsOfExperience;
    @Column(name = "average_customer_rating")
    private Double customerAverageRating;
    @Column(name = "total_customer_ratings")
    private Long totalCustomerRatings;
    @Column(name = "company_unique_id")
    private String companyUniqueId;
    @Column(name = "parent_company_unique_id")
    private String parentCompanyUniqueId;
    @Column(name = "provider_unique_id")
    private String providerUniqueId;

    @Column(name = "is_stripe_set_done")
    private boolean stripeSetupDone;

    @Column(name = "stripe_secret_hash")
    private String stripeSecretHash;
    @Column(name = "account_setup_completed")
    private Boolean accountSetupCompleted;
    @Column(name = "account_setup_reminder_count", columnDefinition = "int default 0")
    private long accountSetupRemindersCount;
    @Column(name = "is_active")
    private Boolean isActive;
    @OneToOne(fetch = FetchType.EAGER, orphanRemoval = true,
            cascade = CascadeType.MERGE, targetEntity = UserLoginDetails.class)
    @JoinColumn(name = "login_credentials")
    private UserLoginDetails userLoginDetails;
    @OneToOne(fetch = FetchType.EAGER, cascade = CascadeType.MERGE,
            targetEntity = Address.class, orphanRemoval = true)
    @JoinColumn(name = "address")
    private Address address;
    @OneToOne(fetch = FetchType.EAGER, orphanRemoval = true,
            cascade = CascadeType.MERGE, targetEntity = BankAccount.class)
    @JoinColumn(name = "bank_account")
    private BankAccount bankAccount;
    @ManyToMany(cascade = CascadeType.MERGE, fetch = FetchType.EAGER)
    @JoinColumn(name = "license_id")
    private Set<License> licenses;

    @ManyToMany(cascade = CascadeType.MERGE, fetch = FetchType.EAGER)
    @JoinColumn(name = "insurance_id")
    private Set<Insurance> insurances;
    @ManyToMany(cascade = CascadeType.MERGE, fetch = FetchType.EAGER)
    @JoinColumn(name = "vehicle_id")
    private Set<Vehicle> vehicles;
    @ManyToMany(cascade = CascadeType.MERGE, fetch = FetchType.EAGER)
    @JoinColumn(name = "timeslot_id")
    private Set<Timeslot> timeslots;
    @ManyToMany(cascade = CascadeType.MERGE, fetch = FetchType.EAGER)
    @JoinColumn(name = "category_id")
    private Set<ProviderCategory> categories;

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
    @Column(name = "last_completed_page")
    private CompletedPage lastCompletedPage;
    @Column(name = "profile_image_path")
    private String profileImagePath;
    @Column(name = "stripe_accountId")
    private String stripAccountId;
    @Column(name = "payout_enable")
    private boolean payoutEnable = true;

    public void validate() {
        validateProviderBasicDetails();

        if (Objects.isNull(userLoginDetails)) {
            throw new CustomerException("Customer login details are mandatory.");
        } else {
            userLoginDetails.validate();
        }


        validateProviderCompany();
        //Always true while creating a provider
        pushNotificationEnabled = true;
    }

    private void validateProviderBasicDetails() {
        if ((Objects.isNull(providerUniqueId) || !StringUtils.hasText(providerUniqueId))) {
            throw new ProviderException("Provider unique id can not be null or empty.", HttpStatus.BAD_REQUEST);
        }
        if ((Objects.isNull(name) || !StringUtils.hasText(name))) {
            throw new ProviderException("Name can not be null or empty.", HttpStatus.BAD_REQUEST);
        }
        if ((Objects.isNull(phone) || !StringUtils.hasText(phone))
                && Objects.isNull(email) || Objects.equals("", email.trim())) {
            throw new CustomerException("Phone and Email both can not be null or empty.");
        }
        if (Objects.nonNull(address)) {
            address.validate();
        }
    }

    private void validateProviderCompany() {
        if (Objects.nonNull(categories)) {
            for (ProviderCategory category : categories) {
                category.validate();
            }
        }
        if (Objects.nonNull(timeslots)) {
            for (Timeslot timeslot : timeslots) {
                timeslot.validate();
            }
        }
        validateProviderVehicles();
        if (Objects.nonNull(bankAccount)) {
            bankAccount.validate();
        }
    }

    private void validateProviderVehicles() {
        if (Objects.nonNull(vehicles)) {
            for (Vehicle vehicle : vehicles) {
                vehicle.validate();
            }
        }
        if (Objects.nonNull(insurances)) {
            for (Insurance insurance : insurances) {
                insurance.validate();
            }
        }
        if (Objects.nonNull(licenses)) {
            for (License license : licenses) {
                license.validate();
            }
        }
    }

    public void copyNonNullValues(Provider provider) {

        setBasicDetails(provider);
        providerIdDetails(provider);
        providerCompanyDetails(provider);

    }

    private void providerCompanyDetails(Provider provider) {


        if (Objects.isNull(provider.getCategories()) || provider.getCategories().isEmpty()) {
            provider.setCategories(categories);
        }
        if (Objects.isNull(provider.getVehicles()) || provider.getVehicles().isEmpty()) {
            provider.setVehicles(vehicles);
        }
        if (Objects.isNull(provider.getLicenses()) || provider.getLicenses().isEmpty()) {
            provider.setLicenses(licenses);
        }
        if (Objects.isNull(provider.getInsurances()) || provider.getInsurances().isEmpty()) {
            provider.setInsurances(insurances);
        }
        if (Objects.isNull(provider.getBankAccount())) {
            provider.setBankAccount(bankAccount);
        }
        if (Objects.isNull(provider.getAccountSetupCompleted())) {
            provider.setAccountSetupCompleted(accountSetupCompleted);
        }
        if (Objects.isNull(provider.getIsActive())) {
            provider.setIsActive(isActive);
        }
        if (Objects.isNull(provider.getTotalCustomerRatings())
                || Objects.equals(0L, provider.getTotalCustomerRatings())) {
            provider.setTotalCustomerRatings(totalCustomerRatings);
        }
    }

    private void providerIdDetails(Provider provider) {
        if (Objects.isNull(provider.getCompanyUniqueId())
                || Objects.equals("", provider.getCompanyUniqueId())) {
            provider.setCompanyUniqueId(companyUniqueId);
        }
        if (Objects.isNull(provider.getParentCompanyUniqueId())
                || Objects.equals("", provider.getParentCompanyUniqueId())) {
            provider.setParentCompanyUniqueId(parentCompanyUniqueId);
        }
        if (Objects.isNull(provider.getProviderUniqueId())
                || !StringUtils.hasText(provider.getProviderUniqueId())) {
            provider.setProviderUniqueId(providerUniqueId);
        }
    }

    private void setBasicDetails(Provider provider) {
        if (Objects.isNull(provider.getEmail()) || Objects.equals("", provider.getEmail())) {
            provider.setEmail(email);
        }
        if (Objects.isNull(provider.getName()) || Objects.equals("", provider.getName())) {
            provider.setName(name);
        }
        if (Objects.isNull(provider.getAddress())) {
            provider.setAddress(address);
        }
        if (Objects.isNull(provider.getPhone()) || Objects.equals("", provider.getPhone())) {
            provider.setPhone(phone);
        }
        if (Objects.isNull(provider.getCustomerAverageRating())
                || Objects.equals(0.0, provider.getCustomerAverageRating())) {
            provider.setCustomerAverageRating(customerAverageRating);
        }
        if (Objects.isNull(provider.getAddress())) {
            provider.setAddress(address);
        }
        if (Objects.isNull(provider.getCreatedAt())) {
            provider.setCreatedAt(createdAt);
        }
        if (Objects.isNull(provider.getUserLoginDetails())) {
            provider.setUserLoginDetails(userLoginDetails);
        }
    }
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.license;

import com.helpampm.common.StringUtils;
import com.helpampm.metadata.license.LicenseType;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;

@SuppressFBWarnings("EI_EXPOSE_REP2")
@Entity
@Table(name = "tb_licenses")
@Data
/*
  @author kuldeep
 */
public class License implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "issued_by")
    private String issuedBy;
    @Column(name = "registered_state")
    private String registeredState;
    @OneToOne
    private LicenseType licenseType;
    @Column(name = "license_number")
    private String licenseNumber;
    @Column(name = "license_start")
    private LocalDate licenseStartDate;
    @Column(name = "license_expires")
    private LocalDate licenseExpiryDate;
    @Column(name = "license_holder_name")
    private String licenseHolderName;
    @Column(name = "is_active")
    private Boolean isActive;
    @Column(name = "provider_unique_id")
    private String providerUniqueId;

    @Column(name = "create_at")
    private LocalDateTime createdAt;
    @Column(name = "last_updated_at")
    private LocalDateTime lastUpdatedAt;
    @Column(name = "image_path")
    private String imagePath;


    public void validate() {
        if (StringUtils.isNullOrEmpty(issuedBy)) {
            throw new IllegalArgumentException("License issued by can not be null or empty");
        }
        if (StringUtils.isNullOrEmpty(registeredState)) {
            throw new IllegalArgumentException("Registered State by can not be null or empty");
        }
        if (Objects.isNull(licenseType)) {
            throw new IllegalArgumentException("License type can not be null or empty");
        }
        if (StringUtils.isNullOrEmpty(licenseNumber)) {
            throw new IllegalArgumentException("License number can not be null or empty");
        }
        if (StringUtils.isNullOrEmpty(licenseHolderName)) {
            throw new IllegalArgumentException("License holder name id can not be null or empty");
        }
        if (StringUtils.isNullOrEmpty(providerUniqueId)) {
            throw new IllegalArgumentException("Provider unique id can not be null or empty");
        }
        if (Objects.isNull(licenseStartDate)) {
            throw new IllegalArgumentException("License start date can not be null.");
        }
        if (Objects.isNull(licenseExpiryDate)) {
            throw new IllegalArgumentException("License expiry date can not be null.");
        }
        if (Objects.isNull(isActive)) {
            isActive = true;
        }
    }

    public void copyNonNullValues(License license) {
        if (Objects.isNull(license.getIssuedBy())) {
            license.setIssuedBy(issuedBy);
        }
        if (Objects.isNull(license.getIsActive())) {
            license.setIsActive(isActive);
        }
        if (Objects.isNull(license.getCreatedAt())) {
            license.setCreatedAt(createdAt);
        }
        if (Objects.isNull(license.getLicenseNumber())) {
            license.setLicenseNumber(licenseNumber);
        }
        if (Objects.isNull(license.getLicenseExpiryDate())) {
            license.setLicenseExpiryDate(licenseExpiryDate);
        }
        if (Objects.isNull(license.getLicenseStartDate())) {
            license.setLicenseStartDate(licenseStartDate);
        }
        if (Objects.isNull(license.getLicenseHolderName())) {
            license.setLicenseHolderName(licenseHolderName);
        }
        if (Objects.isNull(license.getProviderUniqueId())) {
            license.setProviderUniqueId(providerUniqueId);
        }
        if (Objects.isNull(license.getLicenseType())) {
            license.setLicenseType(licenseType);
        }
        if (Objects.isNull(license.getRegisteredState())) {
            license.setRegisteredState(registeredState);
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        License license = (License) o;

        if (!Objects.equals(issuedBy, license.issuedBy)) return false;
        if (!Objects.equals(licenseType, license.licenseType)) return false;
        if (!Objects.equals(licenseNumber, license.licenseNumber))
            return false;
        if (!Objects.equals(licenseStartDate, license.licenseStartDate))
            return false;
        if (!Objects.equals(licenseExpiryDate, license.licenseExpiryDate))
            return false;
        if (!Objects.equals(licenseHolderName, license.licenseHolderName))
            return false;
        return Objects.equals(providerUniqueId, license.providerUniqueId);
    }

    @Override
    public int hashCode() {
        int result = issuedBy != null ? issuedBy.hashCode() : 0;
        result = 31 * result + (licenseType != null ? licenseType.hashCode() : 0);
        result = 31 * result + (licenseNumber != null ? licenseNumber.hashCode() : 0);
        result = 31 * result + (licenseStartDate != null ? licenseStartDate.hashCode() : 0);
        result = 31 * result + (licenseExpiryDate != null ? licenseExpiryDate.hashCode() : 0);
        result = 31 * result + (licenseHolderName != null ? licenseHolderName.hashCode() : 0);
        result = 31 * result + (providerUniqueId != null ? providerUniqueId.hashCode() : 0);
        return result;
    }
}

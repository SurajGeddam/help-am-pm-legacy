/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.insurance;

import com.helpampm.common.StringUtils;
import com.helpampm.metadata.insurance.InsuranceType;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.Data;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Objects;

@SuppressFBWarnings("EI_EXPOSE_REP2")
@Entity
@Table(name = "tb_insurances")
@Data
/*
  @author kuldeep
 */
public class Insurance implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "insurer_name")
    private String insurerName;
    @OneToOne
    private InsuranceType policyType;
    @Column(name = "policy_number")
    private String policyNumber;
    @Column(name = "policy_start")
    private LocalDate policyStartDate;
    @Column(name = "policy_expires")
    private LocalDate policyExpiryDate;
    @Column(name = "policy_holder_name")
    private String policyHolderName;
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
        if (StringUtils.isNullOrEmpty(insurerName)) {
            throw new IllegalArgumentException("Insurer name can not be null or empty");
        }
        if (Objects.isNull(policyType)) {
            throw new IllegalArgumentException("Insurance type can not be null or empty");
        }
        if (StringUtils.isNullOrEmpty(policyNumber)) {
            throw new IllegalArgumentException("Policy number can not be null or empty");
        }
        if (StringUtils.isNullOrEmpty(policyHolderName)) {
            throw new IllegalArgumentException("Policy holder name id can not be null or empty");
        }
        if (StringUtils.isNullOrEmpty(providerUniqueId)) {
            throw new IllegalArgumentException("Provider unique id can not be null or empty");
        }
        if (Objects.isNull(policyExpiryDate)) {
            throw new IllegalArgumentException("Policy expiry date can not be null.");
        }
        if (Objects.isNull(isActive)) {
            isActive = true;
        }
    }

    public void copyNonNullValues(Insurance insurance) {
        if (Objects.isNull(insurance.getInsurerName())
                || Objects.equals("", insurance.getInsurerName().trim())) {
            insurance.setInsurerName(insurerName);
        }
        if (Objects.isNull(insurance.getIsActive())) {
            insurance.setIsActive(isActive);
        }
        if (Objects.isNull(insurance.getCreatedAt())) {
            insurance.setCreatedAt(createdAt);
        }
        if (Objects.isNull(insurance.getPolicyNumber())
                || Objects.equals("", insurance.getPolicyNumber().trim())) {
            insurance.setPolicyNumber(policyNumber);
        }
        if (Objects.isNull(insurance.getPolicyExpiryDate())) {
            insurance.setPolicyExpiryDate(policyExpiryDate);
        }
        if (Objects.isNull(insurance.getPolicyStartDate())) {
            insurance.setPolicyStartDate(policyStartDate);
        }
        if (Objects.isNull(insurance.getPolicyHolderName())
                || Objects.equals("", insurance.getPolicyHolderName().trim())) {
            insurance.setPolicyHolderName(policyHolderName);
        }
        if (Objects.isNull(insurance.getProviderUniqueId())) {
            insurance.setProviderUniqueId(providerUniqueId);
        }
        if (Objects.isNull(insurance.getPolicyType())) {
            insurance.setPolicyType(policyType);
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        Insurance insurance = (Insurance) o;

        if (!Objects.equals(insurerName, insurance.insurerName))
            return false;
        if (!Objects.equals(policyType, insurance.policyType)) return false;
        if (!Objects.equals(policyNumber, insurance.policyNumber))
            return false;
        if (!Objects.equals(policyStartDate, insurance.policyStartDate))
            return false;
        if (!Objects.equals(policyExpiryDate, insurance.policyExpiryDate))
            return false;
        if (!Objects.equals(policyHolderName, insurance.policyHolderName))
            return false;
        return Objects.equals(providerUniqueId, insurance.providerUniqueId);
    }

    @Override
    public int hashCode() {
        int result = insurerName != null ? insurerName.hashCode() : 0;
        result = 31 * result + (policyType != null ? policyType.hashCode() : 0);
        result = 31 * result + (policyNumber != null ? policyNumber.hashCode() : 0);
        result = 31 * result + (policyStartDate != null ? policyStartDate.hashCode() : 0);
        result = 31 * result + (policyExpiryDate != null ? policyExpiryDate.hashCode() : 0);
        result = 31 * result + (policyHolderName != null ? policyHolderName.hashCode() : 0);
        result = 31 * result + (providerUniqueId != null ? providerUniqueId.hashCode() : 0);
        return result;
    }
}

/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.bankaccount;

import com.helpampm.provider.ProviderException;
import lombok.Data;
import org.springframework.http.HttpStatus;

import javax.persistence.*;
import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.Objects;

@Entity
@Table(name = "tb_bank_account")
@Data
/*
  @author kuldeep
 */
public class BankAccount implements Serializable {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;

    @Column(name = "account_holder_name")
    private String accountHolderName;
    @Column(name = "account_number")
    private String accountNumber;
    @Column(name = "bank_name")
    private String bankName;
    @Enumerated(EnumType.STRING)
    @Column(name = "account_type")
    private AccountType accountType;
    @Column(name = "routing_number")
    private String routingNumber;
    @Column(name = "provider_unique_id")
    private String providerUniqueId;
    @Column(name = "parent_company_unique_id")
    private String parentCompanyUniqueId;
    @Column(name = "create_at")
    private LocalDateTime createdAt;
    @Column(name = "last_updated_at")
    private LocalDateTime lastUpdatedAt;

    public void validate() {
        if (Objects.isNull(this.accountHolderName) || Objects.equals("", accountHolderName.trim())) {
            throw new ProviderException("Account holder name can't be null for bank account.", HttpStatus.BAD_REQUEST);
        }
        if (Objects.isNull(this.accountNumber) || Objects.equals("", accountNumber.trim())) {
            throw new ProviderException("Account Number can't be null for bank account.", HttpStatus.BAD_REQUEST);
        }
        if (Objects.isNull(this.bankName) || Objects.equals("", bankName.trim())) {
            throw new ProviderException("Bank Name can't be null for bank account.", HttpStatus.BAD_REQUEST);
        }
        if (Objects.isNull(this.routingNumber) || Objects.equals("", routingNumber.trim())) {
            throw new ProviderException("Routing Number can't be null for bank account.", HttpStatus.BAD_REQUEST);
        }
        if (Objects.isNull(this.accountType)) {
            throw new ProviderException("Account Type can't be null for bank account.", HttpStatus.BAD_REQUEST);
        }
    }

    public void copyNonNullValues(BankAccount bankAccount) {
        if (Objects.isNull(bankAccount.getAccountHolderName())
                || Objects.equals("", bankAccount.getAccountHolderName().trim())) {
            bankAccount.setAccountHolderName(accountHolderName);
        }
        if (Objects.isNull(bankAccount.getAccountType())) {
            bankAccount.setAccountType(getAccountType());
        }
        if (Objects.isNull(bankAccount.getBankName())
                || Objects.equals("", bankAccount.getBankName())) {
            bankAccount.setBankName(bankName);
        }
        if (Objects.isNull(bankAccount.getRoutingNumber())
                || Objects.equals("", bankAccount.getRoutingNumber())) {
            bankAccount.setRoutingNumber(routingNumber);
        }
        if (Objects.isNull(bankAccount.getAccountNumber())
                || Objects.equals("", bankAccount.getAccountNumber())) {
            bankAccount.setAccountNumber(accountNumber);
        }
        if (Objects.isNull(bankAccount.getProviderUniqueId())
                || Objects.equals("", bankAccount.getProviderUniqueId())) {
            bankAccount.setProviderUniqueId(providerUniqueId);
        }
        if (Objects.isNull(bankAccount.getParentCompanyUniqueId())
                || Objects.equals("", bankAccount.getParentCompanyUniqueId())) {
            bankAccount.setParentCompanyUniqueId(parentCompanyUniqueId);
        }

        if (Objects.isNull(bankAccount.getCreatedAt())) {
            bankAccount.setCreatedAt(createdAt);
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        BankAccount that = (BankAccount) o;

        if (!accountHolderName.equals(that.accountHolderName)) return false;
        if (!accountNumber.equals(that.accountNumber)) return false;
        if (!bankName.equals(that.bankName)) return false;
        if (accountType != that.accountType) return false;
        if (!routingNumber.equals(that.routingNumber)) return false;
        return providerUniqueId.equals(that.providerUniqueId);
    }

    @Override
    public int hashCode() {
        int result = accountHolderName.hashCode();
        result = 31 * result + accountNumber.hashCode();
        result = 31 * result + bankName.hashCode();
        result = 31 * result + accountType.hashCode();
        result = 31 * result + routingNumber.hashCode();
        result = 31 * result + providerUniqueId.hashCode();
        return result;
    }
}

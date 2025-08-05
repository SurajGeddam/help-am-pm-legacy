/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.dto;

import com.helpampm.provider.bankaccount.AccountType;
import com.helpampm.provider.bankaccount.BankAccount;
import edu.umd.cs.findbugs.annotations.SuppressFBWarnings;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;

import java.io.Serializable;

@Data
@Builder(setterPrefix = "with")
@AllArgsConstructor
@SuppressFBWarnings("EI_EXPOSE_REP")
/*
  @author kuldeep
 */
public class BankAccountDto implements Serializable {
    private long id;
    private String accountHolderName;
    private String accountNumber;
    private String bankName;
    private AccountType accountType;
    private String routingNumber;
    private String providerUniqueId;
    private String parentCompanyUniqueId;


    public static BankAccountDto buildWithBankAccount(BankAccount bankAccount) {
        if (bankAccount != null) {
            return BankAccountDto.builder()
                    .withId(bankAccount.getId())
                    .withBankName(bankAccount.getBankName())
                    .withAccountType(bankAccount.getAccountType())
                    .withAccountNumber(bankAccount.getAccountNumber())
                    .withAccountHolderName(bankAccount.getAccountHolderName())
                    .withRoutingNumber(bankAccount.getRoutingNumber())
                    .withProviderUniqueId(bankAccount.getProviderUniqueId())
                    .withParentCompanyUniqueId(bankAccount.getParentCompanyUniqueId())
                    .build();
        } else {
            return null;

        }
    }

}

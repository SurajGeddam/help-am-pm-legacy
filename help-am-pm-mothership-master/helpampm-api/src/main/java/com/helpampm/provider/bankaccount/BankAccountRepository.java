/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.bankaccount;


import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

/**
 * @author kuldeep
 */
public interface BankAccountRepository extends JpaRepository<BankAccount, Long> {
    Optional<BankAccount> findByProviderUniqueIdAndAccountNumberAndRoutingNumberAndAccountHolderName(String providerUniqueId, String accountNumber, String routingNumber, String accountHolderName);
}

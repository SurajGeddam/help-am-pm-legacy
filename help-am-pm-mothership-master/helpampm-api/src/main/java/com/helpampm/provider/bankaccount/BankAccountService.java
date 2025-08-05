/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.bankaccount;

import java.util.Optional;

/**
 * @author kuldeep
 */
public interface BankAccountService {
    BankAccount save(BankAccount bankAccount);

    BankAccount update(BankAccount bankAccount);

    Optional<BankAccount> findByProviderUniqueIdAndAccountNumberAndRoutingNumberAndAccountHolderName(String providerUniqueId,
                                                                                                     String accountNumber, String routingNumber, String accountHolderName);

    BankAccount findById(Long id);
}

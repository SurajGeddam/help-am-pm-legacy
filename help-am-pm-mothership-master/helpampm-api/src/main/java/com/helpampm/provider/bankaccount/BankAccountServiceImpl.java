/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.provider.bankaccount;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Objects;
import java.util.Optional;

@Service
@Slf4j
@RequiredArgsConstructor
/*
  @author kuldeep
 */
public class BankAccountServiceImpl implements BankAccountService {
    private final BankAccountRepository repository;

    @Override
    public BankAccount save(BankAccount bankAccount) {
        assert Objects.nonNull(bankAccount);
        bankAccount.setLastUpdatedAt(LocalDateTime.now());
        bankAccount.setCreatedAt(LocalDateTime.now());
        checkDuplicates(bankAccount);
        bankAccount.validate();
        return repository.save(bankAccount);
    }

    private void checkDuplicates(BankAccount bankAccount) {
        if (findByProviderUniqueIdAndAccountNumberAndRoutingNumberAndAccountHolderName(bankAccount.getProviderUniqueId(),
                bankAccount.getAccountNumber(),
                bankAccount.getRoutingNumber(),
                bankAccount.getAccountHolderName()).isPresent()) {
            throw new DuplicateKeyException("Bank account is already exists.");
        }
    }

    @Override
    public BankAccount update(BankAccount bankAccount) {
        return repository.save(bankAccount);
    }

    @Override
    public Optional<BankAccount> findByProviderUniqueIdAndAccountNumberAndRoutingNumberAndAccountHolderName(String providerUniqueId,
                                                                                                            String accountNumber,
                                                                                                            String routingNumber,
                                                                                                            String accountHolderName) {
        return repository
                .findByProviderUniqueIdAndAccountNumberAndRoutingNumberAndAccountHolderName(providerUniqueId,
                        accountNumber,
                        routingNumber,
                        accountHolderName);
    }

    @Override
    public BankAccount findById(Long id) {
        return repository.findById(id).orElseThrow(() -> new RuntimeException("Bank Account not found."));
    }
}

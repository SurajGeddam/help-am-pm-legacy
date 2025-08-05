/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.quote.quoteproviders;

import org.springframework.data.jpa.repository.JpaRepository;

/**
 * @author kuldeep
 */
public interface QuoteProviderRepository extends JpaRepository<QuoteProvider, Long> {
}

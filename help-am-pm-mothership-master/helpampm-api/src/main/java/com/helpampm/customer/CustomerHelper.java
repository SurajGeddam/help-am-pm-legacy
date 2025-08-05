/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */

package com.helpampm.customer;

import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.util.Random;

/**
 * @author kuldeep
 */
@Slf4j
@Component
public class CustomerHelper {
    private static final Random RANDOM = new Random();

    public String createCustomerUniqueId(CustomerRepository repository) {
        log.info("Generating unique customer id.");
        char[] chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".toCharArray();
        StringBuilder sb = generate(chars);
        while (repository.findByCustomerUniqueId(sb.toString()).isPresent()) {
            log.warn("Generated id is already in use, try again.");
            sb = generate(chars);
        }
        log.info("Unique customer id generated " + sb);
        return sb.toString();
    }

    private static StringBuilder generate(char[] chars) {
        StringBuilder sb = new StringBuilder((100000 + RANDOM.nextInt(900000)) + "-");
        for (int i = 0; i < 5; i++)
            sb.append(chars[RANDOM.nextInt(chars.length)]);
        return sb;
    }

}

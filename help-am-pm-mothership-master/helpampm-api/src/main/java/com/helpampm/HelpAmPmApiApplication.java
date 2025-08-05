/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm;

import com.helpampm.config.EmailTemplateConfig;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;

@SpringBootApplication
@EnableScheduling
@EnableConfigurationProperties(EmailTemplateConfig.class)
/*
  @author kuldeep
 */
public class HelpAmPmApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(HelpAmPmApiApplication.class, args);
    }

    @Bean
    public BCryptPasswordEncoder bCryptPasswordEncoder() throws NoSuchAlgorithmException {
        return new BCryptPasswordEncoder(8, SecureRandom.getInstance("SHA1PRNG"));
    }

}

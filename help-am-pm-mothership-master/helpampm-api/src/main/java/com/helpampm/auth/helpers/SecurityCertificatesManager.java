/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.helpers;

import lombok.Data;
import lombok.extern.log4j.Log4j2;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;

@Component
@ConfigurationProperties(prefix = "security")
@Data
@Log4j2
/*
  @author kuldeep
 */
public class SecurityCertificatesManager {
    private static final String PUBLIC_KEY_START_TEXT = "-----BEGIN PUBLIC KEY-----";
    private static final String PUBLIC_KEY_END_TEXT = "-----END PUBLIC KEY-----";
    private static final String PRIVATE_KEY_START_TEXT = "-----BEGIN PRIVATE KEY-----";
    private static final String PRIVATE_KEY_END_TEXT = "-----END PRIVATE KEY-----";
    
    private String publicKey;
    private String privateKey;

    @PostConstruct
    public void init() {
        log.info("SecurityCertificatesManager initialization started");
        
        // Direct console output to verify injection
        System.out.println("=== SECURITY CERTIFICATES MANAGER INIT ===");
        System.out.println("Public key is null: " + (publicKey == null));
        System.out.println("Private key is null: " + (privateKey == null));
        
        if (publicKey != null) {
            System.out.println("Public key length: " + publicKey.length());
            System.out.println("Public key starts with: " + publicKey.substring(0, Math.min(50, publicKey.length())));
        }
        
        if (privateKey != null) {
            System.out.println("Private key length: " + privateKey.length());
            System.out.println("Private key starts with: " + privateKey.substring(0, Math.min(50, privateKey.length())));
        }
        
        log.info("Public key value: {}", publicKey != null ? "NOT NULL" : "NULL");
        log.info("Private key value: {}", privateKey != null ? "NOT NULL" : "NULL");
        
        if (publicKey == null) {
            log.error("Public key is null - @ConfigurationProperties injection failed");
            throw new IllegalStateException("Public key @ConfigurationProperties injection failed - key is null");
        } else {
            log.info("Public key loaded successfully, length: {}", publicKey.length());
        }
        if (privateKey == null) {
            log.error("Private key is null - @ConfigurationProperties injection failed");
            throw new IllegalStateException("Private key @ConfigurationProperties injection failed - key is null");
        } else {
            log.info("Private key loaded successfully, length: {}", privateKey.length());
        }
        
        System.out.println("=== SECURITY CERTIFICATES MANAGER INIT COMPLETE ===");
    }

    public void testKeyInjection() {
        log.info("Testing key injection...");
        log.info("Public key: {}", publicKey != null ? "INJECTED" : "NULL");
        log.info("Private key: {}", privateKey != null ? "INJECTED" : "NULL");
    }

    public PublicKey getPublicKey() throws NoSuchAlgorithmException, InvalidKeySpecException {
        if (publicKey == null) {
            log.error("Public key is null - cannot generate PublicKey");
            throw new IllegalStateException("Public key not properly injected");
        }
        
        log.debug("Generating public key from configuration");
        String cleanPublicKey = publicKey.replace(PUBLIC_KEY_START_TEXT, "")
                .replace(PUBLIC_KEY_END_TEXT, "");
        return KeyFactory
                .getInstance("RSA")
                .generatePublic(new X509EncodedKeySpec(Base64.getDecoder().decode(cleanPublicKey)));
    }

    public PrivateKey getPrivateKey() throws NoSuchAlgorithmException, InvalidKeySpecException {
        if (privateKey == null) {
            log.error("Private key is null - cannot generate PrivateKey");
            throw new IllegalStateException("Private key not properly injected");
        }
        
        log.debug("Generating private key from configuration");
        String cleanPrivateKey = privateKey.replace(PRIVATE_KEY_START_TEXT, "")
                .replace(PRIVATE_KEY_END_TEXT, "");

        return KeyFactory
                .getInstance("RSA")
                .generatePrivate(new PKCS8EncodedKeySpec(Base64.getDecoder().decode(cleanPrivateKey)));
    }
}

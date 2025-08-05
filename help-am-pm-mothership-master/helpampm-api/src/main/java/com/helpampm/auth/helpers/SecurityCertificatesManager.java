/*
 * Copyright (c) 2023.
 * All right reserved.
 *
 */
package com.helpampm.auth.helpers;

import lombok.extern.log4j.Log4j2;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;

@Component
@Log4j2
/*
  @author kuldeep
 */
public class SecurityCertificatesManager {
    private static final String PUBLIC_KEY_START_TEXT = "-----BEGIN PUBLIC KEY-----";
    private static final String PUBLIC_KEY_END_TEXT = "-----END PUBLIC KEY-----";
    private static final String PRIVATE_KEY_START_TEXT = "-----BEGIN PRIVATE KEY-----";
    private static final String PRIVATE_KEY_END_TEXT = "-----END PRIVATE KEY-----";
    @Value("${security.public-key}")
    private String publicKey;

    @Value("${security.private-key}")
    private String privateKey;

    public PublicKey getPublicKey() throws NoSuchAlgorithmException, InvalidKeySpecException {
        publicKey = publicKey.replace(PUBLIC_KEY_START_TEXT, "")
                .replace(PUBLIC_KEY_END_TEXT, "");
        return KeyFactory
                .getInstance("RSA")
                .generatePublic(new X509EncodedKeySpec(Base64.getDecoder().decode(publicKey)));
    }

    public PrivateKey getPrivateKey() throws NoSuchAlgorithmException, InvalidKeySpecException {
        privateKey = privateKey.replace(PRIVATE_KEY_START_TEXT, "")
                .replace(PRIVATE_KEY_END_TEXT, "");

        return KeyFactory
                .getInstance("RSA")
                .generatePrivate(new PKCS8EncodedKeySpec(Base64.getDecoder().decode(privateKey)));
    }
}

package com.helpampm.auth.security;

import com.helpampm.auth.helpers.SecurityCertificatesManager;
import com.helpampm.auth.security.jwt.JwtTokenParser;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jws;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import java.security.KeyFactory;
import java.security.NoSuchAlgorithmException;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;

import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.Mockito.when;

@Slf4j
class JwtTokenParserTest {
    private final SecurityCertificatesManager securityCertificatesManager = Mockito.mock(SecurityCertificatesManager.class);
    private JwtTokenParser jwtTokenParser;

    @BeforeEach
    public void setup() throws NoSuchAlgorithmException, InvalidKeySpecException {
        when(securityCertificatesManager.getPrivateKey()).thenReturn(createPrivateKey());
        when(securityCertificatesManager.getPublicKey()).thenReturn(createPublicKey());
        jwtTokenParser = new JwtTokenParser(securityCertificatesManager);
    }

    private PublicKey createPublicKey() throws NoSuchAlgorithmException, InvalidKeySpecException {
        return KeyFactory
                .getInstance("RSA")
                .generatePublic(new X509EncodedKeySpec(Base64.getDecoder().decode("MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA4C9Acujc6szUo0FO4nigqLWoEyrvxFS63axtw7zA7yvZDahZB56l4IBG28H30Kh6xqUFyV8moV1CQ8JhPWltfXt1Jlr/qvXiXHITkc3rIiNos5qYXNF34XgQwgiNzzQyoH6G2MaWth7x9rrRk4S51t7MQdpo3ToeYFGEBzJV7/xatttiy3ZOcYv41kGchUszXekKtVtAlF1+e8sNFc/NO8qSILFBxY/a5NXSd651MlGW4H73+EyrbKDjg9HKn09itDWKCsTQxnskl/WReWAOsBlM2B3/mcsLoD27dQeJUdwLeeS+f2fQN7iQITbWz/TskrenN24/XGThoqg1+I0wdwIDAQAB")));
    }

    private PrivateKey createPrivateKey() throws NoSuchAlgorithmException, InvalidKeySpecException {
        return KeyFactory
                .getInstance("RSA")
                .generatePrivate(new PKCS8EncodedKeySpec(Base64.getDecoder().decode("MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDgL0By6NzqzNSjQU7ieKCotagTKu/EVLrdrG3DvMDvK9kNqFkHnqXggEbbwffQqHrGpQXJXyahXUJDwmE9aW19e3UmWv+q9eJcchORzesiI2izmphc0XfheBDCCI3PNDKgfobYxpa2HvH2utGThLnW3sxB2mjdOh5gUYQHMlXv/Fq222LLdk5xi/jWQZyFSzNd6Qq1W0CUXX57yw0Vz807ypIgsUHFj9rk1dJ3rnUyUZbgfvf4TKtsoOOD0cqfT2K0NYoKxNDGeySX9ZF5YA6wGUzYHf+ZywugPbt1B4lR3At55L5/Z9A3uJAhNtbP9OySt6c3bj9cZOGiqDX4jTB3AgMBAAECggEAaqJvMHlNI65ccm8NG7IvETCfCscAl02KOQjciR9OUjV0IAf0mShAVIIPslYYDzskczppfzhwQo7+hwZ9hF2Sg/5mYeEk/WfJzRlB77eX4XwgQFYHpRbJxAh9SB4TffyhHDAy6gfEBkq/4xFHwLiAQRFm7Of7u0b6zevYNigeMnDdlCSAqC21jK7ZDVr6/B34FVJr7UmdRFErHRqeC82ZxT6f9iUtH/8CK5dL+OMCoRJC/+/G7HtMBAkmxKH7h9A0Za+yMliuzErLOjXyC6j6uEZ+mD/lLj/5XYM9UuuJWxKILfrZCvUsQGfsic0KPUWb72TailClM6Cq+tjKXdDaIQKBgQD4Wi3I08YlZwdg1CWMVbgfK+7ScyL6QVPXvbIBve+eH68OpdAnYTpcOh8k3MoFKdUlN2NVtCWS7aVhc4C3kdlMG/g8DJHUIUU4IcBCxfO+xGcu4aTk0FjGQoHP6V4BqMNQd8+V4XQKRulubSEbcDgrLQPUb7XULMnI+L6pYDJy8QKBgQDnFo2dziXLaxtjln8IxxDlmtXWZ3ECK+1uOUZ9VXbXShe+E4CoCP8TedBpIULVQakcGH4ItBmfoCiUEy9QBZq2jbG2zBKa2Jb4uxU0JU9m6bCyiE1J8LuAq8DoATi1Pdy2opDgM/8HzEvLOQDdQ2gHM4TqZaxI9IL9Cq/p+s0J5wKBgQCAiDt12pSMOvxIksM0FBEMoPIjHM+XcUPxPg3odOKUlZVGIW7PUrSfkr0XmOU9Mt9LOZVBf9CKcE/NVbfiSauKhlc8zMyUWvu2B1G3vTdfHcrBKqrqeSHYygbhEchDV5JuDPP0gBBMWVLqgbRGvRd00QFQathSDTQJvSMACfdSIQKBgQCeN+PYQte/seK7ycPKd7lK6zszo/lM2lSi3hY0I/rNJo6g9mtlIVu7svCNulcu+djWQrKwNNdCYn7F+2iualfmW5dsp8apPFgJjtXSsSTvOltfsVDxqiBG1dGrR4LTHLrsVNvKle8sIKVYS/wagldMbuq3LcvK25Z/t/x/v9b4ywKBgEXGwKkfT722zHdvL16QZUHBR7uJgAWhCRTJnURMm5dI/KZuKML6MD9EtmEVdoz55bRtQlnnpi4v797Esaf576xyOguktGBAAcceX9J303oNjLLtKWPP7d9Y78+blA/Z9KzkfQmocgXFZcFU6CMpU+WZDuZwuNzoyPR/i0YPEHeT")));
    }


    @Test
    void parseJwt() {
        try {
            Jws<Claims> claimsJws = jwtTokenParser.parseJwt("eyJhbGciOiJub25lIn0.eyJ1c2VybmFtZSI6InN1cGVyYWRtaW4iLCJyb2xlcyI6W3siaWQiOjEsIm5hbWUiOiJST0xFX1NVUEVSQURNSU4iLCJhdXRob3JpdHkiOiJST0xFX1NVUEVSQURNSU4ifV0sImlzUmVmcmVzaFRva2VuIjpmYWxzZSwic3ViIjoic3VwZXJhZG1pbiIsImp0aSI6IjM3Y2I0MDgxLWI2MmUtNDYwNi1iZWY3LWU0OGVlNjk2NjUyYSIsImlhdCI6MTY3MDAwNTIxMSwiZXhwIjoxNjcwMDA4ODExfQ.");
            assertNotNull(claimsJws);
        } catch (InvalidKeySpecException | NoSuchAlgorithmException | ExpiredJwtException e) {
            log.error(e.getMessage());
        }
    }
}
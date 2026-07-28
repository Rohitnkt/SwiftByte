package com.swiftbyte.util;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordUtil {

    private static final SecureRandom RANDOM = new SecureRandom();

    // returns "base64Salt:base64Hash"
    public static String hash(String plain) {
        try {
            byte[] salt = new byte[16];
            RANDOM.nextBytes(salt);
            byte[] hash = sha256(salt, plain);
            return Base64.getEncoder().encodeToString(salt) + ":" +
                   Base64.getEncoder().encodeToString(hash);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static boolean verify(String plain, String stored) {
        try {
            if (stored == null || !stored.contains(":")) return false;
            String[] parts = stored.split(":");
            byte[] salt = Base64.getDecoder().decode(parts[0]);
            byte[] expected = Base64.getDecoder().decode(parts[1]);
            byte[] actual = sha256(salt, plain);
            if (actual.length != expected.length) return false;
            int diff = 0;
            for (int i = 0; i < actual.length; i++) diff |= actual[i] ^ expected[i];
            return diff == 0;
        } catch (Exception e) {
            return false;
        }
    }

    private static byte[] sha256(byte[] salt, String plain) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(salt);
        return md.digest(plain.getBytes("UTF-8"));
    }
}

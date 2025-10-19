package vn.ute.uteshop.common;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordHasher {
    private static final SecureRandom random = new SecureRandom();
    
    public static String generateSalt() {
        byte[] salt = new byte[16];
        random.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }

    public static String hashPassword(String password, String salt) {
        try {
            // Try Spring Security BCrypt first
            try {
                org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder encoder = 
                    new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder(12);
                return encoder.encode(password + salt);
            } catch (Exception e) {
                // Fallback to SHA-256 if BCrypt fails
                System.out.println("⚠️ BCrypt failed, using SHA-256 fallback: " + e.getMessage());
                return hashPasswordSHA256(password, salt);
            }
        } catch (Exception e) {
            System.err.println("❌ Password hashing failed: " + e.getMessage());
            throw new RuntimeException("Password hashing failed", e);
        }
    }

    public static boolean verifyPassword(String password, String salt, String hashedPassword) {
        try {
            // Try Spring Security BCrypt first
            try {
                org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder encoder = 
                    new org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder(12);
                return encoder.matches(password + salt, hashedPassword);
            } catch (Exception e) {
                // Fallback to SHA-256 verification
                System.out.println("⚠️ BCrypt verification failed, using SHA-256 fallback: " + e.getMessage());
                return hashPasswordSHA256(password, salt).equals(hashedPassword);
            }
        } catch (Exception e) {
            System.err.println("❌ Password verification failed: " + e.getMessage());
            return false;
        }
    }
    
    // Fallback SHA-256 implementation
    private static String hashPasswordSHA256(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt.getBytes());
            byte[] hashedPassword = md.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hashedPassword);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 algorithm not available", e);
        }
    }
}
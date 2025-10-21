package vn.ute.uteshop.config;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import vn.ute.uteshop.model.User;

import javax.crypto.SecretKey;
import java.util.Date;

/**
 * JwtService - Complete JWT Service with fixes for UTESHOP-CPL
 * Updated: 2025-10-21 00:28:23 UTC - Added missing isTokenValid method
 * Created by tuaanshuuysv
 */
public class JwtService {
    // Secret key phải đủ dài cho HS256 (ít nhất 32 bytes = 256 bits)
    private static final String SECRET_KEY = "uteshop-cpl-secret-key-for-tuaanshuuysv-2025-very-long-secret-must-be-at-least-256-bits";
    private static final long EXPIRATION_TIME = 24 * 60 * 60 * 1000; // 24 hours
    private static final SecretKey key = Keys.hmacShaKeyFor(SECRET_KEY.getBytes());

    public static String generateToken(User user) {
        try {
            String token = Jwts.builder()
                    .subject(user.getUserId().toString())
                    .claim("username", user.getUsername())
                    .claim("email", user.getEmail())
                    .claim("fullName", user.getFullName())
                    .claim("roleId", user.getRoleId())
                    .claim("isActive", user.getIsActive())
                    .claim("isVerified", user.getIsVerified())
                    .issuedAt(new Date())
                    .expiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME))
                    .signWith(key, Jwts.SIG.HS256)
                    .compact();
            
            System.out.println("🔑 JWT token generated for user: " + user.getEmail());
            System.out.println("⏰ Token expires at: " + new Date(System.currentTimeMillis() + EXPIRATION_TIME));
            return token;
            
        } catch (Exception e) {
            System.err.println("❌ JWT generation failed: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public static Claims validateToken(String token) {
        try {
            Claims claims = Jwts.parser()
                    .verifyWith(key)
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
            
            System.out.println("✅ JWT token validated for user: " + claims.get("email"));
            return claims;
            
        } catch (ExpiredJwtException e) {
            System.err.println("❌ JWT token expired: " + e.getMessage());
            return null;
        } catch (UnsupportedJwtException e) {
            System.err.println("❌ JWT token unsupported: " + e.getMessage());
            return null;
        } catch (MalformedJwtException e) {
            System.err.println("❌ JWT token malformed: " + e.getMessage());
            return null;
        } catch (IllegalArgumentException e) {
            System.err.println("❌ JWT token illegal argument: " + e.getMessage());
            return null;
        } catch (Exception e) {
            System.err.println("❌ JWT validation failed: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public static Integer getUserIdFromToken(String token) {
        try {
            Claims claims = validateToken(token);
            if (claims != null) {
                Integer userId = Integer.parseInt(claims.getSubject());
                System.out.println("🆔 Extracted user ID from token: " + userId);
                return userId;
            }
        } catch (NumberFormatException e) {
            System.err.println("❌ Invalid user ID in JWT token: " + e.getMessage());
        }
        return null;
    }

    public static boolean isTokenExpired(String token) {
        try {
            Claims claims = validateToken(token);
            if (claims != null) {
                boolean expired = claims.getExpiration().before(new Date());
                System.out.println("⏰ Token expired check: " + expired);
                return expired;
            }
        } catch (Exception e) {
            System.err.println("❌ Error checking token expiration: " + e.getMessage());
        }
        return true; // Consider expired if any error
    }

    /**
     * ✅ ADDED: Missing method that JwtAuthFilter uses
     */
    public static boolean isTokenValid(String token) {
        try {
            Claims claims = validateToken(token);
            boolean valid = claims != null && !isTokenExpired(token);
            System.out.println("🔍 Token validity check: " + valid);
            return valid;
        } catch (Exception e) {
            System.err.println("❌ Token validation failed: " + e.getMessage());
            return false;
        }
    }

    public static String getUsernameFromToken(String token) {
        try {
            Claims claims = validateToken(token);
            if (claims != null) {
                return claims.get("username", String.class);
            }
        } catch (Exception e) {
            System.err.println("❌ Error extracting username from token: " + e.getMessage());
        }
        return null;
    }

    public static String getEmailFromToken(String token) {
        try {
            Claims claims = validateToken(token);
            if (claims != null) {
                return claims.get("email", String.class);
            }
        } catch (Exception e) {
            System.err.println("❌ Error extracting email from token: " + e.getMessage());
        }
        return null;
    }

    public static Integer getRoleIdFromToken(String token) {
        try {
            Claims claims = validateToken(token);
            if (claims != null) {
                return claims.get("roleId", Integer.class);
            }
        } catch (Exception e) {
            System.err.println("❌ Error extracting roleId from token: " + e.getMessage());
        }
        return null;
    }

    // Utility method to refresh token
    public static String refreshToken(String oldToken) {
        try {
            Claims claims = validateToken(oldToken);
            if (claims != null && !isTokenExpired(oldToken)) {
                return Jwts.builder()
                        .subject(claims.getSubject())
                        .claim("username", claims.get("username"))
                        .claim("email", claims.get("email"))
                        .claim("fullName", claims.get("fullName"))
                        .claim("roleId", claims.get("roleId"))
                        .claim("isActive", claims.get("isActive"))
                        .claim("isVerified", claims.get("isVerified"))
                        .issuedAt(new Date())
                        .expiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME))
                        .signWith(key, Jwts.SIG.HS256)
                        .compact();
            }
        } catch (Exception e) {
            System.err.println("❌ Token refresh failed: " + e.getMessage());
        }
        return null;
    }

    // Debug method to log token info
    public static void logTokenInfo(String token) {
        try {
            Claims claims = validateToken(token);
            if (claims != null) {
                System.out.println("🔍 JWT Token Info:");
                System.out.println("   Subject (User ID): " + claims.getSubject());
                System.out.println("   Username: " + claims.get("username"));
                System.out.println("   Email: " + claims.get("email"));
                System.out.println("   Role ID: " + claims.get("roleId"));
                System.out.println("   Issued At: " + claims.getIssuedAt());
                System.out.println("   Expires At: " + claims.getExpiration());
                System.out.println("   Is Expired: " + isTokenExpired(token));
                System.out.println("   Current Time: " + new Date());
            }
        } catch (Exception e) {
            System.err.println("❌ Error logging token info: " + e.getMessage());
        }
    }

    /**
     * Health check method
     */
    public static boolean healthCheck() {
        try {
            System.out.println("💊 JwtService Health Check:");
            System.out.println("   Secret Key Length: " + SECRET_KEY.length() + " bytes");
            System.out.println("   Expiration Time: " + (EXPIRATION_TIME / 1000 / 60 / 60) + " hours");
            System.out.println("   Current Time: " + new Date());
            return true;
        } catch (Exception e) {
            System.err.println("❌ JwtService health check failed: " + e.getMessage());
            return false;
        }
    }
}
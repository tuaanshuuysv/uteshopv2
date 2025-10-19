package vn.ute.uteshop.config;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import vn.ute.uteshop.model.User;

import javax.crypto.SecretKey;
import java.util.Date;

public class JwtService {
    // Secret key phải đủ dài cho HS256 (ít nhất 32 bytes = 256 bits)
    private static final String SECRET_KEY = "uteshop-cpl-secret-key-for-tuaanshuuysv-2025-very-long-secret-must-be-at-least-256-bits";
    private static final long EXPIRATION_TIME = 24 * 60 * 60 * 1000; // 24 hours
    private static final SecretKey key = Keys.hmacShaKeyFor(SECRET_KEY.getBytes());

    public static String generateToken(User user) {
        try {
            return Jwts.builder()
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
        } catch (Exception e) {
            System.err.println("❌ JWT generation failed: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public static Claims validateToken(String token) {
        try {
            return Jwts.parser()
                    .verifyWith(key)
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
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
                return Integer.parseInt(claims.getSubject());
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
                return claims.getExpiration().before(new Date());
            }
        } catch (Exception e) {
            System.err.println("❌ Error checking token expiration: " + e.getMessage());
        }
        return true; // Consider expired if any error
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

    public static boolean isTokenValid(String token) {
        try {
            Claims claims = validateToken(token);
            return claims != null && !isTokenExpired(token);
        } catch (Exception e) {
            System.err.println("❌ Error validating token: " + e.getMessage());
            return false;
        }
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
            }
        } catch (Exception e) {
            System.err.println("❌ Error logging token info: " + e.getMessage());
        }
    }
}
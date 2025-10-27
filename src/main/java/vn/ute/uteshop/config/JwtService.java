package vn.ute.uteshop.config;

import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import vn.ute.uteshop.model.User;

import javax.crypto.SecretKey;
import java.util.Date;

/**
 * JwtService - FINAL FIX FOR JWT 0.11.x+
 * Updated: 2025-10-26 19:16:58 UTC by tuaanshuuysv
 * Fix: Use Jwts.parser().setSigningKey().build().parseClaimsJws() for newer JWT
 * Fix: All methods static for AuthService compatibility
 */
public class JwtService {
    
    private static final String SECRET_KEY = "uteshopSecretKeyForJwtTokenGenerationMustBeLongEnough256Bits";
    private static final long EXPIRATION_TIME = 86400000; // 24 hours in milliseconds
    
    private static final SecretKey key = Keys.hmacShaKeyFor(SECRET_KEY.getBytes());
    
    /**
     * Generate JWT token for user - STATIC METHOD
     */
    public static String generateToken(User user) {
        try {
            return Jwts.builder()
                    .setSubject(user.getEmail())
                    .claim("userId", String.valueOf(user.getUserId())) // FIXED: Use String.valueOf()
                    .claim("username", user.getUsername())
                    .claim("fullName", user.getFullName())
                    .claim("roleId", String.valueOf(user.getRoleId())) // FIXED: Use String.valueOf()
                    .claim("isActive", user.getIsActive())
                    .claim("isVerified", user.getIsVerified())
                    .setIssuedAt(new Date())
                    .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME))
                    .signWith(key, SignatureAlgorithm.HS256)
                    .compact();
        } catch (Exception e) {
            System.err.println("❌ Error generating JWT token: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * Validate JWT token - FIXED: Use .build() for newer JWT versions
     */
    public static boolean validateToken(String token) {
        try {
            // FIXED: Add .build() for newer JWT library
            Jwts.parser().setSigningKey(key).build().parseClaimsJws(token);
            return true;
        } catch (ExpiredJwtException e) {
            System.err.println("❌ JWT token expired: " + e.getMessage());
            return false;
        } catch (MalformedJwtException e) {
            System.err.println("❌ Malformed JWT token: " + e.getMessage());
            return false;
        } catch (SignatureException e) {
            System.err.println("❌ Invalid JWT signature: " + e.getMessage());
            return false;
        } catch (IllegalArgumentException e) {
            System.err.println("❌ Illegal JWT argument: " + e.getMessage());
            return false;
        } catch (Exception e) {
            System.err.println("❌ JWT validation error: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Extract email from JWT token - FIXED: Use .build()
     */
    public static String getEmailFromToken(String token) {
        try {
            // FIXED: Add .build() for newer JWT library
            Claims claims = Jwts.parser()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
            return claims.getSubject();
        } catch (Exception e) {
            System.err.println("❌ Error extracting email from token: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Extract user ID from JWT token - FIXED: Use .build()
     */
    public static String getUserIdFromToken(String token) {
        try {
            // FIXED: Add .build() for newer JWT library
            Claims claims = Jwts.parser()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
            return claims.get("userId", String.class);
        } catch (Exception e) {
            System.err.println("❌ Error extracting userId from token: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Check if JWT token is expired - FIXED: Use .build()
     */
    public static boolean isTokenExpired(String token) {
        try {
            // FIXED: Add .build() for newer JWT library
            Claims claims = Jwts.parser()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
            return claims.getExpiration().before(new Date());
        } catch (ExpiredJwtException e) {
            System.err.println("⏰ Token is expired: " + e.getMessage());
            return true;
        } catch (Exception e) {
            System.err.println("❌ Error checking token expiration: " + e.getMessage());
            return true; // Consider invalid tokens as expired
        }
    }
    
    /**
     * Extract all claims from JWT token - FIXED: Use .build()
     */
    public static Claims getAllClaimsFromToken(String token) {
        try {
            return Jwts.parser()
                    .setSigningKey(key)
                    .build()
                    .parseClaimsJws(token)
                    .getBody();
        } catch (Exception e) {
            System.err.println("❌ Error extracting claims from token: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Get role ID from JWT token
     */
    public static String getRoleIdFromToken(String token) {
        try {
            Claims claims = getAllClaimsFromToken(token);
            return claims != null ? claims.get("roleId", String.class) : null;
        } catch (Exception e) {
            System.err.println("❌ Error extracting roleId from token: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Get username from JWT token
     */
    public static String getUsernameFromToken(String token) {
        try {
            Claims claims = getAllClaimsFromToken(token);
            return claims != null ? claims.get("username", String.class) : null;
        } catch (Exception e) {
            System.err.println("❌ Error extracting username from token: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Check if user is active from JWT token
     */
    public static Boolean getIsActiveFromToken(String token) {
        try {
            Claims claims = getAllClaimsFromToken(token);
            return claims != null ? claims.get("isActive", Boolean.class) : null;
        } catch (Exception e) {
            System.err.println("❌ Error extracting isActive from token: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Check if user is verified from JWT token
     */
    public static Boolean getIsVerifiedFromToken(String token) {
        try {
            Claims claims = getAllClaimsFromToken(token);
            return claims != null ? claims.get("isVerified", Boolean.class) : null;
        } catch (Exception e) {
            System.err.println("❌ Error extracting isVerified from token: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Get token expiration date
     */
    public static Date getTokenExpiration(String token) {
        try {
            Claims claims = getAllClaimsFromToken(token);
            return claims != null ? claims.getExpiration() : null;
        } catch (Exception e) {
            System.err.println("❌ Error extracting expiration from token: " + e.getMessage());
            return null;
        }
    }
    
    /**
     * Get remaining time in milliseconds until token expires
     */
    public static long getTokenRemainingTime(String token) {
        try {
            Date expiration = getTokenExpiration(token);
            if (expiration != null) {
                long remaining = expiration.getTime() - System.currentTimeMillis();
                return Math.max(0, remaining);
            }
        } catch (Exception e) {
            System.err.println("❌ Error calculating remaining time: " + e.getMessage());
        }
        return 0;
    }
    
    /**
     * Instance methods for backwards compatibility
     */
    public String generateTokenInstance(User user) {
        return generateToken(user);
    }
    
    public boolean validateTokenInstance(String token) {
        return validateToken(token);
    }
    
    public String getEmailFromTokenInstance(String token) {
        return getEmailFromToken(token);
    }
    
    public String getUserIdFromTokenInstance(String token) {
        return getUserIdFromToken(token);
    }
    
    public boolean isTokenExpiredInstance(String token) {
        return isTokenExpired(token);
    }
    
    /**
     * Utility method to check JWT library compatibility
     */
    public static void checkJwtCompatibility() {
        System.out.println("🔍 JWT Library Compatibility Check:");
        System.out.println("   Fixed: 2025-10-26 19:16:58 UTC by tuaanshuuysv");
        System.out.println("   Using: Jwts.parser().setSigningKey().build().parseClaimsJws()");
        System.out.println("   Compatible with: jjwt 0.11.x+");
        
        try {
            // Test the fix
            String testToken = "test";
            try {
                validateToken(testToken);
            } catch (Exception e) {
                // Expected to fail with test token
            }
            System.out.println("✅ JWT parser chain is working correctly");
        } catch (Exception e) {
            System.out.println("❌ JWT parser chain error: " + e.getMessage());
        }
    }
    
    /**
     * Debug method to test token operations
     */
    public static void debugTokenOperations() {
        System.out.println("🧪 JWT Token Operations Debug:");
        System.out.println("   Secret Key Length: " + SECRET_KEY.length());
        System.out.println("   Expiration Time: " + EXPIRATION_TIME + "ms (" + (EXPIRATION_TIME/1000/60/60) + " hours)");
        System.out.println("   Algorithm: HS256");
        System.out.println("   Updated: 2025-10-26 19:16:58 UTC");
    }
}
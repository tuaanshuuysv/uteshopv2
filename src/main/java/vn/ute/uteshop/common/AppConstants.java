package vn.ute.uteshop.common;

/**
 * AppConstants - Application Constants for UTESHOP-CPL
 * Updated: 2025-10-21 00:40:12 UTC - Verified constant values
 * Created by tuaanshuuysv
 */
public final class AppConstants {
    private AppConstants() {}
    
    // Pagination
    public static final int PAGE_SIZE = 20;
    
    // JWT & Cookie - CRITICAL: These must match between AuthController and JwtAuthFilter
    public static final String COOKIE_TOKEN = "UTESHOP_TOKEN";
    public static final String AUTH_USER_ATTR = "authUser";
    
    // OTP
    public static final int OTP_EXPIRY_MINUTES = 5;
    public static final int OTP_MAX_ATTEMPTS = 3;
    
    // Password
    public static final int MIN_PASSWORD_LENGTH = 6;
    public static final int BCRYPT_ROUNDS = 12;
    
    // Application Info
    public static final String APP_NAME = "UTESHOP-CPL";
    public static final String APP_VERSION = "2.0.0";
    public static final String APP_AUTHOR = "tuaanshuuysv";
    public static final String APP_BUILD_DATE = "2025-10-21";
    
    // Debug
    public static final boolean DEBUG_MODE = true; // Set to false in production
    
    static {
        System.out.println("📋 AppConstants loaded:");
        System.out.println("   COOKIE_TOKEN: " + COOKIE_TOKEN);
        System.out.println("   AUTH_USER_ATTR: " + AUTH_USER_ATTR);
        System.out.println("   APP_NAME: " + APP_NAME);
        System.out.println("   DEBUG_MODE: " + DEBUG_MODE);
        System.out.println("   Build: " + APP_BUILD_DATE + " by " + APP_AUTHOR);
    }
}
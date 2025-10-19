package vn.ute.uteshop.common;

public final class AppConstants {
    private AppConstants() {}
    
    // Pagination
    public static final int PAGE_SIZE = 20;
    
    // JWT & Cookie
    public static final String COOKIE_TOKEN = "UTESHOP_TOKEN";
    public static final String AUTH_USER_ATTR = "authUser";
    
    // OTP
    public static final int OTP_EXPIRY_MINUTES = 5;
    public static final int OTP_MAX_ATTEMPTS = 3;
    
    // Password
    public static final int MIN_PASSWORD_LENGTH = 6;
    public static final int BCRYPT_ROUNDS = 12;
}
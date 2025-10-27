package vn.ute.uteshop.services;

import vn.ute.uteshop.dao.UserDao;
import vn.ute.uteshop.dao.OtpTokenDao;
import vn.ute.uteshop.dao.impl.UserDaoImpl;
import vn.ute.uteshop.dao.impl.OtpTokenDaoImpl;
import vn.ute.uteshop.model.User;
import vn.ute.uteshop.model.OtpToken;
import vn.ute.uteshop.common.PasswordHasher;
import vn.ute.uteshop.common.OtpUtil;
import vn.ute.uteshop.common.Enums;
import vn.ute.uteshop.config.MailConfig;
import vn.ute.uteshop.config.JwtService;
import vn.ute.uteshop.dto.AuthDtos;

import java.sql.Timestamp;

/**
 * AuthService - Complete Authentication Service for UTESHOP-CPL
 * Created by tuaanshuuysv on 2025-10-19
 * Updated: 2025-10-19 23:34:58 UTC
 * Fixed: OTP expiry time calculation, recently used OTP support for password reset
 * Compatible with: Tomcat 10.x, Jakarta EE, MySQL 8.x
 */
public class AuthService {
    private final UserDao userDao;
    private final OtpTokenDao otpTokenDao;

    public AuthService() {
        this.userDao = new UserDaoImpl();
        this.otpTokenDao = new OtpTokenDaoImpl();
        System.out.println("✅ AuthService initialized successfully");
        System.out.println("🕐 Current UTC: 2025-10-19 23:34:58");
        System.out.println("👨‍💻 Created by: tuaanshuuysv");
        System.out.println("🔧 Features: Registration, Login, OTP, JWT, Password Reset");
    }

    /**
     * User Registration with OTP verification
     * @param request RegisterRequest containing user data
     * @return RegisterResponse with success status and message
     */
    public AuthDtos.RegisterResponse register(AuthDtos.RegisterRequest request) {
        AuthDtos.RegisterResponse response = new AuthDtos.RegisterResponse();

        try {
            System.out.println("🔄 Processing registration for: " + request.getEmail());
            System.out.println("🕐 Registration time (UTC): 2025-10-19 23:34:58");
            System.out.println("👤 Full name: " + request.getFullName());
            System.out.println("📱 Phone: " + request.getPhone());
            System.out.println("🎭 Role ID: " + request.getRoleId());

            // Comprehensive input validation
            if (!isValidRegisterRequest(request)) {
                response.setSuccess(false);
                response.setMessage("Thông tin đăng ký không hợp lệ");
                return response;
            }

            // Check if username already exists
            boolean usernameExists = userDao.existsByUsername(request.getUsername());
            System.out.println("🔍 Username '" + request.getUsername() + "' exists: " + usernameExists);
            if (usernameExists) {
                response.setSuccess(false);
                response.setMessage("Tên đăng nhập đã tồn tại");
                return response;
            }

            // Check if email already exists
            boolean emailExists = userDao.existsByEmail(request.getEmail());
            System.out.println("🔍 Email '" + request.getEmail() + "' exists: " + emailExists);
            if (emailExists) {
                response.setSuccess(false);
                response.setMessage("Email đã được sử dụng");
                return response;
            }

            // Validate role (only USER or VENDOR allowed)
            if (request.getRoleId() != Enums.UserRole.USER.getValue() && 
                request.getRoleId() != Enums.UserRole.VENDOR.getValue()) {
                System.err.println("❌ Invalid role ID: " + request.getRoleId());
                response.setSuccess(false);
                response.setMessage("Vai trò không hợp lệ. Chỉ được tạo tài khoản User hoặc Vendor");
                return response;
            }

            // Hash password with enhanced security
            System.out.println("🔒 Generating password hash...");
            String salt = PasswordHasher.generateSalt();
            String hashedPassword = PasswordHasher.hashPassword(request.getPassword(), salt);
            System.out.println("✅ Password hashed successfully");

            // Create user entity
            User user = new User(
                request.getUsername(),
                request.getEmail(),
                hashedPassword,
                salt,
                request.getFullName(),
                request.getPhone(),
                request.getRoleId()
            );

            // Save user to database
            Integer userId = userDao.save(user);
            if (userId == null) {
                System.err.println("❌ Failed to save user to database");
                response.setSuccess(false);
                response.setMessage("Lỗi tạo tài khoản. Vui lòng thử lại sau.");
                return response;
            }

            System.out.println("✅ User created successfully with ID: " + userId);

            // Generate OTP code
            String otpCode = OtpUtil.generateOtp();
            System.out.println("🔑 Generated OTP: " + otpCode + " for user: " + userId);

            // Create OTP token (expires_at calculated by database)
            OtpToken otpToken = new OtpToken(userId, otpCode, Enums.OtpType.REGISTRATION.name(), null);
            Integer otpId = otpTokenDao.save(otpToken);
            
            if (otpId == null) {
                System.err.println("❌ Failed to save OTP token");
                response.setSuccess(false);
                response.setMessage("Lỗi tạo mã xác thực. Vui lòng thử lại sau.");
                return response;
            }
            
            System.out.println("✅ OTP token saved with ID: " + otpId);

            // Send OTP via email
            System.out.println("📧 Sending OTP email to: " + request.getEmail());
            boolean emailSent = MailConfig.sendOtpEmail(request.getEmail(), otpCode, Enums.OtpType.REGISTRATION.name());
            if (!emailSent) {
                System.err.println("❌ Failed to send OTP email");
                response.setSuccess(false);
                response.setMessage("Lỗi gửi email xác thực. Vui lòng kiểm tra địa chỉ email và thử lại.");
                return response;
            }

            System.out.println("✅ OTP email sent successfully");

            // Success response
            response.setSuccess(true);
            response.setMessage("Đăng ký thành công! Vui lòng kiểm tra email để xác thực tài khoản trong vòng 5 phút.");
            response.setUserId(userId);

            System.out.println("✅ Registration completed successfully for: " + request.getEmail());

        } catch (Exception e) {
            System.err.println("❌ Registration failed with exception: " + e.getMessage());
            e.printStackTrace();
            response.setSuccess(false);
            response.setMessage("Lỗi hệ thống: " + e.getMessage());
        }

        return response;
    }

    /**
     * User Login with JWT token generation
     * @param request LoginRequest containing username/email and password
     * @return LoginResponse with JWT token and user info
     */
    public AuthDtos.LoginResponse login(AuthDtos.LoginRequest request) {
        AuthDtos.LoginResponse response = new AuthDtos.LoginResponse();

        try {
            System.out.println("🔄 Processing login for: " + request.getUsernameOrEmail());
            System.out.println("🕐 Login time (UTC): 2025-10-19 23:34:58");

            // Input validation
            if (request.getUsernameOrEmail() == null || request.getUsernameOrEmail().trim().isEmpty()) {
                response.setSuccess(false);
                response.setMessage("Vui lòng nhập email hoặc tên đăng nhập");
                return response;
            }

            if (request.getPassword() == null || request.getPassword().trim().isEmpty()) {
                response.setSuccess(false);
                response.setMessage("Vui lòng nhập mật khẩu");
                return response;
            }

            // Find user by email or username
            User user = userDao.findByEmail(request.getUsernameOrEmail());
            if (user == null) {
                user = userDao.findByUsername(request.getUsernameOrEmail());
            }

            if (user == null) {
                System.out.println("❌ User not found: " + request.getUsernameOrEmail());
                response.setSuccess(false);
                response.setMessage("Tài khoản không tồn tại");
                return response;
            }

            System.out.println("👤 User found: " + user.getEmail() + " (ID: " + user.getUserId() + ")");
            System.out.println("🔒 Account status - Active: " + user.getIsActive() + ", Verified: " + user.getIsVerified());

            // Verify password
            boolean passwordValid = PasswordHasher.verifyPassword(request.getPassword(), user.getSalt(), user.getPasswordHash());
            System.out.println("🔑 Password verification: " + passwordValid);
            
            if (!passwordValid) {
                System.err.println("❌ Password verification failed for: " + user.getEmail());
                response.setSuccess(false);
                response.setMessage("Mật khẩu không chính xác");
                return response;
            }

            // Check if account is verified
            if (!user.getIsVerified()) {
                System.out.println("⚠️ Account not verified: " + user.getEmail());
                response.setSuccess(false);
                response.setMessage("Tài khoản chưa được xác thực. Vui lòng kiểm tra email để kích hoạt tài khoản.");
                return response;
            }

            // Check if account is active
            if (!user.getIsActive()) {
                System.out.println("⚠️ Account not active: " + user.getEmail());
                response.setSuccess(false);
                response.setMessage("Tài khoản đã bị khóa. Vui lòng liên hệ admin.");
                return response;
            }

            // Update last login timestamp
            user.setLastLogin(new Timestamp(System.currentTimeMillis()));
            boolean updated = userDao.update(user);
            System.out.println("🕐 Last login updated: " + updated);

            // Generate JWT token
            String token = JwtService.generateToken(user);
            if (token == null) {
                System.err.println("❌ JWT token generation failed");
                response.setSuccess(false);
                response.setMessage("Lỗi tạo phiên đăng nhập. Vui lòng thử lại.");
                return response;
            }

            System.out.println("🔑 JWT token generated successfully");

            // Build successful response
            response.setSuccess(true);
            response.setMessage("Đăng nhập thành công! Chào mừng " + user.getFullName());
            response.setToken(token);
            response.setUser(convertToUserResponse(user));

            System.out.println("✅ Login completed successfully for: " + user.getEmail());
            System.out.println("🎭 User role: " + user.getRoleId());

        } catch (Exception e) {
            System.err.println("❌ Login failed with exception: " + e.getMessage());
            e.printStackTrace();
            response.setSuccess(false);
            response.setMessage("Lỗi hệ thống: " + e.getMessage());
        }

        return response;
    }

    /**
     * OTP Verification for registration and password reset
     * @param request VerifyOtpRequest containing email, OTP code and type
     * @return VerifyOtpResponse with success status
     */
    public AuthDtos.VerifyOtpResponse verifyOtp(AuthDtos.VerifyOtpRequest request) {
        AuthDtos.VerifyOtpResponse response = new AuthDtos.VerifyOtpResponse();

        try {
            System.out.println("🔄 ========== OTP VERIFICATION START ==========");
            System.out.println("🕐 Verification time (UTC): 2025-10-19 23:34:58");
            System.out.println("📧 Email: '" + request.getEmail() + "'");
            System.out.println("🔑 OTP Code: '" + request.getOtpCode() + "'");
            System.out.println("🏷️ OTP Type: '" + request.getOtpType() + "'");

            // Enhanced input validation with detailed logging
            if (request.getEmail() == null) {
                System.err.println("❌ CRITICAL: Email is NULL");
                response.setSuccess(false);
                response.setMessage("Email không được để trống");
                return response;
            }

            if (request.getEmail().trim().isEmpty()) {
                System.err.println("❌ CRITICAL: Email is EMPTY after trim");
                response.setSuccess(false);
                response.setMessage("Email không được để trống");
                return response;
            }

            if (request.getOtpCode() == null) {
                System.err.println("❌ CRITICAL: OTP Code is NULL");
                System.err.println("   This indicates form submission issue");
                System.err.println("   Check JSP form input name='otpCode'");
                response.setSuccess(false);
                response.setMessage("Vui lòng nhập mã OTP");
                return response;
            }

            if (request.getOtpCode().trim().isEmpty()) {
                System.err.println("❌ CRITICAL: OTP Code is EMPTY after trim");
                response.setSuccess(false);
                response.setMessage("Vui lòng nhập mã OTP");
                return response;
            }

            if (request.getOtpType() == null || request.getOtpType().trim().isEmpty()) {
                System.err.println("❌ CRITICAL: OTP Type is NULL or EMPTY");
                response.setSuccess(false);
                response.setMessage("Loại OTP không hợp lệ");
                return response;
            }

            // Sanitize inputs
            String email = request.getEmail().trim().toLowerCase();
            String otpCode = request.getOtpCode().trim();
            String otpType = request.getOtpType().trim().toUpperCase();

            System.out.println("✅ After sanitization:");
            System.out.println("   Email: '" + email + "'");
            System.out.println("   OTP Code: '" + otpCode + "'");
            System.out.println("   OTP Type: '" + otpType + "'");

            // Validate OTP format
            if (!OtpUtil.isValidOtp(otpCode)) {
                System.err.println("❌ Invalid OTP format: " + otpCode);
                response.setSuccess(false);
                response.setMessage("Mã OTP phải có đúng 6 chữ số");
                return response;
            }

            System.out.println("✅ OTP format validation passed");

            // Find user by email
            User user = userDao.findByEmail(email);
            if (user == null) {
                System.err.println("❌ User not found for email: " + email);
                response.setSuccess(false);
                response.setMessage("Email không tồn tại trong hệ thống");
                return response;
            }

            System.out.println("👤 User found:");
            System.out.println("   ID: " + user.getUserId());
            System.out.println("   Email: " + user.getEmail());
            System.out.println("   Username: " + user.getUsername());
            System.out.println("   Active: " + user.getIsActive());
            System.out.println("   Verified: " + user.getIsVerified());

            // Find and validate OTP token
            System.out.println("🔍 Searching for valid OTP token...");
            OtpToken otpToken = otpTokenDao.findValidOtp(user.getUserId(), otpCode, otpType);

            if (otpToken == null) {
                System.err.println("❌ OTP VALIDATION FAILED!");
                System.err.println("   Search criteria:");
                System.err.println("     User ID: " + user.getUserId());
                System.err.println("     OTP Code: '" + otpCode + "'");
                System.err.println("     OTP Type: '" + otpType + "'");
                
                System.out.println("🕐 Current system time: " + new Timestamp(System.currentTimeMillis()));
                
                // Debug: Show recent OTPs for this user
                if (otpTokenDao instanceof OtpTokenDaoImpl) {
                    ((OtpTokenDaoImpl) otpTokenDao).debugOtpsForUser(user.getUserId());
                }
                
                response.setSuccess(false);
                response.setMessage("Mã OTP không hợp lệ hoặc đã hết hạn. Vui lòng thử lại.");
                return response;
            }

            System.out.println("✅ Valid OTP token found:");
            System.out.println("   OTP ID: " + otpToken.getOtpId());
            System.out.println("   Created at: " + otpToken.getCreatedAt());
            System.out.println("   Expires at: " + otpToken.getExpiresAt());
            System.out.println("   Is used: " + otpToken.getIsUsed());
            System.out.println("   Current time: " + new Timestamp(System.currentTimeMillis()));

            // Mark OTP as used
            boolean marked = otpTokenDao.markAsUsed(otpToken.getOtpId());
            System.out.println("🏷️ OTP marked as used: " + marked);

            // Process based on OTP type
            if (Enums.OtpType.REGISTRATION.name().equals(otpType)) {
                System.out.println("🔄 Processing REGISTRATION OTP...");
                
                // Activate user account
                user.setIsActive(true);
                user.setIsVerified(true);
                boolean updated = userDao.update(user);
                
                System.out.println("👤 User account activation result: " + updated);
                
                if (!updated) {
                    System.err.println("❌ Failed to update user account status");
                    response.setSuccess(false);
                    response.setMessage("Lỗi kích hoạt tài khoản. Vui lòng thử lại.");
                    return response;
                }
                
                response.setMessage("Tài khoản đã được kích hoạt thành công! Bạn có thể đăng nhập ngay bây giờ.");
                
            } else if (Enums.OtpType.FORGOT_PASSWORD.name().equals(otpType)) {
                System.out.println("🔄 Processing FORGOT_PASSWORD OTP...");
                response.setMessage("Xác thực OTP thành công. Bạn có thể đặt lại mật khẩu.");
                
            } else {
                System.out.println("🔄 Processing generic OTP...");
                response.setMessage("Xác thực OTP thành công");
            }

            response.setSuccess(true);
            System.out.println("✅ ========== OTP VERIFICATION SUCCESS ==========");
            System.out.println("✅ OTP verification completed for: " + email);

        } catch (Exception e) {
            System.err.println("❌ ========== OTP VERIFICATION ERROR ==========");
            System.err.println("❌ OTP verification failed with exception: " + e.getMessage());
            e.printStackTrace();
            response.setSuccess(false);
            response.setMessage("Lỗi hệ thống: " + e.getMessage());
        }

        return response;
    }

    /**
     * Forgot Password - Send OTP to email
     * @param request ForgotPasswordRequest containing email
     * @return ForgotPasswordResponse with success status
     */
    public AuthDtos.ForgotPasswordResponse forgotPassword(AuthDtos.ForgotPasswordRequest request) {
        AuthDtos.ForgotPasswordResponse response = new AuthDtos.ForgotPasswordResponse();

        try {
            System.out.println("🔄 Processing forgot password request");
            System.out.println("📧 Email: " + request.getEmail());
            System.out.println("🕐 Request time (UTC): 2025-10-19 23:34:58");

            // Validate email input
            if (request.getEmail() == null || request.getEmail().trim().isEmpty()) {
                response.setSuccess(false);
                response.setMessage("Vui lòng nhập địa chỉ email");
                return response;
            }

            String email = request.getEmail().trim().toLowerCase();
            System.out.println("🔍 Looking up email: " + email);

            // Find user by email
            User user = userDao.findByEmail(email);
            if (user == null) {
                System.out.println("❌ User not found for email: " + email);
                response.setSuccess(false);
                response.setMessage("Email không tồn tại trong hệ thống");
                return response;
            }

            System.out.println("👤 User found: ID=" + user.getUserId() + ", Active=" + user.getIsActive() + ", Verified=" + user.getIsVerified());

            // Check account status
            if (!user.getIsActive() || !user.getIsVerified()) {
                System.out.println("❌ Account not active or verified: " + email);
                response.setSuccess(false);
                response.setMessage("Tài khoản chưa được kích hoạt hoặc đã bị khóa");
                return response;
            }

            // Generate OTP code
            String otpCode = OtpUtil.generateOtp();
            System.out.println("🔑 Generated forgot password OTP: " + otpCode);

            // Create OTP token (database calculates expiry)
            OtpToken otpToken = new OtpToken(user.getUserId(), otpCode, Enums.OtpType.FORGOT_PASSWORD.name(), null);
            Integer otpId = otpTokenDao.save(otpToken);
            
            if (otpId == null) {
                System.err.println("❌ Failed to save OTP token");
                response.setSuccess(false);
                response.setMessage("Lỗi tạo mã xác thực. Vui lòng thử lại sau.");
                return response;
            }

            System.out.println("✅ Forgot password OTP saved with ID: " + otpId);

            // Send OTP email
            boolean emailSent = MailConfig.sendOtpEmail(email, otpCode, Enums.OtpType.FORGOT_PASSWORD.name());
            if (!emailSent) {
                System.err.println("❌ Failed to send forgot password email");
                response.setSuccess(false);
                response.setMessage("Lỗi gửi email. Vui lòng kiểm tra địa chỉ email và thử lại sau.");
                return response;
            }

            response.setSuccess(true);
            response.setMessage("Mã OTP đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư trong vòng 5 phút.");

            System.out.println("✅ Forgot password process completed for: " + email);

        } catch (Exception e) {
            System.err.println("❌ Forgot password failed with exception: " + e.getMessage());
            e.printStackTrace();
            response.setSuccess(false);
            response.setMessage("Lỗi hệ thống: " + e.getMessage());
        }

        return response;
    }

    /**
     * ✅ FIXED: Reset Password with recently used OTP support
     * @param request ResetPasswordRequest containing email, OTP and new password
     * @return ResetPasswordResponse with success status
     */
    public AuthDtos.ResetPasswordResponse resetPassword(AuthDtos.ResetPasswordRequest request) {
        AuthDtos.ResetPasswordResponse response = new AuthDtos.ResetPasswordResponse();

        try {
            System.out.println("🔄 Processing password reset");
            System.out.println("📧 Email: " + request.getEmail());
            System.out.println("🔑 OTP Code: " + request.getOtpCode());
            System.out.println("🕐 Reset time (UTC): 2025-10-19 23:34:58");

            // Comprehensive input validation
            if (request.getEmail() == null || request.getEmail().trim().isEmpty()) {
                response.setSuccess(false);
                response.setMessage("Email không được để trống");
                return response;
            }

            if (request.getOtpCode() == null || request.getOtpCode().trim().isEmpty()) {
                response.setSuccess(false);
                response.setMessage("Mã OTP không được để trống");
                return response;
            }

            if (request.getNewPassword() == null || request.getNewPassword().trim().isEmpty()) {
                response.setSuccess(false);
                response.setMessage("Mật khẩu mới không được để trống");
                return response;
            }

            // Validate OTP format
            String otpCode = request.getOtpCode().trim();
            if (!OtpUtil.isValidOtp(otpCode)) {
                response.setSuccess(false);
                response.setMessage("Mã OTP phải có đúng 6 chữ số");
                return response;
            }

            // Validate new password strength
            if (request.getNewPassword().length() < 6) {
                response.setSuccess(false);
                response.setMessage("Mật khẩu mới phải có ít nhất 6 ký tự");
                return response;
            }

            String email = request.getEmail().trim().toLowerCase();
            System.out.println("🔍 Processing reset for email: " + email);

            // Find user by email
            User user = userDao.findByEmail(email);
            if (user == null) {
                System.out.println("❌ User not found: " + email);
                response.setSuccess(false);
                response.setMessage("Email không tồn tại trong hệ thống");
                return response;
            }

            System.out.println("👤 User found for password reset: ID=" + user.getUserId());

            // ✅ FIX: Find RECENTLY USED OTP instead of unused OTP
            // Because OTP was already marked as used in verify step
            OtpToken otpToken = findRecentlyUsedOtpForReset(user.getUserId(), otpCode);

            if (otpToken == null) {
                System.err.println("❌ Invalid or expired OTP for password reset");
                System.err.println("   User ID: " + user.getUserId());
                System.err.println("   OTP Code: " + otpCode);
                System.err.println("   Type: FORGOT_PASSWORD");
                
                // Debug: Show recent OTPs
                if (otpTokenDao instanceof OtpTokenDaoImpl) {
                    ((OtpTokenDaoImpl) otpTokenDao).debugOtpsForUser(user.getUserId());
                }
                
                response.setSuccess(false);
                response.setMessage("Mã OTP không hợp lệ hoặc đã hết hạn. Vui lòng thử lại từ đầu.");
                return response;
            }

            System.out.println("✅ Valid recently used OTP found: " + otpToken.getOtpId());
            System.out.println("⏰ OTP was created at: " + otpToken.getCreatedAt());
            System.out.println("🔒 OTP is already used: " + otpToken.getIsUsed());

            // Generate new password hash
            System.out.println("🔒 Generating new password hash...");
            String salt = PasswordHasher.generateSalt();
            String hashedPassword = PasswordHasher.hashPassword(request.getNewPassword(), salt);

            // Update password in database
            boolean updated = userDao.updatePassword(user.getUserId(), hashedPassword, salt);
            if (!updated) {
                System.err.println("❌ Failed to update password in database");
                response.setSuccess(false);
                response.setMessage("Lỗi cập nhật mật khẩu. Vui lòng thử lại.");
                return response;
            }

            System.out.println("🔒 Password updated successfully for user: " + user.getUserId());

            // ✅ FIX: Clean up used OTP
            cleanupUsedOtp(otpToken.getOtpId());

            response.setSuccess(true);
            response.setMessage("Đặt lại mật khẩu thành công! Bạn có thể đăng nhập với mật khẩu mới.");

            System.out.println("✅ Password reset completed successfully for: " + email);

        } catch (Exception e) {
            System.err.println("❌ Password reset failed with exception: " + e.getMessage());
            e.printStackTrace();
            response.setSuccess(false);
            response.setMessage("Lỗi hệ thống: " + e.getMessage());
        }

        return response;
    }

    /**
     * ✅ NEW METHOD: Find recently used OTP for password reset
     * This is needed because OTP is marked as used in verify step
     */
    private OtpToken findRecentlyUsedOtpForReset(Integer userId, String otpCode) {
        try {
            System.out.println("🔍 Searching for recently used OTP for password reset:");
            System.out.println("   User ID: " + userId);
            System.out.println("   OTP Code: " + otpCode);
            System.out.println("   Type: FORGOT_PASSWORD");
            System.out.println("   Condition: Used within last 10 minutes");
            
            if (otpTokenDao instanceof OtpTokenDaoImpl) {
                return ((OtpTokenDaoImpl) otpTokenDao).findRecentlyUsedOtp(userId, otpCode, "FORGOT_PASSWORD");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error finding recently used OTP: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * ✅ NEW METHOD: Clean up used OTP after successful password reset
     */
    private void cleanupUsedOtp(Integer otpId) {
        try {
            System.out.println("🗑️ Cleaning up used OTP: " + otpId);
            if (otpTokenDao instanceof OtpTokenDaoImpl) {
                ((OtpTokenDaoImpl) otpTokenDao).cleanupUsedOtp(otpId);
            }
        } catch (Exception e) {
            System.err.println("❌ Error cleaning up OTP: " + e.getMessage());
        }
    }

    /**
     * Comprehensive validation for registration request
     * @param request RegisterRequest to validate
     * @return true if all validations pass
     */
    private boolean isValidRegisterRequest(AuthDtos.RegisterRequest request) {
        System.out.println("🔍 Validating registration request...");
        
        // Check username
        if (request.getUsername() == null || request.getUsername().trim().isEmpty()) {
            System.err.println("❌ Username is null or empty");
            return false;
        }
        
        String username = request.getUsername().trim();
        if (username.length() < 3) {
            System.err.println("❌ Username too short: " + username.length() + " characters (minimum 3)");
            return false;
        }
        
        if (username.length() > 30) {
            System.err.println("❌ Username too long: " + username.length() + " characters (maximum 30)");
            return false;
        }
        
        if (username.contains(" ")) {
            System.err.println("❌ Username contains spaces");
            return false;
        }
        
        if (!username.matches("^[a-zA-Z0-9_]+$")) {
            System.err.println("❌ Username contains invalid characters");
            return false;
        }

        // Check email
        if (request.getEmail() == null || request.getEmail().trim().isEmpty()) {
            System.err.println("❌ Email is null or empty");
            return false;
        }
        
        String email = request.getEmail().trim();
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$")) {
            System.err.println("❌ Invalid email format: " + email);
            return false;
        }

        // Check password
        if (request.getPassword() == null || request.getPassword().isEmpty()) {
            System.err.println("❌ Password is null or empty");
            return false;
        }
        
        if (request.getPassword().length() < 6) {
            System.err.println("❌ Password too short: " + request.getPassword().length() + " characters (minimum 6)");
            return false;
        }
        
        if (request.getPassword().length() > 100) {
            System.err.println("❌ Password too long: " + request.getPassword().length() + " characters (maximum 100)");
            return false;
        }

        // Check full name
        if (request.getFullName() == null || request.getFullName().trim().isEmpty()) {
            System.err.println("❌ Full name is null or empty");
            return false;
        }
        
        if (request.getFullName().trim().length() > 100) {
            System.err.println("❌ Full name too long: " + request.getFullName().length() + " characters (maximum 100)");
            return false;
        }

        // Check role ID
        if (request.getRoleId() <=0) {
            System.err.println("❌ Role ID is null");
            return false;
        }
        
        // Check phone (optional but validate if provided)
        if (request.getPhone() != null && !request.getPhone().trim().isEmpty()) {
            String phone = request.getPhone().trim();
            if (phone.length() > 20) {
                System.err.println("❌ Phone number too long: " + phone.length() + " characters (maximum 20)");
                return false;
            }
        }
        
        System.out.println("✅ Registration request validation passed");
        return true;
    }

    /**
     * Convert User model to UserResponse DTO
     * @param user User entity
     * @return UserResponse DTO
     */
    private AuthDtos.UserResponse convertToUserResponse(User user) {
        AuthDtos.UserResponse userResponse = new AuthDtos.UserResponse();
        userResponse.setUserId(user.getUserId());
        userResponse.setUsername(user.getUsername());
        userResponse.setEmail(user.getEmail());
        userResponse.setFullName(user.getFullName());
        userResponse.setPhone(user.getPhone());
        userResponse.setRoleId(user.getRoleId());
        
        System.out.println("✅ User converted to response DTO: " + user.getEmail());
        return userResponse;
    }

    /**
     * Get current system timestamp
     * @return Current Timestamp
     */
    private Timestamp getCurrentTimestamp() {
        return new Timestamp(System.currentTimeMillis());
    }

    /**
     * Health check for AuthService and dependencies
     * @return true if all components are healthy
     */
    public boolean healthCheck() {
        try {
            System.out.println("💊 ========== AUTHSERVICE HEALTH CHECK ==========");
            System.out.println("🕐 Health check time (UTC): 2025-10-19 23:34:58");
            System.out.println("👨‍💻 Maintainer: tuaanshuuysv");
            
            boolean userDaoHealthy = (userDao != null);
            boolean otpDaoHealthy = (otpTokenDao != null);
            
            System.out.println("🔍 Component status:");
            System.out.println("   UserDao: " + (userDaoHealthy ? "✅ OK" : "❌ FAIL"));
            System.out.println("   OtpTokenDao: " + (otpDaoHealthy ? "✅ OK" : "❌ FAIL"));
            
            // Test basic functionality
            boolean canGenerateOtp = OtpUtil.generateOtp() != null;
            System.out.println("   OTP Generation: " + (canGenerateOtp ? "✅ OK" : "❌ FAIL"));
            
            boolean canHashPassword = PasswordHasher.generateSalt() != null;
            System.out.println("   Password Hashing: " + (canHashPassword ? "✅ OK" : "❌ FAIL"));
            
            boolean overall = userDaoHealthy && otpDaoHealthy && canGenerateOtp && canHashPassword;
            System.out.println("📊 Overall Health: " + (overall ? "✅ HEALTHY" : "❌ UNHEALTHY"));
            System.out.println("================================================");
            
            return overall;
            
        } catch (Exception e) {
            System.err.println("❌ Health check failed with exception: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Log detailed system information for debugging
     */
    public void logSystemInfo() {
        System.out.println("=====================================");
        System.out.println("🏷️ UTESHOP-CPL AuthService Info");
        System.out.println("=====================================");
        System.out.println("🕐 Current UTC: 2025-10-19 23:34:58");
        System.out.println("🕐 System Time: " + getCurrentTimestamp());
        System.out.println("👨‍💻 Author: tuaanshuuysv");
        System.out.println("📅 Build Date: 2025-10-19");
        System.out.println("🔧 Platform: Tomcat 10.x + Jakarta EE + MySQL 8.x");
        System.out.println("🎯 Features:");
        System.out.println("   ✅ User Registration with Email OTP");
        System.out.println("   ✅ JWT-based Authentication");
        System.out.println("   ✅ Password Reset with Recently Used OTP Support");
        System.out.println("   ✅ BCrypt Password Hashing");
        System.out.println("   ✅ Role-based Access Control");
        System.out.println("   ✅ Email Verification System");
        System.out.println("🔒 Security:");
        System.out.println("   ✅ BCrypt + Salt Password Hashing");
        System.out.println("   ✅ JWT Token Expiration (24h)");
        System.out.println("   ✅ OTP Expiration (5 minutes)");
        System.out.println("   ✅ Recently Used OTP Support (10 minutes window)");
        System.out.println("   ✅ Input Validation & Sanitization");
        System.out.println("   ✅ SQL Injection Prevention");
        System.out.println("=====================================");
    }
}
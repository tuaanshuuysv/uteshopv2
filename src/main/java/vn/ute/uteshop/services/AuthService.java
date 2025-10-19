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

public class AuthService {
    private final UserDao userDao;
    private final OtpTokenDao otpTokenDao;

    public AuthService() {
        this.userDao = new UserDaoImpl();
        this.otpTokenDao = new OtpTokenDaoImpl();
    }

    public AuthDtos.RegisterResponse register(AuthDtos.RegisterRequest request) {
        AuthDtos.RegisterResponse response = new AuthDtos.RegisterResponse();

        try {
            System.out.println("🔄 Processing registration for: " + request.getEmail());

            // Validate input
            if (!isValidRegisterRequest(request)) {
                response.setSuccess(false);
                response.setMessage("Thông tin đăng ký không hợp lệ");
                return response;
            }

            // Check if username already exists
            if (userDao.existsByUsername(request.getUsername())) {
                response.setSuccess(false);
                response.setMessage("Tên đăng nhập đã tồn tại");
                return response;
            }

            // Check if email already exists
            if (userDao.existsByEmail(request.getEmail())) {
                response.setSuccess(false);
                response.setMessage("Email đã được sử dụng");
                return response;
            }

            // Validate role (only USER or VENDOR allowed)
            if (request.getRoleId() != Enums.UserRole.USER.getValue() && 
                request.getRoleId() != Enums.UserRole.VENDOR.getValue()) {
                response.setSuccess(false);
                response.setMessage("Vai trò không hợp lệ. Chỉ được tạo tài khoản User hoặc Vendor");
                return response;
            }

            // Hash password
            String salt = PasswordHasher.generateSalt();
            String hashedPassword = PasswordHasher.hashPassword(request.getPassword(), salt);

            // Create user
            User user = new User(
                request.getUsername(),
                request.getEmail(),
                hashedPassword,
                salt,
                request.getFullName(),
                request.getPhone(),
                request.getRoleId()
            );

            Integer userId = userDao.save(user);
            if (userId == null) {
                response.setSuccess(false);
                response.setMessage("Lỗi tạo tài khoản");
                return response;
            }

            // Generate and send OTP
            String otpCode = OtpUtil.generateOtp();
            Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + 5 * 60 * 1000); // 5 minutes

            OtpToken otpToken = new OtpToken(userId, otpCode, Enums.OtpType.REGISTRATION.name(), expiresAt);
            otpTokenDao.save(otpToken);

            // Send OTP email
            boolean emailSent = MailConfig.sendOtpEmail(request.getEmail(), otpCode, Enums.OtpType.REGISTRATION.name());
            if (!emailSent) {
                response.setSuccess(false);
                response.setMessage("Lỗi gửi email xác thực. Vui lòng thử lại sau.");
                return response;
            }

            response.setSuccess(true);
            response.setMessage("Đăng ký thành công! Vui lòng kiểm tra email để xác thực tài khoản.");
            response.setUserId(userId);

            System.out.println("✅ Registration successful for user: " + request.getEmail());

        } catch (Exception e) {
            System.err.println("❌ Registration failed: " + e.getMessage());
            e.printStackTrace();
            response.setSuccess(false);
            response.setMessage("Lỗi hệ thống: " + e.getMessage());
        }

        return response;
    }

    public AuthDtos.LoginResponse login(AuthDtos.LoginRequest request) {
        AuthDtos.LoginResponse response = new AuthDtos.LoginResponse();

        try {
            System.out.println("🔄 Processing login for: " + request.getUsernameOrEmail());

            // Find user by email or username
            User user = userDao.findByEmail(request.getUsernameOrEmail());
            if (user == null) {
                user = userDao.findByUsername(request.getUsernameOrEmail());
            }

            if (user == null) {
                response.setSuccess(false);
                response.setMessage("Tài khoản không tồn tại");
                return response;
            }

            // Verify password
            if (!PasswordHasher.verifyPassword(request.getPassword(), user.getSalt(), user.getPasswordHash())) {
                response.setSuccess(false);
                response.setMessage("Mật khẩu không chính xác");
                return response;
            }

            // Check if account is verified
            if (!user.getIsVerified()) {
                response.setSuccess(false);
                response.setMessage("Tài khoản chưa được xác thực. Vui lòng kiểm tra email để kích hoạt tài khoản.");
                return response;
            }

            // Check if account is active
            if (!user.getIsActive()) {
                response.setSuccess(false);
                response.setMessage("Tài khoản đã bị khóa. Vui lòng liên hệ admin.");
                return response;
            }

            // Update last login
            user.setLastLogin(new Timestamp(System.currentTimeMillis()));
            userDao.update(user);

            // Generate JWT token
            String token = JwtService.generateToken(user);

            response.setSuccess(true);
            response.setMessage("Đăng nhập thành công! Chào mừng " + user.getFullName());
            response.setToken(token);
            response.setUser(convertToUserResponse(user));

            System.out.println("✅ Login successful for user: " + user.getEmail());

        } catch (Exception e) {
            System.err.println("❌ Login failed: " + e.getMessage());
            e.printStackTrace();
            response.setSuccess(false);
            response.setMessage("Lỗi hệ thống: " + e.getMessage());
        }

        return response;
    }

    public AuthDtos.VerifyOtpResponse verifyOtp(AuthDtos.VerifyOtpRequest request) {
        AuthDtos.VerifyOtpResponse response = new AuthDtos.VerifyOtpResponse();

        try {
            System.out.println("🔄 Verifying OTP for: " + request.getEmail());

            // Find user
            User user = userDao.findByEmail(request.getEmail());
            if (user == null) {
                response.setSuccess(false);
                response.setMessage("Email không tồn tại trong hệ thống");
                return response;
            }

            // Find valid OTP
            OtpToken otpToken = otpTokenDao.findValidOtp(
                user.getUserId(), 
                request.getOtpCode(), 
                request.getOtpType()
            );

            if (otpToken == null) {
                response.setSuccess(false);
                response.setMessage("Mã OTP không hợp lệ hoặc đã hết hạn. Vui lòng thử lại.");
                return response;
            }

            // Mark OTP as used
            otpTokenDao.markAsUsed(otpToken.getOtpId());

            // Activate user account if registration
            if (Enums.OtpType.REGISTRATION.name().equals(request.getOtpType())) {
                user.setIsActive(true);
                user.setIsVerified(true);
                userDao.update(user);
                response.setMessage("Tài khoản đã được kích hoạt thành công! Bạn có thể đăng nhập ngay bây giờ.");
            } else {
                response.setMessage("Xác thực OTP thành công");
            }

            response.setSuccess(true);
            System.out.println("✅ OTP verification successful for: " + request.getEmail());

        } catch (Exception e) {
            System.err.println("❌ OTP verification failed: " + e.getMessage());
            e.printStackTrace();
            response.setSuccess(false);
            response.setMessage("Lỗi hệ thống: " + e.getMessage());
        }

        return response;
    }
    public AuthDtos.ForgotPasswordResponse forgotPassword(AuthDtos.ForgotPasswordRequest request) {
        AuthDtos.ForgotPasswordResponse response = new AuthDtos.ForgotPasswordResponse();

        try {
            System.out.println("🔄 Processing forgot password for: " + request.getEmail());

            // Find user by email
            User user = userDao.findByEmail(request.getEmail());
            if (user == null) {
                response.setSuccess(false);
                response.setMessage("Email không tồn tại trong hệ thống");
                return response;
            }

            // Check if account is active
            if (!user.getIsActive() || !user.getIsVerified()) {
                response.setSuccess(false);
                response.setMessage("Tài khoản chưa được kích hoạt hoặc đã bị khóa");
                return response;
            }

            // Generate and send OTP
            String otpCode = OtpUtil.generateOtp();
            Timestamp expiresAt = new Timestamp(System.currentTimeMillis() + 5 * 60 * 1000); // 5 minutes

            OtpToken otpToken = new OtpToken(user.getUserId(), otpCode, Enums.OtpType.FORGOT_PASSWORD.name(), expiresAt);
            otpTokenDao.save(otpToken);

            // Send OTP email
            boolean emailSent = MailConfig.sendOtpEmail(request.getEmail(), otpCode, Enums.OtpType.FORGOT_PASSWORD.name());
            if (!emailSent) {
                response.setSuccess(false);
                response.setMessage("Lỗi gửi email. Vui lòng thử lại sau.");
                return response;
            }

            response.setSuccess(true);
            response.setMessage("Mã OTP đã được gửi đến email của bạn. Vui lòng kiểm tra hộp thư.");

            System.out.println("✅ Forgot password OTP sent to: " + request.getEmail());

        } catch (Exception e) {
            System.err.println("❌ Forgot password failed: " + e.getMessage());
            e.printStackTrace();
            response.setSuccess(false);
            response.setMessage("Lỗi hệ thống: " + e.getMessage());
        }

        return response;
    }

    public AuthDtos.ResetPasswordResponse resetPassword(AuthDtos.ResetPasswordRequest request) {
        AuthDtos.ResetPasswordResponse response = new AuthDtos.ResetPasswordResponse();

        try {
            System.out.println("🔄 Processing password reset for: " + request.getEmail());

            // Find user
            User user = userDao.findByEmail(request.getEmail());
            if (user == null) {
                response.setSuccess(false);
                response.setMessage("Email không tồn tại trong hệ thống");
                return response;
            }

            // Verify OTP
            OtpToken otpToken = otpTokenDao.findValidOtp(
                user.getUserId(), 
                request.getOtpCode(), 
                Enums.OtpType.FORGOT_PASSWORD.name()
            );

            if (otpToken == null) {
                response.setSuccess(false);
                response.setMessage("Mã OTP không hợp lệ hoặc đã hết hạn");
                return response;
            }

            // Validate new password
            if (request.getNewPassword() == null || request.getNewPassword().length() < 6) {
                response.setSuccess(false);
                response.setMessage("Mật khẩu mới phải có ít nhất 6 ký tự");
                return response;
            }

            // Update password
            String salt = PasswordHasher.generateSalt();
            String hashedPassword = PasswordHasher.hashPassword(request.getNewPassword(), salt);

            boolean updated = userDao.updatePassword(user.getUserId(), hashedPassword, salt);
            if (!updated) {
                response.setSuccess(false);
                response.setMessage("Lỗi cập nhật mật khẩu. Vui lòng thử lại.");
                return response;
            }

            // Mark OTP as used
            otpTokenDao.markAsUsed(otpToken.getOtpId());

            response.setSuccess(true);
            response.setMessage("Đặt lại mật khẩu thành công! Bạn có thể đăng nhập với mật khẩu mới.");

            System.out.println("✅ Password reset successful for: " + request.getEmail());

        } catch (Exception e) {
            System.err.println("❌ Password reset failed: " + e.getMessage());
            e.printStackTrace();
            response.setSuccess(false);
            response.setMessage("Lỗi hệ thống: " + e.getMessage());
        }

        return response;
    }

    // ===== PRIVATE HELPER METHODS =====
    
    private boolean isValidRegisterRequest(AuthDtos.RegisterRequest request) {
        if (request.getUsername() == null || request.getUsername().trim().isEmpty()) {
            return false;
        }
        if (request.getEmail() == null || !request.getEmail().contains("@")) {
            return false;
        }
        if (request.getPassword() == null || request.getPassword().length() < 6) {
            return false;
        }
        if (request.getFullName() == null || request.getFullName().trim().isEmpty()) {
            return false;
        }
        return true;
    }

    private AuthDtos.UserResponse convertToUserResponse(User user) {
        AuthDtos.UserResponse userResponse = new AuthDtos.UserResponse();
        userResponse.setUserId(user.getUserId());
        userResponse.setUsername(user.getUsername());
        userResponse.setEmail(user.getEmail());
        userResponse.setFullName(user.getFullName());
        userResponse.setPhone(user.getPhone());
        userResponse.setRoleId(user.getRoleId());
        return userResponse;
    }
}

    
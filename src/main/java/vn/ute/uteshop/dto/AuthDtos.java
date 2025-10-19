package vn.ute.uteshop.dto;

public class AuthDtos {
    
    // Register Request/Response
    public static class RegisterRequest {
        private String username;
        private String email;
        private String password;
        private String fullName;
        private String phone;
        private Integer roleId;

        // Constructors
        public RegisterRequest() {}

        // Getters and Setters
        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }

        public String getPassword() { return password; }
        public void setPassword(String password) { this.password = password; }

        public String getFullName() { return fullName; }
        public void setFullName(String fullName) { this.fullName = fullName; }

        public String getPhone() { return phone; }
        public void setPhone(String phone) { this.phone = phone; }

        public Integer getRoleId() { return roleId; }
        public void setRoleId(Integer roleId) { this.roleId = roleId; }
    }

    public static class RegisterResponse {
        private boolean success;
        private String message;
        private Integer userId;

        // Constructors
        public RegisterResponse() {}

        // Getters and Setters
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }

        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }

        public Integer getUserId() { return userId; }
        public void setUserId(Integer userId) { this.userId = userId; }
    }

    // Login Request/Response
    public static class LoginRequest {
        private String usernameOrEmail;
        private String password;

        // Constructors
        public LoginRequest() {}

        // Getters and Setters
        public String getUsernameOrEmail() { return usernameOrEmail; }
        public void setUsernameOrEmail(String usernameOrEmail) { this.usernameOrEmail = usernameOrEmail; }

        public String getPassword() { return password; }
        public void setPassword(String password) { this.password = password; }
    }

    public static class LoginResponse {
        private boolean success;
        private String message;
        private String token;
        private UserResponse user;

        // Constructors
        public LoginResponse() {}

        // Getters and Setters
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }

        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }

        public String getToken() { return token; }
        public void setToken(String token) { this.token = token; }

        public UserResponse getUser() { return user; }
        public void setUser(UserResponse user) { this.user = user; }
    }

    // Verify OTP Request/Response
    public static class VerifyOtpRequest {
        private String email;
        private String otpCode;
        private String otpType;

        // Constructors
        public VerifyOtpRequest() {}

        // Getters and Setters
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }

        public String getOtpCode() { return otpCode; }
        public void setOtpCode(String otpCode) { this.otpCode = otpCode; }

        public String getOtpType() { return otpType; }
        public void setOtpType(String otpType) { this.otpType = otpType; }
    }

    public static class VerifyOtpResponse {
        private boolean success;
        private String message;

        // Constructors
        public VerifyOtpResponse() {}

        // Getters and Setters
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }

        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
    }

    // Forgot Password Request/Response
    public static class ForgotPasswordRequest {
        private String email;

        // Constructors
        public ForgotPasswordRequest() {}

        // Getters and Setters
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
    }

    public static class ForgotPasswordResponse {
        private boolean success;
        private String message;

        // Constructors
        public ForgotPasswordResponse() {}

        // Getters and Setters
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }

        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
    }

    // Reset Password Request/Response
    public static class ResetPasswordRequest {
        private String email;
        private String otpCode;
        private String newPassword;

        // Constructors
        public ResetPasswordRequest() {}

        // Getters and Setters
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }

        public String getOtpCode() { return otpCode; }
        public void setOtpCode(String otpCode) { this.otpCode = otpCode; }

        public String getNewPassword() { return newPassword; }
        public void setNewPassword(String newPassword) { this.newPassword = newPassword; }
    }

    public static class ResetPasswordResponse {
        private boolean success;
        private String message;

        // Constructors
        public ResetPasswordResponse() {}

        // Getters and Setters
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }

        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
    }

    // User Response DTO
    public static class UserResponse {
        private Integer userId;
        private String username;
        private String email;
        private String fullName;
        private String phone;
        private Integer roleId;

        // Constructors
        public UserResponse() {}

        // Getters and Setters
        public Integer getUserId() { return userId; }
        public void setUserId(Integer userId) { this.userId = userId; }

        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }

        public String getFullName() { return fullName; }
        public void setFullName(String fullName) { this.fullName = fullName; }

        public String getPhone() { return phone; }
        public void setPhone(String phone) { this.phone = phone; }

        public Integer getRoleId() { return roleId; }
        public void setRoleId(Integer roleId) { this.roleId = roleId; }
    }
}
package vn.ute.uteshop.dto;

import vn.ute.uteshop.model.User;

/**
 * AuthDtos - COMPLETE WITH ALL FIELDS
 * Updated: 2025-10-26 18:33:55 UTC by tuaanshuuysv
 */
public class AuthDtos {
    
    public static class UserResponse {
        private int userId;
        private Integer userIdInteger;
        private String email;
        private String fullName;
        private String username;
        private String phone;
        private int roleId;
        
        public UserResponse() {}
        
        public UserResponse(int userId, String email, String fullName, String username, String phone, int roleId) {
            this.userId = userId;
            this.userIdInteger = userId;
            this.email = email;
            this.fullName = fullName;
            this.username = username;
            this.phone = phone;
            this.roleId = roleId;
        }
        
        public static UserResponse fromUser(User user) {
            if (user == null) return null;
            return new UserResponse(
                user.getUserId(), 
                user.getEmail(), 
                user.getFullName(), 
                user.getUsername(),
                user.getPhone(),
                user.getRoleId()
            );
        }
        
        public int getUserId() { return userId; }
        public void setUserId(int userId) { 
            this.userId = userId; 
            this.userIdInteger = userId;
        }
        public void setUserId(Integer userId) { 
            this.userId = userId != null ? userId : 0; 
            this.userIdInteger = userId;
        }
        
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        
        public String getFullName() { return fullName; }
        public void setFullName(String fullName) { this.fullName = fullName; }
        
        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }
        
        public String getPhone() { return phone; }
        public void setPhone(String phone) { this.phone = phone; }
        
        public int getRoleId() { return roleId; }
        public void setRoleId(int roleId) { this.roleId = roleId; }
    }
    
    public static class LoginRequest {
        private String username;
        private String usernameOrEmail;
        private String password;
        private boolean rememberMe;
        
        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }
        
        public String getUsernameOrEmail() { return usernameOrEmail; }
        public void setUsernameOrEmail(String usernameOrEmail) { this.usernameOrEmail = usernameOrEmail; }
        
        public String getPassword() { return password; }
        public void setPassword(String password) { this.password = password; }
        
        public boolean isRememberMe() { return rememberMe; }
        public void setRememberMe(boolean rememberMe) { this.rememberMe = rememberMe; }
    }
    
    public static class LoginResponse {
        private boolean success;
        private String message;
        private UserResponse user;
        private String token;
        
        public LoginResponse() {}
        
        public LoginResponse(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
        
        public LoginResponse(boolean success, String message, UserResponse user, String token) {
            this.success = success;
            this.message = message;
            this.user = user;
            this.token = token;
        }
        
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }
        
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        
        public UserResponse getUser() { return user; }
        public void setUser(UserResponse user) { this.user = user; }
        
        public String getToken() { return token; }
        public void setToken(String token) { this.token = token; }
    }
    
    public static class RegisterRequest {
        private String email;
        private String password;
        private String fullName;
        private String username;
        private String phone;
        private int roleId = 2;
        
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        
        public String getPassword() { return password; }
        public void setPassword(String password) { this.password = password; }
        
        public String getFullName() { return fullName; }
        public void setFullName(String fullName) { this.fullName = fullName; }
        
        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }
        
        public String getPhone() { return phone; }
        public void setPhone(String phone) { this.phone = phone; }
        
        public int getRoleId() { return roleId; }
        public void setRoleId(int roleId) { this.roleId = roleId; }
    }
    
    public static class RegisterResponse {
        private boolean success;
        private String message;
        private UserResponse user;
        private String otpRequired;
        private Integer userId;
        
        public RegisterResponse() {}
        
        public RegisterResponse(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
        
        public RegisterResponse(boolean success, String message, UserResponse user) {
            this.success = success;
            this.message = message;
            this.user = user;
            this.userId = user != null ? user.getUserId() : null;
        }
        
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }
        
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        
        public UserResponse getUser() { return user; }
        public void setUser(UserResponse user) { 
            this.user = user; 
            this.userId = user != null ? user.getUserId() : null;
        }
        
        public String getOtpRequired() { return otpRequired; }
        public void setOtpRequired(String otpRequired) { this.otpRequired = otpRequired; }
        
        public Integer getUserId() { return userId; }
        public void setUserId(Integer userId) { this.userId = userId; }
    }
    
    public static class VerifyOtpRequest {
        private String email;
        private String otp;
        private String otpCode;
        private String otpType;
        
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        
        public String getOtp() { return otp; }
        public void setOtp(String otp) { this.otp = otp; }
        
        public String getOtpCode() { return otpCode != null ? otpCode : otp; }
        public void setOtpCode(String otpCode) { 
            this.otpCode = otpCode; 
            if (this.otp == null) this.otp = otpCode;
        }
        
        public String getOtpType() { return otpType; }
        public void setOtpType(String otpType) { this.otpType = otpType; }
    }
    
    public static class VerifyOtpResponse {
        private boolean success;
        private String message;
        private UserResponse user;
        
        public VerifyOtpResponse() {}
        
        public VerifyOtpResponse(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
        
        public VerifyOtpResponse(boolean success, String message, UserResponse user) {
            this.success = success;
            this.message = message;
            this.user = user;
        }
        
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }
        
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        
        public UserResponse getUser() { return user; }
        public void setUser(UserResponse user) { this.user = user; }
    }
    
    public static class ForgotPasswordRequest {
        private String email;
        
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
    }
    
    public static class ForgotPasswordResponse {
        private boolean success;
        private String message;
        private String resetToken;
        
        public ForgotPasswordResponse() {}
        
        public ForgotPasswordResponse(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
        
        public ForgotPasswordResponse(boolean success, String message, String resetToken) {
            this.success = success;
            this.message = message;
            this.resetToken = resetToken;
        }
        
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }
        
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        
        public String getResetToken() { return resetToken; }
        public void setResetToken(String resetToken) { this.resetToken = resetToken; }
    }
    
    public static class ResetPasswordRequest {
        private String token;
        private String email;
        private String newPassword;
        private String confirmPassword;
        private String otp;
        private String otpCode;
        
        public String getToken() { return token; }
        public void setToken(String token) { this.token = token; }
        
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        
        public String getNewPassword() { return newPassword; }
        public void setNewPassword(String newPassword) { this.newPassword = newPassword; }
        
        public String getConfirmPassword() { return confirmPassword; }
        public void setConfirmPassword(String confirmPassword) { this.confirmPassword = confirmPassword; }
        
        public String getOtp() { return otp; }
        public void setOtp(String otp) { this.otp = otp; }
        
        public String getOtpCode() { return otpCode != null ? otpCode : otp; }
        public void setOtpCode(String otpCode) { 
            this.otpCode = otpCode; 
            if (this.otp == null) this.otp = otpCode;
        }
    }
    
    public static class ResetPasswordResponse {
        private boolean success;
        private String message;
        
        public ResetPasswordResponse() {}
        
        public ResetPasswordResponse(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
        
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }
        
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
    }
}
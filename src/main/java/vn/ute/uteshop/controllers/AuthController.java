package vn.ute.uteshop.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Cookie;

import vn.ute.uteshop.services.AuthService;
import vn.ute.uteshop.dto.AuthDtos;
import vn.ute.uteshop.common.Enums;
import vn.ute.uteshop.common.AppConstants;

import java.io.IOException;

/**
 * AuthController - Complete Authentication Controller for UTESHOP-CPL
 * Created by tuaanshuuysv on 2025-10-19
 * Updated: 2025-10-21 00:28:23 UTC - Fixed cookie names and JWT token flow
 * Features: Login, Register, OTP Verification, Forgot Password, Reset Password
 * Compatible with: Tomcat 10.x, Jakarta EE, MySQL 8.x
 */
@WebServlet(name = "AuthController", urlPatterns = {
    "/auth/login", 
    "/auth/register", 
    "/auth/verify-otp",
    "/auth/forgot-password",
    "/auth/reset-password",
    "/auth/logout"
})
public class AuthController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private AuthService authService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.authService = new AuthService();
        System.out.println("✅ AuthController initialized successfully");
        System.out.println("🕐 Current UTC: 2025-10-21 00:28:23");
        System.out.println("👨‍💻 Created by: tuaanshuuysv");
        System.out.println("🔧 Supported endpoints: /login, /register, /verify-otp, /forgot-password, /reset-password, /logout");
        System.out.println("🔒 Fixed: Cookie names, JWT flow, session handling");
    }

    /**
     * Handle GET requests for authentication pages
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getRequestURI();
        System.out.println("🔄 GET request to: " + path);
        
        try {
            if (path.endsWith("/login")) {
                handleLoginPage(request, response);
                
            } else if (path.endsWith("/register")) {
                handleRegisterPage(request, response);
                
            } else if (path.endsWith("/verify-otp")) {
                handleVerifyOtpPage(request, response);
                
            } else if (path.endsWith("/forgot-password")) {
                handleForgotPasswordPage(request, response);
                
            } else if (path.endsWith("/reset-password")) {
                handleResetPasswordPage(request, response);
                
            } else if (path.endsWith("/logout")) {
                handleLogout(request, response);
                
            } else {
                System.out.println("❌ Unknown GET path: " + path);
                response.sendRedirect(request.getContextPath() + "/auth/login");
            }
        } catch (Exception e) {
            System.err.println("❌ Error in GET request: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
        }
    }

    /**
     * Handle POST requests for authentication actions
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getRequestURI();
        System.out.println("🔄 POST request to: " + path);
        
        try {
            if (path.endsWith("/login")) {
                handleLogin(request, response);
                
            } else if (path.endsWith("/register")) {
                handleRegister(request, response);
                
            } else if (path.endsWith("/verify-otp")) {
                handleVerifyOtp(request, response);
                
            } else if (path.endsWith("/forgot-password")) {
                handleForgotPassword(request, response);
                
            } else if (path.endsWith("/reset-password")) {
                handleResetPassword(request, response);
                
            } else {
                System.out.println("❌ Unknown POST path: " + path);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Endpoint not found");
            }
        } catch (Exception e) {
            System.err.println("❌ Error in POST request: " + e.getMessage());
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
        }
    }

    // ================== GET PAGE HANDLERS ==================

    /**
     * Display login page
     */
    private void handleLoginPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("📄 Displaying login page");
        
        // Check if user is already logged in
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            System.out.println("👤 User already logged in, redirecting to home");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        request.setAttribute("pageTitle", "Đăng nhập - UTESHOP-CPL");
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    /**
     * Display register page
     */
    private void handleRegisterPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("📄 Displaying register page");
        request.setAttribute("pageTitle", "Đăng ký - UTESHOP-CPL");
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    /**
     * Display OTP verification page
     */
    private void handleVerifyOtpPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("📄 Displaying OTP verification page");
        
        String email = request.getParameter("email");
        String otpType = request.getParameter("otpType");
        
        if (email == null || otpType == null) {
            System.out.println("❌ Missing email or otpType parameters");
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        request.setAttribute("email", email);
        request.setAttribute("otpType", otpType);
        request.setAttribute("pageTitle", "Xác thực OTP - UTESHOP-CPL");
        request.getRequestDispatcher("/WEB-INF/views/auth/verify-otp.jsp").forward(request, response);
    }

    /**
     * Display forgot password page
     */
    private void handleForgotPasswordPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("📄 Displaying forgot password page");
        request.setAttribute("pageTitle", "Quên mật khẩu - UTESHOP-CPL");
        request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
    }

    /**
     * Display reset password page
     */
    private void handleResetPasswordPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("📄 Displaying reset password page");
        
        String email = request.getParameter("email");
        String otpCode = request.getParameter("otpCode");
        
        request.setAttribute("email", email);
        request.setAttribute("otpCode", otpCode);
        request.setAttribute("pageTitle", "Đặt lại mật khẩu - UTESHOP-CPL");
        request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response);
    }

    // ================== POST ACTION HANDLERS ==================

    /**
     * ✅ FIXED: Handle user login with correct cookie name
     */
    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        System.out.println("🔐 Processing login request");
        
        // Extract login data
        AuthDtos.LoginRequest loginRequest = new AuthDtos.LoginRequest();
        loginRequest.setUsernameOrEmail(request.getParameter("usernameOrEmail"));
        loginRequest.setPassword(request.getParameter("password"));
        
        String rememberMe = request.getParameter("rememberMe");
        boolean shouldRemember = "on".equals(rememberMe) || "true".equals(rememberMe);
        
        System.out.println("👤 Login attempt for: " + loginRequest.getUsernameOrEmail());
        System.out.println("🔄 Remember me: " + shouldRemember);

        // Process login
        AuthDtos.LoginResponse loginResponse = authService.login(loginRequest);

        if (loginResponse.isSuccess()) {
            System.out.println("✅ Login successful for: " + loginRequest.getUsernameOrEmail());
            
            // Create session
            HttpSession session = request.getSession(true);
            session.setAttribute("user", loginResponse.getUser());
            session.setAttribute("token", loginResponse.getToken());
            session.setMaxInactiveInterval(24 * 60 * 60); // 24 hours
            
            System.out.println("🔑 Session created for user: " + loginResponse.getUser().getUsername());
            
            // ✅ FIX: Set JWT cookie with correct name from AppConstants
            // Always set cookie for authentication - not just for remember me
            Cookie jwtCookie = new Cookie(AppConstants.COOKIE_TOKEN, loginResponse.getToken());
            jwtCookie.setMaxAge(shouldRemember ? (7 * 24 * 60 * 60) : (24 * 60 * 60)); // 7 days or 24 hours
            jwtCookie.setPath("/");
            jwtCookie.setHttpOnly(true);
            jwtCookie.setSecure(false); // Set to true in production with HTTPS
            response.addCookie(jwtCookie);
            System.out.println("🍪 JWT cookie set with name: " + AppConstants.COOKIE_TOKEN);
            System.out.println("⏰ Cookie expires in: " + (shouldRemember ? "7 days" : "24 hours"));
            
            // Redirect to intended page or home
            String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
            if (redirectUrl != null) {
                session.removeAttribute("redirectAfterLogin");
                System.out.println("↪️ Redirecting to intended page: " + redirectUrl);
                response.sendRedirect(redirectUrl);
            } else {
                System.out.println("🏠 Redirecting to home page");
                response.sendRedirect(request.getContextPath() + "/home"); // ✅ FIX: Redirect to /home
            }
            
        } else {
            System.out.println("❌ Login failed: " + loginResponse.getMessage());
            request.setAttribute("error", loginResponse.getMessage());
            request.setAttribute("usernameOrEmail", loginRequest.getUsernameOrEmail());
            request.setAttribute("pageTitle", "Đăng nhập - UTESHOP-CPL");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }

    /**
     * Handle user registration
     */
    private void handleRegister(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        System.out.println("👤 Processing registration request");
        
        // Extract registration data
        AuthDtos.RegisterRequest registerRequest = new AuthDtos.RegisterRequest();
        registerRequest.setUsername(request.getParameter("username"));
        registerRequest.setEmail(request.getParameter("email"));
        registerRequest.setPassword(request.getParameter("password"));
        registerRequest.setFullName(request.getParameter("fullName"));
        registerRequest.setPhone(request.getParameter("phone"));
        
        // Handle role selection
        String roleParam = request.getParameter("role");
        if ("user".equals(roleParam)) {
            registerRequest.setRoleId(Enums.UserRole.USER.getValue());
        } else if ("vendor".equals(roleParam)) {
            registerRequest.setRoleId(Enums.UserRole.VENDOR.getValue());
        } else {
            registerRequest.setRoleId(Enums.UserRole.USER.getValue()); // Default to USER
        }
        
        System.out.println("📧 Registration for email: " + registerRequest.getEmail());
        System.out.println("👤 Username: " + registerRequest.getUsername());
        System.out.println("🎭 Role: " + registerRequest.getRoleId());

        // Process registration
        AuthDtos.RegisterResponse registerResponse = authService.register(registerRequest);

        if (registerResponse.isSuccess()) {
            System.out.println("✅ Registration successful for: " + registerRequest.getEmail());
            request.setAttribute("success", registerResponse.getMessage());
            request.setAttribute("email", registerRequest.getEmail());
            request.setAttribute("otpType", "REGISTRATION");
            request.setAttribute("pageTitle", "Xác thực OTP - UTESHOP-CPL");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify-otp.jsp").forward(request, response);
            
        } else {
            System.out.println("❌ Registration failed: " + registerResponse.getMessage());
            request.setAttribute("error", registerResponse.getMessage());
            
            // Preserve form data
            AuthDtos.RegisterRequest formData = new AuthDtos.RegisterRequest();
            formData.setUsername(registerRequest.getUsername());
            formData.setEmail(registerRequest.getEmail());
            formData.setFullName(registerRequest.getFullName());
            formData.setPhone(registerRequest.getPhone());
            formData.setRoleId(registerRequest.getRoleId());
            request.setAttribute("formData", formData);
            
            request.setAttribute("pageTitle", "Đăng ký - UTESHOP-CPL");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }

    /**
     * Handle OTP verification
     */
    private void handleVerifyOtp(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        System.out.println("🔐 Processing OTP verification");
        
        // Extract OTP data
        AuthDtos.VerifyOtpRequest verifyRequest = new AuthDtos.VerifyOtpRequest();
        verifyRequest.setEmail(request.getParameter("email"));
        verifyRequest.setOtpCode(request.getParameter("otpCode"));
        verifyRequest.setOtpType(request.getParameter("otpType"));
        
        System.out.println("📧 OTP verification for: " + verifyRequest.getEmail());
        System.out.println("🔑 OTP Code: " + verifyRequest.getOtpCode());
        System.out.println("🏷️ OTP Type: " + verifyRequest.getOtpType());

        // Process OTP verification
        AuthDtos.VerifyOtpResponse verifyResponse = authService.verifyOtp(verifyRequest);

        if (verifyResponse.isSuccess()) {
            System.out.println("✅ OTP verification successful");
            
            if ("REGISTRATION".equals(verifyRequest.getOtpType())) {
                // Account activation successful
                System.out.println("🎉 Account activation successful for: " + verifyRequest.getEmail());
                request.setAttribute("success", "Tài khoản đã được kích hoạt thành công! Bạn có thể đăng nhập ngay bây giờ.");
                request.setAttribute("pageTitle", "Đăng nhập - UTESHOP-CPL");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
                
            } else if ("FORGOT_PASSWORD".equals(verifyRequest.getOtpType())) {
                // OTP verified for password reset
                System.out.println("🔑 OTP verified for password reset: " + verifyRequest.getEmail());
                request.setAttribute("email", verifyRequest.getEmail());
                request.setAttribute("otpCode", verifyRequest.getOtpCode());
                request.setAttribute("pageTitle", "Đặt lại mật khẩu - UTESHOP-CPL");
                request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response);
                
            } else {
                // Generic OTP verification success
                request.setAttribute("success", verifyResponse.getMessage());
                request.setAttribute("pageTitle", "Đăng nhập - UTESHOP-CPL");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            }
            
        } else {
            System.out.println("❌ OTP verification failed: " + verifyResponse.getMessage());
            request.setAttribute("error", verifyResponse.getMessage());
            request.setAttribute("email", verifyRequest.getEmail());
            request.setAttribute("otpType", verifyRequest.getOtpType());
            request.setAttribute("pageTitle", "Xác thực OTP - UTESHOP-CPL");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify-otp.jsp").forward(request, response);
        }
    }

    /**
     * Handle forgot password request
     */
    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        System.out.println("🔑 Processing forgot password request");
        
        // Extract forgot password data
        AuthDtos.ForgotPasswordRequest forgotRequest = new AuthDtos.ForgotPasswordRequest();
        forgotRequest.setEmail(request.getParameter("email"));
        
        System.out.println("📧 Forgot password for: " + forgotRequest.getEmail());

        // Process forgot password
        AuthDtos.ForgotPasswordResponse forgotResponse = authService.forgotPassword(forgotRequest);

        if (forgotResponse.isSuccess()) {
            System.out.println("✅ Forgot password OTP sent successfully");
            request.setAttribute("success", forgotResponse.getMessage());
            request.setAttribute("email", forgotRequest.getEmail());
            request.setAttribute("otpType", "FORGOT_PASSWORD");
            request.setAttribute("pageTitle", "Xác thực OTP - UTESHOP-CPL");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify-otp.jsp").forward(request, response);
            
        } else {
            System.out.println("❌ Forgot password failed: " + forgotResponse.getMessage());
            request.setAttribute("error", forgotResponse.getMessage());
            request.setAttribute("email", forgotRequest.getEmail());
            request.setAttribute("pageTitle", "Quên mật khẩu - UTESHOP-CPL");
            request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
        }
    }

    /**
     * Handle password reset
     */
    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        System.out.println("🔐 Processing password reset");
        
        // Extract reset password data
        AuthDtos.ResetPasswordRequest resetRequest = new AuthDtos.ResetPasswordRequest();
        resetRequest.setEmail(request.getParameter("email"));
        resetRequest.setOtpCode(request.getParameter("otpCode"));
        resetRequest.setNewPassword(request.getParameter("newPassword"));
        
        System.out.println("📧 Password reset for: " + resetRequest.getEmail());
        System.out.println("🔑 Using OTP: " + resetRequest.getOtpCode());

        // Process password reset
        AuthDtos.ResetPasswordResponse resetResponse = authService.resetPassword(resetRequest);

        if (resetResponse.isSuccess()) {
            System.out.println("✅ Password reset successful");
            request.setAttribute("success", "Đặt lại mật khẩu thành công! Bạn có thể đăng nhập với mật khẩu mới.");
            request.setAttribute("pageTitle", "Đăng nhập - UTESHOP-CPL");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            
        } else {
            System.out.println("❌ Password reset failed: " + resetResponse.getMessage());
            request.setAttribute("error", resetResponse.getMessage());
            request.setAttribute("email", resetRequest.getEmail());
            request.setAttribute("otpCode", resetRequest.getOtpCode());
            request.setAttribute("pageTitle", "Đặt lại mật khẩu - UTESHOP-CPL");
            request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response);
        }
    }

    /**
     * ✅ FIXED: Handle user logout with correct cookie name
     */
    private void handleLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        System.out.println("👋 Processing logout request");
        
        // Get current session
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object user = session.getAttribute("user");
            if (user != null) {
                System.out.println("👤 Logging out user: " + user.toString());
            }
            
            // Invalidate session
            session.invalidate();
            System.out.println("🗑️ Session invalidated");
        }
        
        // ✅ FIX: Clear JWT cookie with correct name from AppConstants
        Cookie jwtCookie = new Cookie(AppConstants.COOKIE_TOKEN, "");
        jwtCookie.setMaxAge(0);
        jwtCookie.setPath("/");
        jwtCookie.setHttpOnly(true);
        response.addCookie(jwtCookie);
        System.out.println("🍪 JWT cookie cleared: " + AppConstants.COOKIE_TOKEN);
        
        // Redirect to login with success message
        request.setAttribute("success", "Đăng xuất thành công! Hẹn gặp lại bạn.");
        request.setAttribute("pageTitle", "Đăng nhập - UTESHOP-CPL");
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        
        System.out.println("✅ Logout completed successfully");
    }

    @Override
    public void destroy() {
        System.out.println("🗑️ AuthController destroying...");
        System.out.println("👋 AuthController destroyed at: 2025-10-21 00:28:23 UTC");
        super.destroy();
    }
}
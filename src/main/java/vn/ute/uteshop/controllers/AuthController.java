package vn.ute.uteshop.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.ute.uteshop.services.AuthService;
import vn.ute.uteshop.dto.AuthDtos;
import vn.ute.uteshop.common.AppConstants;
import vn.ute.uteshop.common.Enums;
import vn.ute.uteshop.config.JwtService;

import java.io.IOException;

@WebServlet(urlPatterns = {
	    "/auth/login", "/auth/register", "/auth/verify-otp", 
	    "/auth/logout", "/auth/forgot-password", "/auth/reset-password"
	})
public class AuthController extends HttpServlet {
    private AuthService authService;

    @Override
    public void init() throws ServletException {
        authService = new AuthService();
        System.out.println("✅ AuthController initialized successfully");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        System.out.println("🔄 GET request to: " + path);
        
        switch (path) {
            case "/auth/login":
                request.setAttribute("pageTitle", "Đăng nhập - UTESHOP-CPL");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
                break;
            case "/auth/register":
                request.setAttribute("pageTitle", "Đăng ký - UTESHOP-CPL");
                request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
                break;
            case "/auth/verify-otp":
                request.setAttribute("pageTitle", "Xác thực OTP - UTESHOP-CPL");
                request.getRequestDispatcher("/WEB-INF/views/auth/verify-otp.jsp").forward(request, response);
                break;
            case "/auth/forgot-password":
                request.setAttribute("pageTitle", "Quên mật khẩu - UTESHOP-CPL");
                request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
                break;
            case "/auth/reset-password":
                request.setAttribute("pageTitle", "Đặt lại mật khẩu - UTESHOP-CPL");
                request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response);
                break;
            case "/auth/logout":
                handleLogout(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Set UTF-8 encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String path = request.getServletPath();
        System.out.println("🔄 POST request to: " + path);
        
        switch (path) {
            case "/auth/login":
                handleLogin(request, response);
                break;
            case "/auth/register":
                handleRegister(request, response);
                break;
            case "/auth/verify-otp":
                handleVerifyOtp(request, response);
                break;
            case "/auth/forgot-password":
                handleForgotPassword(request, response);
                break;
            case "/auth/reset-password":
                handleResetPassword(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }


    private void handleLogin(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        AuthDtos.LoginRequest loginRequest = new AuthDtos.LoginRequest();
        loginRequest.setUsernameOrEmail(request.getParameter("usernameOrEmail"));
        loginRequest.setPassword(request.getParameter("password"));

        AuthDtos.LoginResponse loginResponse = authService.login(loginRequest);

        if (loginResponse.isSuccess()) {
            // Validate JWT token before setting cookie
            String token = loginResponse.getToken();
            if (token != null && JwtService.isTokenValid(token)) {
                // Set JWT token in cookie
                Cookie cookie = new Cookie(AppConstants.COOKIE_TOKEN, token);
                cookie.setHttpOnly(true);
                cookie.setPath("/");
                cookie.setMaxAge(24 * 60 * 60); // 24 hours
                cookie.setSecure(false); // Set to true in production with HTTPS
                response.addCookie(cookie);

                // Redirect based on role
                Integer roleId = loginResponse.getUser().getRoleId();
                String redirectUrl;
                
                if (roleId == Enums.UserRole.ADMIN.getValue()) {
                    redirectUrl = request.getContextPath() + "/admin/dashboard";
                } else if (roleId == Enums.UserRole.VENDOR.getValue()) {
                    redirectUrl = request.getContextPath() + "/vendor/dashboard";
                } else {
                    redirectUrl = request.getContextPath() + "/";
                }
                
                System.out.println("✅ Login successful, redirecting to: " + redirectUrl);
                System.out.println("🔑 JWT Token generated for user: " + loginResponse.getUser().getEmail());
                
                // Optional: Log token info for debugging
                if (System.getProperty("jwt.debug") != null) {
                    JwtService.logTokenInfo(token);
                }
                
                response.sendRedirect(redirectUrl);
            } else {
                System.err.println("❌ Generated JWT token is invalid!");
                request.setAttribute("error", "Lỗi tạo phiên đăng nhập. Vui lòng thử lại.");
                request.setAttribute("usernameOrEmail", loginRequest.getUsernameOrEmail());
                request.setAttribute("pageTitle", "Đăng nhập - UTESHOP-CPL");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            }
        } else {
            System.out.println("❌ Login failed: " + loginResponse.getMessage());
            request.setAttribute("error", loginResponse.getMessage());
            request.setAttribute("usernameOrEmail", loginRequest.getUsernameOrEmail());
            request.setAttribute("pageTitle", "Đăng nhập - UTESHOP-CPL");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        AuthDtos.RegisterRequest registerRequest = new AuthDtos.RegisterRequest();
        registerRequest.setUsername(request.getParameter("username"));
        registerRequest.setEmail(request.getParameter("email"));
        registerRequest.setPassword(request.getParameter("password"));
        registerRequest.setFullName(request.getParameter("fullName"));
        registerRequest.setPhone(request.getParameter("phone"));
        
        // Parse role
        String roleStr = request.getParameter("role");
        if ("vendor".equals(roleStr)) {
            registerRequest.setRoleId(Enums.UserRole.VENDOR.getValue());
        } else {
            registerRequest.setRoleId(Enums.UserRole.USER.getValue());
        }

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
            request.setAttribute("formData", registerRequest);
            request.setAttribute("pageTitle", "Đăng ký - UTESHOP-CPL");
            request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
        }
    }

    private void handleVerifyOtp(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        AuthDtos.VerifyOtpRequest verifyRequest = new AuthDtos.VerifyOtpRequest();
        verifyRequest.setEmail(request.getParameter("email"));
        verifyRequest.setOtpCode(request.getParameter("otpCode"));
        verifyRequest.setOtpType(request.getParameter("otpType"));

        AuthDtos.VerifyOtpResponse verifyResponse = authService.verifyOtp(verifyRequest);

        if (verifyResponse.isSuccess()) {
            if ("REGISTRATION".equals(verifyRequest.getOtpType())) {
                System.out.println("✅ Account activation successful for: " + verifyRequest.getEmail());
                request.setAttribute("success", "Tài khoản đã được kích hoạt thành công! Bạn có thể đăng nhập ngay bây giờ.");
                request.setAttribute("pageTitle", "Đăng nhập - UTESHOP-CPL");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            } else {
                // For FORGOT_PASSWORD, redirect to reset password
                request.setAttribute("email", verifyRequest.getEmail());
                request.setAttribute("otpCode", verifyRequest.getOtpCode());
                request.setAttribute("pageTitle", "Đặt lại mật khẩu - UTESHOP-CPL");
                request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response);
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

    private void handleForgotPassword(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        AuthDtos.ForgotPasswordRequest forgotRequest = new AuthDtos.ForgotPasswordRequest();
        forgotRequest.setEmail(request.getParameter("email"));

        AuthDtos.ForgotPasswordResponse forgotResponse = authService.forgotPassword(forgotRequest);

        if (forgotResponse.isSuccess()) {
            System.out.println("✅ Forgot password OTP sent to: " + forgotRequest.getEmail());
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

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        
        AuthDtos.ResetPasswordRequest resetRequest = new AuthDtos.ResetPasswordRequest();
        resetRequest.setEmail(request.getParameter("email"));
        resetRequest.setOtpCode(request.getParameter("otpCode"));
        resetRequest.setNewPassword(request.getParameter("newPassword"));

        AuthDtos.ResetPasswordResponse resetResponse = authService.resetPassword(resetRequest);

        if (resetResponse.isSuccess()) {
            System.out.println("✅ Password reset successful for: " + resetRequest.getEmail());
            request.setAttribute("success", "Mật khẩu đã được đặt lại thành công! Bạn có thể đăng nhập với mật khẩu mới.");
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

    private void handleLogout(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        System.out.println("🔄 Processing logout");
        
        // Clear JWT cookie
        Cookie cookie = new Cookie(AppConstants.COOKIE_TOKEN, null);
        cookie.setMaxAge(0);
        cookie.setPath("/");
        response.addCookie(cookie);

        // Clear session
        request.getSession().invalidate();

        System.out.println("✅ Logout successful");
        
        // Redirect to home
        response.sendRedirect(request.getContextPath() + "/");
    }
}
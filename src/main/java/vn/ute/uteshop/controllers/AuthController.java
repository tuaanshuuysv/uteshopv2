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
import vn.ute.uteshop.model.User;
import vn.ute.uteshop.dao.UserDao;
import vn.ute.uteshop.dao.impl.UserDaoImpl;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

/**
 * AuthController - Fixed: Always set session user as User object for profile access
 * Updated: 2025-10-27
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
    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        super.init();
        this.authService = new AuthService();
        this.userDao = new UserDaoImpl();
        System.out.println("✅ AuthController initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getRequestURI();
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
                response.sendRedirect(request.getContextPath() + "/auth/login");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getRequestURI();
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
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Endpoint not found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
        }
    }

    // ================== GET PAGES ==================
    private void handleLoginPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        String successParam = request.getParameter("success");
        if (successParam != null && !successParam.isBlank()) {
            request.setAttribute("success", successParam);
        }
        request.setAttribute("pageTitle", "Đăng nhập - UTESHOP-CPL");
        request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
    }

    private void handleRegisterPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Đăng ký - UTESHOP-CPL");
        request.getRequestDispatcher("/WEB-INF/views/auth/register.jsp").forward(request, response);
    }

    private void handleVerifyOtpPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String otpType = request.getParameter("otpType");
        if (email == null || otpType == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        request.setAttribute("email", email);
        request.setAttribute("otpType", otpType);
        request.setAttribute("pageTitle", "Xác thực OTP - UTESHOP-CPL");
        request.getRequestDispatcher("/WEB-INF/views/auth/verify-otp.jsp").forward(request, response);
    }

    private void handleForgotPasswordPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("pageTitle", "Quên mật khẩu - UTESHOP-CPL");
        request.getRequestDispatcher("/WEB-INF/views/auth/forgot-password.jsp").forward(request, response);
    }

    private void handleResetPasswordPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String otpCode = request.getParameter("otpCode");
        request.setAttribute("email", email);
        request.setAttribute("otpCode", otpCode);
        request.setAttribute("pageTitle", "Đặt lại mật khẩu - UTESHOP-CPL");
        request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response);
    }

    // ================== POST ACTIONS ==================
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        AuthDtos.LoginRequest loginRequest = new AuthDtos.LoginRequest();
        loginRequest.setUsernameOrEmail(request.getParameter("usernameOrEmail"));
        loginRequest.setPassword(request.getParameter("password"));

        boolean remember = "on".equals(request.getParameter("rememberMe")) || "true".equals(request.getParameter("rememberMe"));
        AuthDtos.LoginResponse loginResponse = authService.login(loginRequest);

        if (loginResponse.isSuccess()) {
            HttpSession session = request.getSession(true);
            AuthDtos.UserResponse userResponse = loginResponse.getUser();
            User user = null;
            if (userResponse != null) {
                user = userDao.findById(userResponse.getUserId());
                session.setAttribute("user", user);
                System.out.println("✅ Session user set: " + (user != null ? user.getEmail() : "null"));
            } else {
                System.out.println("❌ loginResponse.getUser() trả về null!");
            }
            session.setAttribute("token", loginResponse.getToken());
            session.setMaxInactiveInterval(24 * 60 * 60);

            Cookie jwtCookie = new Cookie(AppConstants.COOKIE_TOKEN, loginResponse.getToken());
            jwtCookie.setMaxAge(remember ? (7 * 24 * 60 * 60) : (24 * 60 * 60));
            jwtCookie.setPath("/");
            jwtCookie.setHttpOnly(true);
            jwtCookie.setSecure(false); // true khi HTTPS
            response.addCookie(jwtCookie);

            String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
            if (redirectUrl != null) {
                session.removeAttribute("redirectAfterLogin");
                response.sendRedirect(redirectUrl);
            } else {
                response.sendRedirect(request.getContextPath() + "/dashboard");
            }
        } else {
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

        String roleParam = request.getParameter("role");
        if ("vendor".equals(roleParam)) registerRequest.setRoleId(Enums.UserRole.VENDOR.getValue());
        else registerRequest.setRoleId(Enums.UserRole.USER.getValue());

        AuthDtos.RegisterResponse registerResponse = authService.register(registerRequest);

        if (registerResponse.isSuccess()) {
            request.setAttribute("success", registerResponse.getMessage());
            request.setAttribute("email", registerRequest.getEmail());
            request.setAttribute("otpType", "REGISTRATION");
            request.setAttribute("pageTitle", "Xác thực OTP - UTESHOP-CPL");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify-otp.jsp").forward(request, response);
        } else {
            request.setAttribute("error", registerResponse.getMessage());
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

    private void handleVerifyOtp(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        AuthDtos.VerifyOtpRequest verifyRequest = new AuthDtos.VerifyOtpRequest();
        verifyRequest.setEmail(request.getParameter("email"));
        verifyRequest.setOtpCode(request.getParameter("otpCode"));
        verifyRequest.setOtpType(request.getParameter("otpType"));

        AuthDtos.VerifyOtpResponse verifyResponse = authService.verifyOtp(verifyRequest);

        if (verifyResponse.isSuccess()) {
            if ("REGISTRATION".equals(verifyRequest.getOtpType())) {
                request.setAttribute("success", "Tài khoản đã được kích hoạt thành công! Bạn có thể đăng nhập ngay bây giờ.");
                request.setAttribute("pageTitle", "Đăng nhập - UTESHOP-CPL");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            } else if ("FORGOT_PASSWORD".equals(verifyRequest.getOtpType())) {
                request.setAttribute("email", verifyRequest.getEmail());
                request.setAttribute("otpCode", verifyRequest.getOtpCode());
                request.setAttribute("pageTitle", "Đặt lại mật khẩu - UTESHOP-CPL");
                request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response);
            } else {
                request.setAttribute("success", verifyResponse.getMessage());
                request.setAttribute("pageTitle", "Đăng nhập - UTESHOP-CPL");
                request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
            }
        } else {
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
            request.setAttribute("success", forgotResponse.getMessage());
            request.setAttribute("email", forgotRequest.getEmail());
            request.setAttribute("otpType", "FORGOT_PASSWORD");
            request.setAttribute("pageTitle", "Xác thực OTP - UTESHOP-CPL");
            request.getRequestDispatcher("/WEB-INF/views/auth/verify-otp.jsp").forward(request, response);
        } else {
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
            request.setAttribute("success", "Đặt lại mật khẩu thành công! Bạn có thể đăng nhập với mật khẩu mới.");
            request.setAttribute("pageTitle", "Đăng nhập - UTESHOP-CPL");
            request.getRequestDispatcher("/WEB-INF/views/auth/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", resetResponse.getMessage());
            request.setAttribute("email", resetRequest.getEmail());
            request.setAttribute("otpCode", resetRequest.getOtpCode());
            request.setAttribute("pageTitle", "Đặt lại mật khẩu - UTESHOP-CPL");
            request.getRequestDispatcher("/WEB-INF/views/auth/reset-password.jsp").forward(request, response);
        }
    }

    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session != null) session.invalidate();

        Cookie jwtCookie = new Cookie(AppConstants.COOKIE_TOKEN, "");
        jwtCookie.setMaxAge(0);
        jwtCookie.setPath("/");
        jwtCookie.setHttpOnly(true);
        response.addCookie(jwtCookie);

        String msg = URLEncoder.encode("Đăng xuất thành công! Hẹn gặp lại bạn.", StandardCharsets.UTF_8);
        response.sendRedirect(request.getContextPath() + "/auth/login?success=" + msg);
    }
}
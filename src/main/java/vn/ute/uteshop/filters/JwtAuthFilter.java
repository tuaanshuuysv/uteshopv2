package vn.ute.uteshop.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.ute.uteshop.config.JwtService;
import vn.ute.uteshop.dao.UserDao;
import vn.ute.uteshop.dao.impl.UserDaoImpl;
import vn.ute.uteshop.model.User;
import vn.ute.uteshop.common.AppConstants;

import java.io.IOException;

/**
 * JwtAuthFilter - FIXED Authentication Filter for UTESHOP-CPL
 * Fixed: 2025-10-21 14:38:00 UTC by tuaanshuuysv
 * Issue: Admin paths incorrectly marked as public
 */
@WebFilter("/*")
public class JwtAuthFilter implements Filter {
    private UserDao userDao;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        userDao = new UserDaoImpl();
        System.out.println("✅ JwtAuthFilter FIXED initialized successfully");
        System.out.println("🕐 Fixed time: 2025-10-21 14:38:00 UTC");
        System.out.println("🔧 Fixed issue: Admin paths authentication");
        System.out.println("🔧 Cookie name: " + AppConstants.COOKIE_TOKEN);
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Get path info for debugging
        String path = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Remove context path from URI
        if (path.startsWith(contextPath)) {
            path = path.substring(contextPath.length());
        }

        System.out.println("🔍 JwtAuthFilter processing: " + path);

        // ✅ FIX: ADMIN PATHS KHÔNG PHẢI PUBLIC
        if (path.startsWith("/admin")) {
            System.out.println("🔍 ADMIN ACCESS ATTEMPT:");
            System.out.println("   Path: " + path);
            System.out.println("   Session: " + (httpRequest.getSession(false) != null));
            
            // Check cookies
            Cookie[] cookies = httpRequest.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (AppConstants.COOKIE_TOKEN.equals(cookie.getName())) {
                        System.out.println("   JWT Cookie found: " + cookie.getName());
                        System.out.println("   JWT Cookie value length: " + cookie.getValue().length());
                        break;
                    }
                }
            }
        }

        // Check if path is public (KHÔNG BAO GỒM /admin/*)
        if (isPublicPath(path)) {
            System.out.println("🟢 Public path, skipping authentication: " + path);
            chain.doFilter(request, response);
            return;
        }

        // ✅ ADMIN PATHS CẦN AUTHENTICATION
        System.out.println("🔒 Protected path, checking authentication: " + path);

        // Get JWT token from cookie
        String token = getTokenFromCookies(httpRequest);
        
        if (token != null && !token.isEmpty()) {
            System.out.println("🍪 JWT token found in cookie: " + AppConstants.COOKIE_TOKEN);
            System.out.println("🔑 Token length: " + token.length() + " chars");
            
            try {
                // Validate token using correct method name
                if (JwtService.isTokenValid(token)) {
                    Integer userId = JwtService.getUserIdFromToken(token);
                    
                    if (userId != null) {
                        System.out.println("✅ Valid JWT token for user ID: " + userId);
                        User user = userDao.findById(userId);
                        
                        if (user != null && user.getIsActive() && user.getIsVerified()) {
                            // ✅ SET USER IN REQUEST ATTRIBUTES
                            httpRequest.setAttribute(AppConstants.AUTH_USER_ATTR, user);
                            System.out.println("✅ User authenticated via JWT: " + user.getEmail() + " (Role: " + user.getRoleId() + ")");
                            
                            // ✅ THÊM DEBUG CHO ADMIN ROLE
                            if (path.startsWith("/admin")) {
                                System.out.println("🔍 ADMIN ACCESS CHECK:");
                                System.out.println("   User Role: " + user.getRoleId());
                                System.out.println("   Is Admin: " + (user.getRoleId() == 4));
                                System.out.println("   User set in request: " + (httpRequest.getAttribute(AppConstants.AUTH_USER_ATTR) != null));
                            }
                            
                        } else {
                            System.out.println("⚠️ User found but inactive/unverified: " + (user != null ? user.getEmail() : "null"));
                            if (user != null) {
                                System.out.println("   Active: " + user.getIsActive() + ", Verified: " + user.getIsVerified());
                            }
                        }
                    } else {
                        System.out.println("⚠️ Could not extract user ID from token");
                    }
                } else {
                    System.out.println("⚠️ Invalid or expired JWT token");
                    clearTokenCookie(httpResponse);
                }
            } catch (Exception e) {
                System.err.println("❌ Error processing JWT token: " + e.getMessage());
                e.printStackTrace();
                clearTokenCookie(httpResponse);
            }
        } else {
            System.out.println("🍪 No JWT token found in cookies");
            
            // ✅ DEBUG CHO ADMIN ACCESS WITHOUT TOKEN
            if (path.startsWith("/admin")) {
                System.out.println("❌ ADMIN ACCESS DENIED: No JWT token for path: " + path);
            }
        }

        chain.doFilter(request, response);
    }

    /**
     * ✅ FIXED: Check if path is public (KHÔNG BAO GỒM /admin/*)
     */
    private boolean isPublicPath(String path) {
        String[] publicPaths = {
            "/auth/login", "/auth/register", "/auth/verify-otp", 
            "/auth/forgot-password", "/auth/reset-password",
            "/", "/home", "/product", "/category", "/search",
            "/assets/", "/WEB-INF/", "/error/", "/favicon.ico",
            "/css/", "/js/", "/images/", "/fonts/"
            // ❌ REMOVED: "/admin/" - Admin paths are NOT public
        };

        for (String publicPath : publicPaths) {
            if (path.startsWith(publicPath)) {
                return true;
            }
        }
        
        // ✅ ADMIN PATHS ARE PROTECTED
        if (path.startsWith("/admin")) {
            System.out.println("🔒 Admin path detected as PROTECTED: " + path);
            return false;
        }
        
        return false;
    }

    private String getTokenFromCookies(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (AppConstants.COOKIE_TOKEN.equals(cookie.getName())) {
                    System.out.println("🍪 Found JWT cookie: " + AppConstants.COOKIE_TOKEN);
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

    private void clearTokenCookie(HttpServletResponse response) {
        Cookie cookie = new Cookie(AppConstants.COOKIE_TOKEN, null);
        cookie.setMaxAge(0);
        cookie.setPath("/");
        cookie.setHttpOnly(true);
        response.addCookie(cookie);
        System.out.println("🗑️ Cleared invalid JWT cookie: " + AppConstants.COOKIE_TOKEN);
    }

    @Override
    public void destroy() {
        System.out.println("🔄 JwtAuthFilter destroyed at: 2025-10-21 14:38:00 UTC");
    }
}
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
 * JwtAuthFilter - Enhanced JWT Authentication Filter
 * Updated: 2025-10-21 00:40:12 UTC - Added enhanced debugging
 * Created by tuaanshuuysv
 */
@WebFilter("/*")
public class JwtAuthFilter implements Filter {
    private UserDao userDao;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        userDao = new UserDaoImpl();
        System.out.println("✅ JwtAuthFilter initialized successfully");
        System.out.println("🕐 Init time: 2025-10-21 00:40:12 UTC");
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

        // Skip authentication for public paths
        if (isPublicPath(path)) {
            System.out.println("🟢 Public path, skipping authentication: " + path);
            chain.doFilter(request, response);
            return;
        }

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
                            // Set user in request attributes
                            httpRequest.setAttribute(AppConstants.AUTH_USER_ATTR, user);
                            System.out.println("✅ User authenticated via JWT: " + user.getEmail() + " (Role: " + user.getRoleId() + ")");
                            System.out.println("🎭 User details: " + user.getFullName() + " (ID: " + user.getUserId() + ")");
                            
                            // Optional: Log token info for debugging
                            if (System.getProperty("jwt.debug") != null) {
                                JwtService.logTokenInfo(token);
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
                    
                    // Clear invalid token cookie
                    clearTokenCookie(httpResponse);
                }
            } catch (Exception e) {
                System.err.println("❌ Error processing JWT token: " + e.getMessage());
                e.printStackTrace();
                
                // Clear invalid token cookie
                clearTokenCookie(httpResponse);
            }
        } else {
            System.out.println("🍪 No JWT token found in cookies");
            
            // Debug: List all cookies
            Cookie[] cookies = httpRequest.getCookies();
            if (cookies != null) {
                System.out.println("🔍 Available cookies:");
                for (Cookie cookie : cookies) {
                    System.out.println("   - " + cookie.getName() + " = " + 
                        (cookie.getValue().length() > 50 ? 
                            cookie.getValue().substring(0, 50) + "..." : 
                            cookie.getValue()));
                }
            } else {
                System.out.println("🔍 No cookies found in request");
            }
        }

        chain.doFilter(request, response);
    }

    private boolean isPublicPath(String path) {
        String[] publicPaths = {
            "/auth/login", "/auth/register", "/auth/verify-otp", 
            "/auth/forgot-password", "/auth/reset-password",
            "/", "/home", "/product", "/category", "/search",
            "/assets/", "/WEB-INF/", "/error/", "/favicon.ico",
            "/css/", "/js/", "/images/", "/fonts/"
        };

        for (String publicPath : publicPaths) {
            if (path.startsWith(publicPath)) {
                return true;
            }
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
        System.out.println("🔄 JwtAuthFilter destroyed at: 2025-10-21 00:40:12 UTC");
    }
}
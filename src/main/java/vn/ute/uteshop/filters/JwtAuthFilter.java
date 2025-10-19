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
import io.jsonwebtoken.Claims;

import java.io.IOException;

@WebFilter("/*")
public class JwtAuthFilter implements Filter {
    private UserDao userDao;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        userDao = new UserDaoImpl();
        System.out.println("✅ JwtAuthFilter initialized successfully");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Skip authentication for public paths
        String path = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Remove context path from URI
        if (path.startsWith(contextPath)) {
            path = path.substring(contextPath.length());
        }

        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        // Get JWT token from cookie
        String token = getTokenFromCookies(httpRequest);
        
        if (token != null && !token.isEmpty()) {
            try {
                // Validate token using new API
                if (JwtService.isTokenValid(token)) {
                    Integer userId = JwtService.getUserIdFromToken(token);
                    
                    if (userId != null) {
                        User user = userDao.findById(userId);
                        
                        if (user != null && user.getIsActive() && user.getIsVerified()) {
                            // Set user in request attributes
                            httpRequest.setAttribute(AppConstants.AUTH_USER_ATTR, user);
                            System.out.println("✅ User authenticated: " + user.getEmail() + " (Role: " + user.getRoleId() + ")");
                            
                            // Optional: Log token info for debugging
                            if (System.getProperty("jwt.debug") != null) {
                                JwtService.logTokenInfo(token);
                            }
                        } else {
                            System.out.println("⚠️ User found but inactive/unverified: " + (user != null ? user.getEmail() : "null"));
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
    }

    @Override
    public void destroy() {
        System.out.println("🔄 JwtAuthFilter destroyed");
    }
}
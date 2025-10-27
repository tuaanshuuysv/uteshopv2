package vn.ute.uteshop.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.ute.uteshop.dto.AuthDtos;
import vn.ute.uteshop.model.User;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * JwtAuthFilter - COMPLETE FIXED VERSION
 * Updated: 2025-10-26 18:33:55 UTC by tuaanshuuysv
 */
@WebFilter("/*")
public class JwtAuthFilter implements Filter {
    
    private static final List<String> PUBLIC_PATHS = Arrays.asList(
        "/", "/home", "/auth/login", "/auth/register", "/auth/logout", 
        "/auth/verify-otp", "/auth/forgot-password", "/auth/reset-password",
        "/search", "/products", "/shops", "/categories", "/test"
    );
    
    private static final List<String> STATIC_EXTENSIONS = Arrays.asList(
        ".css", ".js", ".jpg", ".jpeg", ".png", ".gif", ".ico", ".svg", 
        ".woff", ".woff2", ".ttf", ".eot", ".map", ".webp", ".bmp"
    );
    
    private static final List<String> STATIC_PATHS = Arrays.asList(
        "/assets/", "/static/", "/resources/", "/images/", "/css/", "/js/", 
        "/fonts/", "/uploads/", "/favicon.ico"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("✅ JwtAuthFilter initialized successfully");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String requestURI = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        String path = requestURI.substring(contextPath.length());
        
        if (isStaticResource(path)) {
            chain.doFilter(request, response);
            return;
        }
        
        System.out.println("🔍 JwtAuthFilter processing: " + path);
        
        if (isPublicPath(path)) {
            System.out.println("🟢 Public path, skipping authentication: " + path);
            chain.doFilter(request, response);
            return;
        }
        
        try {
            HttpSession session = httpRequest.getSession(false);
            
            if (session != null) {
                Object sessionUser = session.getAttribute("user");
                
                if (sessionUser != null) {
                    System.out.println("✅ Authenticated user found for path: " + path);
                    chain.doFilter(request, response);
                    return;
                }
            }
        } catch (Exception e) {
            System.err.println("⚠️ Auth error for path " + path + ": " + e.getMessage());
        }
        
        System.out.println("🔒 Access denied to protected path: " + path);
        httpResponse.sendRedirect(contextPath + "/auth/login");
    }
    
    private boolean isStaticResource(String path) {
        if (path == null) return false;
        
        for (String staticPath : STATIC_PATHS) {
            if (path.startsWith(staticPath)) {
                return true;
            }
        }
        
        for (String extension : STATIC_EXTENSIONS) {
            if (path.toLowerCase().endsWith(extension)) {
                return true;
            }
        }
        
        return false;
    }
    
    private boolean isPublicPath(String path) {
        if (path == null) return false;
        
        for (String publicPath : PUBLIC_PATHS) {
            if (path.equals(publicPath) || path.startsWith(publicPath + "/")) {
                return true;
            }
        }
        
        return false;
    }

    @Override
    public void destroy() {
        System.out.println("🗑️ JwtAuthFilter destroyed");
    }
}
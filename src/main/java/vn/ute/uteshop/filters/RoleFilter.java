package vn.ute.uteshop.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.ute.uteshop.dto.AuthDtos;
import vn.ute.uteshop.model.User;

import java.io.IOException;

/**
 * RoleFilter - FIXED for Profile Access
 * Fixed: 2025-10-23 06:50:00 UTC by tuaanshuuysv
 * Fixed: Allow profile paths to pass through
 */
@WebFilter(urlPatterns = {
    "/admin/*", 
    "/vendor/*", 
    "/user/orders", 
    "/user/wishlist"
    // ✅ REMOVED: "/user/profile" to allow access
})
public class RoleFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("✅ RoleFilter FIXED initialized - Enhanced for Profile Access");
        System.out.println("🕐 Fixed time: 2025-10-23 06:50:00 UTC");
        System.out.println("🔧 Fixed: Allow profile paths to access UserProfileController");
        System.out.println("🔧 Protected paths: /admin/*, /vendor/*, /user/orders, /user/wishlist");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        String path = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        if (path.startsWith(contextPath)) {
            path = path.substring(contextPath.length());
        }
        
        System.out.println("🔍 RoleFilter checking: " + path);
        
        // ✅ SKIP PROFILE PATHS - Let UserProfileController handle authentication
        if (path.startsWith("/user/profile") || 
            path.startsWith("/vendor/profile") || 
            path.startsWith("/admin/profile")) {
            System.out.println("🟢 Profile path, allowing UserProfileController to handle: " + path);
            chain.doFilter(request, response);
            return;
        }
        
        // Get user from request attributes (set by JwtAuthFilter)
        User user = (User) httpRequest.getAttribute("authUser");
        System.out.println("🔍 User in request: " + (user != null ? user.getEmail() : "null"));
        
        if (user == null) {
            // Try to get from session as fallback
            HttpSession session = httpRequest.getSession(false);
            if (session != null) {
                Object sessionUser = session.getAttribute("user");
                if (sessionUser instanceof AuthDtos.UserResponse) {
                    AuthDtos.UserResponse userResponse = (AuthDtos.UserResponse) sessionUser;
                    System.out.println("🔄 Using session user: " + userResponse.getEmail() + " (Role: " + userResponse.getRoleId() + ")");
                    
                    // Check role-based access
                    if (checkRoleAccess(path, userResponse.getRoleId())) {
                        chain.doFilter(request, response);
                        return;
                    }
                }
            }
            
            System.out.println("❌ RoleFilter: No authenticated user found for path: " + path);
            System.out.println("🔍 DEBUG: All request attributes:");
            java.util.Enumeration<String> attrNames = httpRequest.getAttributeNames();
            if (attrNames.hasMoreElements()) {
                while (attrNames.hasMoreElements()) {
                    String attrName = attrNames.nextElement();
                    System.out.println("   " + attrName + ": " + httpRequest.getAttribute(attrName));
                }
            } else {
                System.out.println("   ❌ No request attributes found!");
            }
            
            httpResponse.sendRedirect(contextPath + "/auth/login?redirect=" + path);
            return;
        }
        
        // Check role-based access for authenticated user
        if (checkRoleAccess(path, user.getRoleId())) {
            System.out.println("✅ RoleFilter: Access granted for role " + user.getRoleId() + " to path: " + path);
            chain.doFilter(request, response);
        } else {
            System.out.println("❌ RoleFilter: Access denied for role " + user.getRoleId() + " to path: " + path);
            httpResponse.sendRedirect(contextPath + "/home?error=access_denied");
        }
    }

    /**
     * Check if user role has access to the given path
     */
    private boolean checkRoleAccess(String path, Integer roleId) {
        System.out.println("🔐 Checking role access: Role " + roleId + " for path: " + path);
        
        if (path.startsWith("/admin/")) {
            return roleId == 4; // Admin only
        } else if (path.startsWith("/vendor/")) {
            return roleId == 3 || roleId == 4; // Vendor or Admin
        } else if (path.startsWith("/user/")) {
            return roleId == 2 || roleId == 3 || roleId == 4; // User, Vendor, or Admin
        }
        
        return true; // Allow access for other paths
    }

    @Override
    public void destroy() {
        System.out.println("🗑️ RoleFilter destroyed");
    }
}
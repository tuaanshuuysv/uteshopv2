package vn.ute.uteshop.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.ute.uteshop.model.User;
import vn.ute.uteshop.common.AppConstants;
import vn.ute.uteshop.common.Enums;

import java.io.IOException;

/**
 * RoleFilter - FIXED Role-based Access Control
 * Fixed: 2025-10-21 14:38:00 UTC by tuaanshuuysv
 * Enhanced: Debug logging for admin access
 */
@WebFilter(urlPatterns = {"/user/*", "/vendor/*", "/admin/*"})
public class RoleFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("✅ RoleFilter FIXED initialized - Enhanced for Admin/Vendor");
        System.out.println("🕐 Fixed time: 2025-10-21 14:38:00 UTC");
        System.out.println("🔧 Enhanced debug logging for admin access");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Get authenticated user
        User user = (User) httpRequest.getAttribute(AppConstants.AUTH_USER_ATTR);
        
        String path = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Remove context path
        if (path.startsWith(contextPath)) {
            path = path.substring(contextPath.length());
        }
        
        System.out.println("🔍 RoleFilter checking: " + path);
        System.out.println("🔍 User in request: " + (user != null ? user.getEmail() + " (Role: " + user.getRoleId() + ")" : "null"));
        
        if (user == null) {
            System.out.println("❌ RoleFilter: No authenticated user found for path: " + path);
            
            // ✅ DEBUG: Check all request attributes
            System.out.println("🔍 DEBUG: All request attributes:");
            java.util.Enumeration<String> attrs = httpRequest.getAttributeNames();
            boolean hasAttributes = false;
            while (attrs.hasMoreElements()) {
                String attrName = attrs.nextElement();
                Object attrValue = httpRequest.getAttribute(attrName);
                System.out.println("   - " + attrName + " = " + (attrValue != null ? attrValue.getClass().getSimpleName() + ":" + attrValue : "null"));
                hasAttributes = true;
            }
            if (!hasAttributes) {
                System.out.println("   ❌ No request attributes found!");
            }
            
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/auth/login?redirect=" + 
                                     httpRequest.getRequestURI());
            return;
        }
        
        System.out.println("✅ User found in RoleFilter: " + user.getEmail() + " with role: " + user.getRoleId());
        
        // Check role-based access
        if (path.startsWith("/admin/")) {
            if (user.getRoleId() != Enums.UserRole.ADMIN.getValue()) {
                System.out.println("❌ Access denied to admin area for role: " + user.getRoleId());
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/home?error=access_denied");
                return;
            } else {
                System.out.println("✅ Admin access granted for user: " + user.getEmail());
            }
        }
        
        if (path.startsWith("/vendor/")) {
            if (user.getRoleId() != Enums.UserRole.VENDOR.getValue() && 
                user.getRoleId() != Enums.UserRole.ADMIN.getValue()) {
                System.out.println("❌ Access denied to vendor area for role: " + user.getRoleId());
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/home?error=access_denied");
                return;
            }
        }
        
        if (path.startsWith("/user/")) {
            if (user.getRoleId() == Enums.UserRole.GUEST.getValue()) {
                System.out.println("❌ Access denied to user area for guest");
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/auth/login");
                return;
            }
        }

        System.out.println("✅ Access granted for user: " + user.getEmail() + " to path: " + path);
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        System.out.println("🗑️ RoleFilter destroyed at: 2025-10-21 14:38:00 UTC");
    }
}
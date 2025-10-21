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
 * RoleFilter - Enhanced Role-based Access Control
 * Updated: 2025-10-21 03:34:17 UTC by tuaanshuuysv
 * Added: Admin and Vendor role filtering
 */
@WebFilter(urlPatterns = {"/user/*", "/vendor/*", "/admin/*"})
public class RoleFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("✅ RoleFilter initialized - Enhanced for Admin/Vendor");
        System.out.println("🕐 Init time: 2025-10-21 03:34:17 UTC");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Get authenticated user
        User user = (User) httpRequest.getAttribute(AppConstants.AUTH_USER_ATTR);
        
        if (user == null) {
            System.out.println("❌ RoleFilter: No authenticated user found");
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/auth/login?redirect=" + 
                                     httpRequest.getRequestURI());
            return;
        }

        String path = httpRequest.getRequestURI();
        String contextPath = httpRequest.getContextPath();
        
        // Remove context path
        if (path.startsWith(contextPath)) {
            path = path.substring(contextPath.length());
        }
        
        System.out.println("🔍 RoleFilter checking: " + path + " for user role: " + user.getRoleId());
        
        // Check role-based access
        if (path.startsWith("/admin/")) {
            if (user.getRoleId() != Enums.UserRole.ADMIN.getValue()) {
                System.out.println("❌ Access denied to admin area for role: " + user.getRoleId());
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/home?error=access_denied");
                return;
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
        System.out.println("🗑️ RoleFilter destroyed at: 2025-10-21 03:34:17 UTC");
    }
}
package vn.ute.uteshop.filters;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.ute.uteshop.model.User;
import vn.ute.uteshop.common.AppConstants;
import vn.ute.uteshop.common.Enums;

import java.io.IOException;

@WebFilter(urlPatterns = {"/user/*", "/vendor/*", "/admin/*"})
public class RoleFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        // Get authenticated user
        User user = (User) httpRequest.getAttribute(AppConstants.AUTH_USER_ATTR);
        
        if (user == null) {
            // Redirect to login if not authenticated
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
        
        // Check role-based access
        if (path.startsWith("/admin/") && user.getRoleId() != Enums.UserRole.ADMIN.getValue()) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/WEB-INF/views/error/access-denied.jsp");
            return;
        }
        
        if (path.startsWith("/vendor/") && 
            user.getRoleId() != Enums.UserRole.VENDOR.getValue() && 
            user.getRoleId() != Enums.UserRole.ADMIN.getValue()) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/WEB-INF/views/error/access-denied.jsp");
            return;
        }
        
        if (path.startsWith("/user/") && 
            user.getRoleId() == Enums.UserRole.GUEST.getValue()) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/auth/login");
            return;
        }

        System.out.println("✅ Access granted for user: " + user.getEmail() + " to path: " + path);
        chain.doFilter(request, response);
    }
}
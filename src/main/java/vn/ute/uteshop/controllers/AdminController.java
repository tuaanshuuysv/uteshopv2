package vn.ute.uteshop.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.ute.uteshop.model.User;
import vn.ute.uteshop.common.AppConstants;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * AdminController - Fixed Admin Dashboard Controller for UTESHOP-CPL
 * Updated: 2025-10-21 14:28:00 UTC by tuaanshuuysv
 * Fixed: URL mapping và debugging issue
 */
@WebServlet(urlPatterns = {"/admin", "/admin/", "/admin/home", "/admin/dashboard"})
public class AdminController extends HttpServlet {

    @Override
    public void init() throws ServletException {
        System.out.println("✅ AdminController initialized successfully");
        System.out.println("🕐 Fixed: 2025-10-21 14:28:00 UTC");
        System.out.println("👨‍💻 Fixed by: tuaanshuuysv");
        System.out.println("👑 Fixed URL mappings: /admin, /admin/, /admin/home, /admin/dashboard");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getRequestURI();
        String contextPath = request.getContextPath();
        
        // Remove context path from URI
        if (path.startsWith(contextPath)) {
            path = path.substring(contextPath.length());
        }
        
        System.out.println("🔄 Admin GET request to: " + path);
        System.out.println("🔍 Full URI: " + request.getRequestURI());
        System.out.println("🔍 Context path: " + contextPath);
        
        try {
            // Check if user is authenticated and has admin role
            User authUser = (User) request.getAttribute(AppConstants.AUTH_USER_ATTR);
            
            if (authUser == null) {
                System.out.println("❌ No authenticated user found for admin access");
                response.sendRedirect(request.getContextPath() + "/auth/login?redirect=" + 
                                     request.getRequestURI());
                return;
            }
            
            System.out.println("👤 User found: " + authUser.getEmail() + " (Role: " + authUser.getRoleId() + ")");
            
            // Check admin role (4)
            if (authUser.getRoleId() != 4) {
                System.out.println("❌ Access denied to admin area. User role: " + authUser.getRoleId());
                response.sendRedirect(request.getContextPath() + "/home?error=access_denied");
                return;
            }
            
            System.out.println("✅ Admin access granted for: " + authUser.getEmail());
            
            // Set common attributes
            request.setAttribute("authUser", authUser);
            request.setAttribute("isLoggedIn", true);
            request.setAttribute("userRoleId", authUser.getRoleId());
            request.setAttribute("userRoleDisplay", "Admin");
            request.setAttribute("currentDateTime", LocalDateTime.now());
            request.setAttribute("serverTime", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
            request.setAttribute("pageTitle", "Admin Dashboard - UTESHOP-CPL");
            
            // Set admin-specific data (mock data for UI)
            setAdminDashboardData(request);
            
            // Set view for decorator pattern
            request.setAttribute("view", "/WEB-INF/views/admin/home.jsp");
            
            System.out.println("📄 Forwarding to main decorator with admin home view");
            
            // Forward to main decorator
            request.getRequestDispatcher("/WEB-INF/decorators/main.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("❌ Error in AdminController: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Có lỗi xảy ra khi tải dashboard admin: " + e.getMessage());
            request.setAttribute("pageTitle", "Lỗi - Admin Dashboard");
            request.setAttribute("view", "/WEB-INF/views/admin/home.jsp");
            request.getRequestDispatcher("/WEB-INF/decorators/main.jsp").forward(request, response);
        }
    }

    /**
     * Set admin dashboard data (mock data for UI demonstration)
     */
    private void setAdminDashboardData(HttpServletRequest request) {
        System.out.println("📊 Setting admin dashboard data...");
        
        // System overview
        request.setAttribute("totalUsers", "15,234");
        request.setAttribute("totalShops", "1,456");
        request.setAttribute("totalProducts", "89,567");
        request.setAttribute("monthlyRevenue", "2.8B₫");
        
        // Trends
        request.setAttribute("usersTrend", "+12%");
        request.setAttribute("shopsTrend", "+8%");
        request.setAttribute("productsTrend", "+23%");
        request.setAttribute("revenueTrend", "+15%");
        
        // Pending tasks
        request.setAttribute("pendingShops", "12");
        request.setAttribute("reportedProducts", "45");
        request.setAttribute("supportTickets", "23");
        request.setAttribute("pendingReports", "67");
        
        // System metrics
        request.setAttribute("cpuUsage", "35");
        request.setAttribute("memoryUsage", "68");
        request.setAttribute("storageUsage", "42");
        request.setAttribute("networkUsage", "23");
        
        // System status
        request.setAttribute("systemStatus", "online");
        request.setAttribute("databaseStatus", "online");
        request.setAttribute("apiStatus", "online");
        
        System.out.println("✅ Admin dashboard data set successfully");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getRequestURI();
        System.out.println("🔄 Admin POST request to: " + path);
        
        // Handle admin actions here (to be implemented)
        response.sendRedirect(request.getContextPath() + "/admin");
    }

    @Override
    public void destroy() {
        System.out.println("🗑️ AdminController destroyed at: 2025-10-21 14:28:00 UTC");
        super.destroy();
    }
}
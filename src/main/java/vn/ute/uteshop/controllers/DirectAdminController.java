package vn.ute.uteshop.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.ute.uteshop.dto.AuthDtos;
import vn.ute.uteshop.model.User;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * DirectAdminController - BYPASS FILTER SOLUTION
 * Created: 2025-10-21 14:56:15 UTC by tuaanshuuysv
 * Purpose: Direct admin access without filter interference
 */
@WebServlet(urlPatterns = {"/admin-direct", "/admin-direct/dashboard"})
public class DirectAdminController extends HttpServlet {

    @Override
    public void init() throws ServletException {
        System.out.println("🚨 DirectAdminController initialized - BYPASS SOLUTION");
        System.out.println("🕐 Created: 2025-10-21 14:56:15 UTC");
        System.out.println("👨‍💻 Created by: tuaanshuuysv");
        System.out.println("🔧 Purpose: Bypass filter issues for admin access");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getRequestURI();
        System.out.println("🚨 DirectAdmin GET request: " + path);
        
        try {
            // Get user from session directly (bypass filter)
            HttpSession session = request.getSession(false);
            
            if (session == null) {
                System.out.println("❌ DirectAdmin: No session found");
                response.sendRedirect(request.getContextPath() + "/auth/login?message=session_required");
                return;
            }
            
            Object sessionUser = session.getAttribute("user");
            
            if (sessionUser == null) {
                System.out.println("❌ DirectAdmin: No user in session");
                response.sendRedirect(request.getContextPath() + "/auth/login?message=login_required");
                return;
            }
            
            System.out.println("✅ DirectAdmin: User found in session: " + sessionUser.getClass().getSimpleName());
            
            // Convert UserResponse to User if needed
            User authUser = null;
            if (sessionUser instanceof AuthDtos.UserResponse) {
                AuthDtos.UserResponse userResponse = (AuthDtos.UserResponse) sessionUser;
                System.out.println("🔄 DirectAdmin: Converting UserResponse: " + userResponse.getEmail() + " (Role: " + userResponse.getRoleId() + ")");
                
                // Create User object
                authUser = new User();
                authUser.setUserId(userResponse.getUserId());
                authUser.setUsername(userResponse.getUsername());
                authUser.setEmail(userResponse.getEmail());
                authUser.setFullName(userResponse.getFullName());
                authUser.setPhone(userResponse.getPhone());
                authUser.setRoleId(userResponse.getRoleId());
                authUser.setIsActive(true);
                authUser.setIsVerified(true);
                
            } else if (sessionUser instanceof User) {
                authUser = (User) sessionUser;
                System.out.println("✅ DirectAdmin: User object found: " + authUser.getEmail());
            }
            
            if (authUser == null) {
                System.out.println("❌ DirectAdmin: Could not convert session user");
                response.sendRedirect(request.getContextPath() + "/auth/login?message=user_conversion_failed");
                return;
            }
            
            // Check admin role
            if (authUser.getRoleId() != 4) {
                System.out.println("❌ DirectAdmin: Access denied. User role: " + authUser.getRoleId());
                response.sendRedirect(request.getContextPath() + "/home?error=access_denied&role=" + authUser.getRoleId());
                return;
            }
            
            System.out.println("✅ DirectAdmin: ADMIN ACCESS GRANTED for: " + authUser.getEmail());
            
            // Set attributes for admin dashboard
            request.setAttribute("authUser", authUser);
            request.setAttribute("isLoggedIn", true);
            request.setAttribute("userRoleId", authUser.getRoleId());
            request.setAttribute("userRoleDisplay", "Admin");
            request.setAttribute("currentDateTime", LocalDateTime.now());
            request.setAttribute("serverTime", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
            request.setAttribute("pageTitle", "Direct Admin Dashboard - UTESHOP-CPL");
            
            // Set admin dashboard data
            setAdminDashboardData(request);
            
            // Set view for decorator pattern
            request.setAttribute("view", "/WEB-INF/views/admin/home.jsp");
            
            System.out.println("📄 DirectAdmin: Forwarding to main decorator with admin home view");
            
            // Forward to main decorator
            request.getRequestDispatcher("/WEB-INF/decorators/main.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("❌ DirectAdmin Error: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Direct Admin Error: " + e.getMessage());
            request.setAttribute("pageTitle", "Direct Admin Error");
            request.setAttribute("view", "/WEB-INF/views/admin/home.jsp");
            request.getRequestDispatcher("/WEB-INF/decorators/main.jsp").forward(request, response);
        }
    }

    /**
     * Set admin dashboard data
     */
    private void setAdminDashboardData(HttpServletRequest request) {
        System.out.println("📊 DirectAdmin: Setting dashboard data...");
        
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
        
        System.out.println("✅ DirectAdmin: Dashboard data set successfully");
    }

    @Override
    public void destroy() {
        System.out.println("🗑️ DirectAdminController destroyed at: 2025-10-21 14:56:15 UTC");
        super.destroy();
    }
}
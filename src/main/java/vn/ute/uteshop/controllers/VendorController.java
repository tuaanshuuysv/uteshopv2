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
 * VendorController - Vendor Dashboard Controller for UTESHOP-CPL
 * Created: 2025-10-21 03:29:03 UTC by tuaanshuuysv
 * Features: Shop management, Product management, Order management, Promotions, Revenue analytics
 */
@WebServlet(urlPatterns = {"/vendor", "/vendor/home", "/vendor/dashboard"})
public class VendorController extends HttpServlet {

    @Override
    public void init() throws ServletException {
        System.out.println("✅ VendorController initialized successfully");
        System.out.println("🕐 Init time: 2025-10-21 03:29:03 UTC");
        System.out.println("👨‍💻 Created by: tuaanshuuysv");
        System.out.println("🏪 Vendor features: Shop, Products, Orders, Promotions, Analytics");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getRequestURI();
        System.out.println("🔄 Vendor GET request to: " + path);
        
        try {
            // Check if user is authenticated and has vendor role
            User authUser = (User) request.getAttribute(AppConstants.AUTH_USER_ATTR);
            
            if (authUser == null) {
                System.out.println("❌ No authenticated user found");
                response.sendRedirect(request.getContextPath() + "/auth/login");
                return;
            }
            
            // Check vendor role (3) or admin role (4)
            if (authUser.getRoleId() != 3 && authUser.getRoleId() != 4) {
                System.out.println("❌ Access denied. User role: " + authUser.getRoleId());
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }
            
            System.out.println("✅ Vendor access granted for: " + authUser.getEmail());
            
            // Set common attributes
            request.setAttribute("authUser", authUser);
            request.setAttribute("isLoggedIn", true);
            request.setAttribute("userRoleId", authUser.getRoleId());
            request.setAttribute("userRoleDisplay", authUser.getRoleId() == 4 ? "Admin" : "Vendor");
            request.setAttribute("currentDateTime", LocalDateTime.now());
            request.setAttribute("serverTime", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
            request.setAttribute("pageTitle", "Vendor Dashboard - UTESHOP-CPL");
            
            // Set vendor-specific data (mock data for UI)
            setVendorDashboardData(request);
            
            // Set view for decorator pattern
            request.setAttribute("view", "/WEB-INF/views/vendor/home.jsp");
            
            // Forward to main decorator
            request.getRequestDispatcher("/WEB-INF/decorators/main.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("❌ Error in VendorController: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Có lỗi xảy ra khi tải dashboard vendor");
            request.setAttribute("pageTitle", "Lỗi - Vendor Dashboard");
            request.setAttribute("view", "/WEB-INF/views/vendor/home.jsp");
            request.getRequestDispatcher("/WEB-INF/decorators/main.jsp").forward(request, response);
        }
    }

    /**
     * Set vendor dashboard data (mock data for UI demonstration)
     */
    private void setVendorDashboardData(HttpServletRequest request) {
        // Shop info
        request.setAttribute("shopName", "TechStore VN");
        request.setAttribute("shopRating", "4.8");
        request.setAttribute("shopVerified", true);
        request.setAttribute("shopJoinDate", "15/03/2024");
        
        // Stats
        request.setAttribute("monthlyRevenue", "125,500,000");
        request.setAttribute("monthlyOrders", "342");
        request.setAttribute("activeProducts", "156");
        request.setAttribute("avgRating", "4.8");
        
        // Trends
        request.setAttribute("revenueTrend", "+15.2%");
        request.setAttribute("ordersTrend", "+8.7%");
        request.setAttribute("productsTrend", "0%");
        request.setAttribute("ratingTrend", "+0.2");
        
        // Quick stats
        request.setAttribute("pendingOrders", "12");
        request.setAttribute("confirmedOrders", "23");
        request.setAttribute("shippingOrders", "45");
        request.setAttribute("totalViews", "12,345");
        request.setAttribute("totalFollowers", "567");
        request.setAttribute("conversionRate", "2.8%");
        
        System.out.println("📊 Vendor dashboard data set for: " + request.getAttribute("shopName"));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getRequestURI();
        System.out.println("🔄 Vendor POST request to: " + path);
        
        // Handle vendor actions here (to be implemented)
        response.sendRedirect(request.getContextPath() + "/vendor");
    }

    @Override
    public void destroy() {
        System.out.println("🗑️ VendorController destroyed at: 2025-10-21 03:29:03 UTC");
        super.destroy();
    }
}
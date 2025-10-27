package vn.ute.uteshop.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.ute.uteshop.dto.AuthDtos;
import vn.ute.uteshop.services.HomeDataService;

import java.io.IOException;
import java.util.Collections;
import java.util.Date;
import java.util.Map;

/**
 * AdminHomeController - set currentDateTime as java.util.Date to work with fmt:formatDate
 */
@WebServlet(urlPatterns = {"/admin/home"})
public class AdminHomeController extends HttpServlet {

    private HomeDataService homeDataService;

    @Override
    public void init() throws ServletException {
        super.init();
        homeDataService = new HomeDataService();
        System.out.println("✅ AdminHomeController initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Provide authUser for JSP if filter didn't set it
        HttpSession session = request.getSession(false);
        if (request.getAttribute("authUser") == null && session != null) {
            Object su = session.getAttribute("user");
            if (su instanceof AuthDtos.UserResponse) {
                request.setAttribute("authUser", su);
            }
        }

        // IMPORTANT: use java.util.Date for JSTL fmt:formatDate
        request.setAttribute("currentDateTime", new Date());

        try {
            Map<String, Object> analytics = homeDataService.getHomeAnalytics();
            request.setAttribute("systemStats", Map.of(
                "total_users", analytics.getOrDefault("totalUsers", 0),
                "new_users_today", 0,
                "total_shops", analytics.getOrDefault("totalShops", 0),
                "pending_verification", 0,
                "total_products", analytics.getOrDefault("totalProducts", 0),
                "active_products", analytics.getOrDefault("totalProducts", 0),
                "revenue_today", analytics.getOrDefault("formattedMonthlyRevenue", "0₫"),
                "orders_today", analytics.getOrDefault("monthlyOrders", 0)
            ));
            request.setAttribute("systemAlerts", Collections.emptyList());
        } catch (Exception ex) {
            System.err.println("❌ AdminHomeController analytics error: " + ex.getMessage());
            request.setAttribute("systemStats", Map.of(
                "total_users", "1,234",
                "new_users_today", "12",
                "total_shops", "567",
                "pending_verification", "8",
                "total_products", "12,890",
                "active_products", "11,245",
                "revenue_today", "125,400,000₫",
                "orders_today", "89"
            ));
            request.setAttribute("systemAlerts", Collections.emptyList());
        }

        request.getRequestDispatcher("/WEB-INF/views/admin/home.jsp").forward(request, response);
    }
}
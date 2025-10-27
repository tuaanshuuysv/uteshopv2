package vn.ute.uteshop.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import vn.ute.uteshop.dto.AuthDtos;
import vn.ute.uteshop.model.User;
import vn.ute.uteshop.dao.UserDao;
import vn.ute.uteshop.dao.impl.UserDaoImpl;
import vn.ute.uteshop.services.HomeDataService;

import java.io.IOException;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * VendorHomeController - set currentDateTime as java.util.Date to work with fmt:formatDate
 */
@WebServlet(urlPatterns = {"/vendor/home"})
public class VendorHomeController extends HttpServlet {

    private HomeDataService homeDataService;
    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        super.init();
        homeDataService = new HomeDataService();
        userDao = new UserDaoImpl();
        System.out.println("✅ VendorHomeController initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Provide current time as java.util.Date for JSP
        request.setAttribute("currentDateTime", new Date());

        // Provide authUser for JSP if filter didn't set it
        ensureAuthUser(request);

        Map<String, Object> vendorShop = null;
        Map<String, Object> vendorStats = Collections.emptyMap();
        List<Map<String, Object>> vendorRecentOrders = Collections.emptyList();
        List<Map<String, Object>> lowStockProducts = Collections.emptyList();

        try {
            AuthDtos.UserResponse u = getSessionUser(request);
            if (u != null) {
                vendorShop = homeDataService.getVendorShopByUser(u.getUserId());
                request.setAttribute("vendorShop", vendorShop);

                if (vendorShop != null) {
                    int shopId = (int) vendorShop.getOrDefault("shop_id", vendorShop.getOrDefault("shopId", 0));
                    vendorStats = homeDataService.getVendorStats(shopId);
                    vendorRecentOrders = homeDataService.getVendorRecentOrders(shopId, 10);
                    lowStockProducts = homeDataService.getLowStockProducts(shopId, 10);
                }
            }
        } catch (Exception ex) {
            System.err.println("⚠️ VendorHomeController data error: " + ex.getMessage());
        }

        request.setAttribute("vendorStats", vendorStats);
        request.setAttribute("vendorRecentOrders", vendorRecentOrders);
        request.setAttribute("lowStockProducts", lowStockProducts);

        request.getRequestDispatcher("/WEB-INF/views/vendor/home.jsp").forward(request, response);
    }

    private void ensureAuthUser(HttpServletRequest request) {
        if (request.getAttribute("authUser") != null) return;
        HttpSession session = request.getSession(false);
        if (session != null) {
            Object su = session.getAttribute("user");
            if (su != null) {
                request.setAttribute("authUser", su);
            }
        }
    }

    private AuthDtos.UserResponse getSessionUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        Object su = session.getAttribute("user");
        if (su instanceof AuthDtos.UserResponse) {
            return (AuthDtos.UserResponse) su;
        } else if (su instanceof User) {
            // Nếu session đang lưu model.User (ít khả năng), bạn có thể map sang UserResponse nếu cần
            User user = (User) su;
            AuthDtos.UserResponse u = new AuthDtos.UserResponse();
            u.setUserId(user.getUserId());
            u.setUsername(user.getUsername());
            u.setFullName(user.getFullName());
            u.setEmail(user.getEmail());
            u.setRoleId(user.getRoleId());
            return u;
        }
        return null;
    }
}
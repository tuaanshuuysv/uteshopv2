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
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * HomeController - Role-aware and JSTL friendly (java.util.Date)
 */
@WebServlet(urlPatterns = {"/", "/home", "/dashboard"})
public class HomeController extends HttpServlet {

    private UserDao userDao;
    private HomeDataService homeDataService;

    @Override
    public void init() throws ServletException {
        try {
            userDao = new UserDaoImpl();
            homeDataService = new HomeDataService();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getRequestURI();

        if (uri.endsWith("/dashboard")) {
            handleDashboardRedirect(request, response);
            return;
        }

        if (uri.endsWith("/") || uri.endsWith("/home")) {
            User authUser = getAuthenticatedUser(request);
            if (authUser != null) {
                int roleId = authUser.getRoleId();
                if (roleId == 4) { // Admin
                    response.sendRedirect(request.getContextPath() + "/admin/home");
                    return;
                } else if (roleId == 3) { // Vendor
                    response.sendRedirect(request.getContextPath() + "/vendor/home");
                    return;
                }
            }
        }

        try {
            User authUser = getAuthenticatedUser(request);
            setCommonAttributes(request, authUser);

            List<Map<String, Object>> categories = homeDataService.getFeaturedCategories();
            List<Map<String, Object>> products = homeDataService.getFeaturedProducts();
            List<Map<String, Object>> shops = homeDataService.getFeaturedShops();

            request.setAttribute("categories", categories);
            request.setAttribute("products", products);
            request.setAttribute("shops", shops);

            if (authUser != null) {
                Map<String, Object> userStats = homeDataService.getUserStats(authUser.getUserId());
                request.setAttribute("userStats", userStats);

                List<Map<String, Object>> recentlyViewed =
                        homeDataService.getRecentlyViewedProducts(authUser.getUserId());
                request.setAttribute("recentlyViewedProducts", recentlyViewed);
            }

            request.setAttribute("trendingKeywords", homeDataService.getTrendingKeywords());

            request.setAttribute("hasCategories", !categories.isEmpty());
            request.setAttribute("hasProducts", !products.isEmpty());
            request.setAttribute("hasShops", !shops.isEmpty());
            request.setAttribute("categoriesCount", categories.size());
            request.setAttribute("productsCount", products.size());
            request.setAttribute("shopsCount", shops.size());

            request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            setFallbackData(request);
            request.getRequestDispatcher("/WEB-INF/views/index.jsp").forward(request, response);
        }
    }

    private void handleDashboardRedirect(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User authUser = getAuthenticatedUser(request);
        if (authUser == null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("redirectAfterLogin", request.getContextPath() + "/dashboard");
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        int roleId = authUser.getRoleId();
        switch (roleId) {
            case 4 -> response.sendRedirect(request.getContextPath() + "/admin/home");
            case 3 -> response.sendRedirect(request.getContextPath() + "/vendor/home");
            default -> response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    private User getAuthenticatedUser(HttpServletRequest request) {
        try {
            Object reqUser = request.getAttribute("authUser");
            if (reqUser instanceof User) return (User) reqUser;

            HttpSession session = request.getSession(false);
            if (session == null) return null;

            Object sessionUser = session.getAttribute("user");
            if (sessionUser instanceof AuthDtos.UserResponse) {
                AuthDtos.UserResponse u = (AuthDtos.UserResponse) sessionUser;
                return userDao.findById(u.getUserId());
            }
            if (sessionUser instanceof User) {
                return (User) sessionUser;
            }
            return null;
        } catch (Exception e) {
            return null;
        }
    }

    private void setCommonAttributes(HttpServletRequest request, User user) {
        request.setAttribute("authUser", user);
        request.setAttribute("isLoggedIn", user != null);
        int roleId = (user != null) ? user.getRoleId() : 0;
        request.setAttribute("userRoleId", roleId);
        request.setAttribute("userRoleDisplay", getRoleDisplay(roleId));
        // Use java.util.Date for JSP fmt tags
        request.setAttribute("currentDateTime", new Date());
    }

    private String getRoleDisplay(int roleId) {
        return switch (roleId) {
            case 4 -> "Admin";
            case 3 -> "Vendor";
            case 2 -> "Customer";
            default -> "Guest";
        };
    }

    private void setFallbackData(HttpServletRequest request) {
        request.setAttribute("categories", List.of());
        request.setAttribute("products", List.of());
        request.setAttribute("shops", List.of());
        request.setAttribute("hasCategories", false);
        request.setAttribute("hasProducts", false);
        request.setAttribute("hasShops", false);
        request.setAttribute("categoriesCount", 0);
        request.setAttribute("productsCount", 0);
        request.setAttribute("shopsCount", 0);
        request.setAttribute("currentDateTime", new Date());
    }
}
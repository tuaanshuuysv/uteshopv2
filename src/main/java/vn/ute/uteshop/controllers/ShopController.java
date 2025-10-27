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
import vn.ute.uteshop.services.ShopService;
import vn.ute.uteshop.services.ShopService.ShopPageParams;
import vn.ute.uteshop.services.ShopService.ShopPageResult;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;

/**
 * ShopController - Display Shop Products by Shop ID
 * Created: 2025-10-26 19:23:03 UTC by tuaanshuuysv
 * URL Pattern: /shops/{shopId}
 * Features: Shop info, products pagination, filtering, sorting
 */
@WebServlet(urlPatterns = {"/shops/*"})
public class ShopController extends HttpServlet {

    private UserDao userDao;
    private ShopService shopService;

    @Override
    public void init() throws ServletException {
        try {
            userDao = new UserDaoImpl();
            shopService = new ShopService();
            System.out.println("✅ ShopController initialized successfully");
            System.out.println("🕐 Created: 2025-10-26 19:23:03 UTC by tuaanshuuysv");
            System.out.println("🏪 URL Pattern: /shops/{shopId}");
            System.out.println("🛍️ Features: Shop products display with pagination");
        } catch (Exception e) {
            System.err.println("❌ Error initializing ShopController: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pathInfo = request.getPathInfo();
        System.out.println("🔄 ShopController GET: " + pathInfo + " at " + LocalDateTime.now());
        
        try {
            // Extract shop ID from URL
            Integer shopId = extractShopIdFromPath(pathInfo);
            if (shopId == null) {
                System.out.println("❌ Invalid shop ID in URL: " + pathInfo);
                response.sendRedirect(request.getContextPath() + "/home?error=invalid_shop");
                return;
            }

            System.out.println("🏪 Loading shop page for Shop ID: " + shopId);
            
            User authUser = getAuthenticatedUser(request);
            setCommonAttributes(request, authUser);
            
            // Create shop page parameters
            ShopPageParams params = new ShopPageParams();
            params.setShopId(shopId);
            params.setPage(getIntParameter(request, "page", 1));
            params.setPageSize(getIntParameter(request, "pageSize", 12));
            params.setCategory(request.getParameter("category"));
            params.setSortBy(request.getParameter("sort"));
            params.setMinPrice(getDoubleParameter(request, "minPrice", 0));
            params.setMaxPrice(getDoubleParameter(request, "maxPrice", 0));
            params.setSearchQuery(request.getParameter("q"));
            
            System.out.println("📋 Shop page params: " + params);
            
            // Get shop page data
            ShopPageResult result = shopService.getShopPageData(params);
            
            if (result.getShop() == null) {
                System.out.println("❌ Shop not found: " + shopId);
                response.sendRedirect(request.getContextPath() + "/home?error=shop_not_found");
                return;
            }
            
            // Set attributes for JSP
            request.setAttribute("shop", result.getShop());
            request.setAttribute("products", result.getProducts());
            request.setAttribute("categories", result.getCategories());
            request.setAttribute("totalProducts", result.getTotalProducts());
            request.setAttribute("totalPages", result.getTotalPages());
            request.setAttribute("currentPage", result.getCurrentPage());
            request.setAttribute("shopStats", result.getShopStats());
            
            // Set search/filter parameters for form persistence
            request.setAttribute("searchQuery", params.getSearchQuery());
            request.setAttribute("selectedCategory", params.getCategory());
            request.setAttribute("sortBy", params.getSortBy());
            request.setAttribute("minPrice", params.getMinPrice());
            request.setAttribute("maxPrice", params.getMaxPrice());
            request.setAttribute("pageSize", params.getPageSize());
            
            // Pagination info
            setPaginationInfo(request, params.getPage(), result.getTotalPages(), params.getPageSize());
            
            // Page metadata
            String shopName = result.getShop().get("shop_name").toString();
            request.setAttribute("pageTitle", shopName + " - Cửa hàng trên UTESHOP");
            request.setAttribute("pageDescription", "Khám phá các sản phẩm chất lượng từ " + shopName);
            request.setAttribute("currentShopId", shopId);
            
            System.out.println("✅ Shop page loaded: " + shopName + " with " + result.getProducts().size() + " products");
            
            // Forward to shop page JSP
            request.getRequestDispatcher("/WEB-INF/views/shop/shop-page.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("❌ Error in ShopController: " + e.getMessage());
            e.printStackTrace();
            
            // Set error attributes
            request.setAttribute("error", "Có lỗi xảy ra khi tải trang shop: " + e.getMessage());
            request.setAttribute("pageTitle", "Lỗi - UTESHOP");
            
            request.getRequestDispatcher("/WEB-INF/views/error/shop-error.jsp").forward(request, response);
        }
    }

    /**
     * Extract shop ID from URL path like /shops/123
     */
    private Integer extractShopIdFromPath(String pathInfo) {
        if (pathInfo == null || pathInfo.equals("/")) {
            return null;
        }
        
        try {
            // Remove leading slash and parse
            String[] parts = pathInfo.substring(1).split("/");
            if (parts.length > 0 && !parts[0].isEmpty()) {
                int shopId = Integer.parseInt(parts[0]);
                System.out.println("🔍 Extracted Shop ID: " + shopId + " from path: " + pathInfo);
                return shopId;
            }
        } catch (NumberFormatException e) {
            System.err.println("❌ Invalid shop ID format in path: " + pathInfo);
        }
        
        return null;
    }

    /**
     * Set pagination info for JSP
     */
    private void setPaginationInfo(HttpServletRequest request, int currentPage, int totalPages, int pageSize) {
        int startPage = Math.max(1, currentPage - 2);
        int endPage = Math.min(totalPages, currentPage + 2);
        
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        request.setAttribute("hasPrevious", currentPage > 1);
        request.setAttribute("hasNext", currentPage < totalPages);
        request.setAttribute("previousPage", Math.max(1, currentPage - 1));
        request.setAttribute("nextPage", Math.min(totalPages, currentPage + 1));
        
        // Page size options
        int[] pageSizeOptions = {12, 24, 36, 48};
        request.setAttribute("pageSizeOptions", pageSizeOptions);
        
        // URL parameters for pagination links
        StringBuilder baseUrl = new StringBuilder(request.getRequestURI());
        String queryString = request.getQueryString();
        if (queryString != null && !queryString.contains("page=")) {
            baseUrl.append("?").append(queryString);
        } else if (queryString != null) {
            // Remove existing page parameter
            String cleanQuery = queryString.replaceAll("&?page=\\d+", "");
            if (!cleanQuery.isEmpty()) {
                baseUrl.append("?").append(cleanQuery);
            }
        }
        request.setAttribute("paginationBaseUrl", baseUrl.toString());
    }

    /**
     * Get authenticated user from session
     */
    private User getAuthenticatedUser(HttpServletRequest request) {
        try {
            HttpSession session = request.getSession(false);
            if (session == null) return null;
            
            Object sessionUser = session.getAttribute("user");
            if (sessionUser instanceof AuthDtos.UserResponse) {
                AuthDtos.UserResponse userResponse = (AuthDtos.UserResponse) sessionUser;
                return userDao != null ? userDao.findById(userResponse.getUserId()) : null;
            }
            
            return sessionUser instanceof User ? (User) sessionUser : null;
        } catch (Exception e) {
            System.err.println("⚠️ Error getting authenticated user: " + e.getMessage());
            return null;
        }
    }

    /**
     * Set common attributes for JSP
     */
    private void setCommonAttributes(HttpServletRequest request, User user) {
        request.setAttribute("authUser", user);
        request.setAttribute("isLoggedIn", user != null);
        request.setAttribute("userRoleId", user != null ? user.getRoleId() : 0);
        request.setAttribute("userRoleDisplay", user != null ? getRoleDisplay(user.getRoleId()) : "Guest");
        request.setAttribute("currentDateTime", LocalDateTime.now());
    }

    /**
     * Get role display name
     */
    private String getRoleDisplay(int roleId) {
        return switch (roleId) {
            case 4 -> "Admin";
            case 3 -> "Vendor";
            case 2 -> "Customer";
            default -> "Guest";
        };
    }

    /**
     * Get integer parameter with default value
     */
    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        try {
            String paramValue = request.getParameter(paramName);
            return paramValue != null && !paramValue.trim().isEmpty() ? Integer.parseInt(paramValue) : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Get double parameter with default value
     */
    private double getDoubleParameter(HttpServletRequest request, String paramName, double defaultValue) {
        try {
            String paramValue = request.getParameter(paramName);
            return paramValue != null && !paramValue.trim().isEmpty() ? Double.parseDouble(paramValue) : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    @Override
    public void destroy() {
        System.out.println("🗑️ ShopController destroyed at: " + LocalDateTime.now());
        System.out.println("👨‍💻 Developed by: tuaanshuuysv - UTESHOP Shop Pages");
        super.destroy();
    }
}
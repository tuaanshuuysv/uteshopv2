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
import vn.ute.uteshop.services.AdminService;
import vn.ute.uteshop.config.DataSourceFactory;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.sql.*;
import java.util.*;

/**
 * AdminController - COMPLETE WITH REAL DATABASE INTEGRATION
 * Updated: 2025-10-26 16:57:23 UTC by tuaanshuuysv
 * Features: Complete admin management with real database data
 */
@WebServlet(urlPatterns = {
    "/admin", "/admin/", "/admin/dashboard", 
    "/admin/users", "/admin/shops", "/admin/products", 
    "/admin/admin-orders", "/admin/reports"
})
public class AdminController extends HttpServlet {

    private UserDao userDao;
    private AdminService adminService;

    @Override
    public void init() throws ServletException {
        try {
            userDao = new UserDaoImpl();
            adminService = new AdminService();
            System.out.println("✅ AdminController COMPLETE WITH REAL DATA initialized successfully");
            System.out.println("🕐 Updated: 2025-10-26 16:57:23 UTC");
            System.out.println("👨‍💻 Updated by: tuaanshuuysv");
            System.out.println("🔧 Features: Complete admin management with real database data");
        } catch (Exception e) {
            System.err.println("❌ Error initializing AdminController: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = getRequestPath(request);
        System.out.println("🔄 AdminController GET: " + path + " at " + LocalDateTime.now());
        
        try {
            User authUser = getAuthenticatedUser(request);
            if (authUser == null || authUser.getRoleId() != 4) {
                System.out.println("⛔ Access denied for admin path: " + path + " - User role: " + 
                                 (authUser != null ? authUser.getRoleId() : "null"));
                response.sendRedirect(request.getContextPath() + "/auth/login?error=access_denied");
                return;
            }
            
            setCommonAttributes(request, authUser);
            
            switch (path) {
                case "/admin":
                case "/admin/":
                case "/admin/dashboard":
                    handleDashboard(request, response, authUser);
                    break;
                case "/admin/users":
                    handleUsers(request, response, authUser);
                    break;
                case "/admin/shops":
                    handleShops(request, response, authUser);
                    break;
                case "/admin/products":
                    handleProducts(request, response, authUser);
                    break;
                case "/admin/admin-orders":
                    handleOrders(request, response, authUser);
                    break;
                case "/admin/reports":
                    handleReports(request, response, authUser);
                    break;
                default:
                    System.out.println("⚠️ Unknown admin path: " + path + " - redirecting to dashboard");
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error in AdminController: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.setAttribute("authUser", getAuthenticatedUser(request));
            request.setAttribute("currentDateTime", LocalDateTime.now());
            request.getRequestDispatcher("/WEB-INF/views/admin/home.jsp").forward(request, response);
        }
    }

    /**
     * Handle Admin Dashboard - WITH REAL DATA
     */
    private void handleDashboard(HttpServletRequest request, HttpServletResponse response, User authUser) 
            throws ServletException, IOException {
        
        System.out.println("📊 Loading REAL admin dashboard for: " + authUser.getEmail());
        
        try {
            // Load REAL system statistics from database
            Map<String, Object> systemStats = adminService.getSystemStats();
            request.setAttribute("systemStats", systemStats);
            
            // Load REAL recent activities from database
            List<Map<String, Object>> recentActivities = adminService.getRecentActivities(10);
            request.setAttribute("recentActivities", recentActivities);
            
            // Load REAL system alerts from database
            List<Map<String, Object>> systemAlerts = adminService.getSystemAlerts();
            request.setAttribute("systemAlerts", systemAlerts);
            
            System.out.println("✅ REAL admin dashboard data loaded successfully");
            System.out.println("📊 Stats: " + systemStats.size() + " metrics");
            System.out.println("📋 Activities: " + recentActivities.size() + " activities");
            System.out.println("⚠️ Alerts: " + systemAlerts.size() + " alerts");
            
        } catch (Exception e) {
            System.err.println("⚠️ Error loading REAL admin dashboard data: " + e.getMessage());
            e.printStackTrace();
            // Set fallback data
            request.setAttribute("systemStats", createFallbackSystemStats());
            request.setAttribute("recentActivities", createFallbackActivities());
            request.setAttribute("systemAlerts", new ArrayList<>());
            request.setAttribute("error", "Một số dữ liệu không thể tải từ database: " + e.getMessage());
        }
        
        request.setAttribute("pageTitle", "UTESHOP Admin - Dashboard");
        request.setAttribute("currentPage", "dashboard");
        
        request.getRequestDispatcher("/WEB-INF/views/admin/home.jsp").forward(request, response);
    }

    /**
     * Handle Users Management - WITH REAL DATA
     */
    private void handleUsers(HttpServletRequest request, HttpServletResponse response, User authUser) 
            throws ServletException, IOException {
        
        System.out.println("👥 Loading REAL users management for: " + authUser.getEmail());
        
        try {
            // Get filter parameters
            String search = request.getParameter("search");
            String roleFilter = request.getParameter("role");
            String statusFilter = request.getParameter("status");
            int page = getIntParameter(request, "page", 1);
            int pageSize = 20;
            
            // Load REAL users data from database
            List<Map<String, Object>> users = getRealUsers(search, roleFilter, statusFilter, page, pageSize);
            request.setAttribute("users", users);
            
            int totalUsers = getTotalUsers(search, roleFilter, statusFilter);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", (int) Math.ceil((double) totalUsers / pageSize));
            
            // Load REAL user statistics
            Map<String, Object> userStats = getRealUserStats();
            request.setAttribute("userStats", userStats);
            
            // Set filter attributes
            request.setAttribute("searchFilter", search);
            request.setAttribute("roleFilter", roleFilter);
            request.setAttribute("statusFilter", statusFilter);
            
            System.out.println("✅ REAL users data loaded: " + users.size() + " users");
            
        } catch (Exception e) {
            System.err.println("⚠️ Error loading REAL users data: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("users", createDummyUsers());
            request.setAttribute("userStats", createDummyUserStats());
            request.setAttribute("error", "Không thể tải dữ liệu người dùng từ database: " + e.getMessage());
        }
        
        request.setAttribute("pageTitle", "UTESHOP Admin - Quản lý người dùng");
        request.setAttribute("currentPage", "users");
        
        request.getRequestDispatcher("/WEB-INF/views/admin/users.jsp").forward(request, response);
    }

    /**
     * Handle Shops Management - WITH REAL DATA
     */
    private void handleShops(HttpServletRequest request, HttpServletResponse response, User authUser) 
            throws ServletException, IOException {
        
        System.out.println("🏪 Loading REAL shops management for: " + authUser.getEmail());
        
        try {
            // Get filter parameters
            String search = request.getParameter("search");
            String statusFilter = request.getParameter("status");
            int page = getIntParameter(request, "page", 1);
            
            // Load REAL shops data from database
            List<Map<String, Object>> shops = getRealShops(search, statusFilter, page, 20);
            request.setAttribute("shops", shops);
            
            // Load REAL pending verifications from database
            List<Map<String, Object>> pendingVerifications = adminService.getPendingVerifications(10);
            request.setAttribute("pendingVerifications", pendingVerifications);
            
            // Load REAL shop statistics
            Map<String, Object> shopStats = getRealShopStats();
            request.setAttribute("shopStats", shopStats);
            
            System.out.println("✅ REAL shops data loaded: " + shops.size() + " shops");
            System.out.println("⏳ Pending verifications: " + pendingVerifications.size() + " shops");
            
        } catch (Exception e) {
            System.err.println("⚠️ Error loading REAL shops data: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("shops", createDummyShops());
            request.setAttribute("pendingVerifications", createDummyPendingShops());
            request.setAttribute("shopStats", createDummyShopStats());
            request.setAttribute("error", "Không thể tải dữ liệu shop từ database: " + e.getMessage());
        }
        
        request.setAttribute("pageTitle", "UTESHOP Admin - Quản lý Shop");
        request.setAttribute("currentPage", "shops");
        
        request.getRequestDispatcher("/WEB-INF/views/admin/shops.jsp").forward(request, response);
    }

    /**
     * Handle Products Management - WITH REAL DATA
     */
    private void handleProducts(HttpServletRequest request, HttpServletResponse response, User authUser) 
            throws ServletException, IOException {
        
        System.out.println("📦 Loading REAL products management for: " + authUser.getEmail());
        
        try {
            // Get filter parameters
            String search = request.getParameter("search");
            String categoryFilter = request.getParameter("category");
            String statusFilter = request.getParameter("status");
            int page = getIntParameter(request, "page", 1);
            
            // Load REAL products data from database
            List<Map<String, Object>> products = getRealProducts(search, categoryFilter, statusFilter, page, 20);
            request.setAttribute("products", products);
            
            // Load REAL product statistics
            Map<String, Object> productStats = getRealProductStats();
            request.setAttribute("productStats", productStats);
            
            // Load categories for filter
            List<Map<String, Object>> categories = getRealCategories();
            request.setAttribute("categories", categories);
            
            System.out.println("✅ REAL products data loaded: " + products.size() + " products");
            
        } catch (Exception e) {
            System.err.println("⚠️ Error loading REAL products data: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("products", createDummyProducts());
            request.setAttribute("productStats", createDummyProductStats());
            request.setAttribute("categories", new ArrayList<>());
            request.setAttribute("error", "Không thể tải dữ liệu sản phẩm từ database: " + e.getMessage());
        }
        
        request.setAttribute("pageTitle", "UTESHOP Admin - Quản lý sản phẩm");
        request.setAttribute("currentPage", "products");
        
        request.getRequestDispatcher("/WEB-INF/views/admin/products.jsp").forward(request, response);
    }

    /**
     * Handle Orders Management - WITH REAL DATA
     */
    private void handleOrders(HttpServletRequest request, HttpServletResponse response, User authUser) 
            throws ServletException, IOException {
        
        System.out.println("🛒 Loading REAL admin orders management for: " + authUser.getEmail());
        
        try {
            // Get filter parameters
            String search = request.getParameter("search");
            String statusFilter = request.getParameter("status");
            String dateFrom = request.getParameter("date_from");
            String dateTo = request.getParameter("date_to");
            int page = getIntParameter(request, "page", 1);
            
            // Load REAL orders data from database
            List<Map<String, Object>> orders = getRealOrders(search, statusFilter, dateFrom, dateTo, page, 20);
            request.setAttribute("orders", orders);
            
            // Load REAL order statistics
            Map<String, Object> orderStats = getRealOrderStats();
            request.setAttribute("orderStats", orderStats);
            
            System.out.println("✅ REAL admin orders data loaded: " + orders.size() + " orders");
            
        } catch (Exception e) {
            System.err.println("⚠️ Error loading REAL admin orders data: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("orders", createDummyOrders());
            request.setAttribute("orderStats", createDummyOrderStats());
            request.setAttribute("error", "Không thể tải dữ liệu đơn hàng từ database: " + e.getMessage());
        }
        
        request.setAttribute("pageTitle", "UTESHOP Admin - Quản lý đơn hàng");
        request.setAttribute("currentPage", "admin-orders");
        
        request.getRequestDispatcher("/WEB-INF/views/admin/orders.jsp").forward(request, response);
    }

    /**
     * Handle Reports - WITH REAL DATA
     */
    private void handleReports(HttpServletRequest request, HttpServletResponse response, User authUser) 
            throws ServletException, IOException {
        
        System.out.println("📊 Loading REAL reports for: " + authUser.getEmail());
        
        try {
            // Load REAL revenue chart data from database
            List<Map<String, Object>> revenueChartData = adminService.getRevenueChartData(30);
            request.setAttribute("revenueChartData", revenueChartData);
            
            // Load REAL top products from database
            List<Map<String, Object>> topProducts = adminService.getTopSellingProducts(10);
            request.setAttribute("topProducts", topProducts);
            
            // Load REAL top shops from database
            List<Map<String, Object>> topShops = adminService.getTopShops(10);
            request.setAttribute("topShops", topShops);
            
            System.out.println("✅ REAL reports data loaded successfully");
            System.out.println("📈 Revenue data points: " + revenueChartData.size());
            System.out.println("🏆 Top products: " + topProducts.size());
            System.out.println("🏪 Top shops: " + topShops.size());
            
        } catch (Exception e) {
            System.err.println("⚠️ Error loading REAL reports data: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("revenueChartData", createDummyRevenueData());
            request.setAttribute("topProducts", createDummyTopProducts());
            request.setAttribute("topShops", createDummyTopShops());
            request.setAttribute("error", "Không thể tải dữ liệu báo cáo từ database: " + e.getMessage());
        }
        
        request.setAttribute("pageTitle", "UTESHOP Admin - Báo cáo");
        request.setAttribute("currentPage", "reports");
        
        request.getRequestDispatcher("/WEB-INF/views/admin/reports.jsp").forward(request, response);
    }

    // ============================================================================
    // REAL DATABASE QUERY METHODS
    // ============================================================================

    /**
     * Get real users from database
     */
    private List<Map<String, Object>> getRealUsers(String search, String roleFilter, String statusFilter, 
                                                   int page, int pageSize) throws SQLException {
        List<Map<String, Object>> users = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder("""
            SELECT u.user_id, u.username, u.email, u.full_name, u.phone, 
                   u.role_id, u.is_active, u.is_verified, u.created_at, u.last_login,
                   CASE 
                       WHEN u.role_id = 4 THEN 'Admin'
                       WHEN u.role_id = 3 THEN 'Vendor'
                       WHEN u.role_id = 2 THEN 'Customer'
                       ELSE 'Unknown'
                   END as role_name
            FROM users u
            WHERE 1=1
            """);
        
        List<Object> params = new ArrayList<>();
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (u.full_name LIKE ? OR u.email LIKE ? OR u.username LIKE ?)");
            String searchParam = "%" + search.trim() + "%";
            params.add(searchParam);
            params.add(searchParam);
            params.add(searchParam);
        }
        
        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append(" AND u.role_id = ?");
            params.add(Integer.parseInt(roleFilter));
        }
        
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND u.is_active = ?");
            params.add("active".equals(statusFilter) ? 1 : 0);
        }
        
        sql.append(" ORDER BY u.created_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> user = new HashMap<>();
                    user.put("user_id", rs.getInt("user_id"));
                    user.put("username", rs.getString("username"));
                    user.put("email", rs.getString("email"));
                    user.put("full_name", rs.getString("full_name"));
                    user.put("phone", rs.getString("phone"));
                    user.put("role_id", rs.getInt("role_id"));
                    user.put("role_name", rs.getString("role_name"));
                    user.put("is_active", rs.getBoolean("is_active"));
                    user.put("is_verified", rs.getBoolean("is_verified"));
                    user.put("created_at", rs.getTimestamp("created_at"));
                    user.put("last_login", rs.getTimestamp("last_login"));
                    users.add(user);
                }
            }
        }
        
        return users;
    }

    /**
     * Get total users count for pagination
     */
    private int getTotalUsers(String search, String roleFilter, String statusFilter) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users u WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (u.full_name LIKE ? OR u.email LIKE ? OR u.username LIKE ?)");
            String searchParam = "%" + search.trim() + "%";
            params.add(searchParam);
            params.add(searchParam);
            params.add(searchParam);
        }
        
        if (roleFilter != null && !roleFilter.isEmpty()) {
            sql.append(" AND u.role_id = ?");
            params.add(Integer.parseInt(roleFilter));
        }
        
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND u.is_active = ?");
            params.add("active".equals(statusFilter) ? 1 : 0);
        }
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        
        return 0;
    }

    /**
     * Get real user statistics
     */
    private Map<String, Object> getRealUserStats() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        String sql = """
            SELECT 
                COUNT(*) as total_users,
                SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) as active_users,
                SUM(CASE WHEN role_id = 4 THEN 1 ELSE 0 END) as admin_count,
                SUM(CASE WHEN role_id = 3 THEN 1 ELSE 0 END) as vendor_count,
                SUM(CASE WHEN role_id = 2 THEN 1 ELSE 0 END) as customer_count,
                SUM(CASE WHEN DATE(created_at) = CURDATE() THEN 1 ELSE 0 END) as new_today
            FROM users
            """;
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                stats.put("total_users", rs.getInt("total_users"));
                stats.put("active_users", rs.getInt("active_users"));
                stats.put("admin_count", rs.getInt("admin_count"));
                stats.put("vendor_count", rs.getInt("vendor_count"));
                stats.put("customer_count", rs.getInt("customer_count"));
                stats.put("new_today", rs.getInt("new_today"));
            }
        }
        
        return stats;
    }

    /**
     * Get real shops from database
     */
    private List<Map<String, Object>> getRealShops(String search, String statusFilter, int page, int pageSize) throws SQLException {
        List<Map<String, Object>> shops = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder("""
            SELECT s.shop_id, s.shop_name, s.shop_description, s.shop_address,
                   s.shop_phone, s.shop_email, s.is_verified, s.is_active, s.created_at,
                   u.full_name as owner_name, u.email as owner_email,
                   COUNT(DISTINCT p.product_id) as product_count,
                   COALESCE(AVG(pr.rating), 0) as total_rating,
                   COUNT(DISTINCT pr.review_id) as total_reviews
            FROM shops s
            JOIN users u ON s.owner_id = u.user_id
            LEFT JOIN products p ON s.shop_id = p.shop_id AND p.status = 'ACTIVE'
            LEFT JOIN product_reviews pr ON p.product_id = pr.product_id
            WHERE 1=1
            """);
        
        List<Object> params = new ArrayList<>();
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (s.shop_name LIKE ? OR u.full_name LIKE ? OR u.email LIKE ?)");
            String searchParam = "%" + search.trim() + "%";
            params.add(searchParam);
            params.add(searchParam);
            params.add(searchParam);
        }
        
        if (statusFilter != null && !statusFilter.isEmpty()) {
            if ("verified".equals(statusFilter)) {
                sql.append(" AND s.is_verified = 1");
            } else if ("pending".equals(statusFilter)) {
                sql.append(" AND s.is_verified = 0");
            } else if ("active".equals(statusFilter)) {
                sql.append(" AND s.is_active = 1");
            } else if ("inactive".equals(statusFilter)) {
                sql.append(" AND s.is_active = 0");
            }
        }
        
        sql.append("""
            GROUP BY s.shop_id, s.shop_name, s.shop_description, s.shop_address,
                     s.shop_phone, s.shop_email, s.is_verified, s.is_active, s.created_at,
                     u.full_name, u.email
            ORDER BY s.created_at DESC
            LIMIT ? OFFSET ?
            """);
        
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> shop = new HashMap<>();
                    shop.put("shop_id", rs.getInt("shop_id"));
                    shop.put("shop_name", rs.getString("shop_name"));
                    shop.put("shop_description", rs.getString("shop_description"));
                    shop.put("owner_name", rs.getString("owner_name"));
                    shop.put("owner_email", rs.getString("owner_email"));
                    shop.put("is_verified", rs.getBoolean("is_verified"));
                    shop.put("is_active", rs.getBoolean("is_active"));
                    shop.put("product_count", rs.getInt("product_count"));
                    shop.put("total_rating", Math.round(rs.getDouble("total_rating") * 10.0) / 10.0);
                    shop.put("total_reviews", rs.getInt("total_reviews"));
                    shop.put("created_at", rs.getTimestamp("created_at"));
                    shops.add(shop);
                }
            }
        }
        
        return shops;
    }

    /**
     * Get real shop statistics
     */
    private Map<String, Object> getRealShopStats() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        String sql = """
            SELECT 
                COUNT(*) as total_shops,
                SUM(CASE WHEN is_verified = 1 THEN 1 ELSE 0 END) as verified_shops,
                SUM(CASE WHEN is_verified = 0 THEN 1 ELSE 0 END) as pending_verification,
                SUM(CASE WHEN is_active = 1 THEN 1 ELSE 0 END) as active_shops,
                SUM(CASE WHEN DATE(created_at) = CURDATE() THEN 1 ELSE 0 END) as new_today
            FROM shops
            """;
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                stats.put("total_shops", rs.getInt("total_shops"));
                stats.put("verified_shops", rs.getInt("verified_shops"));
                stats.put("pending_verification", rs.getInt("pending_verification"));
                stats.put("active_shops", rs.getInt("active_shops"));
                stats.put("new_today", rs.getInt("new_today"));
            }
        }
        
        return stats;
    }

    /**
     * Get real products from database
     */
    private List<Map<String, Object>> getRealProducts(String search, String categoryFilter, String statusFilter, 
                                                      int page, int pageSize) throws SQLException {
        List<Map<String, Object>> products = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder("""
            SELECT p.product_id, p.product_name, p.price, p.sale_price, p.stock_quantity, 
                   p.status, p.brand, p.created_at,
                   s.shop_name, c.category_name,
                   COALESCE(pi.image_url, '/assets/images/products/default.jpg') as image_url,
                   COALESCE(SUM(od.quantity), 0) as total_sold
            FROM products p
            JOIN shops s ON p.shop_id = s.shop_id
            LEFT JOIN categories c ON p.category_id = c.category_id
            LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
            LEFT JOIN order_details od ON p.product_id = od.product_id
            WHERE 1=1
            """);
        
        List<Object> params = new ArrayList<>();
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (p.product_name LIKE ? OR p.brand LIKE ? OR s.shop_name LIKE ?)");
            String searchParam = "%" + search.trim() + "%";
            params.add(searchParam);
            params.add(searchParam);
            params.add(searchParam);
        }
        
        if (categoryFilter != null && !categoryFilter.isEmpty()) {
            sql.append(" AND p.category_id = ?");
            params.add(Integer.parseInt(categoryFilter));
        }
        
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND p.status = ?");
            params.add(statusFilter.toUpperCase());
        }
        
        sql.append("""
            GROUP BY p.product_id, p.product_name, p.price, p.sale_price, p.stock_quantity,
                     p.status, p.brand, p.created_at, s.shop_name, c.category_name, pi.image_url
            ORDER BY p.created_at DESC
            LIMIT ? OFFSET ?
            """);
        
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> product = new HashMap<>();
                    product.put("product_id", rs.getInt("product_id"));
                    product.put("product_name", rs.getString("product_name"));
                    product.put("price", rs.getDouble("price"));
                    product.put("formatted_price", formatCurrency(rs.getDouble("price")));
                    product.put("sale_price", rs.getDouble("sale_price"));
                    product.put("stock_quantity", rs.getInt("stock_quantity"));
                    product.put("status", rs.getString("status"));
                    product.put("brand", rs.getString("brand"));
                    product.put("shop_name", rs.getString("shop_name"));
                    product.put("category_name", rs.getString("category_name"));
                    product.put("image_url", rs.getString("image_url"));
                    product.put("total_sold", rs.getInt("total_sold"));
                    product.put("created_at", rs.getTimestamp("created_at"));
                    products.add(product);
                }
            }
        }
        
        return products;
    }

    /**
     * Get real product statistics
     */
    private Map<String, Object> getRealProductStats() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        String sql = """
            SELECT 
                COUNT(*) as total_products,
                SUM(CASE WHEN status = 'ACTIVE' THEN 1 ELSE 0 END) as active_products,
                SUM(CASE WHEN stock_quantity = 0 THEN 1 ELSE 0 END) as out_of_stock,
                SUM(CASE WHEN stock_quantity < 10 AND stock_quantity > 0 THEN 1 ELSE 0 END) as low_stock,
                SUM(CASE WHEN DATE(created_at) = CURDATE() THEN 1 ELSE 0 END) as new_today
            FROM products
            """;
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                stats.put("total_products", rs.getInt("total_products"));
                stats.put("active_products", rs.getInt("active_products"));
                stats.put("out_of_stock", rs.getInt("out_of_stock"));
                stats.put("low_stock", rs.getInt("low_stock"));
                stats.put("new_today", rs.getInt("new_today"));
            }
        }
        
        return stats;
    }

    /**
     * Get real categories
     */
    private List<Map<String, Object>> getRealCategories() throws SQLException {
        List<Map<String, Object>> categories = new ArrayList<>();
        
        String sql = """
            SELECT c.category_id, c.category_name, COUNT(p.product_id) as product_count
            FROM categories c
            LEFT JOIN products p ON c.category_id = p.category_id AND p.status = 'ACTIVE'
            WHERE c.is_active = 1
            GROUP BY c.category_id, c.category_name
            ORDER BY c.category_name
            """;
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> category = new HashMap<>();
                category.put("category_id", rs.getInt("category_id"));
                category.put("category_name", rs.getString("category_name"));
                category.put("product_count", rs.getInt("product_count"));
                categories.add(category);
            }
        }
        
        return categories;
    }

    /**
     * Get real orders from database
     */
    private List<Map<String, Object>> getRealOrders(String search, String statusFilter, String dateFrom, String dateTo, 
                                                    int page, int pageSize) throws SQLException {
        List<Map<String, Object>> orders = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder("""
            SELECT o.order_id, o.order_number, o.total_amount, o.order_status, 
                   o.payment_method, o.payment_status, o.created_at,
                   u.full_name as customer_name, u.email as customer_email,
                   s.shop_name,
                   COUNT(od.detail_id) as item_count
            FROM orders o
            JOIN users u ON o.user_id = u.user_id
            JOIN shops s ON o.shop_id = s.shop_id
            LEFT JOIN order_details od ON o.order_id = od.order_id
            WHERE 1=1
            """);
        
        List<Object> params = new ArrayList<>();
        
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (o.order_number LIKE ? OR u.full_name LIKE ? OR s.shop_name LIKE ?)");
            String searchParam = "%" + search.trim() + "%";
            params.add(searchParam);
            params.add(searchParam);
            params.add(searchParam);
        }
        
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" AND o.order_status = ?");
            params.add(statusFilter.toUpperCase());
        }
        
        if (dateFrom != null && !dateFrom.isEmpty()) {
            sql.append(" AND DATE(o.created_at) >= ?");
            params.add(dateFrom);
        }
        
        if (dateTo != null && !dateTo.isEmpty()) {
            sql.append(" AND DATE(o.created_at) <= ?");
            params.add(dateTo);
        }
        
        sql.append("""
            GROUP BY o.order_id, o.order_number, o.total_amount, o.order_status,
                     o.payment_method, o.payment_status, o.created_at,
                     u.full_name, u.email, s.shop_name
            ORDER BY o.created_at DESC
            LIMIT ? OFFSET ?
            """);
        
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> order = new HashMap<>();
                    order.put("order_id", rs.getInt("order_id"));
                    order.put("order_number", rs.getString("order_number"));
                    order.put("customer_name", rs.getString("customer_name"));
                    order.put("customer_email", rs.getString("customer_email"));
                    order.put("shop_name", rs.getString("shop_name"));
                    order.put("total_amount", rs.getDouble("total_amount"));
                    order.put("formatted_amount", formatCurrency(rs.getDouble("total_amount")));
                    order.put("order_status", rs.getString("order_status"));
                    order.put("payment_method", rs.getString("payment_method"));
                    order.put("payment_status", rs.getString("payment_status"));
                    order.put("item_count", rs.getInt("item_count"));
                    order.put("created_at", rs.getTimestamp("created_at"));
                    orders.add(order);
                }
            }
        }
        
        return orders;
    }

    /**
     * Get real order statistics
     */
    private Map<String, Object> getRealOrderStats() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        String sql = """
            SELECT 
                COUNT(*) as total_orders,
                SUM(CASE WHEN order_status IN ('NEW', 'CONFIRMED') THEN 1 ELSE 0 END) as pending_orders,
                SUM(CASE WHEN order_status = 'PROCESSING' THEN 1 ELSE 0 END) as processing_orders,
                SUM(CASE WHEN order_status = 'DELIVERED' THEN 1 ELSE 0 END) as completed_orders,
                SUM(CASE WHEN order_status = 'CANCELLED' THEN 1 ELSE 0 END) as cancelled_orders,
                COALESCE(SUM(total_amount), 0) as total_revenue,
                COALESCE(SUM(CASE WHEN DATE(created_at) = CURDATE() THEN total_amount ELSE 0 END), 0) as revenue_today,
                SUM(CASE WHEN DATE(created_at) = CURDATE() THEN 1 ELSE 0 END) as orders_today
            FROM orders
            """;
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                stats.put("total_orders", rs.getInt("total_orders"));
                stats.put("pending_orders", rs.getInt("pending_orders"));
                stats.put("processing_orders", rs.getInt("processing_orders"));
                stats.put("completed_orders", rs.getInt("completed_orders"));
                stats.put("cancelled_orders", rs.getInt("cancelled_orders"));
                stats.put("total_revenue", formatCurrency(rs.getDouble("total_revenue")));
                stats.put("revenue_today", formatCurrency(rs.getDouble("revenue_today")));
                stats.put("orders_today", rs.getInt("orders_today"));
            }
        }
        
        return stats;
    }

    // ============================================================================
    // FALLBACK DUMMY DATA METHODS (IF DATABASE FAILS)
    // ============================================================================

    private Map<String, Object> createFallbackSystemStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total_users", 22);
        stats.put("total_shops", 6);
        stats.put("total_products", 40);
        stats.put("total_orders", 4);
        stats.put("revenue_today", "33,085,000₫");
        stats.put("orders_today", 4);
        stats.put("new_users_today", 0);
        stats.put("pending_verification", 1);
        stats.put("active_users", 20);
        stats.put("active_products", 38);
        return stats;
    }

    private List<Map<String, Object>> createFallbackActivities() {
        List<Map<String, Object>> activities = new ArrayList<>();
        
        String[][] activityData = {
            {"NEW_USER", "Người dùng mới đăng ký: Phạm Thị Hoa", "120"},
            {"NEW_SHOP", "Shop mới đăng ký: Đức Home Living", "180"},
            {"NEW_ORDER", "Đơn hàng mới: ORD20250301004", "30"},
            {"NEW_USER", "Người dùng mới đăng ký: Lê Minh Đức", "240"},
            {"NEW_SHOP", "Shop mới đăng ký: ThuTrang Beauty & Baby", "300"}
        };
        
        for (String[] data : activityData) {
            Map<String, Object> activity = new HashMap<>();
            activity.put("activity_type", data[0]);
            activity.put("description", data[1]);
            activity.put("activity_time", LocalDateTime.now().minusMinutes(Integer.parseInt(data[2])));
            activities.add(activity);
        }
        
        return activities;
    }

    private List<Map<String, Object>> createDummyUsers() {
        List<Map<String, Object>> users = new ArrayList<>();
        
        String[][] userData = {
            {"15", "vendor_tech", "tech.vendor@uteshop.vn", "Nguyễn Minh Khôi", "3", "true", "2025-01-10"},
            {"16", "vendor_fashion", "fashion.vendor@uteshop.vn", "Trần Thị Hoa Mai", "3", "true", "2025-01-15"},
            {"17", "vendor_beauty", "beauty.vendor@uteshop.vn", "Lê Thị Thu Trang", "3", "true", "2025-01-20"},
            {"18", "vendor_home", "home.vendor@uteshop.vn", "Phạm Văn Đức", "3", "true", "2025-01-25"}
        };
        
        for (String[] data : userData) {
            Map<String, Object> user = new HashMap<>();
            user.put("user_id", Integer.parseInt(data[0]));
            user.put("username", data[1]);
            user.put("email", data[2]);
            user.put("full_name", data[3]);
            user.put("role_id", Integer.parseInt(data[4]));
            user.put("role_name", "Vendor");
            user.put("is_active", Boolean.parseBoolean(data[5]));
            user.put("created_at", data[6]);
            users.add(user);
        }
        
        return users;
    }

    private Map<String, Object> createDummyUserStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total_users", 22);
        stats.put("active_users", 20);
        stats.put("admin_count", 2);
        stats.put("vendor_count", 4);
        stats.put("customer_count", 16);
        stats.put("new_today", 0);
        return stats;
    }

    private List<Map<String, Object>> createDummyShops() {
        List<Map<String, Object>> shops = new ArrayList<>();
        
        String[][] shopData = {
            {"3", "KhoiTech Store", "Nguyễn Minh Khôi", "tech.vendor@uteshop.vn", "true", "true", "10", "4.5"},
            {"4", "HoaMai Fashion", "Trần Thị Hoa Mai", "fashion.vendor@uteshop.vn", "true", "true", "10", "4.2"},
            {"5", "ThuTrang Beauty & Baby", "Lê Thị Thu Trang", "beauty.vendor@uteshop.vn", "true", "true", "10", "4.3"},
            {"6", "Đức Home Living", "Phạm Văn Đức", "home.vendor@uteshop.vn", "true", "true", "10", "4.4"}
        };
        
        for (String[] data : shopData) {
            Map<String, Object> shop = new HashMap<>();
            shop.put("shop_id", Integer.parseInt(data[0]));
            shop.put("shop_name", data[1]);
            shop.put("owner_name", data[2]);
            shop.put("owner_email", data[3]);
            shop.put("is_verified", Boolean.parseBoolean(data[4]));
            shop.put("is_active", Boolean.parseBoolean(data[5]));
            shop.put("product_count", Integer.parseInt(data[6]));
            shop.put("total_rating", Double.parseDouble(data[7]));
            shops.add(shop);
        }
        
        return shops;
    }

    private Map<String, Object> createDummyShopStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total_shops", 6);
        stats.put("verified_shops", 5);
        stats.put("pending_verification", 1);
        stats.put("active_shops", 6);
        stats.put("new_today", 0);
        return stats;
    }

    private List<Map<String, Object>> createDummyPendingShops() {
        return new ArrayList<>(); // No pending shops in real data
    }

    private List<Map<String, Object>> createDummyProducts() {
        List<Map<String, Object>> products = new ArrayList<>();
        
        String[][] productData = {
            {"4", "PlayStation 5 Console", "KhoiTech Store", "12990000", "15", "ACTIVE"},
            {"14", "Váy Đầm Công Sở Zara", "HoaMai Fashion", "990000", "50", "ACTIVE"},
            {"24", "Set Skincare The Ordinary", "ThuTrang Beauty & Baby", "750000", "100", "ACTIVE"},
            {"34", "Sofa Góc L JYSK", "Đức Home Living", "16900000", "8", "ACTIVE"}
        };
        
        for (String[] data : productData) {
            Map<String, Object> product = new HashMap<>();
            product.put("product_id", Integer.parseInt(data[0]));
            product.put("product_name", data[1]);
            product.put("shop_name", data[2]);
            product.put("price", Double.parseDouble(data[3]));
            product.put("formatted_price", formatCurrency(Double.parseDouble(data[3])));
            product.put("stock_quantity", Integer.parseInt(data[4]));
            product.put("status", data[5]);
            products.add(product);
        }
        
        return products;
    }

    private Map<String, Object> createDummyProductStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total_products", 40);
        stats.put("active_products", 38);
        stats.put("out_of_stock", 0);
        stats.put("low_stock", 2);
        stats.put("new_today", 0);
        return stats;
    }

    private List<Map<String, Object>> createDummyOrders() {
        List<Map<String, Object>> orders = new ArrayList<>();
        
        String[][] orderData = {
            {"1", "ORD20250301001", "Nguyễn Văn Nam", "KhoiTech Store", "12540000", "DELIVERED"},
            {"2", "ORD20250301002", "Trần Thị Linh", "HoaMai Fashion", "2810000", "DELIVERED"},
            {"3", "ORD20250301003", "Lê Minh Đức", "ThuTrang Beauty & Baby", "1735000", "SHIPPING"},
            {"4", "ORD20250301004", "Phạm Thị Hoa", "Đức Home Living", "16000000", "DELIVERED"}
        };
        
        for (String[] data : orderData) {
            Map<String, Object> order = new HashMap<>();
            order.put("order_id", Integer.parseInt(data[0]));
            order.put("order_number", data[1]);
            order.put("customer_name", data[2]);
            order.put("shop_name", data[3]);
            order.put("total_amount", Double.parseDouble(data[4]));
            order.put("formatted_amount", formatCurrency(Double.parseDouble(data[4])));
            order.put("order_status", data[5]);
            order.put("created_at", LocalDateTime.now().minusDays(Integer.parseInt(data[0])));
            orders.add(order);
        }
        
        return orders;
    }

    private Map<String, Object> createDummyOrderStats() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("total_orders", 4);
        stats.put("pending_orders", 0);
        stats.put("processing_orders", 1);
        stats.put("completed_orders", 3);
        stats.put("cancelled_orders", 0);
        stats.put("total_revenue", "33,085,000₫");
        stats.put("revenue_today", "0₫");
        stats.put("orders_today", 0);
        return stats;
    }

    private List<Map<String, Object>> createDummyRevenueData() {
        List<Map<String, Object>> revenueData = new ArrayList<>();
        
        String[] dates = {"2025-03-22", "2025-03-20", "2025-03-18", "2025-03-15"};
        double[] revenues = {16000000, 1735000, 2810000, 12540000};
        int[] orderCounts = {1, 1, 1, 1};
        
        for (int i = 0; i < dates.length; i++) {
            Map<String, Object> data = new HashMap<>();
            data.put("date", dates[i]);
            data.put("revenue", revenues[i]);
            data.put("formatted_revenue", formatCurrency(revenues[i]));
            data.put("order_count", orderCounts[i]);
            revenueData.add(data);
        }
        
        return revenueData;
    }

    private List<Map<String, Object>> createDummyTopProducts() {
        List<Map<String, Object>> topProducts = new ArrayList<>();
        
        String[][] productData = {
            {"PlayStation 5 Console", "KhoiTech Store", "1", "1"},
            {"Sofa Góc L JYSK", "Đức Home Living", "1", "1"},
            {"Váy Đầm Công Sở Zara", "HoaMai Fashion", "1", "1"},
            {"Set Skincare The Ordinary", "ThuTrang Beauty & Baby", "1", "1"}
        };
        
        for (String[] data : productData) {
            Map<String, Object> product = new HashMap<>();
            product.put("product_name", data[0]);
            product.put("shop_name", data[1]);
            product.put("total_sold", Integer.parseInt(data[2]));
            product.put("recent_sales", Integer.parseInt(data[3]));
            topProducts.add(product);
        }
        
        return topProducts;
    }

    private List<Map<String, Object>> createDummyTopShops() {
        List<Map<String, Object>> topShops = new ArrayList<>();
        
        String[][] shopData = {
            {"KhoiTech Store", "5.0", "1", "10", "12540000"},
            {"Đức Home Living", "5.0", "1", "10", "16000000"},
            {"HoaMai Fashion", "4.0", "1", "10", "2810000"},
            {"ThuTrang Beauty & Baby", "5.0", "1", "10", "1735000"}
        };
        
        for (String[] data : shopData) {
            Map<String, Object> shop = new HashMap<>();
            shop.put("shop_name", data[0]);
            shop.put("total_rating", Double.parseDouble(data[1]));
            shop.put("total_reviews", Integer.parseInt(data[2]));
            shop.put("product_count", Integer.parseInt(data[3]));
            shop.put("recent_revenue", formatCurrency(Double.parseDouble(data[4])));
            topShops.add(shop);
        }
        
        return topShops;
    }

    // ============================================================================
    // UTILITY METHODS
    // ============================================================================

    private String getRequestPath(HttpServletRequest request) {
        String path = request.getRequestURI();
        String contextPath = request.getContextPath();
        
        if (path.startsWith(contextPath)) {
            path = path.substring(contextPath.length());
        }
        
        return path;
    }

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

    private void setCommonAttributes(HttpServletRequest request, User user) {
        request.setAttribute("authUser", user);
        request.setAttribute("isLoggedIn", user != null);
        request.setAttribute("userRoleId", user != null ? user.getRoleId() : 0);
        request.setAttribute("userRoleDisplay", user != null ? "Admin" : "Guest");
        request.setAttribute("currentDateTime", LocalDateTime.now());
        request.setAttribute("serverTime", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
    }

    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        try {
            String paramValue = request.getParameter(paramName);
            return paramValue != null ? Integer.parseInt(paramValue) : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private String formatCurrency(double amount) {
        return String.format("%,.0f₫", amount);
    }

    @Override
    public void destroy() {
        System.out.println("🗑️ AdminController WITH REAL DATA destroyed at: " + LocalDateTime.now());
        super.destroy();
    }
}
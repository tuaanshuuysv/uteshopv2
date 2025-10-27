package vn.ute.uteshop.services;

import vn.ute.uteshop.config.DataSourceFactory;
import java.sql.*;
import java.util.*;

/**
 * AdminService - REAL DATABASE OPERATIONS
 * Created: 2025-10-26 16:52:18 UTC by tuaanshuuysv
 * Purpose: Fetch real admin data from database
 */
public class AdminService {

    /**
     * Get system statistics from real database
     */
    public Map<String, Object> getSystemStats() throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        String sql = """
            SELECT 
                (SELECT COUNT(*) FROM users) as total_users,
                (SELECT COUNT(*) FROM users WHERE is_active = 1) as active_users,
                (SELECT COUNT(*) FROM users WHERE created_at >= CURDATE()) as new_users_today,
                (SELECT COUNT(*) FROM shops) as total_shops,
                (SELECT COUNT(*) FROM shops WHERE is_verified = 1) as verified_shops,
                (SELECT COUNT(*) FROM shops WHERE is_verified = 0) as pending_verification,
                (SELECT COUNT(*) FROM products) as total_products,
                (SELECT COUNT(*) FROM products WHERE status = 'ACTIVE') as active_products,
                (SELECT COUNT(*) FROM orders) as total_orders,
                (SELECT COUNT(*) FROM orders WHERE DATE(created_at) = CURDATE()) as orders_today,
                (SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE DATE(created_at) = CURDATE()) as revenue_today
            """;
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                stats.put("total_users", rs.getInt("total_users"));
                stats.put("active_users", rs.getInt("active_users"));
                stats.put("new_users_today", rs.getInt("new_users_today"));
                stats.put("total_shops", rs.getInt("total_shops"));
                stats.put("verified_shops", rs.getInt("verified_shops"));
                stats.put("pending_verification", rs.getInt("pending_verification"));
                stats.put("total_products", rs.getInt("total_products"));
                stats.put("active_products", rs.getInt("active_products"));
                stats.put("total_orders", rs.getInt("total_orders"));
                stats.put("orders_today", rs.getInt("orders_today"));
                
                double revenueToday = rs.getDouble("revenue_today");
                stats.put("revenue_today", formatCurrency(revenueToday));
            }
        }
        
        return stats;
    }

    /**
     * Get recent activities from database
     */
    public List<Map<String, Object>> getRecentActivities(int limit) throws SQLException {
        List<Map<String, Object>> activities = new ArrayList<>();
        
        String sql = """
            (SELECT 'NEW_USER' as activity_type, 
                    CONCAT('Người dùng mới đăng ký: ', full_name) as description,
                    created_at as activity_time
             FROM users 
             WHERE created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
             ORDER BY created_at DESC LIMIT ?)
            UNION ALL
            (SELECT 'NEW_SHOP' as activity_type,
                    CONCAT('Shop mới đăng ký: ', shop_name) as description,
                    created_at as activity_time
             FROM shops
             WHERE created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
             ORDER BY created_at DESC LIMIT ?)
            UNION ALL
            (SELECT 'NEW_ORDER' as activity_type,
                    CONCAT('Đơn hàng mới: ', order_number) as description,
                    created_at as activity_time
             FROM orders
             WHERE created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
             ORDER BY created_at DESC LIMIT ?)
            ORDER BY activity_time DESC
            LIMIT ?
            """;
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit / 3);
            stmt.setInt(2, limit / 3);
            stmt.setInt(3, limit / 3);
            stmt.setInt(4, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> activity = new HashMap<>();
                    activity.put("activity_type", rs.getString("activity_type"));
                    activity.put("description", rs.getString("description"));
                    activity.put("activity_time", rs.getTimestamp("activity_time"));
                    activities.add(activity);
                }
            }
        }
        
        return activities;
    }

    /**
     * Get system alerts from database
     */
    public List<Map<String, Object>> getSystemAlerts() throws SQLException {
        List<Map<String, Object>> alerts = new ArrayList<>();
        
        // Check for low stock products
        String lowStockSql = """
            SELECT COUNT(*) as count 
            FROM products 
            WHERE stock_quantity < 10 AND status = 'ACTIVE'
            """;
        
        // Check for pending shop verifications
        String pendingShopsSql = """
            SELECT COUNT(*) as count 
            FROM shops 
            WHERE is_verified = 0
            """;
        
        try (Connection conn = DataSourceFactory.getConnection()) {
            // Low stock alert
            try (PreparedStatement stmt = conn.prepareStatement(lowStockSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next() && rs.getInt("count") > 0) {
                    Map<String, Object> alert = new HashMap<>();
                    alert.put("level", "WARNING");
                    alert.put("message", rs.getInt("count") + " sản phẩm sắp hết hàng");
                    alerts.add(alert);
                }
            }
            
            // Pending shops alert
            try (PreparedStatement stmt = conn.prepareStatement(pendingShopsSql);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next() && rs.getInt("count") > 0) {
                    Map<String, Object> alert = new HashMap<>();
                    alert.put("level", "INFO");
                    alert.put("message", rs.getInt("count") + " shop chờ xác minh");
                    alerts.add(alert);
                }
            }
        }
        
        return alerts;
    }

    /**
     * Get revenue chart data for last N days
     */
    public List<Map<String, Object>> getRevenueChartData(int days) throws SQLException {
        List<Map<String, Object>> chartData = new ArrayList<>();
        
        String sql = """
            SELECT 
                DATE(created_at) as order_date,
                COUNT(*) as order_count,
                COALESCE(SUM(total_amount), 0) as revenue
            FROM orders
            WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL ? DAY)
            GROUP BY DATE(created_at)
            ORDER BY order_date DESC
            """;
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, days);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> data = new HashMap<>();
                    data.put("date", rs.getDate("order_date").toString());
                    data.put("order_count", rs.getInt("order_count"));
                    data.put("revenue", rs.getDouble("revenue"));
                    data.put("formatted_revenue", formatCurrency(rs.getDouble("revenue")));
                    chartData.add(data);
                }
            }
        }
        
        return chartData;
    }

    /**
     * Get pending shop verifications
     */
    public List<Map<String, Object>> getPendingVerifications(int limit) throws SQLException {
        List<Map<String, Object>> pending = new ArrayList<>();
        
        String sql = """
            SELECT s.shop_id, s.shop_name, s.shop_description, 
                   u.email as owner_email, s.created_at,
                   COUNT(p.product_id) as product_count
            FROM shops s
            JOIN users u ON s.owner_id = u.user_id
            LEFT JOIN products p ON s.shop_id = p.shop_id
            WHERE s.is_verified = 0
            GROUP BY s.shop_id, s.shop_name, s.shop_description, u.email, s.created_at
            ORDER BY s.created_at DESC
            LIMIT ?
            """;
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> shop = new HashMap<>();
                    shop.put("shop_id", rs.getInt("shop_id"));
                    shop.put("shop_name", rs.getString("shop_name"));
                    shop.put("shop_description", rs.getString("shop_description"));
                    shop.put("owner_email", rs.getString("owner_email"));
                    shop.put("product_count", rs.getInt("product_count"));
                    shop.put("created_at", rs.getTimestamp("created_at"));
                    pending.add(shop);
                }
            }
        }
        
        return pending;
    }

    /**
     * Get top selling products
     */
    public List<Map<String, Object>> getTopSellingProducts(int limit) throws SQLException {
        List<Map<String, Object>> topProducts = new ArrayList<>();
        
        String sql = """
            SELECT p.product_name, s.shop_name,
                   COALESCE(SUM(od.quantity), 0) as total_sold,
                   COALESCE(SUM(CASE WHEN o.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) 
                                    THEN od.quantity ELSE 0 END), 0) as recent_sales
            FROM products p
            JOIN shops s ON p.shop_id = s.shop_id
            LEFT JOIN order_details od ON p.product_id = od.product_id
            LEFT JOIN orders o ON od.order_id = o.order_id
            WHERE p.status = 'ACTIVE'
            GROUP BY p.product_id, p.product_name, s.shop_name
            HAVING total_sold > 0
            ORDER BY total_sold DESC
            LIMIT ?
            """;
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> product = new HashMap<>();
                    product.put("product_name", rs.getString("product_name"));
                    product.put("shop_name", rs.getString("shop_name"));
                    product.put("total_sold", rs.getInt("total_sold"));
                    product.put("recent_sales", rs.getInt("recent_sales"));
                    topProducts.add(product);
                }
            }
        }
        
        return topProducts;
    }

    /**
     * Get top performing shops
     */
    public List<Map<String, Object>> getTopShops(int limit) throws SQLException {
        List<Map<String, Object>> topShops = new ArrayList<>();
        
        String sql = """
            SELECT s.shop_name,
                   COALESCE(AVG(pr.rating), 0) as total_rating,
                   COUNT(DISTINCT pr.review_id) as total_reviews,
                   COUNT(DISTINCT p.product_id) as product_count,
                   COALESCE(SUM(CASE WHEN o.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) 
                                    THEN o.total_amount ELSE 0 END), 0) as recent_revenue
            FROM shops s
            LEFT JOIN products p ON s.shop_id = p.shop_id
            LEFT JOIN product_reviews pr ON p.product_id = pr.product_id
            LEFT JOIN orders o ON s.shop_id = o.shop_id
            WHERE s.is_verified = 1 AND s.is_active = 1
            GROUP BY s.shop_id, s.shop_name
            ORDER BY recent_revenue DESC
            LIMIT ?
            """;
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> shop = new HashMap<>();
                    shop.put("shop_name", rs.getString("shop_name"));
                    shop.put("total_rating", Math.round(rs.getDouble("total_rating") * 10.0) / 10.0);
                    shop.put("total_reviews", rs.getInt("total_reviews"));
                    shop.put("product_count", rs.getInt("product_count"));
                    shop.put("recent_revenue", formatCurrency(rs.getDouble("recent_revenue")));
                    topShops.add(shop);
                }
            }
        }
        
        return topShops;
    }

    private String formatCurrency(double amount) {
        return String.format("%,.0f₫", amount);
    }
}
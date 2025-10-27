package vn.ute.uteshop.services;

import vn.ute.uteshop.config.DataSourceFactory;
import java.sql.*;
import java.util.*;

/**
 * VendorService - REAL DATABASE OPERATIONS
 * Created: 2025-10-26 16:52:18 UTC by tuaanshuuysv
 * Purpose: Fetch real vendor data from database
 */
public class VendorService {

    /**
     * Get vendor's shop information
     */
    public Map<String, Object> getVendorShop(int vendorUserId) throws SQLException {
        String sql = """
            SELECT s.shop_id, s.shop_name, s.shop_description, s.shop_logo, 
                   s.is_verified, s.is_active, s.created_at,
                   COUNT(DISTINCT p.product_id) as product_count,
                   COALESCE(AVG(pr.rating), 0) as total_rating,
                   COUNT(DISTINCT pr.review_id) as total_reviews
            FROM shops s
            LEFT JOIN products p ON s.shop_id = p.shop_id AND p.status = 'ACTIVE'
            LEFT JOIN product_reviews pr ON p.product_id = pr.product_id
            WHERE s.owner_id = ? AND s.is_active = 1
            GROUP BY s.shop_id, s.shop_name, s.shop_description, s.shop_logo, 
                     s.is_verified, s.is_active, s.created_at
            """;
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, vendorUserId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> shop = new HashMap<>();
                    shop.put("shop_id", rs.getInt("shop_id"));
                    shop.put("shop_name", rs.getString("shop_name"));
                    shop.put("shop_description", rs.getString("shop_description"));
                    shop.put("shop_logo", rs.getString("shop_logo"));
                    shop.put("is_verified", rs.getBoolean("is_verified"));
                    shop.put("is_active", rs.getBoolean("is_active"));
                    shop.put("product_count", rs.getInt("product_count"));
                    shop.put("total_rating", Math.round(rs.getDouble("total_rating") * 10.0) / 10.0);
                    shop.put("total_reviews", rs.getInt("total_reviews"));
                    shop.put("created_at", rs.getTimestamp("created_at"));
                    return shop;
                }
            }
        }
        
        return null; // No shop found
    }

    /**
     * Get shop statistics
     */
    public Map<String, Object> getShopStats(int shopId) throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        String sql = """
            SELECT 
                (SELECT COUNT(*) FROM products WHERE shop_id = ? AND status = 'ACTIVE') as total_products,
                (SELECT COUNT(*) FROM products WHERE shop_id = ? AND status = 'ACTIVE' AND stock_quantity > 0) as in_stock_products,
                (SELECT COUNT(*) FROM products WHERE shop_id = ? AND status = 'ACTIVE' AND stock_quantity < 10) as low_stock_products,
                (SELECT COUNT(*) FROM orders WHERE shop_id = ?) as total_orders,
                (SELECT COUNT(*) FROM orders WHERE shop_id = ? AND order_status IN ('NEW', 'CONFIRMED')) as pending_orders,
                (SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE shop_id = ?) as total_revenue,
                (SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE shop_id = ? AND DATE(created_at) = CURDATE()) as revenue_today
            """;
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, shopId);
            stmt.setInt(2, shopId);
            stmt.setInt(3, shopId);
            stmt.setInt(4, shopId);
            stmt.setInt(5, shopId);
            stmt.setInt(6, shopId);
            stmt.setInt(7, shopId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("total_products", rs.getInt("total_products"));
                    stats.put("in_stock_products", rs.getInt("in_stock_products"));
                    stats.put("low_stock_products", rs.getInt("low_stock_products"));
                    stats.put("total_orders", rs.getInt("total_orders"));
                    stats.put("pending_orders", rs.getInt("pending_orders"));
                    stats.put("total_revenue", formatCurrency(rs.getDouble("total_revenue")));
                    stats.put("revenue_today", formatCurrency(rs.getDouble("revenue_today")));
                }
            }
        }
        
        return stats;
    }

    /**
     * Get recent orders for shop
     */
    public List<Map<String, Object>> getRecentOrders(int shopId, int limit) throws SQLException {
        List<Map<String, Object>> orders = new ArrayList<>();
        
        String sql = """
            SELECT o.order_id, o.order_number, o.total_amount, o.order_status, 
                   o.payment_method, o.created_at,
                   u.full_name as customer_name,
                   COUNT(od.detail_id) as item_count
            FROM orders o
            JOIN users u ON o.user_id = u.user_id
            LEFT JOIN order_details od ON o.order_id = od.order_id
            WHERE o.shop_id = ?
            GROUP BY o.order_id, o.order_number, o.total_amount, o.order_status, 
                     o.payment_method, o.created_at, u.full_name
            ORDER BY o.created_at DESC
            LIMIT ?
            """;
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, shopId);
            stmt.setInt(2, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> order = new HashMap<>();
                    order.put("order_id", rs.getInt("order_id"));
                    order.put("order_number", rs.getString("order_number"));
                    order.put("customer_name", rs.getString("customer_name"));
                    order.put("total_amount", formatCurrency(rs.getDouble("total_amount")));
                    order.put("order_status", rs.getString("order_status"));
                    order.put("payment_method", rs.getString("payment_method"));
                    order.put("item_count", rs.getInt("item_count"));
                    order.put("created_at", rs.getTimestamp("created_at"));
                    orders.add(order);
                }
            }
        }
        
        return orders;
    }

    /**
     * Get low stock products for shop
     */
    public List<Map<String, Object>> getLowStockProducts(int shopId, int limit) throws SQLException {
        List<Map<String, Object>> products = new ArrayList<>();
        
        String sql = """
            SELECT p.product_id, p.product_name, p.stock_quantity,
                   COALESCE(pi.image_url, '/assets/images/products/default.jpg') as image_url
            FROM products p
            LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
            WHERE p.shop_id = ? AND p.status = 'ACTIVE' AND p.stock_quantity < 10
            ORDER BY p.stock_quantity ASC
            LIMIT ?
            """;
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, shopId);
            stmt.setInt(2, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> product = new HashMap<>();
                    product.put("product_id", rs.getInt("product_id"));
                    product.put("product_name", rs.getString("product_name"));
                    product.put("stock_quantity", rs.getInt("stock_quantity"));
                    product.put("min_stock_level", 10); // Default minimum
                    product.put("image_url", rs.getString("image_url"));
                    products.add(product);
                }
            }
        }
        
        return products;
    }

    /**
     * Get shop products
     */
    public List<Map<String, Object>> getShopProducts(int shopId, int limit) throws SQLException {
        List<Map<String, Object>> products = new ArrayList<>();
        
        String sql = """
            SELECT p.product_id, p.product_name, p.price, p.stock_quantity, 
                   p.status, p.created_at,
                   COALESCE(pi.image_url, '/assets/images/products/default.jpg') as image_url,
                   COALESCE(SUM(od.quantity), 0) as total_sold
            FROM products p
            LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
            LEFT JOIN order_details od ON p.product_id = od.product_id
            WHERE p.shop_id = ?
            GROUP BY p.product_id, p.product_name, p.price, p.stock_quantity, 
                     p.status, p.created_at, pi.image_url
            ORDER BY p.created_at DESC
            LIMIT ?
            """;
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, shopId);
            stmt.setInt(2, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> product = new HashMap<>();
                    product.put("product_id", rs.getInt("product_id"));
                    product.put("product_name", rs.getString("product_name"));
                    product.put("formatted_price", formatCurrency(rs.getDouble("price")));
                    product.put("stock_quantity", rs.getInt("stock_quantity"));
                    product.put("status", rs.getString("status"));
                    product.put("total_sold", rs.getInt("total_sold"));
                    product.put("image_url", rs.getString("image_url"));
                    product.put("created_at", rs.getTimestamp("created_at"));
                    products.add(product);
                }
            }
        }
        
        return products;
    }

    private String formatCurrency(double amount) {
        return String.format("%,.0f₫", amount);
    }
}
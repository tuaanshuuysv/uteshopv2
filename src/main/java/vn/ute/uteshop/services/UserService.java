package vn.ute.uteshop.services;

import vn.ute.uteshop.config.DataSourceFactory;
import java.sql.*;
import java.util.*;

/**
 * UserService - User Related Operations
 * Created: 2025-10-26 03:13:27 UTC by tuaanshuuysv
 * Features: User favorites (wishlist), user stats, recent views
 */
public class UserService {

    /**
     * Add product to user's wishlist (favorites)
     */
    public boolean addToWishlist(int userId, int productId) throws SQLException {
        // Check if already in wishlist
        if (isInWishlist(userId, productId)) {
            return false; // Already exists
        }
        
        String sql = "INSERT INTO user_favorites (user_id, product_id, created_at) VALUES (?, ?, NOW())";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Remove product from user's wishlist
     */
    public boolean removeFromWishlist(int userId, int productId) throws SQLException {
        String sql = "DELETE FROM user_favorites WHERE user_id = ? AND product_id = ?";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            
            return stmt.executeUpdate() > 0;
        }
    }

    /**
     * Check if product is in user's wishlist
     */
    public boolean isInWishlist(int userId, int productId) throws SQLException {
        String sql = "SELECT 1 FROM user_favorites WHERE user_id = ? AND product_id = ?";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Get user's wishlist product IDs
     */
    public List<Integer> getUserWishlist(int userId) throws SQLException {
        String sql = "SELECT product_id FROM user_favorites WHERE user_id = ? ORDER BY created_at DESC";
        
        List<Integer> wishlist = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    wishlist.add(rs.getInt("product_id"));
                }
            }
        }
        
        return wishlist;
    }

    /**
     * Get user's wishlist with product details
     */
    public List<Map<String, Object>> getWishlistProducts(int userId) throws SQLException {
        String sql = """
            SELECT uf.favorite_id, p.product_id, p.product_name, p.price, p.sale_price,
                   p.stock_quantity, p.total_rating, p.total_reviews,
                   s.shop_name, pi.image_url, uf.created_at,
                   CASE WHEN p.sale_price > 0 AND p.sale_price < p.price 
                        THEN ROUND(((p.price - p.sale_price) / p.price) * 100)
                        ELSE 0 END as discount_percent
            FROM user_favorites uf
            JOIN products p ON uf.product_id = p.product_id
            JOIN shops s ON p.shop_id = s.shop_id
            LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
            WHERE uf.user_id = ? AND p.status = 'ACTIVE' AND s.is_active = 1
            ORDER BY uf.created_at DESC
        """;
        
        List<Map<String, Object>> wishlistProducts = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> product = new HashMap<>();
                    product.put("favorite_id", rs.getInt("favorite_id"));
                    product.put("product_id", rs.getInt("product_id"));
                    product.put("product_name", rs.getString("product_name"));
                    product.put("formatted_price", formatCurrency(rs.getDouble("price")));
                    
                    double salePrice = rs.getDouble("sale_price");
                    if (salePrice > 0) {
                        product.put("formatted_sale_price", formatCurrency(salePrice));
                        product.put("has_discount", true);
                    } else {
                        product.put("has_discount", false);
                    }
                    
                    product.put("stock_quantity", rs.getInt("stock_quantity"));
                    product.put("total_rating", rs.getDouble("total_rating"));
                    product.put("total_reviews", rs.getInt("total_reviews"));
                    product.put("shop_name", rs.getString("shop_name"));
                    product.put("image_url", rs.getString("image_url"));
                    product.put("discount_percent", rs.getInt("discount_percent"));
                    product.put("added_date", rs.getTimestamp("created_at"));
                    
                    wishlistProducts.add(product);
                }
            }
        }
        
        return wishlistProducts;
    }

    /**
     * Track user product view
     */
    public void trackProductView(int userId, int productId) throws SQLException {
        // Check if already viewed recently (within last hour)
        String checkSql = """
            SELECT 1 FROM user_viewed_products 
            WHERE user_id = ? AND product_id = ? 
            AND viewed_at > DATE_SUB(NOW(), INTERVAL 1 HOUR)
        """;
        
        try (Connection conn = DataSourceFactory.getConnection()) {
            boolean recentlyViewed = false;
            
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, userId);
                checkStmt.setInt(2, productId);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    recentlyViewed = rs.next();
                }
            }
            
            if (!recentlyViewed) {
                // Insert or update view record
                String sql = """
                    INSERT INTO user_viewed_products (user_id, product_id, viewed_at) 
                    VALUES (?, ?, NOW())
                    ON DUPLICATE KEY UPDATE viewed_at = NOW()
                """;
                
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setInt(1, userId);
                    stmt.setInt(2, productId);
                    stmt.executeUpdate();
                }
            }
        }
    }

    /**
     * Get user's recently viewed products
     */
    public List<Map<String, Object>> getRecentlyViewedProducts(int userId, int limit) throws SQLException {
        String sql = """
            SELECT uvp.product_id, p.product_name, p.price, p.sale_price,
                   s.shop_name, pi.image_url, uvp.viewed_at,
                   CASE WHEN p.sale_price > 0 AND p.sale_price < p.price 
                        THEN ROUND(((p.price - p.sale_price) / p.price) * 100)
                        ELSE 0 END as discount_percent
            FROM user_viewed_products uvp
            JOIN products p ON uvp.product_id = p.product_id
            JOIN shops s ON p.shop_id = s.shop_id
            LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
            WHERE uvp.user_id = ? AND p.status = 'ACTIVE' AND s.is_active = 1
            ORDER BY uvp.viewed_at DESC
            LIMIT ?
        """;
        
        List<Map<String, Object>> recentProducts = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setInt(2, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> product = new HashMap<>();
                    product.put("product_id", rs.getInt("product_id"));
                    product.put("product_name", rs.getString("product_name"));
                    product.put("formatted_price", formatCurrency(rs.getDouble("price")));
                    
                    double salePrice = rs.getDouble("sale_price");
                    if (salePrice > 0) {
                        product.put("formatted_sale_price", formatCurrency(salePrice));
                    }
                    
                    product.put("shop_name", rs.getString("shop_name"));
                    product.put("image_url", rs.getString("image_url"));
                    product.put("discount_percent", rs.getInt("discount_percent"));
                    product.put("viewed_at", rs.getTimestamp("viewed_at"));
                    
                    recentProducts.add(product);
                }
            }
        }
        
        return recentProducts;
    }

    /**
     * Get user statistics
     */
    public Map<String, Object> getUserStats(int userId) throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        try (Connection conn = DataSourceFactory.getConnection()) {
            // Get order statistics
            String orderSql = """
                SELECT COUNT(*) as total_orders,
                       COALESCE(SUM(total_amount), 0) as total_spent
                FROM orders 
                WHERE user_id = ? AND order_status != 'CANCELLED'
            """;
            
            try (PreparedStatement stmt = conn.prepareStatement(orderSql)) {
                stmt.setInt(1, userId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        stats.put("total_orders", rs.getInt("total_orders"));
                        stats.put("total_spent", formatCurrency(rs.getDouble("total_spent")));
                    }
                }
            }
            
            // Get wishlist count
            String wishlistSql = "SELECT COUNT(*) as wishlist_count FROM user_favorites WHERE user_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(wishlistSql)) {
                stmt.setInt(1, userId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        stats.put("wishlist_count", rs.getInt("wishlist_count"));
                    }
                }
            }
            
            // Get favorite category
            String categorySql = """
                SELECT c.category_name, COUNT(*) as count
                FROM orders o
                JOIN order_details od ON o.order_id = od.order_id
                JOIN products p ON od.product_id = p.product_id
                JOIN categories c ON p.category_id = c.category_id
                WHERE o.user_id = ? AND o.order_status != 'CANCELLED'
                GROUP BY c.category_id, c.category_name
                ORDER BY count DESC
                LIMIT 1
            """;
            
            try (PreparedStatement stmt = conn.prepareStatement(categorySql)) {
                stmt.setInt(1, userId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        stats.put("favorite_category", rs.getString("category_name"));
                    } else {
                        stats.put("favorite_category", "Chưa có");
                    }
                }
            }
        }
        
        return stats;
    }

    private String formatCurrency(double amount) {
        return String.format("%,.0f₫", amount);
    }
}
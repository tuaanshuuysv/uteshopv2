package vn.ute.uteshop.services;

import vn.ute.uteshop.config.DataSourceFactory;
import java.sql.*;
import java.util.*;

/**
 * CatalogService - Product Catalog Management
 * Created: 2025-10-26 03:13:27 UTC by tuaanshuuysv
 * Features: Categories, Products, Search functionality
 */
public class CatalogService {

    /**
     * Get all active categories with product counts
     */
    public List<Map<String, Object>> getAllCategories() throws SQLException {
        String sql = """
            SELECT c.category_id, c.category_name, c.category_description, c.category_icon,
                   COUNT(p.product_id) as product_count
            FROM categories c
            LEFT JOIN products p ON c.category_id = p.category_id AND p.status = 'ACTIVE'
            WHERE c.is_active = 1
            GROUP BY c.category_id, c.category_name, c.category_description, c.category_icon
            ORDER BY product_count DESC, c.category_name
        """;
        
        List<Map<String, Object>> categories = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> category = new HashMap<>();
                category.put("category_id", rs.getInt("category_id"));
                category.put("category_name", rs.getString("category_name"));
                category.put("category_description", rs.getString("category_description"));
                category.put("category_icon", rs.getString("category_icon"));
                category.put("product_count", rs.getInt("product_count"));
                categories.add(category);
            }
        }
        
        return categories;
    }

    /**
     * Search products with filters
     */
    public List<Map<String, Object>> searchProducts(String query, Integer categoryId, String sortBy, int page, int pageSize) throws SQLException {
        StringBuilder sql = new StringBuilder("""
            SELECT p.product_id, p.product_name, p.product_description, p.price, p.sale_price,
                   p.stock_quantity, p.total_rating, p.total_reviews, p.total_sold,
                   s.shop_id, s.shop_name, s.is_verified,
                   c.category_name,
                   pi.image_url,
                   CASE WHEN p.sale_price > 0 AND p.sale_price < p.price 
                        THEN ROUND(((p.price - p.sale_price) / p.price) * 100)
                        ELSE 0 END as discount_percent
            FROM products p
            JOIN shops s ON p.shop_id = s.shop_id
            JOIN categories c ON p.category_id = c.category_id
            LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
            WHERE p.status = 'ACTIVE' AND s.is_active = 1 AND p.stock_quantity > 0
        """);
        
        List<Object> params = new ArrayList<>();
        
        // Add search filter
        if (query != null && !query.trim().isEmpty()) {
            sql.append(" AND (p.product_name LIKE ? OR p.product_description LIKE ? OR s.shop_name LIKE ?)");
            String searchPattern = "%" + query.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        // Add category filter
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND p.category_id = ?");
            params.add(categoryId);
        }
        
        // Add sorting
        switch (sortBy != null ? sortBy : "popular") {
            case "price_asc":
                sql.append(" ORDER BY COALESCE(p.sale_price, p.price) ASC");
                break;
            case "price_desc":
                sql.append(" ORDER BY COALESCE(p.sale_price, p.price) DESC");
                break;
            case "rating":
                sql.append(" ORDER BY p.total_rating DESC, p.total_reviews DESC");
                break;
            case "newest":
                sql.append(" ORDER BY p.created_at DESC");
                break;
            default: // popular
                sql.append(" ORDER BY p.total_sold DESC, p.total_rating DESC");
        }
        
        // Add pagination
        sql.append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        
        List<Map<String, Object>> products = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                stmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> product = new HashMap<>();
                    product.put("product_id", rs.getInt("product_id"));
                    product.put("product_name", rs.getString("product_name"));
                    product.put("product_description", rs.getString("product_description"));
                    product.put("price", rs.getDouble("price"));
                    product.put("sale_price", rs.getDouble("sale_price"));
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
                    product.put("total_sold", rs.getInt("total_sold"));
                    product.put("shop_id", rs.getInt("shop_id"));
                    product.put("shop_name", rs.getString("shop_name"));
                    product.put("shop_verified", rs.getBoolean("is_verified"));
                    product.put("category_name", rs.getString("category_name"));
                    product.put("image_url", rs.getString("image_url"));
                    product.put("discount_percent", rs.getInt("discount_percent"));
                    
                    products.add(product);
                }
            }
        }
        
        return products;
    }

    /**
     * Get featured products for homepage
     */
    public List<Map<String, Object>> getFeaturedProducts(int limit) throws SQLException {
        String sql = """
            SELECT p.product_id, p.product_name, p.price, p.sale_price,
                   p.total_rating, p.total_reviews, p.total_sold,
                   s.shop_name, s.is_verified,
                   pi.image_url,
                   CASE WHEN p.sale_price > 0 AND p.sale_price < p.price 
                        THEN ROUND(((p.price - p.sale_price) / p.price) * 100)
                        ELSE 0 END as discount_percent
            FROM products p
            JOIN shops s ON p.shop_id = s.shop_id
            LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
            WHERE p.status = 'ACTIVE' AND s.is_active = 1 AND s.is_verified = 1 AND p.stock_quantity > 0
            ORDER BY (p.total_sold * 0.7 + p.total_rating * p.total_reviews * 0.3) DESC
            LIMIT ?
        """;
        
        List<Map<String, Object>> products = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> product = new HashMap<>();
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
                    
                    product.put("total_rating", Math.round(rs.getDouble("total_rating") * 10.0) / 10.0);
                    product.put("total_reviews", rs.getInt("total_reviews"));
                    product.put("total_sold", rs.getInt("total_sold"));
                    product.put("shop_name", rs.getString("shop_name"));
                    product.put("shop_verified", rs.getBoolean("is_verified"));
                    product.put("image_url", rs.getString("image_url"));
                    product.put("discount_percent", rs.getInt("discount_percent"));
                    
                    products.add(product);
                }
            }
        }
        
        return products;
    }

    /**
     * Get products by category
     */
    public List<Map<String, Object>> getProductsByCategory(int categoryId, int limit) throws SQLException {
        String sql = """
            SELECT p.product_id, p.product_name, p.price, p.sale_price,
                   p.total_rating, p.total_reviews, p.total_sold,
                   s.shop_name, pi.image_url,
                   CASE WHEN p.sale_price > 0 AND p.sale_price < p.price 
                        THEN ROUND(((p.price - p.sale_price) / p.price) * 100)
                        ELSE 0 END as discount_percent
            FROM products p
            JOIN shops s ON p.shop_id = s.shop_id
            LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
            WHERE p.category_id = ? AND p.status = 'ACTIVE' AND s.is_active = 1 AND p.stock_quantity > 0
            ORDER BY p.total_sold DESC, p.total_rating DESC
            LIMIT ?
        """;
        
        List<Map<String, Object>> products = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, categoryId);
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
                    
                    product.put("total_rating", rs.getDouble("total_rating"));
                    product.put("total_reviews", rs.getInt("total_reviews"));
                    product.put("total_sold", rs.getInt("total_sold"));
                    product.put("shop_name", rs.getString("shop_name"));
                    product.put("image_url", rs.getString("image_url"));
                    product.put("discount_percent", rs.getInt("discount_percent"));
                    
                    products.add(product);
                }
            }
        }
        
        return products;
    }

    /**
     * Quick search for autocomplete
     */
    public List<Map<String, Object>> quickSearch(String query, int limit) throws SQLException {
        String sql = """
            SELECT p.product_id, p.product_name, p.price, p.sale_price,
                   s.shop_name, pi.image_url
            FROM products p
            JOIN shops s ON p.shop_id = s.shop_id
            LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
            WHERE p.status = 'ACTIVE' AND s.is_active = 1 AND p.stock_quantity > 0
                AND (p.product_name LIKE ? OR s.shop_name LIKE ?)
            ORDER BY p.total_sold DESC
            LIMIT ?
        """;
        
        List<Map<String, Object>> results = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + query.trim() + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setInt(3, limit);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> result = new HashMap<>();
                    result.put("product_id", rs.getInt("product_id"));
                    result.put("product_name", rs.getString("product_name"));
                    
                    double price = rs.getDouble("price");
                    double salePrice = rs.getDouble("sale_price");
                    String displayPrice = salePrice > 0 ? formatCurrency(salePrice) : formatCurrency(price);
                    
                    result.put("price", displayPrice);
                    result.put("shop_name", rs.getString("shop_name"));
                    result.put("image_url", rs.getString("image_url"));
                    
                    results.add(result);
                }
            }
        }
        
        return results;
    }

    private String formatCurrency(double amount) {
        return String.format("%,.0f₫", amount);
    }
}
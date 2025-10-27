package vn.ute.uteshop.services;

import vn.ute.uteshop.config.DataSourceFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.*;

/**
 * HomeDataService - COMPLETE VERSION
 * Cung cấp dữ liệu cho:
 * - Home (User): danh mục, sản phẩm nổi bật, shop nổi bật, từ khóa thịnh hành, sản phẩm đã xem, thống kê user
 * - Admin home: analytics/tổng quan hệ thống
 * - Vendor home: shop của vendor, thống kê, đơn gần đây, sản phẩm sắp hết hàng
 *
 * Chú ý mapping schema:
 * - shops.owner_id (chủ shop) → dùng để lấy shop theo user vendor
 * - shopping_carts (giỏ hàng theo user)
 * - product_reviews (bảng review)
 * - user_viewed_products (sản phẩm đã xem)
 */
public class HomeDataService {

    private static final DecimalFormat CURRENCY_FORMAT = new DecimalFormat("#,###");
    private static final int MAX_FEATURED_ITEMS = 20;

    public HomeDataService() {
        System.out.println("✅ HomeDataService initialized");
    }

    // ================= Home (User) sections =================

    public List<Map<String, Object>> getFeaturedCategories() {
        List<Map<String, Object>> categories = new ArrayList<>();
        String sql = """
            SELECT 
                c.category_id,
                c.category_name,
                c.category_description,
                c.category_image,
                COUNT(p.product_id) as product_count
            FROM categories c
            LEFT JOIN products p ON c.category_id = p.category_id AND p.status = 'ACTIVE'
            WHERE c.is_active = 1
            GROUP BY c.category_id, c.category_name, c.category_description, c.category_image
            HAVING product_count > 0
            ORDER BY product_count DESC, c.category_name ASC
            LIMIT 8
        """;
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> m = new HashMap<>();
                int id = rs.getInt("category_id");
                String name = rs.getString("category_name");
                String desc = rs.getString("category_description");
                String img = rs.getString("category_image");
                int cnt = rs.getInt("product_count");

                m.put("categoryId", id);
                m.put("category_id", id);
                m.put("categoryName", name);
                m.put("category_name", name);
                m.put("categoryDescription", desc != null ? desc : "Khám phá danh mục " + name);
                m.put("category_description", desc != null ? desc : "Khám phá danh mục " + name);
                m.put("categoryImage", img);
                m.put("category_image", img);
                m.put("productCount", cnt);
                m.put("product_count", cnt);
                categories.add(m);
            }
        } catch (SQLException e) {
            System.err.println("⚠️ getFeaturedCategories error: " + e.getMessage());
            categories = getFallbackCategories();
        }
        return categories;
    }

    public List<Map<String, Object>> getFeaturedProducts() {
        List<Map<String, Object>> products = new ArrayList<>();
        String sql = """
            SELECT 
                p.product_id,
                p.product_name,
                p.product_description,
                p.price,
                p.sale_price,
                p.stock_quantity,
                p.brand,
                p.condition_type,
                p.total_rating,
                p.total_reviews,
                p.total_sold,
                p.status,
                p.created_at,
                s.shop_name,
                c.category_name,
                pi.image_url,
                CASE 
                    WHEN p.sale_price IS NOT NULL AND p.sale_price > 0 AND p.sale_price < p.price THEN 1
                    ELSE 0
                END as has_discount,
                CASE 
                    WHEN p.created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY) THEN 1
                    ELSE 0
                END as is_new
            FROM products p
            LEFT JOIN shops s ON p.shop_id = s.shop_id
            LEFT JOIN categories c ON p.category_id = c.category_id
            LEFT JOIN (
                SELECT product_id, image_url
                FROM product_images
                WHERE is_primary = 1
                GROUP BY product_id
            ) pi ON p.product_id = pi.product_id
            WHERE p.status = 'ACTIVE' AND p.stock_quantity > 0 AND s.is_active = 1
            ORDER BY p.total_sold DESC, p.total_rating DESC, p.created_at DESC
            LIMIT ?
        """;
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, MAX_FEATURED_ITEMS);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    products.add(createProductMap(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("⚠️ getFeaturedProducts error: " + e.getMessage());
            products = getFallbackProducts();
        }
        return products;
    }

    public List<Map<String, Object>> getFeaturedShops() {
        List<Map<String, Object>> shops = new ArrayList<>();
        String sql = """
            SELECT 
                s.shop_id,
                s.shop_name,
                s.shop_description,
                s.shop_logo,
                s.shop_banner,
                s.total_rating,
                s.total_reviews,
                s.is_verified,
                s.is_active,
                s.created_at,
                COUNT(DISTINCT p.product_id) as product_count,
                COUNT(DISTINCT CASE WHEN p.status = 'ACTIVE' THEN p.product_id END) as active_product_count,
                AVG(p.price) as avg_price,
                SUM(p.total_sold) as total_sales
            FROM shops s
            LEFT JOIN products p ON s.shop_id = p.shop_id
            WHERE s.is_active = 1
            GROUP BY s.shop_id, s.shop_name, s.shop_description, s.shop_logo, s.shop_banner, 
                     s.total_rating, s.total_reviews, s.is_verified, s.is_active, s.created_at
            HAVING active_product_count > 0
            ORDER BY s.is_verified DESC, s.total_rating DESC, total_sales DESC, active_product_count DESC
            LIMIT 10
        """;
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                shops.add(createShopMap(rs));
            }
        } catch (SQLException e) {
            System.err.println("⚠️ getFeaturedShops error: " + e.getMessage());
            shops = getFallbackShops();
        }
        return shops;
    }

    public Map<String, Object> getUserStats(int userId) {
        Map<String, Object> stats = new HashMap<>();
        try (Connection conn = DataSourceFactory.getConnection()) {
            String orderSql = """
                SELECT 
                    COUNT(*) as order_count,
                    COUNT(CASE WHEN order_status = 'DELIVERED' THEN 1 END) as completed_orders,
                    COUNT(CASE WHEN order_status IN ('NEW','CONFIRMED','PROCESSING','SHIPPING') THEN 1 END) as pending_orders,
                    COALESCE(SUM(CASE WHEN order_status != 'CANCELLED' THEN total_amount ELSE 0 END), 0) as total_spent,
                    COALESCE(MAX(created_at), NOW()) as last_order_date
                FROM orders 
                WHERE user_id = ?
            """;
            try (PreparedStatement stmt = conn.prepareStatement(orderSql)) {
                stmt.setInt(1, userId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) {
                        stats.put("orderCount", rs.getInt("order_count"));
                        stats.put("completedOrders", rs.getInt("completed_orders"));
                        stats.put("pendingOrders", rs.getInt("pending_orders"));
                        stats.put("totalSpent", rs.getDouble("total_spent"));
                        stats.put("formattedTotalSpent", CURRENCY_FORMAT.format(rs.getDouble("total_spent")) + "₫");
                        stats.put("lastOrderDate", rs.getTimestamp("last_order_date"));
                    }
                }
            }

            // wishlist
            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT COUNT(*) FROM user_favorites WHERE user_id = ?")) {
                stmt.setInt(1, userId);
                try (ResultSet rs = stmt.executeQuery()) {
                    stats.put("wishlistCount", rs.next() ? rs.getInt(1) : 0);
                }
            } catch (SQLException e) {
                stats.put("wishlistCount", 0);
            }

            // cart (đúng schema: shopping_carts)
            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT COUNT(*) FROM shopping_carts WHERE user_id = ?")) {
                stmt.setInt(1, userId);
                try (ResultSet rs = stmt.executeQuery()) {
                    stats.put("cartCount", rs.next() ? rs.getInt(1) : 0);
                }
            } catch (SQLException e) {
                stats.put("cartCount", 0);
            }

            // reviews (đúng schema: product_reviews)
            try (PreparedStatement stmt = conn.prepareStatement(
                    "SELECT COUNT(*) FROM product_reviews WHERE user_id = ?")) {
                stmt.setInt(1, userId);
                try (ResultSet rs = stmt.executeQuery()) {
                    stats.put("reviewCount", rs.next() ? rs.getInt(1) : 0);
                }
            } catch (SQLException e) {
                stats.put("reviewCount", 0);
            }

            double totalSpent = ((Number) stats.getOrDefault("totalSpent", 0.0)).doubleValue();
            stats.put("userLevel", calculateUserLevel(totalSpent));

        } catch (SQLException e) {
            System.err.println("⚠️ getUserStats error: " + e.getMessage());
            setDefaultUserStats(stats);
        }
        return stats;
    }

    public List<Map<String, Object>> getRecentlyViewedProducts(int userId, int limit) {
        List<Map<String, Object>> items = new ArrayList<>();
        String sql = """
            SELECT DISTINCT 
                p.product_id, 
                p.product_name, 
                p.price, 
                p.sale_price,
                pi.image_url,
                s.shop_name,
                uv.viewed_at
            FROM user_viewed_products uv
            JOIN products p ON uv.product_id = p.product_id
            LEFT JOIN shops s ON p.shop_id = s.shop_id
            LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
            WHERE uv.user_id = ? AND p.status = 'ACTIVE'
            ORDER BY uv.viewed_at DESC
            LIMIT ?
        """;
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("productId", rs.getInt("product_id"));
                    m.put("productName", rs.getString("product_name"));
                    m.put("price", rs.getDouble("price"));
                    Object sale = rs.getObject("sale_price");
                    m.put("salePrice", sale);
                    m.put("imageUrl", rs.getString("image_url"));
                    m.put("shopName", rs.getString("shop_name"));
                    m.put("viewedAt", rs.getTimestamp("viewed_at"));
                    double finalPrice = sale != null ? rs.getDouble("sale_price") : rs.getDouble("price");
                    m.put("formattedPrice", CURRENCY_FORMAT.format(finalPrice) + "₫");
                    items.add(m);
                }
            }
        } catch (SQLException e) {
            System.err.println("⚠️ getRecentlyViewedProducts error: " + e.getMessage());
        }
        return items;
    }

    public List<Map<String, Object>> getRecentlyViewedProducts(int userId) {
        return getRecentlyViewedProducts(userId, 6);
    }

    public List<String> getTrendingKeywords() {
        List<String> keywords = new ArrayList<>();
        String sql = """
            SELECT search_term, COUNT(*) as search_count 
            FROM search_logs 
            WHERE created_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)
              AND search_term IS NOT NULL 
              AND TRIM(search_term) != ''
            GROUP BY search_term 
            HAVING search_count > 1
            ORDER BY search_count DESC 
            LIMIT 15
        """;
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                keywords.add(rs.getString("search_term"));
            }
        } catch (SQLException e) {
            System.err.println("⚠️ getTrendingKeywords error: " + e.getMessage());
            keywords.addAll(Arrays.asList(
                "iPhone", "Samsung", "MacBook", "PlayStation", "Gaming",
                "Laptop", "Smartphone", "Tablet", "Headphones", "Camera", "Watch"
            ));
        }
        return keywords;
    }

    public Map<String, Object> getHomeAnalytics() {
        Map<String, Object> analytics = new HashMap<>();
        try (Connection conn = DataSourceFactory.getConnection()) {
            String counts = """
                SELECT 
                    (SELECT COUNT(*) FROM products WHERE status = 'ACTIVE') as total_products,
                    (SELECT COUNT(*) FROM shops WHERE is_active = 1) as total_shops,
                    (SELECT COUNT(*) FROM categories WHERE is_active = 1) as total_categories,
                    (SELECT COUNT(*) FROM users WHERE is_active = 1) as total_users,
                    (SELECT COUNT(*) FROM orders WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)) as monthly_orders,
                    (SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE created_at >= DATE_SUB(NOW(), INTERVAL 30 DAY)) as monthly_revenue
            """;
            try (PreparedStatement stmt = conn.prepareStatement(counts);
                 ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    analytics.put("totalProducts", rs.getInt("total_products"));
                    analytics.put("totalShops", rs.getInt("total_shops"));
                    analytics.put("totalCategories", rs.getInt("total_categories"));
                    analytics.put("totalUsers", rs.getInt("total_users"));
                    analytics.put("monthlyOrders", rs.getInt("monthly_orders"));
                    double rev = rs.getDouble("monthly_revenue");
                    analytics.put("monthlyRevenue", rev);
                    analytics.put("formattedMonthlyRevenue", CURRENCY_FORMAT.format(rev) + "₫");
                }
            }
        } catch (SQLException e) {
            System.err.println("⚠️ getHomeAnalytics error: " + e.getMessage());
            setDefaultAnalytics(analytics);
        }
        return analytics;
    }

    public boolean testConnection() {
        try (Connection conn = DataSourceFactory.getConnection()) {
            try (PreparedStatement stmt = conn.prepareStatement("SELECT 1");
                 ResultSet rs = stmt.executeQuery()) {
                // ok
            }
            String[] tables = {"categories", "products", "shops", "users", "orders"};
            for (String t : tables) {
                try (PreparedStatement stmt = conn.prepareStatement("SELECT COUNT(*) FROM " + t + " LIMIT 1")) {
                    stmt.executeQuery();
                }
            }
            return true;
        } catch (SQLException e) {
            System.err.println("❌ testConnection failed: " + e.getMessage());
            return false;
        }
    }

    // ====================== VENDOR HELPERS ==========================

    /**
     * Lấy shop theo chủ sở hữu vendor (shops.owner_id)
     */
    public Map<String, Object> getVendorShopByUser(int userId) {
        String sql = """
            SELECT 
                s.shop_id,
                s.shop_name,
                s.shop_description,
                s.shop_logo,
                s.shop_banner,
                s.total_rating,
                s.total_reviews,
                s.is_verified,
                s.is_active,
                s.created_at,
                COUNT(DISTINCT p.product_id) AS product_count
            FROM shops s
            LEFT JOIN products p ON p.shop_id = s.shop_id
            WHERE s.owner_id = ?
            GROUP BY s.shop_id, s.shop_name, s.shop_description, s.shop_logo, s.shop_banner, 
                     s.total_rating, s.total_reviews, s.is_verified, s.is_active, s.created_at
            LIMIT 1
        """;

        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> shop = new HashMap<>();
                    shop.put("shopId", rs.getInt("shop_id"));
                    shop.put("shop_id", rs.getInt("shop_id"));
                    shop.put("shop_name", rs.getString("shop_name"));
                    shop.put("shop_description", rs.getString("shop_description"));
                    shop.put("shop_logo", rs.getString("shop_logo"));
                    shop.put("shop_banner", rs.getString("shop_banner"));
                    shop.put("total_rating", rs.getDouble("total_rating"));
                    shop.put("total_reviews", rs.getInt("total_reviews"));
                    shop.put("is_verified", rs.getBoolean("is_verified"));
                    shop.put("is_active", rs.getBoolean("is_active"));
                    shop.put("product_count", rs.getInt("product_count"));
                    return shop;
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ getVendorShopByUser error: " + e.getMessage());
        }
        return null;
    }

    /**
     * Thống kê nhanh cho vendor (theo shop_id)
     */
    public Map<String, Object> getVendorStats(int shopId) {
        Map<String, Object> stats = new HashMap<>();

        String sql = """
            SELECT
                (SELECT COUNT(*) FROM products WHERE shop_id = ?) AS total_products,
                (SELECT COUNT(*) FROM products WHERE shop_id = ? AND status = 'ACTIVE' AND stock_quantity > 0) AS in_stock_products,
                (SELECT COUNT(*) FROM orders WHERE shop_id = ?) AS total_orders,
                (SELECT COUNT(*) FROM orders WHERE shop_id = ? AND order_status IN ('NEW','CONFIRMED','PROCESSING','SHIPPING')) AS pending_orders,
                (SELECT COALESCE(SUM(total_amount),0) FROM orders WHERE shop_id = ?) AS total_revenue,
                (SELECT COALESCE(SUM(total_amount),0) FROM orders WHERE shop_id = ? AND DATE(created_at) = CURRENT_DATE()) AS revenue_today,
                (SELECT COUNT(*) FROM products WHERE shop_id = ? AND stock_quantity <= 5) AS low_stock_products
        """;

        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            int i = 1;
            stmt.setInt(i++, shopId);
            stmt.setInt(i++, shopId);
            stmt.setInt(i++, shopId);
            stmt.setInt(i++, shopId);
            stmt.setInt(i++, shopId);
            stmt.setInt(i++, shopId);
            stmt.setInt(i++, shopId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("total_products", rs.getInt("total_products"));
                    stats.put("in_stock_products", rs.getInt("in_stock_products"));
                    stats.put("total_orders", rs.getInt("total_orders"));
                    stats.put("pending_orders", rs.getInt("pending_orders"));
                    stats.put("total_revenue", CURRENCY_FORMAT.format(rs.getDouble("total_revenue")) + "₫");
                    stats.put("revenue_today", CURRENCY_FORMAT.format(rs.getDouble("revenue_today")) + "₫");
                    stats.put("low_stock_products", rs.getInt("low_stock_products"));
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ getVendorStats error: " + e.getMessage());
            stats.put("total_products", 0);
            stats.put("in_stock_products", 0);
            stats.put("total_orders", 0);
            stats.put("pending_orders", 0);
            stats.put("total_revenue", "0₫");
            stats.put("revenue_today", "0₫");
            stats.put("low_stock_products", 0);
        }
        return stats;
    }

    /**
     * Đơn hàng gần đây của shop
     */
    public List<Map<String, Object>> getVendorRecentOrders(int shopId, int limit) {
        List<Map<String, Object>> orders = new ArrayList<>();

        String sql = """
            SELECT 
                o.order_id,
                o.order_number,
                u.full_name AS customer_name,
                o.total_amount,
                o.order_status,
                o.created_at,
                COALESCE(SUM(od.quantity), 0) AS item_count
            FROM orders o
            LEFT JOIN order_details od ON od.order_id = o.order_id
            LEFT JOIN users u ON u.user_id = o.user_id
            WHERE o.shop_id = ?
            GROUP BY o.order_id, o.order_number, customer_name, o.total_amount, o.order_status, o.created_at
            ORDER BY o.created_at DESC
            LIMIT ?
        """;

        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, shopId);
            stmt.setInt(2, limit);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("order_id", rs.getInt("order_id"));
                    m.put("order_number", rs.getString("order_number"));
                    m.put("customer_name", rs.getString("customer_name"));
                    m.put("total_amount", CURRENCY_FORMAT.format(rs.getDouble("total_amount")) + "₫");
                    m.put("order_status", rs.getString("order_status"));
                    m.put("created_at", rs.getTimestamp("created_at"));
                    m.put("item_count", rs.getInt("item_count"));
                    orders.add(m);
                }
            }
        } catch (SQLException e) {
            System.err.println("⚠️ getVendorRecentOrders error: " + e.getMessage());
        }
        return orders;
    }

    /**
     * Sản phẩm sắp hết hàng: stock_quantity <= 5
     */
    public List<Map<String, Object>> getLowStockProducts(int shopId, int limit) {
        List<Map<String, Object>> items = new ArrayList<>();

        String sql = """
            SELECT 
                p.product_id,
                p.product_name,
                p.stock_quantity,
                pi.image_url
            FROM products p
            LEFT JOIN product_images pi 
                ON pi.product_id = p.product_id AND pi.is_primary = 1
            WHERE p.shop_id = ? AND p.stock_quantity <= 5
            ORDER BY p.stock_quantity ASC, p.product_id ASC
            LIMIT ?
        """;

        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, shopId);
            stmt.setInt(2, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> m = new HashMap<>();
                    m.put("product_id", rs.getInt("product_id"));
                    m.put("product_name", rs.getString("product_name"));
                    m.put("stock_quantity", rs.getInt("stock_quantity"));
                    m.put("min_stock_level", 5); // hiển thị min mặc định
                    m.put("image_url", rs.getString("image_url"));
                    items.add(m);
                }
            }
        } catch (SQLException e) {
            System.err.println("⚠️ getLowStockProducts error: " + e.getMessage());
        }
        return items;
    }

    // ================= Helpers & fallbacks =================

    private Map<String, Object> createProductMap(ResultSet rs) throws SQLException {
        Map<String, Object> p = new HashMap<>();
        int id = rs.getInt("product_id");
        String name = rs.getString("product_name");
        String desc = rs.getString("product_description");
        double price = rs.getDouble("price");
        Object saleObj = rs.getObject("sale_price");
        Double sale = saleObj != null ? rs.getDouble("sale_price") : null;
        int stock = rs.getInt("stock_quantity");
        String brand = rs.getString("brand");
        String conditionType = rs.getString("condition_type");
        double rating = rs.getDouble("total_rating");
        int reviews = rs.getInt("total_reviews");
        int sold = rs.getInt("total_sold");
        String status = rs.getString("status");
        String shopName = rs.getString("shop_name");
        String categoryName = rs.getString("category_name");
        String imageUrl = rs.getString("image_url");
        boolean hasDiscount = rs.getBoolean("has_discount");
        p.put("productId", id);
        p.put("product_id", id);
        p.put("productName", name);
        p.put("product_name", name);
        p.put("productDescription", desc);
        p.put("product_description", desc);
        p.put("price", price);
        p.put("salePrice", sale);
        p.put("sale_price", sale);
        p.put("stockQuantity", stock);
        p.put("stock_quantity", stock);
        p.put("brand", brand != null ? brand : "UTESHOP");
        p.put("conditionType", conditionType);
        p.put("condition_type", conditionType);
        p.put("totalRating", rating);
        p.put("total_rating", rating);
        p.put("totalReviews", reviews);
        p.put("total_reviews", reviews);
        p.put("totalSold", sold);
        p.put("total_sold", sold);
        p.put("status", status);
        p.put("shopName", shopName != null ? shopName : "UTESHOP Store");
        p.put("shop_name", shopName != null ? shopName : "UTESHOP Store");
        p.put("categoryName", categoryName);
        p.put("category_name", categoryName);
        p.put("imageUrl", imageUrl != null ? imageUrl : "/assets/images/default-product.png");
        p.put("image_url", imageUrl != null ? imageUrl : "/assets/images/default-product.png");
        p.put("inStock", stock > 0 && "ACTIVE".equals(status));
        p.put("ratingStars", Math.min(5, Math.max(0, (int) Math.round(rating))));
        p.put("reviewCount", reviews);
        double finalPrice = sale != null && sale > 0 ? sale : price;
        p.put("finalPrice", finalPrice);
        p.put("formattedPrice", CURRENCY_FORMAT.format(finalPrice) + "₫");
        if (hasDiscount && sale != null && sale > 0 && sale < price) {
            p.put("hasDiscount", true);
            p.put("originalPrice", CURRENCY_FORMAT.format(price) + "₫");
            p.put("discountAmount", price - sale);
            p.put("discountPercent", Math.round(((price - sale) / price) * 100));
        } else {
            p.put("hasDiscount", false);
            p.put("discountPercent", 0);
        }
        return p;
    }

    private Map<String, Object> createShopMap(ResultSet rs) throws SQLException {
        Map<String, Object> m = new HashMap<>();
        int shopId = rs.getInt("shop_id");
        m.put("shopId", shopId);
        m.put("shop_id", shopId);
        m.put("shopName", rs.getString("shop_name"));
        m.put("shop_name", rs.getString("shop_name"));
        String desc = rs.getString("shop_description");
        m.put("shopDescription", desc != null ? desc : "Cửa hàng uy tín, chất lượng cao");
        m.put("shop_description", desc != null ? desc : "Cửa hàng uy tín, chất lượng cao");
        m.put("shopLogo", rs.getString("shop_logo"));
        m.put("shop_logo", rs.getString("shop_logo"));
        m.put("shopBanner", rs.getString("shop_banner"));
        m.put("shop_banner", rs.getString("shop_banner"));
        double rating = rs.getDouble("total_rating");
        int reviews = rs.getInt("total_reviews");
        m.put("totalRating", rating);
        m.put("total_rating", rating);
        m.put("totalReviews", reviews);
        m.put("total_reviews", reviews);
        m.put("isVerified", rs.getBoolean("is_verified"));
        m.put("is_verified", rs.getBoolean("is_verified"));
        m.put("isActive", rs.getBoolean("is_active"));
        m.put("is_active", rs.getBoolean("is_active"));
        m.put("productCount", rs.getInt("product_count"));
        m.put("product_count", rs.getInt("product_count"));
        m.put("activeProductCount", rs.getInt("active_product_count"));
        m.put("active_product_count", rs.getInt("active_product_count"));
        double avgPrice = rs.getDouble("avg_price");
        m.put("avgPrice", avgPrice);
        m.put("avg_price", avgPrice);
        m.put("totalSales", rs.getInt("total_sales"));
        m.put("total_sales", rs.getInt("total_sales"));
        m.put("ratingStars", Math.min(5, Math.max(0, (int) Math.round(rating))));
        m.put("reviewCount", reviews);
        m.put("formattedAvgPrice", CURRENCY_FORMAT.format(avgPrice) + "₫");
        return m;
    }

    private void setDefaultUserStats(Map<String, Object> stats) {
        stats.put("orderCount", 0);
        stats.put("completedOrders", 0);
        stats.put("pendingOrders", 0);
        stats.put("totalSpent", 0.0);
        stats.put("formattedTotalSpent", "0₫");
        stats.put("wishlistCount", 0);
        stats.put("cartCount", 0);
        stats.put("reviewCount", 0);
        stats.put("userLevel", "Member");
        stats.put("lastOrderDate", null);
    }

    private void setDefaultAnalytics(Map<String, Object> analytics) {
        analytics.put("totalProducts", 0);
        analytics.put("totalShops", 0);
        analytics.put("totalCategories", 0);
        analytics.put("totalUsers", 0);
        analytics.put("monthlyOrders", 0);
        analytics.put("monthlyRevenue", 0.0);
        analytics.put("formattedMonthlyRevenue", "0₫");
        analytics.put("popularCategories", new ArrayList<>());
    }

    private List<Map<String, Object>> getFallbackCategories() {
        List<Map<String, Object>> categories = new ArrayList<>();
        String[] names = {"Điện tử", "Thời trang", "Gia dụng", "Sách & Văn phòng phẩm", "Thể thao & Du lịch"};
        for (int i = 0; i < names.length; i++) {
            Map<String, Object> c = new HashMap<>();
            c.put("categoryId", i + 1);
            c.put("category_id", i + 1);
            c.put("categoryName", names[i]);
            c.put("category_name", names[i]);
            c.put("categoryDescription", "Khám phá danh mục " + names[i]);
            c.put("category_description", "Khám phá danh mục " + names[i]);
            c.put("productCount", (i + 1) * 10);
            c.put("product_count", (i + 1) * 10);
            categories.add(c);
        }
        return categories;
    }

    private List<Map<String, Object>> getFallbackProducts() {
        List<Map<String, Object>> products = new ArrayList<>();
        String[] productNames = {"iPhone 15 Pro", "Samsung Galaxy S24", "MacBook Pro M3", "PlayStation 5"};
        for (int i = 0; i < productNames.length; i++) {
            Map<String, Object> p = new HashMap<>();
            p.put("productId", i + 1);
            p.put("product_id", i + 1);
            p.put("productName", productNames[i]);
            p.put("product_name", productNames[i]);
            p.put("price", (i + 1) * 5000000.0);
            p.put("formattedPrice", CURRENCY_FORMAT.format((i + 1) * 5000000) + "₫");
            p.put("brand", "UTESHOP");
            p.put("shopName", "UTESHOP Store");
            p.put("shop_name", "UTESHOP Store");
            p.put("imageUrl", "/assets/images/default-product.png");
            p.put("image_url", "/assets/images/default-product.png");
            p.put("inStock", true);
            p.put("ratingStars", 5);
            p.put("reviewCount", (i + 1) * 10);
            p.put("hasDiscount", false);
            products.add(p);
        }
        return products;
    }

    private List<Map<String, Object>> getFallbackShops() {
        List<Map<String, Object>> shops = new ArrayList<>();
        String[] names = {"Tech Store", "Fashion World", "Home Living", "Book Corner"};
        for (int i = 0; i < names.length; i++) {
            Map<String, Object> s = new HashMap<>();
            s.put("shopId", i + 1);
            s.put("shop_id", i + 1);
            s.put("shopName", names[i]);
            s.put("shop_name", names[i]);
            s.put("shopDescription", "Cửa hàng uy tín, chất lượng cao");
            s.put("shop_description", "Cửa hàng uy tín, chất lượng cao");
            s.put("ratingStars", 5);
            s.put("reviewCount", (i + 1) * 20);
            s.put("isVerified", true);
            s.put("is_verified", true);
            s.put("productCount", (i + 1) * 50);
            s.put("product_count", (i + 1) * 50);
            shops.add(s);
        }
        return shops;
    }

    /**
     * Xếp hạng người dùng theo tổng chi tiêu (đơn vị VND)
     */
    private String calculateUserLevel(double totalSpent) {
        if (totalSpent >= 50_000_000) return "Platinum";
        if (totalSpent >= 20_000_000) return "Gold";
        if (totalSpent >= 5_000_000)  return "Silver";
        if (totalSpent >= 1_000_000)  return "Bronze";
        return "Member";
    }
}
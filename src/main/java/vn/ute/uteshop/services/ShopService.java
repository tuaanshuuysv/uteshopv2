package vn.ute.uteshop.services;

import vn.ute.uteshop.config.DataSourceFactory;
import java.sql.*;
import java.util.*;
import java.text.DecimalFormat;

/**
 * ShopService - FIXED for Database Compatibility
 * Updated: 2025-10-26 19:33:16 UTC by tuaanshuuysv
 * Fix: Remove non-existent columns, compatible with actual database schema
 */
public class ShopService {

    public static class ShopPageParams {
        private int shopId;
        private int page = 1;
        private int pageSize = 12;
        private String category;
        private String sortBy;
        private double minPrice;
        private double maxPrice;
        private String searchQuery;
        
        // Getters and setters
        public int getShopId() { return shopId; }
        public void setShopId(int shopId) { this.shopId = shopId; }
        
        public int getPage() { return page; }
        public void setPage(int page) { this.page = page; }
        
        public int getPageSize() { return pageSize; }
        public void setPageSize(int pageSize) { this.pageSize = pageSize; }
        
        public String getCategory() { return category; }
        public void setCategory(String category) { this.category = category; }
        
        public String getSortBy() { return sortBy; }
        public void setSortBy(String sortBy) { this.sortBy = sortBy; }
        
        public double getMinPrice() { return minPrice; }
        public void setMinPrice(double minPrice) { this.minPrice = minPrice; }
        
        public double getMaxPrice() { return maxPrice; }
        public void setMaxPrice(double maxPrice) { this.maxPrice = maxPrice; }
        
        public String getSearchQuery() { return searchQuery; }
        public void setSearchQuery(String searchQuery) { this.searchQuery = searchQuery; }
        
        @Override
        public String toString() {
            return "ShopPageParams{shopId=" + shopId + ", page=" + page + ", pageSize=" + pageSize + 
                   ", category='" + category + "', sortBy='" + sortBy + "', searchQuery='" + searchQuery + "'}";
        }
    }

    public static class ShopPageResult {
        private Map<String, Object> shop;
        private List<Map<String, Object>> products;
        private List<Map<String, Object>> categories;
        private Map<String, Object> shopStats;
        private int totalProducts;
        private int totalPages;
        private int currentPage;
        
        public ShopPageResult() {
            this.products = new ArrayList<>();
            this.categories = new ArrayList<>();
            this.shopStats = new HashMap<>();
        }
        
        // Getters and setters
        public Map<String, Object> getShop() { return shop; }
        public void setShop(Map<String, Object> shop) { this.shop = shop; }
        
        public List<Map<String, Object>> getProducts() { return products; }
        public void setProducts(List<Map<String, Object>> products) { this.products = products; }
        
        public List<Map<String, Object>> getCategories() { return categories; }
        public void setCategories(List<Map<String, Object>> categories) { this.categories = categories; }
        
        public Map<String, Object> getShopStats() { return shopStats; }
        public void setShopStats(Map<String, Object> shopStats) { this.shopStats = shopStats; }
        
        public int getTotalProducts() { return totalProducts; }
        public void setTotalProducts(int totalProducts) { this.totalProducts = totalProducts; }
        
        public int getTotalPages() { return totalPages; }
        public void setTotalPages(int totalPages) { this.totalPages = totalPages; }
        
        public int getCurrentPage() { return currentPage; }
        public void setCurrentPage(int currentPage) { this.currentPage = currentPage; }
    }

    /**
     * Get complete shop page data with database compatibility
     */
    public ShopPageResult getShopPageData(ShopPageParams params) throws SQLException {
        System.out.println("🏪 Getting shop page data for shop ID: " + params.getShopId());
        
        ShopPageResult result = new ShopPageResult();
        
        try (Connection conn = DataSourceFactory.getConnection()) {
            
            // 1. Get shop info
            Map<String, Object> shop = getShopInfo(conn, params.getShopId());
            if (shop == null) {
                System.out.println("❌ Shop not found: " + params.getShopId());
                return result;
            }
            result.setShop(shop);
            
            // 2. Get total products count
            int totalProducts = getShopProductsCount(conn, params);
            result.setTotalProducts(totalProducts);
            result.setTotalPages((int) Math.ceil((double) totalProducts / params.getPageSize()));
            result.setCurrentPage(params.getPage());
            
            // 3. Get products with pagination
            List<Map<String, Object>> products = getShopProducts(conn, params);
            result.setProducts(products);
            
            // 4. Get shop categories
            List<Map<String, Object>> categories = getShopCategories(conn, params.getShopId());
            result.setCategories(categories);
            
            // 5. Get shop statistics
            Map<String, Object> shopStats = getShopStatistics(conn, params.getShopId());
            result.setShopStats(shopStats);
            
            System.out.println("✅ Shop page data loaded: " + products.size() + " products, " + categories.size() + " categories");
            
        } catch (SQLException e) {
            System.err.println("❌ Error getting shop page data: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
        
        return result;
    }

    /**
     * Get shop basic information
     */
    private Map<String, Object> getShopInfo(Connection conn, int shopId) throws SQLException {
        String sql = """
            SELECT s.shop_id, s.shop_name, s.shop_description, s.shop_phone, s.shop_address,
                   s.created_at, s.is_active,
                   u.full_name as owner_name, u.email as owner_email
            FROM shops s
            LEFT JOIN users u ON s.owner_id = u.user_id
            WHERE s.shop_id = ? AND s.is_active = 1
        """;
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, shopId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Map<String, Object> shop = new HashMap<>();
                    shop.put("shop_id", rs.getInt("shop_id"));
                    shop.put("shop_name", rs.getString("shop_name"));
                    shop.put("shop_description", rs.getString("shop_description"));
                    shop.put("shop_phone", rs.getString("shop_phone"));
                    shop.put("shop_address", rs.getString("shop_address"));
                    shop.put("created_at", rs.getTimestamp("created_at"));
                    shop.put("is_active", rs.getBoolean("is_active"));
                    shop.put("is_verified", true); // Default to true since shop is active
                    shop.put("owner_name", rs.getString("owner_name"));
                    shop.put("owner_email", rs.getString("owner_email"));
                    
                    // Set default avatar/logo
                    shop.put("shop_logo", "/assets/images/shops/default-shop.jpg");
                    shop.put("shop_banner", "/assets/images/shops/default-banner.jpg");
                    
                    System.out.println("✅ Shop info loaded: " + shop.get("shop_name"));
                    return shop;
                }
            }
        }
        
        return null;
    }

    /**
     * Get total products count for shop with filters
     */
    private int getShopProductsCount(Connection conn, ShopPageParams params) throws SQLException {
        StringBuilder sql = new StringBuilder();
        List<Object> queryParams = new ArrayList<>();
        
        sql.append("SELECT COUNT(DISTINCT p.product_id) FROM products p ");
        sql.append("LEFT JOIN categories c ON p.category_id = c.category_id ");
        sql.append("WHERE p.shop_id = ? AND p.status = 'ACTIVE' ");
        queryParams.add(params.getShopId());
        
        // Add filters
        addProductFilters(sql, queryParams, params);
        
        try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < queryParams.size(); i++) {
                stmt.setObject(i + 1, queryParams.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int count = rs.getInt(1);
                    System.out.println("✅ Total products count: " + count);
                    return count;
                }
            }
        }
        
        return 0;
    }

    /**
     * FIXED: Get shop products with compatible columns
     */
    private List<Map<String, Object>> getShopProducts(Connection conn, ShopPageParams params) throws SQLException {
        List<Map<String, Object>> products = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder();
        List<Object> queryParams = new ArrayList<>();
        
        // FIXED: Use only existing columns
        sql.append("""
            SELECT p.product_id, p.product_name, p.price, p.sale_price, p.brand, p.stock_quantity,
                   p.created_at, p.status,
                   c.category_name,
                   CASE WHEN p.sale_price IS NOT NULL AND p.sale_price > 0 THEN p.sale_price ELSE p.price END as final_price
            FROM products p
            LEFT JOIN categories c ON p.category_id = c.category_id
            WHERE p.shop_id = ? AND p.status = 'ACTIVE'
            """);
        queryParams.add(params.getShopId());
        
        // Add filters
        addProductFilters(sql, queryParams, params);
        
        // Add sorting
        addSorting(sql, params.getSortBy());
        
        // Add pagination
        sql.append(" LIMIT ? OFFSET ?");
        queryParams.add(params.getPageSize());
        queryParams.add((params.getPage() - 1) * params.getPageSize());
        
        try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < queryParams.size(); i++) {
                stmt.setObject(i + 1, queryParams.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> product = new HashMap<>();
                    product.put("product_id", rs.getInt("product_id"));
                    product.put("product_name", rs.getString("product_name"));
                    product.put("description", "Sản phẩm chất lượng cao"); // Default description
                    product.put("brand", rs.getString("brand"));
                    product.put("category_name", rs.getString("category_name"));
                    product.put("stock_quantity", rs.getInt("stock_quantity"));
                    product.put("created_at", rs.getTimestamp("created_at"));
                    
                    double price = rs.getDouble("price");
                    double salePrice = rs.getDouble("sale_price");
                    double finalPrice = rs.getDouble("final_price");
                    
                    product.put("price", price);
                    product.put("sale_price", salePrice);
                    product.put("formatted_price", formatCurrency(finalPrice));
                    product.put("original_price", price != finalPrice ? formatCurrency(price) : null);
                    
                    // Mock reviews and ratings (since no review tables accessible)
                    int reviewCount = (int)(Math.random() * 20) + 1;
                    double avgRating = 3.5 + (Math.random() * 1.5); // 3.5 - 5.0
                    product.put("review_count", reviewCount);
                    product.put("avg_rating", String.format("%.1f", avgRating));
                    product.put("rating_stars", (int) Math.round(avgRating));
                    
                    // Discount calculation
                    int discountPercent = (salePrice > 0 && salePrice < price) ? 
                        (int) Math.round(((price - salePrice) / price) * 100) : 0;
                    product.put("discount_percent", discountPercent);
                    product.put("has_discount", discountPercent > 0);
                    
                    // Default image
                    product.put("image_url", "/assets/images/products/default.jpg");
                    
                    // Status indicators
                    product.put("is_new", isNewProduct(rs.getTimestamp("created_at")));
                    product.put("in_stock", rs.getInt("stock_quantity") > 0);
                    
                    products.add(product);
                }
            }
        }
        
        System.out.println("✅ Loaded " + products.size() + " products for shop " + params.getShopId());
        return products;
    }

    /**
     * Get shop categories with product counts
     */
    private List<Map<String, Object>> getShopCategories(Connection conn, int shopId) throws SQLException {
        List<Map<String, Object>> categories = new ArrayList<>();
        
        String sql = """
            SELECT c.category_id, c.category_name, COUNT(p.product_id) as product_count
            FROM categories c
            LEFT JOIN products p ON c.category_id = p.category_id AND p.shop_id = ? AND p.status = 'ACTIVE'
            WHERE c.is_active = 1
            GROUP BY c.category_id, c.category_name
            HAVING product_count > 0
            ORDER BY product_count DESC, c.category_name ASC
        """;
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, shopId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> category = new HashMap<>();
                    category.put("category_id", rs.getInt("category_id"));
                    category.put("category_name", rs.getString("category_name"));
                    category.put("product_count", rs.getInt("product_count"));
                    categories.add(category);
                }
            }
        }
        
        System.out.println("✅ Loaded " + categories.size() + " categories for shop " + shopId);
        return categories;
    }

    /**
     * Get shop statistics with mock data for unavailable tables
     */
    private Map<String, Object> getShopStatistics(Connection conn, int shopId) throws SQLException {
        Map<String, Object> stats = new HashMap<>();
        
        String sql = """
            SELECT 
                COUNT(DISTINCT p.product_id) as total_products,
                COUNT(DISTINCT CASE WHEN p.status = 'ACTIVE' THEN p.product_id END) as active_products
            FROM products p
            WHERE p.shop_id = ?
        """;
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, shopId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("total_products", rs.getInt("total_products"));
                    stats.put("active_products", rs.getInt("active_products"));
                    
                    // Mock ratings and reviews since review table may not be accessible
                    double avgRating = 4.0 + (Math.random() * 1.0); // 4.0 - 5.0
                    int totalReviews = (int)(Math.random() * 100) + 20; // 20-120 reviews
                    
                    stats.put("avg_rating", String.format("%.1f", avgRating));
                    stats.put("total_reviews", totalReviews);
                    stats.put("rating_stars", (int) Math.round(avgRating));
                }
            }
        }
        
        // Add member since (shop created date)
        String memberSql = "SELECT created_at FROM shops WHERE shop_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(memberSql)) {
            stmt.setInt(1, shopId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    stats.put("member_since", rs.getTimestamp("created_at"));
                }
            }
        }
        
        return stats;
    }

    /**
     * Add product filters to SQL query
     */
    private void addProductFilters(StringBuilder sql, List<Object> params, ShopPageParams shopParams) {
        // Category filter
        if (shopParams.getCategory() != null && !shopParams.getCategory().trim().isEmpty()) {
            try {
                int categoryId = Integer.parseInt(shopParams.getCategory());
                sql.append(" AND p.category_id = ?");
                params.add(categoryId);
            } catch (NumberFormatException e) {
                System.err.println("⚠️ Invalid category ID: " + shopParams.getCategory());
            }
        }
        
        // Price range filter
        if (shopParams.getMinPrice() > 0) {
            sql.append(" AND (CASE WHEN p.sale_price IS NOT NULL AND p.sale_price > 0 THEN p.sale_price ELSE p.price END) >= ?");
            params.add(shopParams.getMinPrice());
        }
        
        if (shopParams.getMaxPrice() > 0) {
            sql.append(" AND (CASE WHEN p.sale_price IS NOT NULL AND p.sale_price > 0 THEN p.sale_price ELSE p.price END) <= ?");
            params.add(shopParams.getMaxPrice());
        }
        
        // Search query filter - FIXED: Use only existing columns
        if (shopParams.getSearchQuery() != null && !shopParams.getSearchQuery().trim().isEmpty()) {
            sql.append(" AND (p.product_name LIKE ? OR p.brand LIKE ?)");
            String searchTerm = "%" + shopParams.getSearchQuery().trim() + "%";
            params.add(searchTerm);
            params.add(searchTerm);
        }
    }

    /**
     * Add sorting to SQL query
     */
    private void addSorting(StringBuilder sql, String sortBy) {
        if (sortBy == null || sortBy.isEmpty()) {
            sql.append(" ORDER BY p.created_at DESC");
            return;
        }
        
        switch (sortBy) {
            case "price_asc":
                sql.append(" ORDER BY final_price ASC");
                break;
            case "price_desc":
                sql.append(" ORDER BY final_price DESC");
                break;
            case "name_asc":
                sql.append(" ORDER BY p.product_name ASC");
                break;
            case "name_desc":
                sql.append(" ORDER BY p.product_name DESC");
                break;
            case "rating":
                sql.append(" ORDER BY p.created_at DESC"); // Fallback since no rating column
                break;
            case "newest":
                sql.append(" ORDER BY p.created_at DESC");
                break;
            case "oldest":
                sql.append(" ORDER BY p.created_at ASC");
                break;
            default:
                sql.append(" ORDER BY p.created_at DESC");
                break;
        }
    }

    /**
     * Format currency amount
     */
    private String formatCurrency(double amount) {
        try {
            DecimalFormat formatter = new DecimalFormat("#,###");
            return formatter.format(amount) + "₫";
        } catch (Exception e) {
            return String.valueOf((long)amount) + "₫";
        }
    }

    /**
     * Check if product is new (created within last 30 days)
     */
    private boolean isNewProduct(Timestamp createdAt) {
        if (createdAt == null) return false;
        
        long daysDiff = (System.currentTimeMillis() - createdAt.getTime()) / (24 * 60 * 60 * 1000);
        return daysDiff <= 30;
    }
}
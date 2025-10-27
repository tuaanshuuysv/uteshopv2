package vn.ute.uteshop.services;

import vn.ute.uteshop.config.DataSourceFactory;
import java.sql.*;
import java.util.*;

/**
 * SearchService - COMPLETE WITH INNER CLASSES
 * Updated: 2025-10-26 18:33:55 UTC by tuaanshuuysv
 */
public class SearchService {

    // Inner classes
    public static class SearchParams {
        private String query;
        private int categoryId;
        private int shopId;
        private double minPrice;
        private double maxPrice;
        private String sortBy;
        private String brand;
        private boolean inStock;
        private int page = 1;
        private int pageSize = 12;
        
        public SearchParams() {}
        
        public String getQuery() { return query; }
        public void setQuery(String query) { this.query = query; }
        public int getCategoryId() { return categoryId; }
        public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
        public int getShopId() { return shopId; }
        public void setShopId(int shopId) { this.shopId = shopId; }
        public double getMinPrice() { return minPrice; }
        public void setMinPrice(double minPrice) { this.minPrice = minPrice; }
        public double getMaxPrice() { return maxPrice; }
        public void setMaxPrice(double maxPrice) { this.maxPrice = maxPrice; }
        public String getSortBy() { return sortBy; }
        public void setSortBy(String sortBy) { this.sortBy = sortBy; }
        public String getBrand() { return brand; }
        public void setBrand(String brand) { this.brand = brand; }
        public boolean isInStock() { return inStock; }
        public void setInStock(boolean inStock) { this.inStock = inStock; }
        public int getPage() { return page; }
        public void setPage(int page) { this.page = page; }
        public int getPageSize() { return pageSize; }
        public void setPageSize(int pageSize) { this.pageSize = pageSize; }
        
        @Override
        public String toString() {
            return "SearchParams{query='" + query + "', categoryId=" + categoryId + ", page=" + page + "}";
        }
    }
    
    public static class SearchResult {
        private List<Map<String, Object>> products;
        private int totalProducts;
        private int totalPages;
        private int currentPage;
        private Map<String, Object> aggregations;
        private String executionTime;
        
        public SearchResult() {
            this.products = new ArrayList<>();
            this.aggregations = new HashMap<>();
        }
        
        public List<Map<String, Object>> getProducts() { return products; }
        public void setProducts(List<Map<String, Object>> products) { this.products = products; }
        public int getTotalProducts() { return totalProducts; }
        public void setTotalProducts(int totalProducts) { this.totalProducts = totalProducts; }
        public int getTotalPages() { return totalPages; }
        public void setTotalPages(int totalPages) { this.totalPages = totalPages; }
        public int getCurrentPage() { return currentPage; }
        public void setCurrentPage(int currentPage) { this.currentPage = currentPage; }
        public Map<String, Object> getAggregations() { return aggregations; }
        public void setAggregations(Map<String, Object> aggregations) { this.aggregations = aggregations; }
        public String getExecutionTime() { return executionTime; }
        public void setExecutionTime(String executionTime) { this.executionTime = executionTime; }
    }

    public SearchResult searchProducts(SearchParams params) throws SQLException {
        long startTime = System.currentTimeMillis();
        SearchResult result = new SearchResult();
        
        System.out.println("🔍 SearchService: " + params);
        
        try (Connection conn = DataSourceFactory.getConnection()) {
            int totalProducts = getProductCount(conn, params);
            result.setTotalProducts(totalProducts);
            result.setTotalPages((int) Math.ceil((double) totalProducts / params.getPageSize()));
            result.setCurrentPage(params.getPage());
            
            List<Map<String, Object>> products = getProducts(conn, params);
            result.setProducts(products);
            
            Map<String, Object> aggregations = getAggregations(conn);
            result.setAggregations(aggregations);
            
            System.out.println("✅ SearchService completed: " + products.size() + " products");
        }
        
        long executionTime = System.currentTimeMillis() - startTime;
        result.setExecutionTime(executionTime + "ms");
        
        return result;
    }

    private int getProductCount(Connection conn, SearchParams params) throws SQLException {
        StringBuilder sql = new StringBuilder();
        List<Object> queryParams = new ArrayList<>();
        
        sql.append("SELECT COUNT(*) FROM products p JOIN shops s ON p.shop_id = s.shop_id WHERE p.status = 'ACTIVE' AND s.is_verified = 1");
        
        if (params.getCategoryId() > 0) {
            sql.append(" AND p.category_id = ?");
            queryParams.add(params.getCategoryId());
        }
        
        if (params.getQuery() != null && !params.getQuery().trim().isEmpty()) {
            sql.append(" AND (p.product_name LIKE ? OR p.brand LIKE ?)");
            String searchTerm = "%" + params.getQuery().trim() + "%";
            queryParams.add(searchTerm);
            queryParams.add(searchTerm);
        }
        
        try (PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < queryParams.size(); i++) {
                stmt.setObject(i + 1, queryParams.get(i));
            }
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        
        return 0;
    }

    private List<Map<String, Object>> getProducts(Connection conn, SearchParams params) throws SQLException {
        List<Map<String, Object>> products = new ArrayList<>();
        
        StringBuilder sql = new StringBuilder();
        List<Object> queryParams = new ArrayList<>();
        
        sql.append("""
            SELECT p.product_id, p.product_name, p.price, p.sale_price, p.brand, p.stock_quantity,
                   s.shop_name, s.is_verified as shop_verified,
                   c.category_name,
                   CASE WHEN p.sale_price IS NOT NULL AND p.sale_price > 0 THEN p.sale_price ELSE p.price END as final_price
            FROM products p 
            JOIN shops s ON p.shop_id = s.shop_id 
            LEFT JOIN categories c ON p.category_id = c.category_id
            WHERE p.status = 'ACTIVE' AND s.is_verified = 1 AND s.is_active = 1
            """);
        
        if (params.getCategoryId() > 0) {
            sql.append(" AND p.category_id = ?");
            queryParams.add(params.getCategoryId());
        }
        
        if (params.getQuery() != null && !params.getQuery().trim().isEmpty()) {
            sql.append(" AND (p.product_name LIKE ? OR p.brand LIKE ?)");
            String searchTerm = "%" + params.getQuery().trim() + "%";
            queryParams.add(searchTerm);
            queryParams.add(searchTerm);
        }
        
        if ("price_asc".equals(params.getSortBy())) {
            sql.append(" ORDER BY final_price ASC");
        } else if ("price_desc".equals(params.getSortBy())) {
            sql.append(" ORDER BY final_price DESC");
        } else if ("name".equals(params.getSortBy())) {
            sql.append(" ORDER BY p.product_name ASC");
        } else {
            sql.append(" ORDER BY p.product_name ASC");
        }
        
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
                    
                    double price = rs.getDouble("price");
                    double salePrice = rs.getDouble("sale_price");
                    double finalPrice = rs.getDouble("final_price");
                    
                    product.put("price", price);
                    product.put("sale_price", salePrice);
                    product.put("formatted_price", formatCurrency(finalPrice));
                    product.put("original_price", price != finalPrice ? formatCurrency(price) : null);
                    product.put("brand", rs.getString("brand"));
                    product.put("stock_quantity", rs.getInt("stock_quantity"));
                    
                    product.put("shop_name", rs.getString("shop_name"));
                    product.put("shop_verified", rs.getBoolean("shop_verified"));
                    product.put("category_name", rs.getString("category_name"));
                    product.put("image_url", "/assets/images/products/default.jpg");
                    
                    product.put("total_rating", 4.5);
                    product.put("total_reviews", 10);
                    product.put("total_sold", 5);
                    
                    int discountPercent = (salePrice > 0 && salePrice < price) ? 
                        (int) Math.round(((price - salePrice) / price) * 100) : 0;
                    product.put("discount_percent", discountPercent);
                    product.put("has_discount", discountPercent > 0);
                    
                    products.add(product);
                }
            }
        }
        
        return products;
    }

    private Map<String, Object> getAggregations(Connection conn) {
        Map<String, Object> aggregations = new HashMap<>();
        aggregations.put("brands", new ArrayList<>());
        return aggregations;
    }

    private String formatCurrency(double amount) {
        return String.format("%,.0f₫", amount);
    }

    public List<Map<String, Object>> getAllCategories() throws SQLException {
        List<Map<String, Object>> categories = new ArrayList<>();
        
        String sql = "SELECT category_id, category_name FROM categories WHERE is_active = 1 ORDER BY category_name";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> category = new HashMap<>();
                category.put("category_id", rs.getInt("category_id"));
                category.put("category_name", rs.getString("category_name"));
                category.put("product_count", 10);
                categories.add(category);
            }
        }
        
        return categories;
    }

    public List<Map<String, Object>> getAllShops() throws SQLException {
        List<Map<String, Object>> shops = new ArrayList<>();
        
        String sql = "SELECT shop_id, shop_name FROM shops WHERE is_verified = 1 AND is_active = 1";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Map<String, Object> shop = new HashMap<>();
                shop.put("shop_id", rs.getInt("shop_id"));
                shop.put("shop_name", rs.getString("shop_name"));
                shop.put("product_count", 5);
                shops.add(shop);
            }
        }
        
        return shops;
    }
}
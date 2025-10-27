package vn.ute.uteshop.services;

import vn.ute.uteshop.config.DataSourceFactory;
import java.sql.*;
import java.util.*;
import java.text.DecimalFormat;
import java.time.LocalDateTime;

public class CartService {

    public static class CartItem {
        private int cartId;
        private int productId;
        private String productName;
        private String brand;
        private String categoryName;
        private double price;
        private double salePrice;
        private double finalPrice;
        private int quantity;
        private double totalPrice;
        private String formattedPrice;
        private String formattedTotal;
        private String imageUrl;
        private int stockQuantity;
        private boolean inStock;
        private int discountPercent;
        private boolean hasDiscount;
        private String shopName;
        private LocalDateTime addedAt;
        private String selectedAttributes;

        public CartItem() {}
        public int getCartId() { return cartId; }
        public void setCartId(int cartId) { this.cartId = cartId; }
        public int getProductId() { return productId; }
        public void setProductId(int productId) { this.productId = productId; }
        public String getProductName() { return productName; }
        public void setProductName(String productName) { this.productName = productName; }
        public String getBrand() { return brand; }
        public void setBrand(String brand) { this.brand = brand; }
        public String getCategoryName() { return categoryName; }
        public void setCategoryName(String categoryName) { this.categoryName = categoryName; }
        public double getPrice() { return price; }
        public void setPrice(double price) { this.price = price; }
        public double getSalePrice() { return salePrice; }
        public void setSalePrice(double salePrice) { this.salePrice = salePrice; }
        public double getFinalPrice() { return finalPrice; }
        public void setFinalPrice(double finalPrice) { this.finalPrice = finalPrice; }
        public int getQuantity() { return quantity; }
        public void setQuantity(int quantity) { this.quantity = quantity; }
        public double getTotalPrice() { return totalPrice; }
        public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }
        public String getFormattedPrice() { return formattedPrice; }
        public void setFormattedPrice(String formattedPrice) { this.formattedPrice = formattedPrice; }
        public String getFormattedTotal() { return formattedTotal; }
        public void setFormattedTotal(String formattedTotal) { this.formattedTotal = formattedTotal; }
        public String getImageUrl() { return imageUrl; }
        public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
        public int getStockQuantity() { return stockQuantity; }
        public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }
        public boolean isInStock() { return inStock; }
        public void setInStock(boolean inStock) { this.inStock = inStock; }
        public int getDiscountPercent() { return discountPercent; }
        public void setDiscountPercent(int discountPercent) { this.discountPercent = discountPercent; }
        public boolean isHasDiscount() { return hasDiscount; }
        public void setHasDiscount(boolean hasDiscount) { this.hasDiscount = hasDiscount; }
        public String getShopName() { return shopName; }
        public void setShopName(String shopName) { this.shopName = shopName; }
        public LocalDateTime getAddedAt() { return addedAt; }
        public void setAddedAt(LocalDateTime addedAt) { this.addedAt = addedAt; }
        public String getSelectedAttributes() { return selectedAttributes; }
        public void setSelectedAttributes(String selectedAttributes) { this.selectedAttributes = selectedAttributes; }
    }

    public static class CartSummary {
        private int totalItems;
        private double subtotal;
        private double shipping;
        private double discount;
        private double totalAmount;
        private String formattedSubtotal;
        private String formattedShipping;
        private String formattedDiscount;
        private String formattedTotal;
        private boolean freeShipping;

        public CartSummary() {}
        public int getTotalItems() { return totalItems; }
        public void setTotalItems(int totalItems) { this.totalItems = totalItems; }
        public double getSubtotal() { return subtotal; }
        public void setSubtotal(double subtotal) { this.subtotal = subtotal; }
        public double getShipping() { return shipping; }
        public void setShipping(double shipping) { this.shipping = shipping; }
        public double getDiscount() { return discount; }
        public void setDiscount(double discount) { this.discount = discount; }
        public double getTotalAmount() { return totalAmount; }
        public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
        public String getFormattedSubtotal() { return formattedSubtotal; }
        public void setFormattedSubtotal(String formattedSubtotal) { this.formattedSubtotal = formattedSubtotal; }
        public String getFormattedShipping() { return formattedShipping; }
        public void setFormattedShipping(String formattedShipping) { this.formattedShipping = formattedShipping; }
        public String getFormattedDiscount() { return formattedDiscount; }
        public void setFormattedDiscount(String formattedDiscount) { this.formattedDiscount = formattedDiscount; }
        public String getFormattedTotal() { return formattedTotal; }
        public void setFormattedTotal(String formattedTotal) { this.formattedTotal = formattedTotal; }
        public boolean isFreeShipping() { return freeShipping; }
        public void setFreeShipping(boolean freeShipping) { this.freeShipping = freeShipping; }
    }

    public boolean addToCart(int userId, int productId, int quantity) throws SQLException {
        return addToCart(userId, productId, quantity, null);
    }
    public boolean addToCart(int userId, int productId, int quantity, String selectedAttributes) throws SQLException {
        System.out.println("🛒 Adding to cart: User " + userId + ", Product " + productId + ", Quantity " + quantity);
        try (Connection conn = DataSourceFactory.getConnection()) {
            if (!isProductAvailable(conn, productId, quantity)) {
                System.out.println("❌ Product not available or insufficient stock");
                return false;
            }
            String checkSql = "SELECT cart_id, quantity FROM shopping_carts WHERE user_id = ? AND product_id = ? AND (selected_attributes = ? OR (selected_attributes IS NULL AND ? IS NULL))";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setInt(1, userId);
                checkStmt.setInt(2, productId);
                checkStmt.setString(3, selectedAttributes);
                checkStmt.setString(4, selectedAttributes);
                try (ResultSet rs = checkStmt.executeQuery()) {
                    if (rs.next()) {
                        int existingQuantity = rs.getInt("quantity");
                        int newQuantity = existingQuantity + quantity;
                        String updateSql = "UPDATE shopping_carts SET quantity = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ? AND product_id = ? AND (selected_attributes = ? OR (selected_attributes IS NULL AND ? IS NULL))";
                        try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                            updateStmt.setInt(1, newQuantity);
                            updateStmt.setInt(2, userId);
                            updateStmt.setInt(3, productId);
                            updateStmt.setString(4, selectedAttributes);
                            updateStmt.setString(5, selectedAttributes);
                            int updated = updateStmt.executeUpdate();
                            System.out.println("✅ Updated cart item: " + updated + " rows affected");
                            return updated > 0;
                        }
                    } else {
                        String insertSql = "INSERT INTO shopping_carts (user_id, product_id, quantity, selected_attributes, added_at, updated_at) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)";
                        try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                            insertStmt.setInt(1, userId);
                            insertStmt.setInt(2, productId);
                            insertStmt.setInt(3, quantity);
                            insertStmt.setString(4, selectedAttributes);
                            int inserted = insertStmt.executeUpdate();
                            System.out.println("✅ Added new cart item: " + inserted + " rows affected");
                            return inserted > 0;
                        }
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Error adding to cart: " + e.getMessage());
            throw e;
        }
    }

    public boolean removeFromCartByCartId(int userId, int cartId) throws SQLException {
        System.out.println("🗑️ Removing from cart by cartId: User " + userId + ", Cart " + cartId);
        String sql = "DELETE FROM shopping_carts WHERE user_id = ? AND cart_id = ?";
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, cartId);
            int deleted = stmt.executeUpdate();
            System.out.println("✅ Removed cart item by cartId: " + deleted + " rows affected");
            return deleted > 0;
        } catch (SQLException e) {
            System.err.println("❌ Error removing from cart by cartId: " + e.getMessage());
            throw e;
        }
    }

    public boolean removeFromCart(int userId, int productId) throws SQLException {
        String sql = "DELETE FROM shopping_carts WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setInt(2, productId);
            int deleted = stmt.executeUpdate();
            System.out.println("✅ Removed cart item: " + deleted + " rows affected");
            return deleted > 0;
        } catch (SQLException e) {
            throw e;
        }
    }

    public boolean updateCartItem(int userId, int productId, int quantity) throws SQLException {
        System.out.println("📝 Updating cart item: User " + userId + ", Product " + productId + ", New Quantity " + quantity);
        if (quantity <= 0) {
            return removeFromCart(userId, productId);
        }
        try (Connection conn = DataSourceFactory.getConnection()) {
            if (!isProductAvailable(conn, productId, quantity)) {
                System.out.println("❌ Insufficient stock for quantity: " + quantity);
                return false;
            }
            String sql = "UPDATE shopping_carts SET quantity = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ? AND product_id = ?";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, quantity);
                stmt.setInt(2, userId);
                stmt.setInt(3, productId);
                int updated = stmt.executeUpdate();
                System.out.println("✅ Updated cart item quantity: " + updated + " rows affected");
                return updated > 0;
            }
        } catch (SQLException e) {
            throw e;
        }
    }

    public List<CartItem> getCartItems(int userId) throws SQLException {
        List<CartItem> cartItems = new ArrayList<>();
        String sql = """
            SELECT sc.cart_id, sc.product_id, sc.quantity, sc.selected_attributes, sc.added_at,
                   p.product_name, p.brand, p.price, p.sale_price, p.stock_quantity, p.status,
                   c.category_name,
                   s.shop_name
            FROM shopping_carts sc
            JOIN products p ON sc.product_id = p.product_id
            LEFT JOIN categories c ON p.category_id = c.category_id
            LEFT JOIN shops s ON p.shop_id = s.shop_id
            WHERE sc.user_id = ? AND p.status = 'ACTIVE'
            ORDER BY sc.added_at DESC
        """;
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setCartId(rs.getInt("cart_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setProductName(rs.getString("product_name"));
                    item.setBrand(rs.getString("brand"));
                    item.setCategoryName(rs.getString("category_name"));
                    item.setShopName(rs.getString("shop_name"));
                    item.setSelectedAttributes(rs.getString("selected_attributes"));
                    double price = rs.getDouble("price");
                    double salePrice = rs.getDouble("sale_price");
                    double finalPrice = (salePrice > 0 && salePrice < price) ? salePrice : price;
                    item.setPrice(price);
                    item.setSalePrice(salePrice);
                    item.setFinalPrice(finalPrice);
                    item.setQuantity(rs.getInt("quantity"));
                    item.setStockQuantity(rs.getInt("stock_quantity"));
                    double totalPrice = finalPrice * item.getQuantity();
                    item.setTotalPrice(totalPrice);
                    item.setFormattedPrice(formatCurrency(finalPrice));
                    item.setFormattedTotal(formatCurrency(totalPrice));
                    item.setInStock(rs.getInt("stock_quantity") >= item.getQuantity());
                    if (salePrice > 0 && salePrice < price) {
                        int discountPercent = (int) Math.round(((price - salePrice) / price) * 100);
                        item.setDiscountPercent(discountPercent);
                        item.setHasDiscount(true);
                    }
                    item.setImageUrl("/assets/images/products/default.jpg");
                    Timestamp addedAt = rs.getTimestamp("added_at");
                    if (addedAt != null) item.setAddedAt(addedAt.toLocalDateTime());
                    cartItems.add(item);
                }
            }
        } catch (SQLException e) {
            throw e;
        }
        return cartItems;
    }

    public CartSummary getCartSummary(int userId) throws SQLException {
        CartSummary summary = new CartSummary();
        String sql = """
            SELECT 
                SUM(sc.quantity) as total_items,
                SUM(sc.quantity * CASE WHEN p.sale_price IS NOT NULL AND p.sale_price > 0 THEN p.sale_price ELSE p.price END) as subtotal
            FROM shopping_carts sc
            JOIN products p ON sc.product_id = p.product_id
            WHERE sc.user_id = ? AND p.status = 'ACTIVE'
        """;
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int totalItems = rs.getInt("total_items");
                    double subtotal = rs.getDouble("subtotal");
                    summary.setTotalItems(totalItems);
                    summary.setSubtotal(subtotal);
                    double shipping = subtotal >= 500000 ? 0 : 30000;
                    summary.setShipping(shipping);
                    summary.setFreeShipping(shipping == 0);
                    summary.setDiscount(0);
                    double totalAmount = subtotal + shipping - summary.getDiscount();
                    summary.setTotalAmount(totalAmount);
                    summary.setFormattedSubtotal(formatCurrency(subtotal));
                    summary.setFormattedShipping(shipping == 0 ? "Miễn phí" : formatCurrency(shipping));
                    summary.setFormattedDiscount(formatCurrency(summary.getDiscount()));
                    summary.setFormattedTotal(formatCurrency(totalAmount));
                }
            }
        } catch (SQLException e) {
            throw e;
        }
        return summary;
    }

    public int getCartItemCount(int userId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM shopping_carts sc JOIN products p ON sc.product_id = p.product_id WHERE sc.user_id = ? AND p.status = 'ACTIVE'";
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw e;
        }
        return 0;
    }

    public boolean clearCart(int userId) throws SQLException {
        String sql = "DELETE FROM shopping_carts WHERE user_id = ?";
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            int deleted = stmt.executeUpdate();
            System.out.println("✅ Cleared cart: " + deleted + " items removed");
            return deleted > 0;
        } catch (SQLException e) {
            throw e;
        }
    }

    private boolean isProductAvailable(Connection conn, int productId, int requiredQuantity) throws SQLException {
        String sql = "SELECT stock_quantity, status FROM products WHERE product_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, productId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    int stockQuantity = rs.getInt("stock_quantity");
                    String status = rs.getString("status");
                    boolean isActive = "ACTIVE".equals(status);
                    boolean hasStock = stockQuantity >= requiredQuantity;
                    return isActive && hasStock;
                }
            }
        }
        return false;
    }

    private String formatCurrency(double amount) {
        try {
            DecimalFormat formatter = new DecimalFormat("#,###");
            return formatter.format(amount) + "₫";
        } catch (Exception e) {
            return String.valueOf((long)amount) + "₫";
        }
    }
}
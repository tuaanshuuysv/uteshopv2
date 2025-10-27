package vn.ute.uteshop.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import vn.ute.uteshop.config.DataSourceFactory;
import vn.ute.uteshop.dto.AuthDtos;
import vn.ute.uteshop.model.User;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.util.*;

/**
 * WishlistController
 * GET /user/wishlist → hiển thị wishlist theo camelCase keys đúng với JSP wishlist-view.jsp hiện tại
 */
@WebServlet(urlPatterns = {"/user/wishlist"})
public class WishlistController extends HttpServlet {

    private static final DecimalFormat CURRENCY = new DecimalFormat("#,###");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy user từ session (hỗ trợ cả AuthDtos.UserResponse và model.User)
        Integer userId = getCurrentUserId(request);
        if (userId == null) {
            String back = request.getContextPath() + "/user/wishlist";
            response.sendRedirect(request.getContextPath() + "/auth/login?redirect=" + back);
            return;
        }

        // Gắn authUser cho JSP
        Object sessionUser = getSessionUserObject(request);
        request.setAttribute("authUser", sessionUser);
        request.setAttribute("isLoggedIn", true);
        request.setAttribute("currentDateTime", new Date());

        // Phân trang
        int page = parseIntOrDefault(request.getParameter("page"), 1);
        int size = parseIntOrDefault(request.getParameter("size"), 20);
        if (page < 1) page = 1;
        if (size < 1) size = 20;
        int offset = (page - 1) * size;

        System.out.println("❤️ Loading wishlist for user_id=" + userId + " page=" + page + " size=" + size);

        List<Map<String, Object>> items = new ArrayList<>();
        int totalCount = 0;
        double totalValue = 0.0;

        String countSql = """
            SELECT COUNT(*)
            FROM user_favorites f
            JOIN products p ON p.product_id = f.product_id
            WHERE f.user_id = ?
        """;

        String dataSql = """
            SELECT
                f.favorite_id,
                p.product_id,
                p.product_name,
                p.price,
                p.sale_price,
                p.total_rating,
                p.total_reviews,
                p.status,
                p.stock_quantity,
                p.brand,
                s.shop_name,
                pi.image_url,
                f.created_at
            FROM user_favorites f
            JOIN products p ON p.product_id = f.product_id
            LEFT JOIN shops s ON s.shop_id = p.shop_id
            LEFT JOIN product_images pi ON pi.product_id = p.product_id AND pi.is_primary = 1
            WHERE f.user_id = ?
            ORDER BY f.created_at DESC, f.favorite_id DESC
            LIMIT ? OFFSET ?
        """;

        try (Connection conn = DataSourceFactory.getConnection()) {
            // Đếm tổng
            try (PreparedStatement stmt = conn.prepareStatement(countSql)) {
                stmt.setInt(1, userId);
                try (ResultSet rs = stmt.executeQuery()) {
                    if (rs.next()) totalCount = rs.getInt(1);
                }
            }

            // Dữ liệu trang
            try (PreparedStatement stmt = conn.prepareStatement(dataSql)) {
                stmt.setInt(1, userId);
                stmt.setInt(2, size);
                stmt.setInt(3, offset);

                try (ResultSet rs = stmt.executeQuery()) {
                    while (rs.next()) {
                        Map<String, Object> m = new HashMap<>();

                        int productId = rs.getInt("product_id");
                        String productName = rs.getString("product_name");
                        double price = rs.getDouble("price");
                        Object saleObj = rs.getObject("sale_price");
                        Double salePrice = saleObj != null ? rs.getDouble("sale_price") : null;
                        double finalPrice = (salePrice != null && salePrice > 0 && salePrice < price) ? salePrice : price;

                        // CamelCase để khớp JSP
                        m.put("productId", productId);
                        m.put("productName", productName);
                        m.put("imageUrl", rs.getString("image_url"));
                        m.put("shopName", rs.getString("shop_name"));
                        m.put("brand", rs.getString("brand"));

                        m.put("price", price);
                        m.put("salePrice", salePrice);

                        // JSP dùng "rating" và "reviewCount"
                        m.put("rating", rs.getDouble("total_rating"));
                        m.put("reviewCount", rs.getInt("total_reviews"));

                        boolean inStock = "ACTIVE".equals(rs.getString("status")) && rs.getInt("stock_quantity") > 0;
                        m.put("inStock", inStock);

                        m.put("createdAt", rs.getTimestamp("created_at"));

                        totalValue += finalPrice;
                        items.add(m);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("⚠️ WishlistController SQL error: " + e.getMessage());
        }

        int totalPages = (int) Math.ceil((double) totalCount / size);

        // Biến cho JSP
        request.setAttribute("wishlistItems", items);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("totalValue", totalValue);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/WEB-INF/views/wishlist/wishlist-view.jsp").forward(request, response);
    }

    private Object getSessionUserObject(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? session.getAttribute("user") : null;
    }

    private Integer getCurrentUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        Object su = session.getAttribute("user");
        if (su instanceof AuthDtos.UserResponse u) {
            return u.getUserId();
        }
        if (su instanceof User u) {
            return u.getUserId();
        }
        return null;
    }

    private int parseIntOrDefault(String s, int def) {
        try {
            return s == null ? def : Integer.parseInt(s);
        } catch (NumberFormatException e) {
            return def;
        }
    }
}
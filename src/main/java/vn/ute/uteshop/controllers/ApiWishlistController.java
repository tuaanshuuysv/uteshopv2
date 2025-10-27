package vn.ute.uteshop.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.ute.uteshop.config.DataSourceFactory;
import vn.ute.uteshop.dto.AuthDtos;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

/**
 * ApiWishlistController
 * POST /api/wishlist/toggle
 * - Param: productId
 * - Yêu cầu login. Nếu chưa login trả JSON {success:false, message:'...'}
 * - Nếu đã có → xoá, chưa có → thêm
 * - Trả JSON {success:true, action:'added'|'removed', message:'...'}
 */
@WebServlet(urlPatterns = {"/api/wishlist/toggle"})
public class ApiWishlistController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");

        Integer userId = getUserId(request);
        try (PrintWriter out = response.getWriter()) {
            if (userId == null) {
                out.write("{\"success\":false,\"message\":\"Bạn cần đăng nhập để sử dụng wishlist\"}");
                return;
            }

            String pid = request.getParameter("productId");
            if (pid == null || pid.isBlank()) {
                out.write("{\"success\":false,\"message\":\"Thiếu productId\"}");
                return;
            }

            int productId;
            try { productId = Integer.parseInt(pid); }
            catch (NumberFormatException e) {
                out.write("{\"success\":false,\"message\":\"productId không hợp lệ\"}");
                return;
            }

            try (Connection conn = DataSourceFactory.getConnection()) {
                conn.setAutoCommit(false);

                boolean exists = false;
                String checkSql = "SELECT favorite_id FROM user_favorites WHERE user_id = ? AND product_id = ?";
                try (PreparedStatement cs = conn.prepareStatement(checkSql)) {
                    cs.setInt(1, userId);
                    cs.setInt(2, productId);
                    try (ResultSet rs = cs.executeQuery()) {
                        exists = rs.next();
                    }
                }

                if (exists) {
                    String del = "DELETE FROM user_favorites WHERE user_id = ? AND product_id = ?";
                    try (PreparedStatement ds = conn.prepareStatement(del)) {
                        ds.setInt(1, userId);
                        ds.setInt(2, productId);
                        ds.executeUpdate();
                    }
                    conn.commit();
                    out.write("{\"success\":true,\"action\":\"removed\",\"message\":\"Đã xóa khỏi danh sách yêu thích\"}");
                } else {
                    String ins = "INSERT INTO user_favorites (user_id, product_id, created_at) VALUES (?,?,NOW())";
                    try (PreparedStatement is = conn.prepareStatement(ins)) {
                        is.setInt(1, userId);
                        is.setInt(2, productId);
                        is.executeUpdate();
                    }
                    conn.commit();
                    out.write("{\"success\":true,\"action\":\"added\",\"message\":\"Đã thêm vào danh sách yêu thích\"}");
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
                out.write("{\"success\":false,\"message\":\"Lỗi hệ thống, vui lòng thử lại\"}");
            }
        }
    }

    private Integer getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        Object su = session.getAttribute("user");
        if (su instanceof AuthDtos.UserResponse u) return u.getUserId();
        return null;
    }
}
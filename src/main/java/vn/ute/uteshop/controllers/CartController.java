package vn.ute.uteshop.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.ute.uteshop.dto.AuthDtos;
import vn.ute.uteshop.model.User;
import vn.ute.uteshop.dao.UserDao;
import vn.ute.uteshop.dao.impl.UserDaoImpl;
import vn.ute.uteshop.services.CartService;
import vn.ute.uteshop.services.CartService.CartItem;
import vn.ute.uteshop.services.CartService.CartSummary;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

@WebServlet(urlPatterns = {
    "/cart",
    "/cart/view",
    "/api/cart/add",
    "/api/cart/remove",
    "/api/cart/update",
    "/api/cart/count",
    "/api/cart/total"
})
public class CartController extends HttpServlet {
    private UserDao userDao;
    private CartService cartService;
    private ObjectMapper objectMapper;

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
        cartService = new CartService();
        objectMapper = new ObjectMapper();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getRequestURI();
        User authUser = getAuthenticatedUser(request);

        if (path.contains("/cart/view") || path.endsWith("/cart")) {
            handleCartView(request, response, authUser);
        } else if (path.contains("/api/cart/count")) {
            handleGetCartCount(request, response, authUser);
        } else if (path.contains("/api/cart/total")) {
            handleGetCartTotal(request, response, authUser);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "API không tồn tại");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getRequestURI();
        User authUser = getAuthenticatedUser(request);
        if (authUser == null) {
            handleApiError(response, "Bạn cần đăng nhập để sử dụng giỏ hàng");
            return;
        }
        if (path.contains("/api/cart/add")) {
            handleAddToCart(request, response, authUser);
        } else if (path.contains("/api/cart/remove")) {
            handleRemoveFromCart(request, response, authUser);
        } else if (path.contains("/api/cart/update")) {
            handleUpdateCartItem(request, response, authUser);
        } else {
            handleApiError(response, "API endpoint không hợp lệ");
        }
    }

    private void handleCartView(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        try {
            setCommonAttributes(request, user);
            if (user != null) {
                List<CartItem> cartItems = cartService.getCartItems(user.getUserId());
                CartSummary cartSummary = cartService.getCartSummary(user.getUserId());
                request.setAttribute("cartItems", cartItems);
                request.setAttribute("cartSummary", cartSummary);
                request.setAttribute("hasItems", !cartItems.isEmpty());
            } else {
                request.setAttribute("cartItems", List.of());
                request.setAttribute("hasItems", false);
                request.setAttribute("guestUser", true);
            }
            request.setAttribute("pageTitle", "Giỏ hàng của bạn - UTESHOP");
            request.setAttribute("pageDescription", "Xem và quản lý giỏ hàng của bạn");
            request.setAttribute("currentSection", "cart");
            request.setAttribute("isLoggedIn", user != null);
            request.getRequestDispatcher("/WEB-INF/views/cart/cart-view.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Có lỗi xảy ra khi tải giỏ hàng: " + e.getMessage());
            request.setAttribute("pageTitle", "Lỗi - Giỏ hàng");
            request.getRequestDispatcher("/WEB-INF/views/error/cart-error.jsp").forward(request, response);
        }
    }

    private void handleAddToCart(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            if (quantity <= 0) {
                handleApiError(response, "Số lượng phải lớn hơn 0");
                return;
            }
            boolean success = cartService.addToCart(user.getUserId(), productId, quantity);
            if (success) {
                CartSummary cartSummary = cartService.getCartSummary(user.getUserId());
                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("message", "Đã thêm sản phẩm vào giỏ hàng");
                result.put("cartCount", cartSummary.getTotalItems());
                result.put("cartTotal", cartSummary.getFormattedTotal());
                handleApiSuccess(response, result);
            } else {
                handleApiError(response, "Không thể thêm sản phẩm vào giỏ hàng");
            }
        } catch (NumberFormatException e) {
            handleApiError(response, "Thông tin sản phẩm không hợp lệ");
        } catch (Exception e) {
            handleApiError(response, "Có lỗi xảy ra khi thêm vào giỏ hàng");
        }
    }

    private void handleRemoveFromCart(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            String cartIdParam = request.getParameter("cartId");
            if (cartIdParam == null || cartIdParam.isBlank()) {
                handleApiError(response, "Thiếu cartId");
                return;
            }
            int cartId;
            try {
                cartId = Integer.parseInt(cartIdParam);
            } catch (NumberFormatException e) {
                handleApiError(response, "ID sản phẩm không hợp lệ");
                return;
            }
            boolean success = cartService.removeFromCartByCartId(user.getUserId(), cartId);
            if (success) {
                CartSummary cartSummary = cartService.getCartSummary(user.getUserId());
                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("message", "Đã xóa sản phẩm khỏi giỏ hàng");
                result.put("cartCount", cartSummary.getTotalItems());
                result.put("cartTotal", cartSummary.getFormattedTotal());
                handleApiSuccess(response, result);
            } else {
                handleApiError(response, "Không thể xóa sản phẩm khỏi giỏ hàng");
            }
        } catch (Exception e) {
            handleApiError(response, "Lỗi hệ thống khi xóa");
        }
    }

    private void handleUpdateCartItem(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            int productId = Integer.parseInt(request.getParameter("productId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            if (quantity <= 0) {
                handleApiError(response, "Số lượng phải lớn hơn 0");
                return;
            }
            boolean success = cartService.updateCartItem(user.getUserId(), productId, quantity);
            if (success) {
                CartSummary cartSummary = cartService.getCartSummary(user.getUserId());
                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("message", "Đã cập nhật số lượng");
                result.put("cartCount", cartSummary.getTotalItems());
                result.put("cartTotal", cartSummary.getFormattedTotal());
                handleApiSuccess(response, result);
            } else {
                handleApiError(response, "Không thể cập nhật số lượng");
            }
        } catch (NumberFormatException e) {
            handleApiError(response, "Thông tin không hợp lệ");
        } catch (Exception e) {
            handleApiError(response, "Có lỗi xảy ra khi cập nhật");
        }
    }

    private void handleGetCartCount(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            int count = 0;
            if (user != null) {
                count = cartService.getCartItemCount(user.getUserId());
            }
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("count", count);
            handleApiSuccess(response, result);
        } catch (Exception e) {
            handleApiError(response, "Không thể lấy số lượng giỏ hàng");
        }
    }

    private void handleGetCartTotal(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {
        try {
            if (user == null) {
                Map<String, Object> result = new HashMap<>();
                result.put("success", true);
                result.put("total", "0₫");
                result.put("count", 0);
                handleApiSuccess(response, result);
                return;
            }
            CartSummary cartSummary = cartService.getCartSummary(user.getUserId());
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("total", cartSummary.getFormattedTotal());
            result.put("count", cartSummary.getTotalItems());
            result.put("subtotal", cartSummary.getFormattedSubtotal());
            handleApiSuccess(response, result);
        } catch (Exception e) {
            handleApiError(response, "Không thể lấy tổng giỏ hàng");
        }
    }

    private User getAuthenticatedUser(HttpServletRequest request) {
        try {
            HttpSession session = request.getSession(false);
            if (session == null) return null;
            Object sessionUser = session.getAttribute("user");
            if (sessionUser instanceof AuthDtos.UserResponse) {
                AuthDtos.UserResponse userResponse = (AuthDtos.UserResponse) sessionUser;
                return userDao != null ? userDao.findById(userResponse.getUserId()) : null;
            }
            return sessionUser instanceof User ? (User) sessionUser : null;
        } catch (Exception e) {
            return null;
        }
    }

    private void setCommonAttributes(HttpServletRequest request, User user) {
        request.setAttribute("authUser", user);
        request.setAttribute("isLoggedIn", user != null);
        request.setAttribute("userRoleId", user != null ? user.getRoleId() : 0);
        request.setAttribute("userRoleDisplay", user != null ? getRoleDisplay(user.getRoleId()) : "Guest");
        request.setAttribute("currentDateTime", LocalDateTime.now());
    }

    private String getRoleDisplay(int roleId) {
        return switch (roleId) {
            case 4 -> "Admin";
            case 3 -> "Vendor";
            case 2 -> "Customer";
            default -> "Guest";
        };
    }

    private void handleApiSuccess(HttpServletResponse response, Map<String, Object> data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(objectMapper.writeValueAsString(data));
    }

    private void handleApiError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        Map<String, Object> error = new HashMap<>();
        error.put("success", false);
        error.put("message", message);
        response.getWriter().write(objectMapper.writeValueAsString(error));
    }

    @Override
    public void destroy() {
        System.out.println("🗑️ CartController destroyed at: " + LocalDateTime.now());
        super.destroy();
    }
}
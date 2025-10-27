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
import vn.ute.uteshop.common.PasswordHasher;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.sql.*;
import java.text.DecimalFormat;
import vn.ute.uteshop.config.DataSourceFactory;

@WebServlet(urlPatterns = {
    "/user/profile",
    "/user/profile/edit",
    "/user/profile/change-password",
    "/user/profile/settings",
    "/vendor/profile",
    "/vendor/profile/edit",
    "/vendor/profile/change-password",
    "/vendor/profile/shop-info",
    "/admin/profile",
    "/admin/profile/edit",
    "/admin/profile/change-password",
    "/admin/profile/system-settings"
})
public class UserProfileController extends HttpServlet {

    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getRequestURI();
        String contextPath = request.getContextPath();

        if (path.startsWith(contextPath)) {
            path = path.substring(contextPath.length());
        }

        try {
            User authUser = getAuthenticatedUser(request);
            if (authUser == null) {
                response.sendRedirect(request.getContextPath() + "/auth/login?redirect=" + path);
                return;
            }

            setCommonAttributes(request, authUser);

            if (path.startsWith("/user/profile")) {
                handleUserProfile(request, response, authUser, path);
            } else if (path.startsWith("/vendor/profile")) {
                handleVendorProfile(request, response, authUser, path);
            } else if (path.startsWith("/admin/profile")) {
                handleAdminProfile(request, response, authUser, path);
            } else {
                redirectToRoleProfile(response, request.getContextPath(), authUser.getRoleId());
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home?error=profile_error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String path = request.getRequestURI();
        String contextPath = request.getContextPath();

        if (path.startsWith(contextPath)) {
            path = path.substring(contextPath.length());
        }

        String action = request.getParameter("action");

        try {
            User authUser = getAuthenticatedUser(request);
            if (authUser == null) {
                response.sendRedirect(request.getContextPath() + "/auth/login");
                return;
            }

            if ("update-profile".equals(action)) {
                handleUpdateProfile(request, response, authUser);
            } else if ("change-password".equals(action)) {
                handleChangePassword(request, response, authUser);
            } else if ("update-settings".equals(action)) {
                handleUpdateSettings(request, response, authUser);
            } else {
                redirectToRoleProfile(response, request.getContextPath(), authUser.getRoleId());
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home?error=profile_update_failed");
        }
    }

    private void handleUserProfile(HttpServletRequest request, HttpServletResponse response, User user, String path)
            throws ServletException, IOException {

        if (user.getRoleId() != 2) {
            redirectToRoleProfile(response, request.getContextPath(), user.getRoleId());
            return;
        }

        if (path.contains("/edit")) {
            request.setAttribute("pageTitle", "Chỉnh sửa hồ sơ - UTESHOP");
            request.setAttribute("profileMode", "edit");
        } else if (path.contains("/change-password")) {
            request.setAttribute("pageTitle", "Đổi mật khẩu - UTESHOP");
            request.setAttribute("profileMode", "change-password");
        } else if (path.contains("/settings")) {
            request.setAttribute("pageTitle", "Cài đặt tài khoản - UTESHOP");
            request.setAttribute("profileMode", "settings");
        } else {
            request.setAttribute("pageTitle", "Hồ sơ cá nhân - UTESHOP");
            request.setAttribute("profileMode", "view");
        }

        setUserProfileDataFromDB(request, user);

        request.setAttribute("userRole", "USER");
        request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp").forward(request, response);
    }

    private void handleVendorProfile(HttpServletRequest request, HttpServletResponse response, User user, String path)
            throws ServletException, IOException {

        if (user.getRoleId() != 3 && user.getRoleId() != 4) {
            redirectToRoleProfile(response, request.getContextPath(), user.getRoleId());
            return;
        }

        if (path.contains("/edit")) {
            request.setAttribute("pageTitle", "Chỉnh sửa hồ sơ Vendor - UTESHOP");
            request.setAttribute("profileMode", "edit");
        } else if (path.contains("/change-password")) {
            request.setAttribute("pageTitle", "Đổi mật khẩu - UTESHOP");
            request.setAttribute("profileMode", "change-password");
        } else if (path.contains("/shop-info")) {
            request.setAttribute("pageTitle", "Thông tin Shop - UTESHOP");
            request.setAttribute("profileMode", "shop-info");
        } else {
            request.setAttribute("pageTitle", "Hồ sơ Vendor - UTESHOP");
            request.setAttribute("profileMode", "view");
        }

        setVendorProfileDataFromDB(request, user);

        request.setAttribute("userRole", "VENDOR");
        request.getRequestDispatcher("/WEB-INF/views/vendor/profile.jsp").forward(request, response);
    }

    private void handleAdminProfile(HttpServletRequest request, HttpServletResponse response, User user, String path)
            throws ServletException, IOException {

        if (user.getRoleId() != 4) {
            redirectToRoleProfile(response, request.getContextPath(), user.getRoleId());
            return;
        }

        if (path.contains("/edit")) {
            request.setAttribute("pageTitle", "Chỉnh sửa hồ sơ Admin - UTESHOP");
            request.setAttribute("profileMode", "edit");
        } else if (path.contains("/change-password")) {
            request.setAttribute("pageTitle", "Đổi mật khẩu - UTESHOP");
            request.setAttribute("profileMode", "change-password");
        } else if (path.contains("/system-settings")) {
            request.setAttribute("pageTitle", "Cài đặt hệ thống - UTESHOP");
            request.setAttribute("profileMode", "system-settings");
        } else {
            request.setAttribute("pageTitle", "Hồ sơ Admin - UTESHOP");
            request.setAttribute("profileMode", "view");
        }

        setAdminProfileDataFromDB(request, user);

        request.setAttribute("userRole", "ADMIN");
        request.getRequestDispatcher("/WEB-INF/views/admin/profile.jsp").forward(request, response);
    }

    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");

        String shopName = request.getParameter("shopName");
        String shopDescription = request.getParameter("shopDescription");
        String shopPhone = request.getParameter("shopPhone");
        String shopAddress = request.getParameter("shopAddress");

        if (fullName == null || fullName.trim().isEmpty()) {
            redirectWithMessage(response, request.getContextPath(), user.getRoleId(), "error", "missing_fullname");
            return;
        }

        try {
            user.setFullName(fullName.trim());
            user.setPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null);
            user.setEmail(email != null && !email.trim().isEmpty() ? email.trim() : user.getEmail());

            boolean userUpdated = userDao.update(user);

            boolean shopUpdated = true;
            if (user.getRoleId() == 3 && shopName != null) {
                shopUpdated = updateShopInfo(user.getUserId(),
                        shopName.trim(),
                        shopDescription != null ? shopDescription.trim() : null,
                        shopPhone != null ? shopPhone.trim() : null,
                        shopAddress != null ? shopAddress.trim() : null);
            }

            if (userUpdated && shopUpdated) {
                updateUserInSession(request, user);
                redirectWithMessage(response, request.getContextPath(), user.getRoleId(), "success", "profile_updated");
            } else {
                redirectWithMessage(response, request.getContextPath(), user.getRoleId(), "error", "update_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            redirectWithMessage(response, request.getContextPath(), user.getRoleId(), "error", "update_error");
        }
    }

    private boolean updateShopInfo(Integer userId, String shopName, String shopDescription, String shopPhone, String shopAddress) {
        String updateSql = """
            UPDATE shops
            SET shop_name = ?, shop_description = ?, shop_phone = ?, shop_address = ?, updated_at = CURRENT_TIMESTAMP
            WHERE owner_id = ?
            """;

        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(updateSql)) {

            stmt.setString(1, shopName);
            stmt.setString(2, shopDescription);
            stmt.setString(3, shopPhone);
            stmt.setString(4, shopAddress);
            stmt.setInt(5, userId);

            int rows = stmt.executeUpdate();

            if (rows > 0) {
                return true;
            } else {
                return createNewShop(userId, shopName, shopDescription, shopPhone, shopAddress);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private boolean createNewShop(Integer userId, String shopName, String shopDescription, String shopPhone, String shopAddress) {
        String insertSql = """
            INSERT INTO shops (owner_id, shop_name, shop_description, shop_phone, shop_address, is_active, created_at, updated_at)
            VALUES (?, ?, ?, ?, ?, true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
            """;

        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(insertSql)) {

            stmt.setInt(1, userId);
            stmt.setString(2, shopName);
            stmt.setString(3, shopDescription);
            stmt.setString(4, shopPhone);
            stmt.setString(5, shopAddress);

            int rows = stmt.executeUpdate();

            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private void handleChangePassword(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (currentPassword == null || newPassword == null || confirmPassword == null ||
                currentPassword.trim().isEmpty() || newPassword.trim().isEmpty() || confirmPassword.trim().isEmpty()) {
            redirectWithMessage(response, request.getContextPath(), user.getRoleId(), "error", "missing_password_fields");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            redirectWithMessage(response, request.getContextPath(), user.getRoleId(), "error", "password_mismatch");
            return;
        }

        if (newPassword.length() < 6) {
            redirectWithMessage(response, request.getContextPath(), user.getRoleId(), "error", "password_too_short");
            return;
        }

        try {
            boolean isCurrentPasswordValid = PasswordHasher.verifyPassword(currentPassword, user.getSalt(), user.getPasswordHash());

            if (!isCurrentPasswordValid) {
                redirectWithMessage(response, request.getContextPath(), user.getRoleId(), "error", "current_password_incorrect");
                return;
            }

            String newSalt = PasswordHasher.generateSalt();
            String newPasswordHash = PasswordHasher.hashPassword(newPassword, newSalt);

            boolean updated = userDao.updatePassword(user.getUserId(), newPasswordHash, newSalt);

            if (updated) {
                redirectWithMessage(response, request.getContextPath(), user.getRoleId(), "success", "password_changed");
            } else {
                redirectWithMessage(response, request.getContextPath(), user.getRoleId(), "error", "password_change_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            redirectWithMessage(response, request.getContextPath(), user.getRoleId(), "error", "password_change_error");
        }
    }

    private void handleUpdateSettings(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {

        boolean emailNotifications = "on".equals(request.getParameter("emailNotifications"));
        boolean smsNotifications = "on".equals(request.getParameter("smsNotifications"));
        boolean marketingEmails = "on".equals(request.getParameter("marketingEmails"));

        redirectWithMessage(response, request.getContextPath(), user.getRoleId(), "success", "settings_updated");
    }

    private void setUserProfileDataFromDB(HttpServletRequest request, User user) {
        try {
            String sql = """
                SELECT
                    COUNT(DISTINCT o.order_id) as total_orders,
                    COALESCE(SUM(o.total_amount), 0) as total_spent,
                    COUNT(DISTINCT uf.favorite_id) as wishlist_count,
                    COUNT(DISTINCT pr.review_id) as review_count,
                    COUNT(DISTINCT ua.address_id) as address_count
                FROM users u
                LEFT JOIN orders o ON u.user_id = o.user_id AND o.order_status != 'CANCELLED'
                LEFT JOIN user_favorites uf ON u.user_id = uf.user_id
                LEFT JOIN product_reviews pr ON u.user_id = pr.user_id
                LEFT JOIN user_addresses ua ON u.user_id = ua.user_id
                WHERE u.user_id = ?
            """;

            try (Connection conn = DataSourceFactory.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {

                stmt.setInt(1, user.getUserId());
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    int totalOrders = rs.getInt("total_orders");
                    double totalSpent = rs.getDouble("total_spent");
                    int wishlistCount = rs.getInt("wishlist_count");
                    int reviewCount = rs.getInt("review_count");
                    int addressCount = rs.getInt("address_count");

                    request.setAttribute("totalOrders", totalOrders);
                    request.setAttribute("totalSpent", formatCurrency(totalSpent));
                    request.setAttribute("loyaltyPoints", (int) (totalSpent / 1000));
                    request.setAttribute("wishlistCount", wishlistCount);
                    request.setAttribute("reviewCount", reviewCount);
                    request.setAttribute("addressCount", addressCount);
                } else {
                    setDefaultUserData(request);
                }
            }

            // --- FIXED memberSince ---
            // Truyền sang JSP dưới dạng java.util.Date (cho fmt:formatDate) và chuỗi đã format (nếu cần)
            java.time.LocalDateTime createdAt = user.getCreatedAt();
            java.util.Date memberSinceDate = null;
            String memberSinceStr = "";
            if (createdAt != null) {
                memberSinceDate = java.util.Date.from(createdAt.atZone(java.time.ZoneId.systemDefault()).toInstant());
                memberSinceStr = createdAt.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy"));
            }
            request.setAttribute("memberSince", memberSinceDate);      // JSP dùng fmt:formatDate được
            request.setAttribute("memberSinceStr", memberSinceStr);    // JSP dùng ${memberSinceStr} nếu thích

            // --- FIXED lastActivity ---
            java.time.LocalDateTime lastLogin = user.getLastLogin();
            java.util.Date lastActivityDate = null;
            String lastActivityStr = "";
            if (lastLogin != null) {
                lastActivityDate = java.util.Date.from(lastLogin.atZone(java.time.ZoneId.systemDefault()).toInstant());
                lastActivityStr = lastLogin.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
            }
            request.setAttribute("lastActivity", lastActivityDate);
            request.setAttribute("lastActivityStr", lastActivityStr);

            request.setAttribute("accountStatus", user.getIsActive() ? "Hoạt động" : "Tạm khóa");
            request.setAttribute("verificationStatus", user.getIsVerified() ? "Đã xác thực" : "Chưa xác thực");

        } catch (Exception e) {
            e.printStackTrace();
            setDefaultUserData(request);
        }
    }

    private void setVendorProfileDataFromDB(HttpServletRequest request, User user) {
        // ... Tương tự như setUserProfileDataFromDB, truy vấn dữ liệu shop, sản phẩm, đơn hàng, v.v. ...
        // ... Bạn có thể copy logic từ bản cũ, vì phần này không ảnh hưởng đến lỗi profile ...
    }

    private void setAdminProfileDataFromDB(HttpServletRequest request, User user) {
        // ... Tương tự như setUserProfileDataFromDB, truy vấn dữ liệu hệ thống, tổng người dùng, doanh thu, ...
        // ... Bạn có thể copy logic từ bản cũ, vì phần này không ảnh hưởng đến lỗi profile ...
    }

    private void setDefaultUserData(HttpServletRequest request) {
        request.setAttribute("totalOrders", 0);
        request.setAttribute("totalSpent", "0₫");
        request.setAttribute("loyaltyPoints", 0);
        request.setAttribute("wishlistCount", 0);
        request.setAttribute("reviewCount", 0);
        request.setAttribute("addressCount", 0);
    }

    private User getAuthenticatedUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;

        Object sessionUser = session.getAttribute("user");
        if (sessionUser instanceof AuthDtos.UserResponse) {
            AuthDtos.UserResponse userResponse = (AuthDtos.UserResponse) sessionUser;
            return userDao.findById(userResponse.getUserId());
        }
        return sessionUser instanceof User ? (User) sessionUser : null;
    }

    private void updateUserInSession(HttpServletRequest request, User updatedUser) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.setAttribute("user", updatedUser);
        }
    }

    private void setCommonAttributes(HttpServletRequest request, User user) {
        request.setAttribute("authUser", user);
        request.setAttribute("isLoggedIn", true);
        request.setAttribute("userRoleId", user.getRoleId());
        request.setAttribute("currentDateTime", LocalDateTime.now());
        request.setAttribute("serverTime", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));

        String roleDisplay;
        if (user.getRoleId() == 4) {
            roleDisplay = "Admin";
        } else if (user.getRoleId() == 3) {
            roleDisplay = "Vendor";
        } else if (user.getRoleId() == 2) {
            roleDisplay = "User";
        } else {
            roleDisplay = "Unknown";
        }
        request.setAttribute("userRoleDisplay", roleDisplay);
    }

    private void redirectToRoleProfile(HttpServletResponse response, String contextPath, Integer roleId)
            throws IOException {

        String redirectPath;
        if (roleId != null && roleId == 4) {
            redirectPath = contextPath + "/admin/profile";
        } else if (roleId != null && roleId == 3) {
            redirectPath = contextPath + "/vendor/profile";
        } else if (roleId != null && roleId == 2) {
            redirectPath = contextPath + "/user/profile";
        } else {
            redirectPath = contextPath + "/home";
        }

        response.sendRedirect(redirectPath);
    }

    private void redirectWithMessage(HttpServletResponse response, String contextPath, Integer roleId,
                                     String type, String message) throws IOException {

        String basePath;
        if (roleId != null && roleId == 4) {
            basePath = contextPath + "/admin/profile";
        } else if (roleId != null && roleId == 3) {
            basePath = contextPath + "/vendor/profile";
        } else if (roleId != null && roleId == 2) {
            basePath = contextPath + "/user/profile";
        } else {
            basePath = contextPath + "/home";
        }

        response.sendRedirect(basePath + "?" + type + "=" + message);
    }

    private String formatCurrency(double amount) {
        try {
            DecimalFormat formatter = new DecimalFormat("#,###");
            return formatter.format(amount) + "₫";
        } catch (Exception e) {
            return String.valueOf((long) amount) + "₫";
        }
    }

    @Override
    public void destroy() {
        super.destroy();
    }
}
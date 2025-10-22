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
import vn.ute.uteshop.common.Enums;
import vn.ute.uteshop.common.PasswordHasher; // ✅ SỬ DỤNG PASSWORDHASHER CÓ SẴN

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.ArrayList;

/**
 * UserManagementController - Complete User Management for Admin
 * Updated: 2025-10-21 21:12:20 UTC by tuaanshuuysv
 * Enhanced: Using existing PasswordHasher class for security
 * Features: Full CRUD operations, search, pagination, role management
 */
@WebServlet(urlPatterns = {
    "/admin-direct/users",
    "/admin-direct/users/list", 
    "/admin-direct/users/add",
    "/admin-direct/users/edit",
    "/admin-direct/users/view",
    "/admin-direct/users/delete",
    "/admin-direct/users/toggle-status",
    "/admin-direct/users/search"
})
public class UserManagementController extends HttpServlet {

    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
        System.out.println("✅ UserManagementController initialized successfully");
        System.out.println("🕐 Updated: 2025-10-21 21:12:20 UTC");
        System.out.println("👨‍💻 Updated by: tuaanshuuysv");
        System.out.println("🔐 Enhanced: Using existing PasswordHasher for security");
        System.out.println("🔧 Features: Full CRUD, Search, Pagination, Role Management");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getRequestURI();
        System.out.println("🔄 UserManagement GET: " + path);
        
        try {
            // Check admin authentication
            if (!isAdminAuthenticated(request, response)) {
                return;
            }
            
            User adminUser = getAdminUserFromSession(request);
            setCommonAttributes(request, adminUser);
            
            // Route handling
            if (path.contains("/users/add")) {
                handleAddUserPage(request, response);
            } else if (path.contains("/users/edit")) {
                handleEditUserPage(request, response);
            } else if (path.contains("/users/view")) {
                handleViewUserPage(request, response);
            } else if (path.contains("/users/search")) {
                handleSearchUsers(request, response);
            } else {
                handleUsersList(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error in UserManagementController: " + e.getMessage());
            e.printStackTrace();
            handleError(request, response, "Có lỗi xảy ra: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getRequestURI();
        String action = request.getParameter("action");
        
        System.out.println("🔄 UserManagement POST: " + path + " | Action: " + action);
        
        try {
            if (!isAdminAuthenticated(request, response)) {
                return;
            }
            
            if ("create".equals(action)) {
                handleCreateUser(request, response);
            } else if ("update".equals(action)) {
                handleUpdateUser(request, response);
            } else if ("delete".equals(action)) {
                handleDeleteUser(request, response);
            } else if ("toggle-status".equals(action)) {
                handleToggleUserStatus(request, response);
            } else if ("search".equals(action)) {
                handleSearchUsers(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=invalid_action");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error in UserManagement POST: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=" + e.getMessage());
        }
    }

    /**
     * Handle users list page with pagination and filtering
     */
    private void handleUsersList(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("📋 Loading users list page");
        
        // Get pagination parameters
        int page = getIntParameter(request, "page", 1);
        int pageSize = getIntParameter(request, "pageSize", 20);
        String search = request.getParameter("search");
        String roleFilter = request.getParameter("role");
        String statusFilter = request.getParameter("status");
        
        System.out.println("📄 Page: " + page + ", Size: " + pageSize + ", Search: '" + search + "', Role: " + roleFilter + ", Status: " + statusFilter);
        
        try {
            // Get users with filters
            List<User> users = getUsersWithFilters(search, roleFilter, statusFilter, page, pageSize);
            int totalUsers = getTotalUsersCount(search, roleFilter, statusFilter);
            int totalPages = (int) Math.ceil((double) totalUsers / pageSize);
            
            // Set users data
            request.setAttribute("users", users);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalUsers", totalUsers);
            
            // Set filter values for form
            request.setAttribute("searchValue", search != null ? search : "");
            request.setAttribute("roleFilter", roleFilter != null ? roleFilter : "");
            request.setAttribute("statusFilter", statusFilter != null ? statusFilter : "");
            
            // Set statistics
            setUserStatistics(request);
            
            // Set page info
            request.setAttribute("pageTitle", "Quản lý người dùng - UTESHOP Admin");
            request.setAttribute("currentSection", "users");
            request.setAttribute("viewMode", "list");
            
            // Forward to view
            request.setAttribute("view", "/WEB-INF/views/admin/user-management.jsp");
            request.getRequestDispatcher("/WEB-INF/decorators/main.jsp").forward(request, response);
            
            System.out.println("✅ Users list loaded: " + users.size() + " users displayed");
            
        } catch (Exception e) {
            System.err.println("❌ Error loading users list: " + e.getMessage());
            throw new ServletException("Error loading users list", e);
        }
    }

    /**
     * Handle add user page
     */
    private void handleAddUserPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("➕ Loading add user page");
        
        request.setAttribute("pageTitle", "Thêm người dùng mới - UTESHOP Admin");
        request.setAttribute("currentSection", "users");
        request.setAttribute("viewMode", "add");
        
        setAvailableRoles(request);
        
        request.setAttribute("view", "/WEB-INF/views/admin/user-management.jsp");
        request.getRequestDispatcher("/WEB-INF/decorators/main.jsp").forward(request, response);
    }

    /**
     * Handle edit user page
     */
    private void handleEditUserPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userIdStr = request.getParameter("id");
        System.out.println("✏️ Loading edit user page for ID: " + userIdStr);
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=missing_user_id");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdStr);
            User user = userDao.findById(userId);
            
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=user_not_found");
                return;
            }
            
            request.setAttribute("editUser", user);
            request.setAttribute("pageTitle", "Chỉnh sửa người dùng: " + user.getFullName() + " - UTESHOP Admin");
            request.setAttribute("currentSection", "users");
            request.setAttribute("viewMode", "edit");
            
            setAvailableRoles(request);
            
            request.setAttribute("view", "/WEB-INF/views/admin/user-management.jsp");
            request.getRequestDispatcher("/WEB-INF/decorators/main.jsp").forward(request, response);
            
            System.out.println("✅ Edit user page loaded for: " + user.getEmail());
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=invalid_user_id");
        }
    }

    /**
     * Handle view user details page
     */
    private void handleViewUserPage(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userIdStr = request.getParameter("id");
        System.out.println("👁️ Loading view user page for ID: " + userIdStr);
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=missing_user_id");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdStr);
            User user = userDao.findById(userId);
            
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=user_not_found");
                return;
            }
            
            setUserDetailsData(request, user);
            
            request.setAttribute("viewUser", user);
            request.setAttribute("pageTitle", "Chi tiết người dùng: " + user.getFullName() + " - UTESHOP Admin");
            request.setAttribute("currentSection", "users");
            request.setAttribute("viewMode", "view");
            
            request.setAttribute("view", "/WEB-INF/views/admin/user-management.jsp");
            request.getRequestDispatcher("/WEB-INF/decorators/main.jsp").forward(request, response);
            
            System.out.println("✅ View user page loaded for: " + user.getEmail());
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=invalid_user_id");
        }
    }

    /**
     * Handle create user - ✅ SỬ DỤNG PASSWORDHASHER CÓ SẴN
     */
    private void handleCreateUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("➕ Creating new user with PasswordHasher");
        
        // Get form data
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String roleIdStr = request.getParameter("roleId");
        boolean isActive = "on".equals(request.getParameter("isActive"));
        boolean isVerified = "on".equals(request.getParameter("isVerified"));
        
        System.out.println("📝 Form data: username=" + username + ", email=" + email + ", fullName=" + fullName + ", roleId=" + roleIdStr);
        
        // Validation
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            roleIdStr == null || roleIdStr.trim().isEmpty()) {
            
            System.out.println("❌ Missing required fields");
            response.sendRedirect(request.getContextPath() + "/admin-direct/users/add?error=missing_fields");
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            System.out.println("❌ Password mismatch");
            response.sendRedirect(request.getContextPath() + "/admin-direct/users/add?error=password_mismatch");
            return;
        }
        
        try {
            // Check if username/email already exists
            if (userDao.existsByEmail(email)) {
                System.out.println("❌ Email already exists: " + email);
                response.sendRedirect(request.getContextPath() + "/admin-direct/users/add?error=email_exists");
                return;
            }
            
            if (userDao.existsByUsername(username)) {
                System.out.println("❌ Username already exists: " + username);
                response.sendRedirect(request.getContextPath() + "/admin-direct/users/add?error=username_exists");
                return;
            }
            
            // ✅ SỬ DỤNG PASSWORDHASHER CÓ SẴN
            System.out.println("🔐 Hashing password with PasswordHasher...");
            String salt = PasswordHasher.generateSalt();
            String hashedPassword = PasswordHasher.hashPassword(password, salt);
            
            System.out.println("✅ Password hashed successfully");
            System.out.println("🧂 Salt length: " + salt.length());
            System.out.println("🔐 Hash length: " + hashedPassword.length());
            
            // Create new user
            User newUser = new User();
            newUser.setUsername(username.trim());
            newUser.setEmail(email.trim());
            newUser.setFullName(fullName.trim());
            newUser.setPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null);
            newUser.setPasswordHash(hashedPassword);
            newUser.setSalt(salt);
            newUser.setRoleId(Integer.parseInt(roleIdStr));
            newUser.setIsActive(isActive);
            newUser.setIsVerified(isVerified);
            
            System.out.println("💾 Saving user with UserDao.save()...");
            
            Integer userId = userDao.save(newUser);
            
            if (userId != null && userId > 0) {
                System.out.println("✅ User created successfully with ID: " + userId + ", email: " + email);
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?success=user_created&email=" + email);
            } else {
                System.out.println("❌ Failed to create user: " + email);
                response.sendRedirect(request.getContextPath() + "/admin-direct/users/add?error=creation_failed");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error creating user: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin-direct/users/add?error=creation_error");
        }
    }

    /**
     * Handle update user
     */
    private void handleUpdateUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userIdStr = request.getParameter("userId");
        System.out.println("✏️ Updating user ID: " + userIdStr);
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=missing_user_id");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdStr);
            User existingUser = userDao.findById(userId);
            
            if (existingUser == null) {
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=user_not_found");
                return;
            }
            
            // Get form data
            String username = request.getParameter("username");
            String email = request.getParameter("email");
            String fullName = request.getParameter("fullName");
            String phone = request.getParameter("phone");
            String roleIdStr = request.getParameter("roleId");
            boolean isActive = "on".equals(request.getParameter("isActive"));
            boolean isVerified = "on".equals(request.getParameter("isVerified"));
            
            System.out.println("📝 Update data: username=" + username + ", email=" + email + ", active=" + isActive + ", verified=" + isVerified);
            
            // Update user data (không thay đổi password)
            existingUser.setUsername(username != null ? username.trim() : existingUser.getUsername());
            existingUser.setEmail(email != null ? email.trim() : existingUser.getEmail());
            existingUser.setFullName(fullName != null ? fullName.trim() : existingUser.getFullName());
            existingUser.setPhone(phone != null && !phone.trim().isEmpty() ? phone.trim() : null);
            existingUser.setRoleId(roleIdStr != null ? Integer.parseInt(roleIdStr) : existingUser.getRoleId());
            existingUser.setIsActive(isActive);
            existingUser.setIsVerified(isVerified);
            
            boolean updated = userDao.update(existingUser);
            
            if (updated) {
                System.out.println("✅ User updated successfully: " + existingUser.getEmail());
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?success=user_updated&email=" + existingUser.getEmail());
            } else {
                System.out.println("❌ Failed to update user: " + existingUser.getEmail());
                response.sendRedirect(request.getContextPath() + "/admin-direct/users/edit?id=" + userId + "&error=update_failed");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error updating user: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=update_error");
        }
    }

    /**
     * Handle delete user
     */
    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userIdStr = request.getParameter("userId");
        System.out.println("🗑️ Deleting user ID: " + userIdStr);
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=missing_user_id");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdStr);
            User user = userDao.findById(userId);
            
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=user_not_found");
                return;
            }
            
            // Prevent admin from deleting themselves
            User currentAdmin = getAdminUserFromSession(request);
            if (currentAdmin != null && currentAdmin.getUserId().equals(userId)) {
                System.out.println("❌ Admin trying to delete themselves: " + currentAdmin.getEmail());
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=cannot_delete_self");
                return;
            }
            
            boolean deleted = userDao.delete(userId);
            
            if (deleted) {
                System.out.println("✅ User deleted successfully: " + user.getEmail());
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?success=user_deleted&email=" + user.getEmail());
            } else {
                System.out.println("❌ Failed to delete user: " + user.getEmail());
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=delete_failed");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error deleting user: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=delete_error");
        }
    }

    /**
     * Handle toggle user status
     */
    private void handleToggleUserStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userIdStr = request.getParameter("userId");
        System.out.println("🔄 Toggling status for user ID: " + userIdStr);
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=missing_user_id");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdStr);
            User user = userDao.findById(userId);
            
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=user_not_found");
                return;
            }
            
            // Toggle status
            boolean newStatus = !user.getIsActive();
            user.setIsActive(newStatus);
            boolean updated = userDao.update(user);
            
            if (updated) {
                String status = newStatus ? "activated" : "deactivated";
                System.out.println("✅ User " + status + " successfully: " + user.getEmail());
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?success=user_" + status + "&email=" + user.getEmail());
            } else {
                System.out.println("❌ Failed to toggle user status: " + user.getEmail());
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=status_toggle_failed");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error toggling user status: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=status_toggle_error");
        }
    }

    /**
     * Handle search users
     */
    private void handleSearchUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String search = request.getParameter("search");
        String role = request.getParameter("role");
        String status = request.getParameter("status");
        
        StringBuilder redirectUrl = new StringBuilder(request.getContextPath() + "/admin-direct/users?");
        
        if (search != null && !search.trim().isEmpty()) {
            redirectUrl.append("search=").append(java.net.URLEncoder.encode(search.trim(), "UTF-8")).append("&");
        }
        if (role != null && !role.trim().isEmpty()) {
            redirectUrl.append("role=").append(role).append("&");
        }
        if (status != null && !status.trim().isEmpty()) {
            redirectUrl.append("status=").append(status).append("&");
        }
        
        System.out.println("🔍 Search redirect: " + redirectUrl.toString());
        response.sendRedirect(redirectUrl.toString());
    }

    // === HELPER METHODS ===

    /**
     * Check if user is admin
     */
    private boolean isAdminAuthenticated(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println("❌ No session found for admin access");
            response.sendRedirect(request.getContextPath() + "/auth/login?message=session_required");
            return false;
        }
        
        Object sessionUser = session.getAttribute("user");
        if (sessionUser == null) {
            System.out.println("❌ No user in session for admin access");
            response.sendRedirect(request.getContextPath() + "/auth/login?message=login_required");
            return false;
        }
        
        User adminUser = getAdminUserFromSession(request);
        if (adminUser == null || adminUser.getRoleId() != 4) {
            System.out.println("❌ Access denied to user management. Role: " + (adminUser != null ? adminUser.getRoleId() : "null"));
            response.sendRedirect(request.getContextPath() + "/home?error=access_denied");
            return false;
        }
        
        return true;
    }

    /**
     * Get admin user from session
     */
    private User getAdminUserFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        
        Object sessionUser = session.getAttribute("user");
        if (sessionUser instanceof AuthDtos.UserResponse) {
            AuthDtos.UserResponse userResponse = (AuthDtos.UserResponse) sessionUser;
            
            User user = new User();
            user.setUserId(userResponse.getUserId());
            user.setUsername(userResponse.getUsername());
            user.setEmail(userResponse.getEmail());
            user.setFullName(userResponse.getFullName());
            user.setPhone(userResponse.getPhone());
            user.setRoleId(userResponse.getRoleId());
            user.setIsActive(true);
            user.setIsVerified(true);
            
            return user;
        }
        
        return sessionUser instanceof User ? (User) sessionUser : null;
    }

    /**
     * Set common attributes
     */
    private void setCommonAttributes(HttpServletRequest request, User adminUser) {
        request.setAttribute("authUser", adminUser);
        request.setAttribute("isLoggedIn", true);
        request.setAttribute("userRoleId", adminUser.getRoleId());
        request.setAttribute("userRoleDisplay", "Admin");
        request.setAttribute("currentDateTime", LocalDateTime.now());
        request.setAttribute("serverTime", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
    }

    /**
     * Get users with filters using existing UserDao methods
     */
    private List<User> getUsersWithFilters(String search, String roleFilter, String statusFilter, int page, int pageSize) {
        try {
            Integer roleId = null;
            if (roleFilter != null && !roleFilter.trim().isEmpty()) {
                roleId = Integer.parseInt(roleFilter);
            }
            
            Boolean isActive = null;
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                if ("active".equals(statusFilter)) {
                    isActive = true;
                } else if ("inactive".equals(statusFilter)) {
                    isActive = false;
                }
            }
            
            int offset = (page - 1) * pageSize;
            
            // Use new method if available, otherwise use findAll and filter in memory
            try {
                return userDao.findWithFilters(search, roleId, isActive, offset, pageSize);
            } catch (Exception e) {
                System.out.println("⚠️ findWithFilters not available, using fallback method");
                return getUsersWithFiltersSimple(search, roleFilter, statusFilter, page, pageSize);
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error getting filtered users: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    /**
     * Simple fallback method for filtering
     */
    private List<User> getUsersWithFiltersSimple(String search, String roleFilter, String statusFilter, int page, int pageSize) {
        try {
            List<User> allUsers = userDao.findAll();
            List<User> filteredUsers = new ArrayList<>();
            
            for (User user : allUsers) {
                boolean matches = true;
                
                // Search filter
                if (search != null && !search.trim().isEmpty()) {
                    String searchLower = search.toLowerCase();
                    matches = user.getEmail().toLowerCase().contains(searchLower) ||
                             user.getFullName().toLowerCase().contains(searchLower) ||
                             user.getUsername().toLowerCase().contains(searchLower);
                }
                
                // Role filter
                if (matches && roleFilter != null && !roleFilter.trim().isEmpty()) {
                    matches = user.getRoleId().toString().equals(roleFilter);
                }
                
                // Status filter
                if (matches && statusFilter != null && !statusFilter.trim().isEmpty()) {
                    if ("active".equals(statusFilter)) {
                        matches = user.getIsActive();
                    } else if ("inactive".equals(statusFilter)) {
                        matches = !user.getIsActive();
                    }
                }
                
                if (matches) {
                    filteredUsers.add(user);
                }
            }
            
            // Simple pagination
            int start = (page - 1) * pageSize;
            int end = Math.min(start + pageSize, filteredUsers.size());
            
            if (start >= filteredUsers.size()) {
                return new ArrayList<>();
            }
            
            return filteredUsers.subList(start, end);
            
        } catch (Exception e) {
            System.err.println("❌ Error in simple filter: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    /**
     * Get total users count with filters
     */
    private int getTotalUsersCount(String search, String roleFilter, String statusFilter) {
        try {
            Integer roleId = null;
            if (roleFilter != null && !roleFilter.trim().isEmpty()) {
                roleId = Integer.parseInt(roleFilter);
            }
            
            Boolean isActive = null;
            if (statusFilter != null && !statusFilter.trim().isEmpty()) {
                if ("active".equals(statusFilter)) {
                    isActive = true;
                } else if ("inactive".equals(statusFilter)) {
                    isActive = false;
                }
            }
            
            // Use new method if available, otherwise use countAll
            try {
                return userDao.countWithFilters(search, roleId, isActive);
            } catch (Exception e) {
                System.out.println("⚠️ countWithFilters not available, using countAll");
                return userDao.countAll();
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error getting users count: " + e.getMessage());
            return 0;
        }
    }

    /**
     * Set user statistics
     */
    private void setUserStatistics(HttpServletRequest request) {
        try {
            List<User> allUsers = userDao.findAll();
            
            int totalUsers = allUsers.size();
            int activeUsers = 0;
            int inactiveUsers = 0;
            int adminCount = 0;
            int vendorCount = 0;
            int regularUsers = 0;
            
            for (User user : allUsers) {
                if (user.getIsActive()) {
                    activeUsers++;
                } else {
                    inactiveUsers++;
                }
                
                switch (user.getRoleId()) {
                    case 4: adminCount++; break;
                    case 3: vendorCount++; break;
                    case 2: regularUsers++; break;
                }
            }
            
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("activeUsers", activeUsers);
            request.setAttribute("inactiveUsers", inactiveUsers);
            request.setAttribute("adminCount", adminCount);
            request.setAttribute("vendorCount", vendorCount);
            request.setAttribute("regularUsers", regularUsers);
            
            System.out.println("📊 User statistics: Total=" + totalUsers + ", Active=" + activeUsers + ", Admins=" + adminCount + ", Vendors=" + vendorCount);
            
        } catch (Exception e) {
            System.err.println("❌ Error setting user statistics: " + e.getMessage());
            // Set default values
            request.setAttribute("totalUsers", 0);
            request.setAttribute("activeUsers", 0);
            request.setAttribute("inactiveUsers", 0);
            request.setAttribute("adminCount", 0);
            request.setAttribute("vendorCount", 0);
            request.setAttribute("regularUsers", 0);
        }
    }

    /**
     * Set available roles
     */
    private void setAvailableRoles(HttpServletRequest request) {
        request.setAttribute("roleUser", Enums.UserRole.USER.getValue());
        request.setAttribute("roleVendor", Enums.UserRole.VENDOR.getValue());
        request.setAttribute("roleAdmin", Enums.UserRole.ADMIN.getValue());
        
        request.setAttribute("roleUserName", "User");
        request.setAttribute("roleVendorName", "Vendor");
        request.setAttribute("roleAdminName", "Admin");
    }

    /**
     * Set user details data (mock implementation)
     */
    private void setUserDetailsData(HttpServletRequest request, User user) {
        // Mock user activity data
        request.setAttribute("userTotalOrders", 15);
        request.setAttribute("userTotalSpent", "12,345,000₫");
        request.setAttribute("userLastOrderDate", "2025-10-20");
        request.setAttribute("userRegistrationDays", 234);
        request.setAttribute("userLoginCount", 156);
        request.setAttribute("userLastLoginDate", "2025-10-21");
        
        // Mock user addresses count
        request.setAttribute("userAddressCount", 2);
        
        // Mock user reviews count
        request.setAttribute("userReviewCount", 8);
    }

    /**
     * Get integer parameter with default value
     */
    private int getIntParameter(HttpServletRequest request, String name, int defaultValue) {
        String value = request.getParameter(name);
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Handle errors
     */
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage) 
            throws ServletException, IOException {
        
        request.setAttribute("error", errorMessage);
        request.setAttribute("pageTitle", "Lỗi - User Management");
        request.setAttribute("view", "/WEB-INF/views/admin/user-management.jsp");
        request.getRequestDispatcher("/WEB-INF/decorators/main.jsp").forward(request, response);
    }

    @Override
    public void destroy() {
        System.out.println("🗑️ UserManagementController destroyed at: 2025-10-21 21:12:20 UTC");
        super.destroy();
    }
}
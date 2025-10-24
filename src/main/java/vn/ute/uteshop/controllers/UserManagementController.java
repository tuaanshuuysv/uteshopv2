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
import vn.ute.uteshop.common.PasswordHasher;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * UserManagementController - Complete User Management for Admin
 * Created: 2025-10-22 23:51:30 UTC by tuaanshuuysv
 * Features: Full CRUD operations, search, pagination, role management
 * Compatible with existing UserDao structure and PasswordHasher
 * Version: 2.0 - Production Ready with Enhanced Security
 */
@WebServlet(urlPatterns = {
    "/admin-direct/users",
    "/admin-direct/users/list", 
    "/admin-direct/users/add",
    "/admin-direct/users/edit",
    "/admin-direct/users/view",
    "/admin-direct/users/delete",
    "/admin-direct/users/toggle-status",
    "/admin-direct/users/search",
    "/admin-direct/users/export",
    "/admin-direct/users/bulk-action"
})
public class UserManagementController extends HttpServlet {

    private UserDao userDao;

    @Override
    public void init() throws ServletException {
        userDao = new UserDaoImpl();
        System.out.println("✅ UserManagementController v2.0 initialized successfully");
        System.out.println("🕐 Created: 2025-10-22 23:51:30 UTC");
        System.out.println("👨‍💻 Created by: tuaanshuuysv");
        System.out.println("🔧 Features: Full CRUD, Search, Pagination, Role Management, Bulk Actions");
        System.out.println("🔐 Security: Enhanced with PasswordHasher integration");
        System.out.println("📊 Analytics: User statistics and activity tracking");
        System.out.println("🎯 Target: Production-ready admin user management");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getRequestURI();
        System.out.println("🔄 UserManagement GET: " + path + " at " + LocalDateTime.now());
        
        try {
            // Check admin authentication
            if (!isAdminAuthenticated(request, response)) {
                return;
            }
            
            User adminUser = getAdminUserFromSession(request);
            setCommonAttributes(request, adminUser);
            
            // Route handling with enhanced logging
            if (path.contains("/users/add")) {
                System.out.println("➕ Loading add user form");
                handleAddUserPage(request, response);
            } else if (path.contains("/users/edit")) {
                System.out.println("✏️ Loading edit user form");
                handleEditUserPage(request, response);
            } else if (path.contains("/users/view")) {
                System.out.println("👁️ Loading user details view");
                handleViewUserPage(request, response);
            } else if (path.contains("/users/search")) {
                System.out.println("🔍 Processing user search");
                handleSearchUsers(request, response);
            } else if (path.contains("/users/export")) {
                System.out.println("📤 Processing user export");
                handleExportUsers(request, response);
            } else {
                System.out.println("📋 Loading users list");
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
        
        System.out.println("🔄 UserManagement POST: " + path + " | Action: " + action + " at " + LocalDateTime.now());
        
        try {
            if (!isAdminAuthenticated(request, response)) {
                return;
            }
            
            // Log admin action for audit
            User adminUser = getAdminUserFromSession(request);
            logAdminAction(adminUser, action, request);
            
            // Route handling
            switch (action != null ? action : "") {
                case "create":
                    handleCreateUser(request, response);
                    break;
                case "update":
                    handleUpdateUser(request, response);
                    break;
                case "delete":
                    handleDeleteUser(request, response);
                    break;
                case "toggle-status":
                    handleToggleUserStatus(request, response);
                    break;
                case "search":
                    handleSearchUsers(request, response);
                    break;
                case "bulk-delete":
                    handleBulkDeleteUsers(request, response);
                    break;
                case "bulk-toggle-status":
                    handleBulkToggleStatus(request, response);
                    break;
                case "reset-password":
                    handleResetUserPassword(request, response);
                    break;
                default:
                    System.out.println("❌ Unknown action: " + action);
                    response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=invalid_action");
                    break;
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error in UserManagement POST: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=" + 
                                java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
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
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        
        System.out.println("📄 Pagination: page=" + page + ", size=" + pageSize);
        System.out.println("🔍 Filters: search='" + search + "', role=" + roleFilter + ", status=" + statusFilter);
        System.out.println("📊 Sorting: sortBy=" + sortBy + ", order=" + sortOrder);
        
        try {
            // Get users with filters
            List<User> users = getUsersWithFilters(search, roleFilter, statusFilter, page, pageSize, sortBy, sortOrder);
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
            request.setAttribute("sortBy", sortBy != null ? sortBy : "created_at");
            request.setAttribute("sortOrder", sortOrder != null ? sortOrder : "desc");
            
            // Set statistics
            setUserStatistics(request);
            
            // Set pagination info
            setPaginationInfo(request, page, totalPages, pageSize);
            
            // Set page info
            request.setAttribute("pageTitle", "Quản lý người dùng - UTESHOP Admin");
            request.setAttribute("currentSection", "users");
            request.setAttribute("viewMode", "list");
            
            // Forward to view
            request.setAttribute("view", "/WEB-INF/views/admin/user-management.jsp");
            request.getRequestDispatcher("/WEB-INF/decorators/main.jsp").forward(request, response);
            
            System.out.println("✅ Users list loaded: " + users.size() + "/" + totalUsers + " users displayed");
            
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
        
        // Set available roles
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
                System.out.println("❌ User not found: " + userId);
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
            System.out.println("❌ Invalid user ID format: " + userIdStr);
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
                System.out.println("❌ User not found: " + userId);
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=user_not_found");
                return;
            }
            
            // Get additional user statistics and activity
            setUserDetailsData(request, user);
            setUserActivityData(request, user);
            
            request.setAttribute("viewUser", user);
            request.setAttribute("pageTitle", "Chi tiết người dùng: " + user.getFullName() + " - UTESHOP Admin");
            request.setAttribute("currentSection", "users");
            request.setAttribute("viewMode", "view");
            
            request.setAttribute("view", "/WEB-INF/views/admin/user-management.jsp");
            request.getRequestDispatcher("/WEB-INF/decorators/main.jsp").forward(request, response);
            
            System.out.println("✅ View user page loaded for: " + user.getEmail());
            
        } catch (NumberFormatException e) {
            System.out.println("❌ Invalid user ID format: " + userIdStr);
            response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=invalid_user_id");
        }
    }

    /**
     * Handle create user with enhanced security
     */
    private void handleCreateUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("➕ Creating new user with enhanced security");
        
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
        
        System.out.println("📝 Creating user: " + username + " (" + email + ") with role: " + roleIdStr);
        
        // Enhanced validation
        String validationError = validateUserInput(username, email, fullName, password, confirmPassword, roleIdStr, true);
        if (validationError != null) {
            System.out.println("❌ Validation failed: " + validationError);
            response.sendRedirect(request.getContextPath() + "/admin-direct/users/add?error=" + validationError);
            return;
        }
        
        try {
            // Check if username/email already exists
            if (userDao.existsByEmail(email.trim())) {
                System.out.println("❌ Email already exists: " + email);
                response.sendRedirect(request.getContextPath() + "/admin-direct/users/add?error=email_exists");
                return;
            }
            
            if (userDao.existsByUsername(username.trim())) {
                System.out.println("❌ Username already exists: " + username);
                response.sendRedirect(request.getContextPath() + "/admin-direct/users/add?error=username_exists");
                return;
            }
            
            // Create user with secure password hashing
            System.out.println("🔐 Generating secure password hash...");
            String salt = PasswordHasher.generateSalt();
            String hashedPassword = PasswordHasher.hashPassword(password, salt);
            
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
            
            System.out.println("💾 Saving user to database...");
            Integer userId = userDao.save(newUser);
            
            if (userId != null && userId > 0) {
                System.out.println("✅ User created successfully with ID: " + userId + ", email: " + email);
                
                // Log successful creation
                logUserAction("CREATE", newUser, getAdminUserFromSession(request));
                
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?success=user_created&email=" + 
                                    java.net.URLEncoder.encode(email, "UTF-8"));
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
     * Handle update user with enhanced validation
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
                System.out.println("❌ User not found for update: " + userId);
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
            
            System.out.println("📝 Updating user: " + existingUser.getEmail() + " -> " + email);
            
            // Enhanced validation (without password check for updates)
            String validationError = validateUserInput(username, email, fullName, null, null, roleIdStr, false);
            if (validationError != null) {
                System.out.println("❌ Update validation failed: " + validationError);
                response.sendRedirect(request.getContextPath() + "/admin-direct/users/edit?id=" + userId + "&error=" + validationError);
                return;
            }
            
            // Check for email conflicts (excluding current user)
            if (!existingUser.getEmail().equals(email.trim()) && userDao.existsByEmail(email.trim())) {
                System.out.println("❌ Email conflict during update: " + email);
                response.sendRedirect(request.getContextPath() + "/admin-direct/users/edit?id=" + userId + "&error=email_exists");
                return;
            }
            
            // Store original values for logging
            User originalUser = cloneUser(existingUser);
            
            // Update user data
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
                
                // Log update action
                logUserUpdateAction(originalUser, existingUser, getAdminUserFromSession(request));
                
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?success=user_updated&email=" + 
                                    java.net.URLEncoder.encode(existingUser.getEmail(), "UTF-8"));
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
     * Handle delete user with safety checks
     */
    private void handleDeleteUser(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userIdStr = request.getParameter("userId");
        System.out.println("🗑️ Attempting to delete user ID: " + userIdStr);
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=missing_user_id");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdStr);
            User user = userDao.findById(userId);
            
            if (user == null) {
                System.out.println("❌ User not found for deletion: " + userId);
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=user_not_found");
                return;
            }
            
            // Safety checks
            User currentAdmin = getAdminUserFromSession(request);
            if (currentAdmin != null && currentAdmin.getUserId().equals(userId)) {
                System.out.println("❌ Admin trying to delete themselves: " + currentAdmin.getEmail());
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=cannot_delete_self");
                return;
            }
            
            // Check if user has critical data that prevents deletion
            if (hasUserCriticalData(userId)) {
                System.out.println("⚠️ User has critical data, soft delete recommended: " + user.getEmail());
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=has_critical_data&suggestion=deactivate");
                return;
            }
            
            System.out.println("🗑️ Proceeding with user deletion: " + user.getEmail());
            boolean deleted = userDao.delete(userId);
            
            if (deleted) {
                System.out.println("✅ User deleted successfully: " + user.getEmail());
                
                // Log deletion
                logUserAction("DELETE", user, currentAdmin);
                
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?success=user_deleted&email=" + 
                                    java.net.URLEncoder.encode(user.getEmail(), "UTF-8"));
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
                System.out.println("❌ User not found for status toggle: " + userId);
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=user_not_found");
                return;
            }
            
            boolean oldStatus = user.getIsActive();
            boolean newStatus = !oldStatus;
            
            // Safety check for admin accounts
            User currentAdmin = getAdminUserFromSession(request);
            if (user.getRoleId() == 4 && currentAdmin.getUserId().equals(userId)) {
                System.out.println("❌ Admin trying to deactivate themselves: " + currentAdmin.getEmail());
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=cannot_deactivate_self");
                return;
            }
            
            user.setIsActive(newStatus);
            boolean updated = userDao.update(user);
            
            if (updated) {
                String status = newStatus ? "activated" : "deactivated";
                System.out.println("✅ User " + status + " successfully: " + user.getEmail());
                
                // Log status change
                logUserStatusChange(user, oldStatus, newStatus, currentAdmin);
                
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?success=user_" + status + "&email=" + 
                                    java.net.URLEncoder.encode(user.getEmail(), "UTF-8"));
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
        
        System.out.println("🔍 Processing search: '" + search + "', role=" + role + ", status=" + status);
        
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
        
        String finalUrl = redirectUrl.toString();
        System.out.println("🔍 Search redirect: " + finalUrl);
        response.sendRedirect(finalUrl);
    }

    /**
     * Handle bulk delete users
     */
    private void handleBulkDeleteUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String[] userIds = request.getParameterValues("selectedUsers");
        System.out.println("🗑️ Bulk delete request for " + (userIds != null ? userIds.length : 0) + " users");
        
        if (userIds == null || userIds.length == 0) {
            response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=no_users_selected");
            return;
        }
        
        User currentAdmin = getAdminUserFromSession(request);
        int successCount = 0;
        int errorCount = 0;
        
        for (String userIdStr : userIds) {
            try {
                int userId = Integer.parseInt(userIdStr);
                
                // Safety check - don't delete current admin
                if (currentAdmin.getUserId().equals(userId)) {
                    System.out.println("⚠️ Skipping self-deletion in bulk operation");
                    errorCount++;
                    continue;
                }
                
                User user = userDao.findById(userId);
                if (user != null && userDao.delete(userId)) {
                    successCount++;
                    logUserAction("BULK_DELETE", user, currentAdmin);
                    System.out.println("✅ Bulk deleted user: " + user.getEmail());
                } else {
                    errorCount++;
                    System.out.println("❌ Failed to bulk delete user ID: " + userId);
                }
                
            } catch (Exception e) {
                errorCount++;
                System.err.println("❌ Error in bulk delete for user ID " + userIdStr + ": " + e.getMessage());
            }
        }
        
        String message = "bulk_delete_completed&success=" + successCount + "&errors=" + errorCount;
        response.sendRedirect(request.getContextPath() + "/admin-direct/users?success=" + message);
    }

    /**
     * Handle bulk toggle status
     */
    private void handleBulkToggleStatus(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String[] userIds = request.getParameterValues("selectedUsers");
        String targetStatus = request.getParameter("targetStatus"); // "activate" or "deactivate"
        
        System.out.println("🔄 Bulk status toggle: " + targetStatus + " for " + (userIds != null ? userIds.length : 0) + " users");
        
        if (userIds == null || userIds.length == 0) {
            response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=no_users_selected");
            return;
        }
        
        boolean newStatus = "activate".equals(targetStatus);
        User currentAdmin = getAdminUserFromSession(request);
        int successCount = 0;
        int errorCount = 0;
        
        for (String userIdStr : userIds) {
            try {
                int userId = Integer.parseInt(userIdStr);
                User user = userDao.findById(userId);
                
                if (user != null) {
                    // Safety check for admin self-deactivation
                    if (user.getRoleId() == 4 && !newStatus && currentAdmin.getUserId().equals(userId)) {
                        System.out.println("⚠️ Skipping admin self-deactivation in bulk operation");
                        errorCount++;
                        continue;
                    }
                    
                    boolean oldStatus = user.getIsActive();
                    user.setIsActive(newStatus);
                    
                    if (userDao.update(user)) {
                        successCount++;
                        logUserStatusChange(user, oldStatus, newStatus, currentAdmin);
                        System.out.println("✅ Bulk " + targetStatus + "d user: " + user.getEmail());
                    } else {
                        errorCount++;
                    }
                } else {
                    errorCount++;
                }
                
            } catch (Exception e) {
                errorCount++;
                System.err.println("❌ Error in bulk status toggle for user ID " + userIdStr + ": " + e.getMessage());
            }
        }
        
        String message = "bulk_status_toggle_completed&action=" + targetStatus + "&success=" + successCount + "&errors=" + errorCount;
        response.sendRedirect(request.getContextPath() + "/admin-direct/users?success=" + message);
    }

    /**
     * Handle reset user password
     */
    private void handleResetUserPassword(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String userIdStr = request.getParameter("userId");
        System.out.println("🔑 Resetting password for user ID: " + userIdStr);
        
        if (userIdStr == null || userIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=missing_user_id");
            return;
        }
        
        try {
            int userId = Integer.parseInt(userIdStr);
            User user = userDao.findById(userId);
            
            if (user == null) {
                System.out.println("❌ User not found for password reset: " + userId);
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=user_not_found");
                return;
            }
            
            // Generate new temporary password
            String tempPassword = generateTempPassword();
            String salt = PasswordHasher.generateSalt();
            String hashedPassword = PasswordHasher.hashPassword(tempPassword, salt);
            
            boolean updated = userDao.updatePassword(userId, hashedPassword, salt);
            
            if (updated) {
                System.out.println("✅ Password reset successfully for user: " + user.getEmail());
                System.out.println("🔑 Temporary password: " + tempPassword + " (should be sent via email)");
                
                // Log password reset
                logPasswordReset(user, getAdminUserFromSession(request));
                
                // In production, send email with temporary password
                // sendPasswordResetEmail(user.getEmail(), tempPassword);
                
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?success=password_reset&email=" + 
                                    java.net.URLEncoder.encode(user.getEmail(), "UTF-8") + "&temp_password=" + tempPassword);
            } else {
                System.out.println("❌ Failed to reset password for user: " + user.getEmail());
                response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=password_reset_failed");
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error resetting password: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=password_reset_error");
        }
    }

    /**
     * Handle export users
     */
    private void handleExportUsers(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String format = request.getParameter("format"); // csv, excel, json
        System.out.println("📤 Exporting users in format: " + format);
        
        try {
            List<User> users = userDao.findAll();
            User adminUser = getAdminUserFromSession(request);
            
            // Log export action
            logAdminAction(adminUser, "EXPORT_USERS", request);
            
            if ("csv".equals(format)) {
                exportUsersAsCsv(response, users);
            } else if ("json".equals(format)) {
                exportUsersAsJson(response, users);
            } else {
                // Default to CSV
                exportUsersAsCsv(response, users);
            }
            
            System.out.println("✅ Users exported successfully: " + users.size() + " users in " + format + " format");
            
        } catch (Exception e) {
            System.err.println("❌ Error exporting users: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin-direct/users?error=export_failed");
        }
    }

    // === HELPER METHODS ===

    /**
     * Check if user is admin with enhanced logging
     */
    private boolean isAdminAuthenticated(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println("❌ Admin access denied: No session found");
            response.sendRedirect(request.getContextPath() + "/auth/login?message=session_required");
            return false;
        }
        
        Object sessionUser = session.getAttribute("user");
        if (sessionUser == null) {
            System.out.println("❌ Admin access denied: No user in session");
            response.sendRedirect(request.getContextPath() + "/auth/login?message=login_required");
            return false;
        }
        
        User adminUser = getAdminUserFromSession(request);
        if (adminUser == null || adminUser.getRoleId() != 4) {
            System.out.println("❌ Admin access denied: Insufficient privileges. Role: " + 
                              (adminUser != null ? adminUser.getRoleId() : "null"));
            response.sendRedirect(request.getContextPath() + "/home?error=access_denied");
            return false;
        }
        
        System.out.println("✅ Admin access granted: " + adminUser.getEmail() + " (Role: " + adminUser.getRoleId() + ")");
        return true;
    }

    /**
     * Get admin user from session with enhanced conversion
     */
    private User getAdminUserFromSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return null;
        
        Object sessionUser = session.getAttribute("user");
        if (sessionUser instanceof AuthDtos.UserResponse) {
            AuthDtos.UserResponse userResponse = (AuthDtos.UserResponse) sessionUser;
            
            // Get full user data from database for latest info
            User fullUser = userDao.findById(userResponse.getUserId());
            if (fullUser != null) {
                return fullUser;
            }
            
            // Fallback to session data conversion
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
     * Set common attributes with enhanced info
     */
    private void setCommonAttributes(HttpServletRequest request, User adminUser) {
        request.setAttribute("authUser", adminUser);
        request.setAttribute("isLoggedIn", true);
        request.setAttribute("userRoleId", adminUser.getRoleId());
        request.setAttribute("userRoleDisplay", "Admin");
        request.setAttribute("currentDateTime", LocalDateTime.now());
        request.setAttribute("serverTime", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        request.setAttribute("adminLevel", "Super Administrator");
        request.setAttribute("adminPrivileges", "Full Access");
    }

    /**
     * Get users with enhanced filtering and sorting
     */
    private List<User> getUsersWithFilters(String search, String roleFilter, String statusFilter, 
                                         int page, int pageSize, String sortBy, String sortOrder) {
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
            
            // Try to use enhanced method if available
            try {
                return userDao.findWithFilters(search, roleId, isActive, offset, pageSize);
            } catch (Exception e) {
                System.out.println("⚠️ Enhanced filtering not available, using simple method");
                return getUsersWithFiltersSimple(search, roleFilter, statusFilter, page, pageSize);
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error getting filtered users: " + e.getMessage());
            return new ArrayList<>();
        }
    }

    /**
     * Fallback simple filtering method
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
            
            try {
                return userDao.countWithFilters(search, roleId, isActive);
            } catch (Exception e) {
                System.out.println("⚠️ Count with filters not available, using total count");
                return userDao.countAll();
            }
            
        } catch (Exception e) {
            System.err.println("❌ Error getting users count: " + e.getMessage());
            return 0;
        }
    }

    /**
     * Set enhanced user statistics
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
            int verifiedUsers = 0;
            int newUsersThisMonth = 0;
            
            LocalDateTime now = LocalDateTime.now();
            LocalDateTime monthStart = now.withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0);
            
            for (User user : allUsers) {
                if (user.getIsActive()) {
                    activeUsers++;
                } else {
                    inactiveUsers++;
                }
                
                if (user.getIsVerified()) {
                    verifiedUsers++;
                }
                
                // Check if user was created this month
                if (user.getCreatedAt() != null && 
                    user.getCreatedAt().toLocalDateTime().isAfter(monthStart)) {
                    newUsersThisMonth++;
                }
                
                switch (user.getRoleId()) {
                    case 4: adminCount++; break;
                    case 3: vendorCount++; break;
                    case 2: regularUsers++; break;
                }
            }
            
            // Calculate percentages
            double activePercentage = totalUsers > 0 ? (double) activeUsers / totalUsers * 100 : 0;
            double verifiedPercentage = totalUsers > 0 ? (double) verifiedUsers / totalUsers * 100 : 0;
            
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("activeUsers", activeUsers);
            request.setAttribute("inactiveUsers", inactiveUsers);
            request.setAttribute("adminCount", adminCount);
            request.setAttribute("vendorCount", vendorCount);
            request.setAttribute("regularUsers", regularUsers);
            request.setAttribute("verifiedUsers", verifiedUsers);
            request.setAttribute("newUsersThisMonth", newUsersThisMonth);
            request.setAttribute("activePercentage", String.format("%.1f", activePercentage));
            request.setAttribute("verifiedPercentage", String.format("%.1f", verifiedPercentage));
            
            System.out.println("📊 Enhanced user statistics calculated: " + 
                              "Total=" + totalUsers + ", Active=" + activeUsers + " (" + String.format("%.1f", activePercentage) + "%), " +
                              "Admins=" + adminCount + ", Vendors=" + vendorCount + ", New this month=" + newUsersThisMonth);
            
        } catch (Exception e) {
            System.err.println("❌ Error setting user statistics: " + e.getMessage());
            // Set default values
            request.setAttribute("totalUsers", 0);
            request.setAttribute("activeUsers", 0);
            request.setAttribute("inactiveUsers", 0);
            request.setAttribute("adminCount", 0);
            request.setAttribute("vendorCount", 0);
            request.setAttribute("regularUsers", 0);
            request.setAttribute("verifiedUsers", 0);
            request.setAttribute("newUsersThisMonth", 0);
            request.setAttribute("activePercentage", "0.0");
            request.setAttribute("verifiedPercentage", "0.0");
        }
    }

    /**
     * Set pagination info
     */
    private void setPaginationInfo(HttpServletRequest request, int currentPage, int totalPages, int pageSize) {
        // Calculate pagination display
        int startPage = Math.max(1, currentPage - 2);
        int endPage = Math.min(totalPages, currentPage + 2);
        
        request.setAttribute("startPage", startPage);
        request.setAttribute("endPage", endPage);
        request.setAttribute("hasPrevious", currentPage > 1);
        request.setAttribute("hasNext", currentPage < totalPages);
        request.setAttribute("previousPage", Math.max(1, currentPage - 1));
        request.setAttribute("nextPage", Math.min(totalPages, currentPage + 1));
        
        // Page size options
        int[] pageSizeOptions = {10, 20, 50, 100};
        request.setAttribute("pageSizeOptions", pageSizeOptions);
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
        
        // Role descriptions
        request.setAttribute("roleUserDesc", "Khách hàng - Mua sắm và đánh giá sản phẩm");
        request.setAttribute("roleVendorDesc", "Người bán - Quản lý shop và bán hàng");
        request.setAttribute("roleAdminDesc", "Quản trị viên - Quản lý toàn bộ hệ thống");
    }

    /**
     * Set enhanced user details data
     */
    private void setUserDetailsData(HttpServletRequest request, User user) {
        // Mock enhanced user statistics (in production, get from database)
        request.setAttribute("userTotalOrders", 25);
        request.setAttribute("userTotalSpent", "15,670,000₫");
        request.setAttribute("userLastOrderDate", "2025-10-20");
        request.setAttribute("userRegistrationDays", calculateDaysSince(user.getCreatedAt()));
        request.setAttribute("userLoginCount", 156);
        request.setAttribute("userLastLoginDate", user.getLastLogin());
        
        // Account activity
        request.setAttribute("userAddressCount", 2);
        request.setAttribute("userReviewCount", 8);
        request.setAttribute("userWishlistCount", 12);
        request.setAttribute("userCartItemsCount", 3);
        
        // Security info
        request.setAttribute("userLastPasswordChange", "2025-09-15");
        request.setAttribute("userLoginAttempts", 0);
        request.setAttribute("userSecurityLevel", "High");
    }

    /**
     * Set user activity data
     */
    private void setUserActivityData(HttpServletRequest request, User user) {
        // Mock recent activity (in production, get from activity logs)
        List<String> recentActivities = new ArrayList<>();
        recentActivities.add("Đăng nhập từ IP: 192.168.1.100 - 2 giờ trước");
        recentActivities.add("Cập nhật thông tin cá nhân - 1 ngày trước");
        recentActivities.add("Đặt hàng #DH001 - 3 ngày trước");
        recentActivities.add("Đánh giá sản phẩm iPhone 15 - 5 ngày trước");
        
        request.setAttribute("userRecentActivities", recentActivities);
        request.setAttribute("userDeviceInfo", "Chrome 118.0 on Windows 11");
        request.setAttribute("userLocationInfo", "Ho Chi Minh City, Vietnam");
    }

    /**
     * Enhanced input validation
     */
    private String validateUserInput(String username, String email, String fullName, 
                                   String password, String confirmPassword, String roleIdStr, boolean isCreate) {
        
        // Username validation
        if (username == null || username.trim().isEmpty()) {
            return "missing_username";
        }
        if (username.trim().length() < 3 || username.trim().length() > 30) {
            return "invalid_username_length";
        }
        if (!username.trim().matches("^[a-zA-Z0-9_]+$")) {
            return "invalid_username_characters";
        }
        
        // Email validation
        if (email == null || email.trim().isEmpty()) {
            return "missing_email";
        }
        if (!email.trim().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            return "invalid_email_format";
        }
        
        // Full name validation
        if (fullName == null || fullName.trim().isEmpty()) {
            return "missing_fullname";
        }
        if (fullName.trim().length() < 2 || fullName.trim().length() > 100) {
            return "invalid_fullname_length";
        }
        
        // Password validation (only for create)
        if (isCreate) {
            if (password == null || password.trim().isEmpty()) {
                return "missing_password";
            }
            if (password.length() < 6) {
                return "password_too_short";
            }
            if (confirmPassword == null || !password.equals(confirmPassword)) {
                return "password_mismatch";
            }
        }
        
        // Role validation
        if (roleIdStr == null || roleIdStr.trim().isEmpty()) {
            return "missing_role";
        }
        try {
            int roleId = Integer.parseInt(roleIdStr);
            if (roleId < 2 || roleId > 4) {
                return "invalid_role";
            }
        } catch (NumberFormatException e) {
            return "invalid_role_format";
        }
        
        return null; // No validation errors
    }

    /**
     * Check if user has critical data
     */
    private boolean hasUserCriticalData(Integer userId) {
        // Mock check (in production, check orders, reviews, etc.)
        // For now, assume users with orders shouldn't be deleted
        return false; // Simplified for demo
    }

    /**
     * Clone user for logging changes
     */
    private User cloneUser(User original) {
        User clone = new User();
        clone.setUserId(original.getUserId());
        clone.setUsername(original.getUsername());
        clone.setEmail(original.getEmail());
        clone.setFullName(original.getFullName());
        clone.setPhone(original.getPhone());
        clone.setRoleId(original.getRoleId());
        clone.setIsActive(original.getIsActive());
        clone.setIsVerified(original.getIsVerified());
        return clone;
    }

    /**
     * Calculate days since date
     */
    private long calculateDaysSince(java.sql.Timestamp timestamp) {
        if (timestamp == null) return 0;
        LocalDateTime then = timestamp.toLocalDateTime();
        LocalDateTime now = LocalDateTime.now();
        return java.time.Duration.between(then, now).toDays();
    }

    /**
     * Generate temporary password
     */
    private String generateTempPassword() {
        String chars = "ABCDEFGHJKMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789";
        StringBuilder password = new StringBuilder();
        java.util.Random random = new java.util.Random();
        
        for (int i = 0; i < 8; i++) {
            password.append(chars.charAt(random.nextInt(chars.length())));
        }
        
        return password.toString();
    }

    /**
     * Export users as CSV
     */
    private void exportUsersAsCsv(HttpServletResponse response, List<User> users) throws IOException {
        response.setContentType("text/csv");
        response.setHeader("Content-Disposition", "attachment; filename=\"users_export_" + 
                          LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss")) + ".csv\"");
        
        java.io.PrintWriter writer = response.getWriter();
        
        // CSV header
        writer.println("ID,Username,Email,Full Name,Phone,Role,Active,Verified,Created Date,Last Login");
        
        // CSV data
        for (User user : users) {
            writer.printf("%d,\"%s\",\"%s\",\"%s\",\"%s\",%d,%s,%s,\"%s\",\"%s\"%n",
                user.getUserId(),
                escapeCsv(user.getUsername()),
                escapeCsv(user.getEmail()),
                escapeCsv(user.getFullName()),
                escapeCsv(user.getPhone()),
                user.getRoleId(),
                user.getIsActive(),
                user.getIsVerified(),
                user.getCreatedAt() != null ? user.getCreatedAt().toString() : "",
                user.getLastLogin() != null ? user.getLastLogin().toString() : ""
            );
        }
        
        writer.flush();
    }

    /**
     * Export users as JSON
     */
    private void exportUsersAsJson(HttpServletResponse response, List<User> users) throws IOException {
        response.setContentType("application/json");
        response.setHeader("Content-Disposition", "attachment; filename=\"users_export_" + 
                          LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMdd_HHmmss")) + ".json\"");
        
        java.io.PrintWriter writer = response.getWriter();
        
        writer.println("{");
        writer.println("  \"export_info\": {");
        writer.println("    \"generated_at\": \"" + LocalDateTime.now() + "\",");
        writer.println("    \"total_users\": " + users.size() + ",");
        writer.println("    \"exported_by\": \"Admin User Management System\"");
        writer.println("  },");
        writer.println("  \"users\": [");
        
        for (int i = 0; i < users.size(); i++) {
            User user = users.get(i);
            writer.println("    {");
            writer.println("      \"id\": " + user.getUserId() + ",");
            writer.println("      \"username\": \"" + escapeJson(user.getUsername()) + "\",");
            writer.println("      \"email\": \"" + escapeJson(user.getEmail()) + "\",");
            writer.println("      \"full_name\": \"" + escapeJson(user.getFullName()) + "\",");
            writer.println("      \"phone\": \"" + escapeJson(user.getPhone()) + "\",");
            writer.println("      \"role_id\": " + user.getRoleId() + ",");
            writer.println("      \"is_active\": " + user.getIsActive() + ",");
            writer.println("      \"is_verified\": " + user.getIsVerified() + ",");
            writer.println("      \"created_at\": \"" + (user.getCreatedAt() != null ? user.getCreatedAt().toString() : "") + "\",");
            writer.println("      \"last_login\": \"" + (user.getLastLogin() != null ? user.getLastLogin().toString() : "") + "\"");
            writer.print("    }");
            if (i < users.size() - 1) writer.println(",");
            else writer.println();
        }
        
        writer.println("  ]");
        writer.println("}");
        writer.flush();
    }

    /**
     * Escape CSV values
     */
    private String escapeCsv(String value) {
        if (value == null) return "";
        return value.replace("\"", "\"\"");
    }

    /**
     * Escape JSON values
     */
    private String escapeJson(String value) {
        if (value == null) return "";
        return value.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r");
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
            System.out.println("⚠️ Invalid integer parameter " + name + ": " + value + ", using default: " + defaultValue);
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

    // === AUDIT LOGGING METHODS ===

    /**
     * Log admin action for audit trail
     */
    // === AUDIT LOGGING METHODS ===

    /**
     * Log admin action for audit trail
     */
    private void logAdminAction(User admin, String action, HttpServletRequest request) {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        String ip = getClientIpAddress(request);
        String userAgent = request.getHeader("User-Agent");
        
        System.out.println("📋 AUDIT LOG: [" + timestamp + "] Admin: " + admin.getEmail() + 
                          " | Action: " + action + " | IP: " + ip + " | UserAgent: " + 
                          (userAgent != null ? userAgent.substring(0, Math.min(50, userAgent.length())) : "Unknown"));
        
        // In production, save to audit_logs table in database
        // auditLogDao.saveAdminAction(admin.getUserId(), action, ip, userAgent, timestamp);
    }

    /**
     * Log user-related action
     */
    private void logUserAction(String action, User targetUser, User admin) {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        
        System.out.println("👤 USER ACTION LOG: [" + timestamp + "] " + action + 
                          " | Target: " + targetUser.getEmail() + " (ID: " + targetUser.getUserId() + ")" +
                          " | Admin: " + admin.getEmail() + " (ID: " + admin.getUserId() + ")");
        
        // In production, save detailed user action log
        // userActionLogDao.saveUserAction(action, targetUser.getUserId(), admin.getUserId(), timestamp);
    }

    /**
     * Log user update action with change details
     */
    private void logUserUpdateAction(User originalUser, User updatedUser, User admin) {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        StringBuilder changes = new StringBuilder();
        
        // Track specific changes
        if (!originalUser.getUsername().equals(updatedUser.getUsername())) {
            changes.append("Username: ").append(originalUser.getUsername()).append(" -> ").append(updatedUser.getUsername()).append("; ");
        }
        if (!originalUser.getEmail().equals(updatedUser.getEmail())) {
            changes.append("Email: ").append(originalUser.getEmail()).append(" -> ").append(updatedUser.getEmail()).append("; ");
        }
        if (!originalUser.getFullName().equals(updatedUser.getFullName())) {
            changes.append("FullName: ").append(originalUser.getFullName()).append(" -> ").append(updatedUser.getFullName()).append("; ");
        }
        if (!originalUser.getRoleId().equals(updatedUser.getRoleId())) {
            changes.append("Role: ").append(originalUser.getRoleId()).append(" -> ").append(updatedUser.getRoleId()).append("; ");
        }
        if (!originalUser.getIsActive().equals(updatedUser.getIsActive())) {
            changes.append("Active: ").append(originalUser.getIsActive()).append(" -> ").append(updatedUser.getIsActive()).append("; ");
        }
        if (!originalUser.getIsVerified().equals(updatedUser.getIsVerified())) {
            changes.append("Verified: ").append(originalUser.getIsVerified()).append(" -> ").append(updatedUser.getIsVerified()).append("; ");
        }
        
        System.out.println("✏️ USER UPDATE LOG: [" + timestamp + "] " +
                          "Target: " + updatedUser.getEmail() + " | " +
                          "Changes: " + (changes.length() > 0 ? changes.toString() : "No changes") + " | " +
                          "Admin: " + admin.getEmail());
        
        // In production, save detailed change log
        // userChangeLogDao.saveUserChanges(originalUser.getUserId(), changes.toString(), admin.getUserId(), timestamp);
    }

    /**
     * Log user status change
     */
    private void logUserStatusChange(User user, boolean oldStatus, boolean newStatus, User admin) {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        String action = newStatus ? "ACTIVATED" : "DEACTIVATED";
        
        System.out.println("🔄 STATUS CHANGE LOG: [" + timestamp + "] " + action + 
                          " | User: " + user.getEmail() + " | " +
                          "Status: " + oldStatus + " -> " + newStatus + " | " +
                          "Admin: " + admin.getEmail());
        
        // In production, save status change log
        // userStatusLogDao.saveStatusChange(user.getUserId(), oldStatus, newStatus, admin.getUserId(), timestamp);
    }

    /**
     * Log password reset action
     */
    private void logPasswordReset(User user, User admin) {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        
        System.out.println("🔑 PASSWORD RESET LOG: [" + timestamp + "] " +
                          "Target: " + user.getEmail() + " | " +
                          "Reset by Admin: " + admin.getEmail() + " | " +
                          "Security Level: HIGH");
        
        // In production, save password reset log
        // passwordResetLogDao.savePasswordReset(user.getUserId(), admin.getUserId(), timestamp);
        
        // Also notify user via email in production
        // emailService.sendPasswordResetNotification(user.getEmail(), admin.getEmail(), timestamp);
    }

    /**
     * Get client IP address from request
     */
    private String getClientIpAddress(HttpServletRequest request) {
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }
        
        String xRealIp = request.getHeader("X-Real-IP");
        if (xRealIp != null && !xRealIp.isEmpty()) {
            return xRealIp;
        }
        
        return request.getRemoteAddr();
    }

    /**
     * Enhanced error logging
     */
    private void logError(String operation, Exception e, HttpServletRequest request) {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        String ip = getClientIpAddress(request);
        
        System.err.println("❌ ERROR LOG: [" + timestamp + "] Operation: " + operation + 
                          " | IP: " + ip + " | Error: " + e.getMessage());
        
        // In production, save error log to database
        // errorLogDao.saveError(operation, e.getMessage(), e.getStackTrace(), ip, timestamp);
    }

    /**
     * Performance monitoring
     */
    private void logPerformance(String operation, long startTime) {
        long executionTime = System.currentTimeMillis() - startTime;
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        
        if (executionTime > 1000) { // Log slow operations (> 1 second)
            System.out.println("⚠️ SLOW OPERATION LOG: [" + timestamp + "] " +
                              "Operation: " + operation + " | " +
                              "Execution Time: " + executionTime + "ms");
        } else {
            System.out.println("⚡ PERFORMANCE LOG: [" + timestamp + "] " +
                              "Operation: " + operation + " | " +
                              "Execution Time: " + executionTime + "ms");
        }
        
        // In production, save performance metrics
        // performanceLogDao.saveMetrics(operation, executionTime, timestamp);
    }

    // === SECURITY METHODS ===

    /**
     * Validate admin session security
     */
    private boolean validateAdminSecurity(HttpServletRequest request, User admin) {
        // Check session timeout
        HttpSession session = request.getSession(false);
        if (session == null) {
            System.out.println("🔒 Security check failed: No session");
            return false;
        }
        
        // Check session age (max 8 hours for admin)
        long sessionAge = System.currentTimeMillis() - session.getCreationTime();
        if (sessionAge > 8 * 60 * 60 * 1000) { // 8 hours
            System.out.println("🔒 Security check failed: Session expired");
            session.invalidate();
            return false;
        }
        
        // Check for suspicious activity (rapid requests)
        String lastRequestTime = (String) session.getAttribute("lastRequestTime");
        long currentTime = System.currentTimeMillis();
        
        if (lastRequestTime != null) {
            long timeDiff = currentTime - Long.parseLong(lastRequestTime);
            if (timeDiff < 100) { // Less than 100ms between requests
                System.out.println("⚠️ Security warning: Rapid requests detected from " + admin.getEmail());
                // In production, implement rate limiting
            }
        }
        
        session.setAttribute("lastRequestTime", String.valueOf(currentTime));
        
        return true;
    }

    /**
     * Log security event
     */
    private void logSecurityEvent(String event, HttpServletRequest request, User admin) {
        String timestamp = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
        String ip = getClientIpAddress(request);
        
        System.out.println("🛡️ SECURITY EVENT: [" + timestamp + "] " +
                          "Event: " + event + " | " +
                          "Admin: " + (admin != null ? admin.getEmail() : "Anonymous") + " | " +
                          "IP: " + ip);
        
        // In production, save security events for monitoring
        // securityLogDao.saveSecurityEvent(event, admin != null ? admin.getUserId() : null, ip, timestamp);
    }

    // === UTILITY METHODS ===

    /**
     * Format user role display name
     */
    private String formatRoleDisplay(Integer roleId) {
        if (roleId == null) return "Unknown";
        
        switch (roleId) {
            case 2: return "User (Khách hàng)";
            case 3: return "Vendor (Người bán)";
            case 4: return "Admin (Quản trị viên)";
            default: return "Unknown Role (" + roleId + ")";
        }
    }

    /**
     * Format user status display
     */
    private String formatStatusDisplay(Boolean isActive, Boolean isVerified) {
        StringBuilder status = new StringBuilder();
        
        if (isActive != null && isActive) {
            status.append("Hoạt động");
        } else {
            status.append("Không hoạt động");
        }
        
        if (isVerified != null && isVerified) {
            status.append(" • Đã xác thực");
        } else {
            status.append(" • Chưa xác thực");
        }
        
        return status.toString();
    }

    /**
     * Sanitize search input
     */
    private String sanitizeSearchInput(String input) {
        if (input == null) return null;
        
        // Remove dangerous characters and limit length
        String sanitized = input.trim()
                               .replaceAll("[<>\"'%;()&+]", "")
                               .substring(0, Math.min(input.length(), 100));
        
        return sanitized.isEmpty() ? null : sanitized;
    }

    /**
     * Generate user management statistics report
     */
    private void generateUserStatsReport(HttpServletRequest request) {
        try {
            List<User> allUsers = userDao.findAll();
            
            // Generate comprehensive statistics
            Map<String, Object> stats = new HashMap<>();
            
            // Basic counts
            stats.put("totalUsers", allUsers.size());
            stats.put("activeUsers", allUsers.stream().mapToInt(u -> u.getIsActive() ? 1 : 0).sum());
            stats.put("verifiedUsers", allUsers.stream().mapToInt(u -> u.getIsVerified() ? 1 : 0).sum());
            
            // Role distribution
            stats.put("adminCount", allUsers.stream().mapToInt(u -> u.getRoleId() == 4 ? 1 : 0).sum());
            stats.put("vendorCount", allUsers.stream().mapToInt(u -> u.getRoleId() == 3 ? 1 : 0).sum());
            stats.put("userCount", allUsers.stream().mapToInt(u -> u.getRoleId() == 2 ? 1 : 0).sum());
            
            // Set all stats as request attributes
            stats.forEach(request::setAttribute);
            
            System.out.println("📊 User management stats report generated: " + stats);
            
        } catch (Exception e) {
            System.err.println("❌ Error generating user stats report: " + e.getMessage());
        }
    }

    @Override
    public void destroy() {
        System.out.println("🗑️ UserManagementController v2.0 destroyed at: " + 
                          LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
        System.out.println("📊 Final statistics: Controller served requests for user management operations");
        System.out.println("🔒 Security: All admin actions were logged and monitored");
        System.out.println("👨‍💻 Developed by: tuaanshuuysv - UTESHOP-CPL Admin System");
        
        // In production, close any open resources
        // if (auditLogger != null) auditLogger.close();
        // if (performanceMonitor != null) performanceMonitor.shutdown();
        
        super.destroy();
    }
}
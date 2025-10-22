<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- UTESHOP-CPL Admin - User Management -->
<!-- Fixed: 2025-10-22 23:17:00 UTC by tuaanshuuysv -->
<!-- Fixed: Role display logic for correct badge colors -->

<div class="user-management-page">
    
    <!-- Page Header (giữ nguyên) -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-1">
                <c:choose>
                    <c:when test="${viewMode == 'add'}">
                        <i class="fas fa-user-plus text-primary"></i> Thêm người dùng mới
                    </c:when>
                    <c:when test="${viewMode == 'edit'}">
                        <i class="fas fa-user-edit text-warning"></i> Chỉnh sửa người dùng
                    </c:when>
                    <c:when test="${viewMode == 'view'}">
                        <i class="fas fa-user text-info"></i> Chi tiết người dùng
                    </c:when>
                    <c:otherwise>
                        <i class="fas fa-users text-primary"></i> Quản lý người dùng
                    </c:otherwise>
                </c:choose>
            </h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/admin-direct">
                            <i class="fas fa-tachometer-alt"></i> Dashboard
                        </a>
                    </li>
                    <li class="breadcrumb-item">
                        <a href="${pageContext.request.contextPath}/admin-direct/users">Người dùng</a>
                    </li>
                    <c:if test="${viewMode != 'list'}">
                        <li class="breadcrumb-item active">
                            <c:choose>
                                <c:when test="${viewMode == 'add'}">Thêm mới</c:when>
                                <c:when test="${viewMode == 'edit'}">Chỉnh sửa</c:when>
                                <c:when test="${viewMode == 'view'}">Chi tiết</c:when>
                            </c:choose>
                        </li>
                    </c:if>
                </ol>
            </nav>
        </div>
        <div class="header-actions">
            <c:choose>
                <c:when test="${viewMode == 'list'}">
                    <a href="${pageContext.request.contextPath}/admin-direct/users/add" class="btn btn-primary">
                        <i class="fas fa-plus me-1"></i>Thêm người dùng
                    </a>
                    <button class="btn btn-outline-success ms-2" onclick="exportUsers('excel')">
                        <i class="fas fa-file-excel me-1"></i>Xuất Excel
                    </button>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/admin-direct/users" class="btn btn-secondary">
                        <i class="fas fa-arrow-left me-1"></i>Quay lại danh sách
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Success/Error Messages (giữ nguyên) -->
    <c:if test="${param.success != null}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="fas fa-check-circle me-2"></i>
            <c:choose>
                <c:when test="${param.success == 'user_created'}">
                    Tạo người dùng thành công: <strong>${param.email}</strong>
                </c:when>
                <c:when test="${param.success == 'user_updated'}">
                    Cập nhật người dùng thành công: <strong>${param.email}</strong>
                </c:when>
                <c:when test="${param.success == 'user_deleted'}">
                    Xóa người dùng thành công: <strong>${param.email}</strong>
                </c:when>
                <c:when test="${param.success == 'user_activated'}">
                    Kích hoạt người dùng thành công: <strong>${param.email}</strong>
                </c:when>
                <c:when test="${param.success == 'user_deactivated'}">
                    Vô hiệu hóa người dùng thành công: <strong>${param.email}</strong>
                </c:when>
                <c:otherwise>Thao tác thành công!</c:otherwise>
            </c:choose>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:if test="${param.error != null}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-triangle me-2"></i>
            <c:choose>
                <c:when test="${param.error == 'user_not_found'}">Không tìm thấy người dùng!</c:when>
                <c:when test="${param.error == 'email_exists'}">Email đã tồn tại trong hệ thống!</c:when>
                <c:when test="${param.error == 'username_exists'}">Tên đăng nhập đã tồn tại!</c:when>
                <c:when test="${param.error == 'password_mismatch'}">Xác nhận mật khẩu không khớp!</c:when>
                <c:when test="${param.error == 'missing_fields'}">Vui lòng điền đầy đủ thông tin bắt buộc!</c:when>
                <c:when test="${param.error == 'cannot_delete_self'}">Không thể xóa tài khoản của chính mình!</c:when>
                <c:otherwise>Có lỗi xảy ra: ${param.error}</c:otherwise>
            </c:choose>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <c:choose>
        <%-- ADD USER FORM (giữ nguyên) --%>
        <c:when test="${viewMode == 'add'}">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-user-plus me-2"></i>Thông tin người dùng mới
                    </h5>
                </div>
                <div class="card-body">
                    <form method="POST" action="${pageContext.request.contextPath}/admin-direct/users" class="needs-validation" novalidate>
                        <input type="hidden" name="action" value="create">
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="username" class="form-label">
                                        Tên đăng nhập <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="username" name="username" required
                                           pattern="^[a-zA-Z0-9_]{3,30}$" 
                                           title="3-30 ký tự, chỉ chữ cái, số và dấu gạch dưới">
                                    <div class="invalid-feedback">
                                        Tên đăng nhập phải có 3-30 ký tự, chỉ chứa chữ cái, số và dấu gạch dưới
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="email" class="form-label">
                                        Email <span class="text-danger">*</span>
                                    </label>
                                    <input type="email" class="form-control" id="email" name="email" required>
                                    <div class="invalid-feedback">
                                        Vui lòng nhập email hợp lệ
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="fullName" class="form-label">
                                        Họ và tên <span class="text-danger">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" required>
                                    <div class="invalid-feedback">
                                        Vui lòng nhập họ và tên
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="phone" class="form-label">Số điện thoại</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" 
                                           pattern="^[0-9]{10,11}$" title="10-11 chữ số">
                                    <div class="invalid-feedback">
                                        Số điện thoại phải có 10-11 chữ số
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="password" class="form-label">
                                        Mật khẩu <span class="text-danger">*</span>
                                    </label>
                                    <input type="password" class="form-control" id="password" name="password" required
                                           minlength="6" title="Ít nhất 6 ký tự">
                                    <div class="invalid-feedback">
                                        Mật khẩu phải có ít nhất 6 ký tự
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="confirmPassword" class="form-label">
                                        Xác nhận mật khẩu <span class="text-danger">*</span>
                                    </label>
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                    <div class="invalid-feedback">
                                        Xác nhận mật khẩu không khớp
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label for="roleId" class="form-label">
                                        Vai trò <span class="text-danger">*</span>
                                    </label>
                                    <select class="form-select" id="roleId" name="roleId" required>
                                        <option value="">Chọn vai trò</option>
                                        <option value="2">User - Khách hàng</option>
                                        <option value="3">Vendor - Người bán</option>
                                        <option value="4">Admin - Quản trị viên</option>
                                    </select>
                                    <div class="invalid-feedback">
                                        Vui lòng chọn vai trò
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label class="form-label">Trạng thái</label>
                                    <div class="form-check-container">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="isActive" name="isActive" checked>
                                            <label class="form-check-label" for="isActive">
                                                <i class="fas fa-check-circle text-success"></i> Tài khoản hoạt động
                                            </label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="isVerified" name="isVerified" checked>
                                            <label class="form-check-label" for="isVerified">
                                                <i class="fas fa-shield-check text-info"></i> Đã xác thực email
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <hr>
                        
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-1"></i>Tạo người dùng
                            </button>
                            <a href="${pageContext.request.contextPath}/admin-direct/users" class="btn btn-secondary">
                                <i class="fas fa-times me-1"></i>Hủy
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </c:when>

        <%-- EDIT USER FORM (giữ nguyên) --%>
        <c:when test="${viewMode == 'edit'}">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-user-edit me-2"></i>Chỉnh sửa thông tin: ${editUser.fullName}
                    </h5>
                </div>
                <div class="card-body">
                    <form method="POST" action="${pageContext.request.contextPath}/admin-direct/users" class="needs-validation" novalidate>
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="userId" value="${editUser.userId}">
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="username" class="form-label">Tên đăng nhập</label>
                                    <input type="text" class="form-control" id="username" name="username" 
                                           value="${editUser.username}" required
                                           pattern="^[a-zA-Z0-9_]{3,30}$">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           value="${editUser.email}" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="fullName" class="form-label">Họ và tên</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" 
                                           value="${editUser.fullName}" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="phone" class="form-label">Số điện thoại</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" 
                                           value="${editUser.phone}" pattern="^[0-9]{10,11}$">
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label for="roleId" class="form-label">Vai trò</label>
                                    <select class="form-select" id="roleId" name="roleId" required>
                                        <option value="2" ${editUser.roleId == 2 ? 'selected' : ''}>User - Khách hàng</option>
                                        <option value="3" ${editUser.roleId == 3 ? 'selected' : ''}>Vendor - Người bán</option>
                                        <option value="4" ${editUser.roleId == 4 ? 'selected' : ''}>Admin - Quản trị viên</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label class="form-label">Trạng thái</label>
                                    <div class="form-check-container">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="isActive" name="isActive" 
                                                   ${editUser.isActive ? 'checked' : ''}>
                                            <label class="form-check-label" for="isActive">
                                                <i class="fas fa-check-circle text-success"></i> Tài khoản hoạt động
                                            </label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="isVerified" name="isVerified" 
                                                   ${editUser.isVerified ? 'checked' : ''}>
                                            <label class="form-check-label" for="isVerified">
                                                <i class="fas fa-shield-check text-info"></i> Đã xác thực email
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label class="form-label">Thông tin thêm</label>
                                    <div class="info-display">
                                        <small class="text-muted d-block">
                                            <i class="fas fa-user-tag"></i> ID: ${editUser.userId}
                                        </small>
                                        <small class="text-muted d-block">
                                            <i class="fas fa-calendar"></i> Tạo: 
                                            <fmt:formatDate value="${editUser.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </small>
                                        <small class="text-muted d-block">
                                            <i class="fas fa-clock"></i> Cập nhật: 
                                            <fmt:formatDate value="${editUser.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <hr>
                        
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-warning">
                                <i class="fas fa-save me-1"></i>Cập nhật
                            </button>
                            <a href="${pageContext.request.contextPath}/admin-direct/users" class="btn btn-secondary">
                                <i class="fas fa-times me-1"></i>Hủy
                            </a>
                            <button type="button" class="btn btn-danger ms-auto" onclick="deleteUser(${editUser.userId}, '${editUser.email}')">
                                <i class="fas fa-trash me-1"></i>Xóa người dùng
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </c:when>

        <%-- VIEW USER DETAILS --%>
        <c:when test="${viewMode == 'view'}">
            <div class="row">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0">
                                <i class="fas fa-user me-2"></i>Thông tin chi tiết: ${viewUser.fullName}
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <table class="table table-borderless">
                                        <tr>
                                            <td class="fw-semibold">ID:</td>
                                            <td>${viewUser.userId}</td>
                                        </tr>
                                        <tr>
                                            <td class="fw-semibold">Tên đăng nhập:</td>
                                            <td>${viewUser.username}</td>
                                        </tr>
                                        <tr>
                                            <td class="fw-semibold">Email:</td>
                                            <td>${viewUser.email}</td>
                                        </tr>
                                        <tr>
                                            <td class="fw-semibold">Họ tên:</td>
                                            <td>${viewUser.fullName}</td>
                                        </tr>
                                        <tr>
                                            <td class="fw-semibold">Số điện thoại:</td>
                                            <td>${viewUser.phone != null ? viewUser.phone : 'Chưa cập nhật'}</td>
                                        </tr>
                                    </table>
                                </div>
                                <div class="col-md-6">
                                    <table class="table table-borderless">
                                        <tr>
                                            <td class="fw-semibold">Vai trò:</td>
                                            <td>
                                                <!-- ✅ FIX: LOGIC HIỂN THỊ ROLE CHÍNH XÁC -->
                                                <c:choose>
                                                    <c:when test="${viewUser.roleId == 4}">
                                                        <span class="badge bg-danger">Admin</span>
                                                    </c:when>
                                                    <c:when test="${viewUser.roleId == 3}">
                                                        <span class="badge bg-info">Vendor</span>
                                                    </c:when>
                                                    <c:when test="${viewUser.roleId == 2}">
                                                        <span class="badge bg-primary">User</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">Unknown (${viewUser.roleId})</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fw-semibold">Trạng thái:</td>
                                            <td>
                                                <c:if test="${viewUser.isActive}">
                                                    <span class="badge bg-success">Hoạt động</span>
                                                </c:if>
                                                <c:if test="${!viewUser.isActive}">
                                                    <span class="badge bg-secondary">Không hoạt động</span>
                                                </c:if>
                                                <c:if test="${viewUser.isVerified}">
                                                    <span class="badge bg-info ms-1">Đã xác thực</span>
                                                </c:if>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fw-semibold">Ngày tạo:</td>
                                            <td>
                                                <fmt:formatDate value="${viewUser.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fw-semibold">Cập nhật cuối:</td>
                                            <td>
                                                <fmt:formatDate value="${viewUser.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="fw-semibold">Đăng nhập cuối:</td>
                                            <td>
                                                <fmt:formatDate value="${viewUser.lastLogin}" pattern="dd/MM/yyyy HH:mm"/>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                            
                            <hr>
                            
                            <div class="d-flex gap-2">
                                <a href="${pageContext.request.contextPath}/admin-direct/users/edit?id=${viewUser.userId}" 
                                   class="btn btn-warning">
                                    <i class="fas fa-edit me-1"></i>Chỉnh sửa
                                </a>
                                <button type="button" class="btn btn-${viewUser.isActive ? 'secondary' : 'success'}" 
                                        onclick="toggleUserStatus(${viewUser.userId}, '${viewUser.email}', ${viewUser.isActive})">
                                    <i class="fas fa-${viewUser.isActive ? 'ban' : 'check'} me-1"></i>
                                    ${viewUser.isActive ? 'Vô hiệu hóa' : 'Kích hoạt'}
                                </button>
                                <button type="button" class="btn btn-danger ms-auto" 
                                        onclick="deleteUser(${viewUser.userId}, '${viewUser.email}')">
                                    <i class="fas fa-trash me-1"></i>Xóa người dùng
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-header">
                            <h6 class="mb-0">
                                <i class="fas fa-chart-bar me-1"></i>Thống kê hoạt động
                            </h6>
                        </div>
                        <div class="card-body">
                            <div class="stats-list">
                                <div class="stat-item">
                                    <i class="fas fa-shopping-cart text-primary"></i>
                                    <span class="stat-label">Tổng đơn hàng:</span>
                                    <span class="stat-value">${userTotalOrders}</span>
                                </div>
                                <div class="stat-item">
                                    <i class="fas fa-money-bill-wave text-success"></i>
                                    <span class="stat-label">Tổng chi tiêu:</span>
                                    <span class="stat-value">${userTotalSpent}</span>
                                </div>
                                <div class="stat-item">
                                    <i class="fas fa-calendar text-info"></i>
                                    <span class="stat-label">Đơn hàng cuối:</span>
                                    <span class="stat-value">${userLastOrderDate}</span>
                                </div>
                                <div class="stat-item">
                                    <i class="fas fa-clock text-warning"></i>
                                    <span class="stat-label">Tham gia:</span>
                                    <span class="stat-value">${userRegistrationDays} ngày</span>
                                </div>
                                <div class="stat-item">
                                    <i class="fas fa-sign-in-alt text-secondary"></i>
                                    <span class="stat-label">Lần đăng nhập:</span>
                                    <span class="stat-value">${userLoginCount}</span>
                                </div>
                                <div class="stat-item">
                                    <i class="fas fa-map-marker-alt text-danger"></i>
                                    <span class="stat-label">Địa chỉ:</span>
                                    <span class="stat-value">${userAddressCount}</span>
                                </div>
                                <div class="stat-item">
                                    <i class="fas fa-star text-warning"></i>
                                    <span class="stat-label">Đánh giá:</span>
                                    <span class="stat-value">${userReviewCount}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>

        <%-- USERS LIST --%>
        <c:otherwise>
            <!-- Statistics Cards (giữ nguyên) -->
            <div class="row mb-4">
                <div class="col-lg-3 col-md-6 mb-3">
                    <div class="stats-card">
                        <div class="stats-icon bg-primary">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stats-content">
                            <h4>${totalUsers}</h4>
                            <p>Tổng người dùng</p>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-3 col-md-6 mb-3">
                    <div class="stats-card">
                        <div class="stats-icon bg-success">
                            <i class="fas fa-user-check"></i>
                        </div>
                        <div class="stats-content">
                            <h4>${activeUsers}</h4>
                            <p>Đang hoạt động</p>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-3 col-md-6 mb-3">
                    <div class="stats-card">
                        <div class="stats-icon bg-info">
                            <i class="fas fa-store"></i>
                        </div>
                        <div class="stats-content">
                            <h4>${vendorCount}</h4>
                            <p>Người bán</p>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-3 col-md-6 mb-3">
                    <div class="stats-card">
                        <div class="stats-icon bg-danger">
                            <i class="fas fa-user-shield"></i>
                        </div>
                        <div class="stats-content">
                            <h4>${adminCount}</h4>
                            <p>Quản trị viên</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Search and Filters (giữ nguyên) -->
            <div class="card mb-4">
                <div class="card-body">
                    <form method="GET" action="${pageContext.request.contextPath}/admin-direct/users">
                        <div class="row">
                            <div class="col-md-4">
                                <div class="form-group">
                                    <label for="search" class="form-label">Tìm kiếm</label>
                                    <input type="text" class="form-control" id="search" name="search" 
                                           placeholder="Email, tên đăng nhập, họ tên..." 
                                           value="${searchValue}">
                                </div>
                            </div>
                            
                            <div class="col-md-2">
                                <div class="form-group">
                                    <label for="role" class="form-label">Vai trò</label>
                                    <select class="form-select" id="role" name="role">
                                        <option value="">Tất cả</option>
                                        <option value="2" ${roleFilter == '2' ? 'selected' : ''}>User</option>
                                        <option value="3" ${roleFilter == '3' ? 'selected' : ''}>Vendor</option>
                                        <option value="4" ${roleFilter == '4' ? 'selected' : ''}>Admin</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="col-md-2">
                                <div class="form-group">
                                    <label for="status" class="form-label">Trạng thái</label>
                                    <select class="form-select" id="status" name="status">
                                        <option value="">Tất cả</option>
                                        <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Hoạt động</option>
                                        <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="col-md-2">
                                <div class="form-group">
                                    <label for="pageSize" class="form-label">Hiển thị</label>
                                    <select class="form-select" id="pageSize" name="pageSize">
                                        <option value="10" ${pageSize == 10 ? 'selected' : ''}>10</option>
                                        <option value="20" ${pageSize == 20 ? 'selected' : ''}>20</option>
                                        <option value="50" ${pageSize == 50 ? 'selected' : ''}>50</option>
                                        <option value="100" ${pageSize == 100 ? 'selected' : ''}>100</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="col-md-2">
                                <label class="form-label">&nbsp;</label>
                                <div class="d-grid">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-search"></i> Tìm kiếm
                                    </button>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row mt-3">
                            <div class="col-12">
                                <a href="${pageContext.request.contextPath}/admin-direct/users" class="btn btn-outline-secondary btn-sm">
                                    <i class="fas fa-times me-1"></i>Xóa bộ lọc
                                </a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Users Table -->
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">
                        <i class="fas fa-list me-1"></i>Danh sách người dùng 
                        <small class="text-muted">(${totalUsers} người dùng)</small>
                    </h5>
                    <div class="bulk-actions" style="display: none;">
                        <button class="btn btn-sm btn-warning me-1" onclick="bulkToggleStatus()">
                            <i class="fas fa-toggle-on me-1"></i>Thay đổi trạng thái
                        </button>
                        <button class="btn btn-sm btn-danger" onclick="bulkDelete()">
                            <i class="fas fa-trash me-1"></i>Xóa đã chọn
                        </button>
                    </div>
                </div>
                
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th width="40">
                                        <input type="checkbox" class="form-check-input" id="selectAll">
                                    </th>
                                    <th>ID</th>
                                    <th>Người dùng</th>
                                    <th>Email</th>
                                    <th>Vai trò</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày tạo</th>
                                    <th>Đăng nhập cuối</th>
                                    <th width="140">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:choose>
                                    <c:when test="${empty users}">
                                        <tr>
                                            <td colspan="9" class="text-center py-4">
                                                <i class="fas fa-users fa-2x text-muted mb-2"></i>
                                                <p class="text-muted mb-0">Không tìm thấy người dùng nào</p>
                                            </td>
                                        </tr>
                                    </c:when>
                                    <c:otherwise>
                                        <c:forEach var="user" items="${users}">
                                            <tr>
                                                <td>
                                                    <input type="checkbox" class="form-check-input row-select" value="${user.userId}">
                                                </td>
                                                <td>
                                                    <span class="fw-bold">#${user.userId}</span>
                                                </td>
                                                <td>
                                                    <div class="d-flex align-items-center">
                                                        <div class="user-avatar me-2">
                                                            ${user.fullName.substring(0, 1).toUpperCase()}
                                                        </div>
                                                        <div>
                                                            <div class="fw-semibold">${user.fullName}</div>
                                                            <small class="text-muted">@${user.username}</small>
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>${user.email}</td>
                                                <td>
                                                    <!-- ✅ FIX: LOGIC HIỂN THỊ ROLE CHÍNH XÁC TRONG TABLE -->
                                                    <c:choose>
                                                        <c:when test="${user.roleId == 4}">
                                                            <span class="badge bg-danger">Admin</span>
                                                        </c:when>
                                                        <c:when test="${user.roleId == 3}">
                                                            <span class="badge bg-info">Vendor</span>
                                                        </c:when>
                                                        <c:when test="${user.roleId == 2}">
                                                            <span class="badge bg-primary">User</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">Unknown (${user.roleId})</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${user.isActive}">
                                                        <span class="badge bg-success">Hoạt động</span>
                                                    </c:if>
                                                    <c:if test="${!user.isActive}">
                                                        <span class="badge bg-secondary">Tạm khóa</span>
                                                    </c:if>
                                                    <c:if test="${user.isVerified}">
                                                        <span class="badge bg-info ms-1">Đã xác thực</span>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy"/>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${user.lastLogin != null}">
                                                            <span class="text-success">
                                                                <fmt:formatDate value="${user.lastLogin}" pattern="dd/MM/yyyy HH:mm"/>
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Chưa đăng nhập</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <div class="btn-group btn-group-sm">
                                                        <a href="${pageContext.request.contextPath}/admin-direct/users/view?id=${user.userId}" 
                                                           class="btn btn-outline-info" title="Xem chi tiết">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="${pageContext.request.contextPath}/admin-direct/users/edit?id=${user.userId}" 
                                                           class="btn btn-outline-primary" title="Chỉnh sửa">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <button class="btn btn-outline-${user.isActive ? 'warning' : 'success'}" 
                                                                title="${user.isActive ? 'Vô hiệu hóa' : 'Kích hoạt'}"
                                                                onclick="toggleUserStatus(${user.userId}, '${user.email}', ${user.isActive})">
                                                            <i class="fas fa-${user.isActive ? 'ban' : 'check'}"></i>
                                                        </button>
                                                        <button class="btn btn-outline-danger" title="Xóa"
                                                                onclick="deleteUser(${user.userId}, '${user.email}')">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Pagination (giữ nguyên) -->
                <c:if test="${totalPages > 1}">
                    <div class="card-footer">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <span class="text-muted">
                                    Hiển thị ${(currentPage - 1) * pageSize + 1}-${(currentPage - 1) * pageSize + users.size()} 
                                    trong tổng số ${totalUsers} người dùng
                                </span>
                            </div>
                            <nav>
                                <ul class="pagination mb-0">
                                    <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="?page=${currentPage - 1}&pageSize=${pageSize}&search=${searchValue}&role=${roleFilter}&status=${statusFilter}">
                                            Trước
                                        </a>
                                    </li>
                                    
                                    <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                        <c:if test="${pageNum == 1 || pageNum == totalPages || (pageNum >= currentPage - 2 && pageNum <= currentPage + 2)}">
                                            <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                <a class="page-link" href="?page=${pageNum}&pageSize=${pageSize}&search=${searchValue}&role=${roleFilter}&status=${statusFilter}">
                                                    ${pageNum}
                                                </a>
                                            </li>
                                        </c:if>
                                        
                                        <c:if test="${pageNum == currentPage + 3 && pageNum < totalPages}">
                                            <li class="page-item disabled">
                                                <span class="page-link">...</span>
                                            </li>
                                        </c:if>
                                    </c:forEach>
                                    
                                    <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="?page=${currentPage + 1}&pageSize=${pageSize}&search=${searchValue}&role=${roleFilter}&status=${statusFilter}">
                                            Sau
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </c:if>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<style>
/* User Management Styles (giữ nguyên) */
.user-management-page {
    padding: 0;
}

.stats-card {
    background: white;
    border-radius: 10px;
    padding: 20px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    border: 1px solid #e3e6f0;
    display: flex;
    align-items: center;
    gap: 15px;
    transition: transform 0.3s ease;
}

.stats-card:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 15px rgba(0,0,0,0.15);
}

.stats-icon {
    width: 50px;
    height: 50px;
    border-radius: 10px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 1.2rem;
}

.stats-content h4 {
    margin: 0;
    font-size: 1.5rem;
    font-weight: 700;
    color: #1f2937;
}

.stats-content p {
    margin: 0;
    font-size: 0.9rem;
    color: #6b7280;
}

.user-avatar {
    width: 35px;
    height: 35px;
    border-radius: 50%;
    background: linear-gradient(135deg, #4f46e5, #7c3aed);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.8rem;
    font-weight: 600;
}

.table th {
    border-top: none;
    font-weight: 600;
    color: #374151;
    font-size: 0.9rem;
    background: #f9fafb !important;
}

.table td {
    vertical-align: middle;
    font-size: 0.9rem;
}

.badge {
    font-size: 0.75rem;
    padding: 0.35em 0.65em;
}

.btn-group-sm .btn {
    padding: 0.25rem 0.5rem;
    font-size: 0.75rem;
}

.form-check-container {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.form-check-label {
    display: flex;
    align-items: center;
    gap: 5px;
}

.info-display {
    background: #f8f9fa;
    border-radius: 6px;
    padding: 10px;
}

.stats-list {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.stat-item {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 8px 0;
    border-bottom: 1px solid #f3f4f6;
}

.stat-item:last-child {
    border-bottom: none;
}

.stat-item i {
    width: 20px;
    text-align: center;
}

.stat-label {
    flex: 1;
    font-size: 0.9rem;
    color: #6b7280;
}

.stat-value {
    font-weight: 600;
    color: #1f2937;
    font-size: 0.9rem;
}

@media (max-width: 768px) {
    .stats-card {
        flex-direction: column;
        text-align: center;
        gap: 10px;
    }
    
    .table-responsive {
        font-size: 0.8rem;
    }
    
    .btn-group-sm .btn {
        padding: 0.2rem 0.4rem;
    }
    
    .user-avatar {
        width: 30px;
        height: 30px;
        font-size: 0.7rem;
    }
    
    .header-actions {
        margin-top: 15px;
    }
}

.bulk-actions {
    animation: slideIn 0.3s ease;
}

@keyframes slideIn {
    from {
        opacity: 0;
        transform: translateX(20px);
    }
    to {
        opacity: 1;
        transform: translateX(0);
    }
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    console.log('✅ FIXED User Management loaded - 2025-10-22 23:17:00 UTC');
    console.log('👨‍💻 Fixed by: tuaanshuuysv');
    console.log('🔧 Fixed: Role display logic for correct badge colors');
    
    // Form validation
    const forms = document.querySelectorAll('.needs-validation');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            if (!form.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();
            }
            
            const password = form.querySelector('#password');
            const confirmPassword = form.querySelector('#confirmPassword');
            
            if (password && confirmPassword) {
                if (password.value !== confirmPassword.value) {
                    e.preventDefault();
                    confirmPassword.setCustomValidity('Xác nhận mật khẩu không khớp');
                } else {
                    confirmPassword.setCustomValidity('');
                }
            }
            
            form.classList.add('was-validated');
        });
    });
    
    const confirmPasswordInput = document.querySelector('#confirmPassword');
    if (confirmPasswordInput) {
        confirmPasswordInput.addEventListener('input', function() {
            const password = document.querySelector('#password').value;
            if (this.value !== password) {
                this.setCustomValidity('Xác nhận mật khẩu không khớp');
            } else {
                this.setCustomValidity('');
            }
        });
    }
    
    const selectAllCheckbox = document.getElementById('selectAll');
    const rowCheckboxes = document.querySelectorAll('.row-select');
    const bulkActions = document.querySelector('.bulk-actions');
    
    if (selectAllCheckbox) {
        selectAllCheckbox.addEventListener('change', function() {
            rowCheckboxes.forEach(checkbox => {
                checkbox.checked = this.checked;
            });
            toggleBulkActions();
        });
    }
    
    rowCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            const checkedBoxes = document.querySelectorAll('.row-select:checked');
            selectAllCheckbox.checked = checkedBoxes.length === rowCheckboxes.length;
            toggleBulkActions();
        });
    });
    
    function toggleBulkActions() {
        const checkedBoxes = document.querySelectorAll('.row-select:checked');
        if (bulkActions) {
            bulkActions.style.display = checkedBoxes.length > 0 ? 'block' : 'none';
        }
    }
});

function deleteUser(userId, email) {
    if (confirm(`Bạn có chắc chắn muốn xóa người dùng "${email}"?\n\nHành động này không thể hoàn tác!`)) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/admin-direct/users';
        
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'delete';
        
        const userIdInput = document.createElement('input');
        userIdInput.type = 'hidden';
        userIdInput.name = 'userId';
        userIdInput.value = userId;
        
        form.appendChild(actionInput);
        form.appendChild(userIdInput);
        document.body.appendChild(form);
        form.submit();
    }
}

function toggleUserStatus(userId, email, currentStatus) {
    const action = currentStatus ? 'vô hiệu hóa' : 'kích hoạt';
    if (confirm(`Bạn có chắc chắn muốn ${action} người dùng "${email}"?`)) {
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = '${pageContext.request.contextPath}/admin-direct/users';
        
        const actionInput = document.createElement('input');
        actionInput.type = 'hidden';
        actionInput.name = 'action';
        actionInput.value = 'toggle-status';
        
        const userIdInput = document.createElement('input');
        userIdInput.type = 'hidden';
        userIdInput.name = 'userId';
        userIdInput.value = userId;
        
        form.appendChild(actionInput);
        form.appendChild(userIdInput);
        document.body.appendChild(form);
        form.submit();
    }
}

function exportUsers(format) {
    if (format === 'excel') {
        console.log('Exporting users to Excel...');
        alert('Tính năng xuất Excel sẽ được phát triển trong phiên bản tiếp theo!');
    }
}

function bulkToggleStatus() {
    const checkedBoxes = document.querySelectorAll('.row-select:checked');
    if (checkedBoxes.length === 0) {
        alert('Vui lòng chọn ít nhất một người dùng!');
        return;
    }
    
    if (confirm(`Bạn có chắc chắn muốn thay đổi trạng thái của ${checkedBoxes.length} người dùng đã chọn?`)) {
        console.log('Bulk toggle status for:', Array.from(checkedBoxes).map(cb => cb.value));
        alert('Tính năng thay đổi trạng thái hàng loạt sẽ được phát triển trong phiên bản tiếp theo!');
    }
}

function bulkDelete() {
    const checkedBoxes = document.querySelectorAll('.row-select:checked');
    if (checkedBoxes.length === 0) {
        alert('Vui lòng chọn ít nhất một người dùng!');
        return;
    }
    
    if (confirm(`CẢNH BÁO: Bạn có chắc chắn muốn xóa ${checkedBoxes.length} người dùng đã chọn?\n\nHành động này không thể hoàn tác!`)) {
        console.log('Bulk delete users:', Array.from(checkedBoxes).map(cb => cb.value));
        alert('Tính năng xóa hàng loạt sẽ được phát triển trong phiên bản tiếp theo!');
    }
}
</script>
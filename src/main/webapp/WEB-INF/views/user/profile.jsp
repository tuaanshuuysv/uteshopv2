<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- UTESHOP-CPL User Profile - SIMPLIFIED REAL DATA ONLY -->
<!-- Updated: 2025-10-24 18:48:19 UTC by tuaanshuuysv -->
<!-- Features: Only real database operations, removed fake settings -->

<div class="user-profile-page">
    
    <!-- User Header -->
    <div class="profile-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <div class="d-flex align-items-center">
                        <div class="profile-avatar">
                            ${authUser.fullName.substring(0, 1).toUpperCase()}
                        </div>
                        <div class="ms-3">
                            <h2 class="mb-1">${authUser.fullName}</h2>
                            <p class="text-muted mb-0">
                                <i class="fas fa-user me-1"></i>Khách hàng thân thiết
                                <span class="ms-3">
                                    <i class="fas fa-calendar me-1"></i>
                                    Thành viên từ: <fmt:formatDate value="${memberSince}" pattern="dd/MM/yyyy"/>
                                </span>
                            </p>
                            <div class="user-badges mt-2">
                                <span class="badge bg-success">
                                    <i class="fas fa-check-circle me-1"></i>${accountStatus}
                                </span>
                                <span class="badge bg-info">
                                    <i class="fas fa-shield-alt me-1"></i>${verificationStatus}
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 text-end">
                    <div class="profile-stats">
                        <div class="stat-item">
                            <span class="stat-number">${loyaltyPoints}</span>
                            <span class="stat-label">Điểm tích lũy</span>
                        </div>
                        <div class="stat-item">
                            <span class="stat-number">${totalOrders}</span>
                            <span class="stat-label">Đơn hàng</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Success/Error Messages -->
    <div class="container mt-4">
        <c:if test="${param.success != null}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                <c:choose>
                    <c:when test="${param.success == 'profile_updated'}">✅ Cập nhật hồ sơ thành công!</c:when>
                    <c:when test="${param.success == 'password_changed'}">✅ Đổi mật khẩu thành công!</c:when>
                    <c:otherwise>✅ Thao tác thành công!</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <c:choose>
                    <c:when test="${param.error == 'missing_fullname'}">❌ Vui lòng nhập họ tên!</c:when>
                    <c:when test="${param.error == 'update_failed'}">❌ Cập nhật thất bại!</c:when>
                    <c:when test="${param.error == 'current_password_incorrect'}">❌ Mật khẩu hiện tại không đúng!</c:when>
                    <c:when test="${param.error == 'password_mismatch'}">❌ Xác nhận mật khẩu không khớp!</c:when>
                    <c:when test="${param.error == 'password_too_short'}">❌ Mật khẩu phải có ít nhất 6 ký tự!</c:when>
                    <c:otherwise>❌ Có lỗi xảy ra: ${param.error}</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
    </div>

    <!-- Profile Content -->
    <div class="container mt-4">
        <div class="row">
            
            <!-- Left Sidebar - CHỈ NHỮNG TÍNH NĂNG THẬT -->
            <div class="col-lg-3 mb-4">
                <div class="profile-sidebar">
                    <div class="sidebar-menu">
                        <a href="${pageContext.request.contextPath}/user/profile" 
                           class="menu-item ${profileMode == 'view' ? 'active' : ''}">
                            <i class="fas fa-user"></i>
                            <span>Thông tin cá nhân</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/user/profile/edit" 
                           class="menu-item ${profileMode == 'edit' ? 'active' : ''}">
                            <i class="fas fa-edit"></i>
                            <span>Chỉnh sửa hồ sơ</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/user/profile/change-password" 
                           class="menu-item ${profileMode == 'change-password' ? 'active' : ''}">
                            <i class="fas fa-lock"></i>
                            <span>Đổi mật khẩu</span>
                        </a>
                    </div>
                    
                    <!-- Real User Statistics từ Database -->
                    <div class="user-stats mt-3">
                        <h6 class="mb-3">📊 Thống kê từ Database</h6>
                        <div class="alert alert-primary mb-2">
                            <i class="fas fa-shopping-cart me-2"></i>
                            <strong>${totalOrders}</strong> đơn hàng
                        </div>
                        <div class="alert alert-success mb-2">
                            <i class="fas fa-money-bill-wave me-2"></i>
                            <strong>${totalSpent}</strong> đã chi tiêu
                        </div>
                        <div class="alert alert-warning mb-2">
                            <i class="fas fa-star me-2"></i>
                            <strong>${loyaltyPoints}</strong> điểm tích lũy
                        </div>
                        <div class="alert alert-info mb-0">
                            <i class="fas fa-heart me-2"></i>
                            <strong>${wishlistCount}</strong> yêu thích
                        </div>
                    </div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-lg-9">
                
                <c:choose>
                    <%-- VIEW USER PROFILE --%>
                    <c:when test="${profileMode == 'view' || empty profileMode}">
                        <div class="row">
                            <div class="col-lg-8">
                                <div class="profile-card">
                                    <div class="card-header">
                                        <h5 class="mb-0">
                                            <i class="fas fa-user me-2"></i>Thông tin cá nhân (Database)
                                        </h5>
                                        <a href="${pageContext.request.contextPath}/user/profile/edit" class="btn btn-outline-primary btn-sm">
                                            <i class="fas fa-edit me-1"></i>Chỉnh sửa
                                        </a>
                                    </div>
                                    <div class="card-body">
                                        <div class="alert alert-info mb-3">
                                            <i class="fas fa-database me-2"></i>
                                            <strong>Dữ liệu thật từ database:</strong> bảng users với user_id = ${authUser.userId}
                                        </div>
                                        
                                        <div class="row">
                                            <div class="col-md-6">
                                                <div class="info-item">
                                                    <label>Họ và tên:</label>
                                                    <span>${authUser.fullName}</span>
                                                </div>
                                                <div class="info-item">
                                                    <label>Email:</label>
                                                    <span>${authUser.email}</span>
                                                </div>
                                                <div class="info-item">
                                                    <label>Số điện thoại:</label>
                                                    <span>${authUser.phone != null ? authUser.phone : 'Chưa cập nhật'}</span>
                                                </div>
                                            </div>
                                            <div class="col-md-6">
                                                <div class="info-item">
                                                    <label>Tên đăng nhập:</label>
                                                    <span>${authUser.username}</span>
                                                </div>
                                                <div class="info-item">
                                                    <label>Trạng thái tài khoản:</label>
                                                    <span class="badge bg-success">${accountStatus}</span>
                                                </div>
                                                <div class="info-item">
                                                    <label>Xác thực email:</label>
                                                    <span class="badge bg-info">${verificationStatus}</span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="col-lg-4">
                                <!-- Real Shopping Statistics từ Database -->
                                <div class="profile-card">
                                    <div class="card-header">
                                        <h6 class="mb-0">
                                            <i class="fas fa-chart-bar me-1"></i>📈 Hoạt động mua sắm
                                        </h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="stats-list">
                                            <div class="stat-item">
                                                <i class="fas fa-shopping-cart text-primary"></i>
                                                <span class="stat-label">Tổng đơn hàng:</span>
                                                <span class="stat-value">${totalOrders}</span>
                                            </div>
                                            <div class="stat-item">
                                                <i class="fas fa-money-bill-wave text-success"></i>
                                                <span class="stat-label">Tổng chi tiêu:</span>
                                                <span class="stat-value">${totalSpent}</span>
                                            </div>
                                            <div class="stat-item">
                                                <i class="fas fa-star text-warning"></i>
                                                <span class="stat-label">Điểm tích lũy:</span>
                                                <span class="stat-value">${loyaltyPoints}</span>
                                            </div>
                                            <div class="stat-item">
                                                <i class="fas fa-heart text-danger"></i>
                                                <span class="stat-label">Sản phẩm yêu thích:</span>
                                                <span class="stat-value">${wishlistCount}</span>
                                            </div>
                                            <div class="stat-item">
                                                <i class="fas fa-comment text-info"></i>
                                                <span class="stat-label">Đánh giá đã viết:</span>
                                                <span class="stat-value">${reviewCount}</span>
                                            </div>
                                            <div class="stat-item">
                                                <i class="fas fa-map-marker-alt text-secondary"></i>
                                                <span class="stat-label">Địa chỉ đã lưu:</span>
                                                <span class="stat-value">${addressCount}</span>
                                            </div>
                                        </div>
                                        
                                        <hr class="my-3">
                                        
                                        <div class="text-center">
                                            <p class="text-muted mb-2">
                                                <i class="fas fa-database me-1"></i>
                                                Dữ liệu từ MySQL DB
                                            </p>
                                            <small class="text-muted">
                                                Cập nhật real-time từ bảng orders, user_favorites, product_reviews, user_addresses
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:when>

                    <%-- EDIT USER PROFILE --%>
                    <c:when test="${profileMode == 'edit'}">
                        <div class="profile-card">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-edit me-2"></i>✏️ Chỉnh sửa thông tin cá nhân
                                </h5>
                            </div>
                            <div class="card-body">
                                <form method="POST" action="${pageContext.request.contextPath}/user/profile" class="needs-validation" novalidate>
                                    <input type="hidden" name="action" value="update-profile">
                                    
                                    <div class="alert alert-success">
                                        <i class="fas fa-database me-2"></i>
                                        <strong>✅ Lưu ý:</strong> Thông tin sẽ được cập nhật trực tiếp vào database MySQL và hiển thị ngay lập tức.
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="fullName" class="form-label">
                                                    👤 Họ và tên <span class="text-danger">*</span>
                                                </label>
                                                <input type="text" class="form-control" id="fullName" name="fullName" 
                                                       value="${authUser.fullName}" required>
                                                <div class="invalid-feedback">Vui lòng nhập họ và tên</div>
                                                <small class="text-muted">➡️ Lưu vào: users.full_name</small>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="phone" class="form-label">📞 Số điện thoại</label>
                                                <input type="tel" class="form-control" id="phone" name="phone" 
                                                       value="${authUser.phone}" pattern="[0-9]{10,11}">
                                                <div class="invalid-feedback">Số điện thoại phải có 10-11 chữ số</div>
                                                <small class="text-muted">➡️ Lưu vào: users.phone</small>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="email" class="form-label">📧 Email</label>
                                                <input type="email" class="form-control" id="email" name="email" 
                                                       value="${authUser.email}" readonly>
                                                <small class="text-muted">Email không thể thay đổi (unique key)</small>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="username" class="form-label">🔑 Tên đăng nhập</label>
                                                <input type="text" class="form-control" id="username" name="username" 
                                                       value="${authUser.username}" readonly>
                                                <small class="text-muted">Username không thể thay đổi</small>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="alert alert-warning">
                                        <i class="fas fa-info-circle me-2"></i>
                                        <strong>Cơ chế hoạt động:</strong>
                                        <ul class="mb-0 mt-2">
                                            <li>Cập nhật trực tiếp vào bảng users với WHERE user_id = ${authUser.userId}</li>
                                            <li>Tự động cập nhật updated_at = CURRENT_TIMESTAMP</li>
                                            <li>Session sẽ được refresh để hiển thị data mới</li>
                                        </ul>
                                    </div>
                                    
                                    <hr>
                                    
                                    <div class="d-flex gap-2">
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-1"></i>💾 Lưu thay đổi
                                        </button>
                                        <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-secondary">
                                            <i class="fas fa-times me-1"></i>❌ Hủy
                                        </a>
                                        <a href="${pageContext.request.contextPath}/user/profile/change-password" class="btn btn-warning ms-auto">
                                            <i class="fas fa-key me-1"></i>🔐 Đổi mật khẩu
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </c:when>

                    <%-- CHANGE PASSWORD --%>
                    <c:when test="${profileMode == 'change-password'}">
                        <div class="profile-card">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-lock me-2"></i>🔐 Đổi mật khẩu
                                </h5>
                            </div>
                            <div class="card-body">
                                <form method="POST" action="${pageContext.request.contextPath}/user/profile" class="needs-validation" novalidate>
                                    <input type="hidden" name="action" value="change-password">
                                    
                                    <div class="alert alert-info">
                                        <i class="fas fa-shield-alt me-2"></i>
                                        <strong>Bảo mật:</strong> Mật khẩu sẽ được hash bằng PasswordHasher với salt an toàn.
                                        <br><small>Vui lòng nhập mật khẩu hiện tại để xác thực danh tính.</small>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <label for="currentPassword" class="form-label">
                                            🔒 Mật khẩu hiện tại <span class="text-danger">*</span>
                                        </label>
                                        <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                        <div class="invalid-feedback">Vui lòng nhập mật khẩu hiện tại</div>
                                    </div>
                                    
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="newPassword" class="form-label">
                                                    🆕 Mật khẩu mới <span class="text-danger">*</span>
                                                </label>
                                                <input type="password" class="form-control" id="newPassword" name="newPassword" 
                                                       required minlength="6">
                                                <div class="invalid-feedback">Mật khẩu phải có ít nhất 6 ký tự</div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="confirmPassword" class="form-label">
                                                    ✅ Xác nhận mật khẩu mới <span class="text-danger">*</span>
                                                </label>
                                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                                <div class="invalid-feedback">Xác nhận mật khẩu không khớp</div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="alert alert-warning">
                                        <i class="fas fa-exclamation-triangle me-2"></i>
                                        <strong>Lưu ý quan trọng:</strong>
                                        <ul class="mb-0 mt-2">
                                            <li>Mật khẩu sẽ được hash an toàn trước khi lưu database</li>
                                            <li>Không thể khôi phục mật khẩu cũ sau khi đổi</li>
                                            <li>Cập nhật vào users.password_hash và users.salt</li>
                                        </ul>
                                    </div>
                                    
                                    <hr>
                                    
                                    <div class="d-flex gap-2">
                                        <button type="submit" class="btn btn-warning">
                                            <i class="fas fa-key me-1"></i>🔐 Đổi mật khẩu
                                        </button>
                                        <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-secondary">
                                            <i class="fas fa-times me-1"></i>❌ Hủy
                                        </a>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </c:when>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<style>
/* User Profile Styles - Simplified Real Data Only */
.user-profile-page {
    background: #f8fafc;
    min-height: calc(100vh - 120px);
}

.profile-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 30px 0;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.profile-avatar {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    background: rgba(255,255,255,0.2);
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 2rem;
    font-weight: bold;
    border: 3px solid rgba(255,255,255,0.3);
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.user-badges {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
}

.profile-stats {
    display: flex;
    gap: 25px;
    justify-content: flex-end;
}

.profile-stats .stat-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    background: rgba(255,255,255,0.1);
    padding: 15px;
    border-radius: 8px;
    min-width: 100px;
}

.profile-stats .stat-number {
    font-size: 1.8rem;
    font-weight: bold;
    margin-bottom: 5px;
}

.profile-stats .stat-label {
    font-size: 0.9rem;
    opacity: 0.9;
}

.profile-sidebar {
    background: white;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    overflow: hidden;
    border: 1px solid #e5e7eb;
}

.sidebar-menu {
    display: flex;
    flex-direction: column;
}

.menu-item {
    display: flex;
    align-items: center;
    padding: 16px 20px;
    color: #374151;
    text-decoration: none;
    border-bottom: 1px solid #f3f4f6;
    transition: all 0.3s ease;
    font-weight: 500;
}

.menu-item:hover {
    background: #f3f4f6;
    color: #667eea;
    text-decoration: none;
    transform: translateX(2px);
}

.menu-item.active {
    background: #667eea;
    color: white;
    box-shadow: inset 4px 0 0 #764ba2;
}

.menu-item i {
    width: 20px;
    margin-right: 12px;
    text-align: center;
    font-size: 1.1rem;
}

.user-stats {
    padding: 18px 20px;
    background: #f8fafc;
}

.user-stats h6 {
    color: #374151;
    font-weight: 600;
    margin-bottom: 15px;
}

.user-stats .alert {
    padding: 12px 15px;
    margin-bottom: 10px;
    font-size: 0.9rem;
    border: none;
    font-weight: 500;
}

.profile-card {
    background: white;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    margin-bottom: 25px;
    overflow: hidden;
    border: 1px solid #e5e7eb;
}

.profile-card .card-header {
    background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
    border-bottom: 2px solid #e5e7eb;
    padding: 20px 25px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.profile-card .card-header h5,
.profile-card .card-header h6 {
    margin: 0;
    color: #1f2937;
    font-weight: 600;
}

.profile-card .card-body {
    padding: 25px;
}

.info-item {
    margin-bottom: 18px;
    padding-bottom: 8px;
    border-bottom: 1px solid #f3f4f6;
}

.info-item:last-child {
    border-bottom: none;
}

.info-item label {
    font-weight: 600;
    color: #374151;
    display: block;
    margin-bottom: 6px;
    font-size: 0.9rem;
}

.info-item span {
    color: #6b7280;
    font-weight: 500;
}

.stats-list {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.stats-list .stat-item {
    display: flex;
    align-items: center;
    gap: 15px;
    padding: 12px 0;
    border-bottom: 1px solid #f3f4f6;
}

.stats-list .stat-item:last-child {
    border-bottom: none;
}

.stats-list .stat-item i {
    width: 24px;
    text-align: center;
    font-size: 1.1rem;
}

.stats-list .stat-label {
    flex: 1;
    font-size: 0.9rem;
    color: #6b7280;
    font-weight: 500;
}

.stats-list .stat-value {
    font-weight: 600;
    color: #1f2937;
    font-size: 0.95rem;
}

/* Form Enhancements */
.form-control:focus {
    border-color: #667eea;
    box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
}

.btn-primary {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    font-weight: 600;
    padding: 10px 20px;
}

.btn-primary:hover {
    background: linear-gradient(135deg, #764ba2 0%, #8b5a95 100%);
    transform: translateY(-1px);
    box-shadow: 0 4px 8px rgba(102, 126, 234, 0.3);
}

.btn-warning {
    background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
    border: none;
    color: white;
    font-weight: 600;
}

.btn-warning:hover {
    background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
    color: white;
}

/* Alert Enhancements */
.alert {
    border: none;
    border-radius: 8px;
    font-weight: 500;
}

.alert-success {
    background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
    color: #065f46;
    border-left: 4px solid #059669;
}

.alert-info {
    background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
    color: #1e40af;
    border-left: 4px solid #3b82f6;
}

.alert-warning {
    background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
    color: #92400e;
    border-left: 4px solid #f59e0b;
}

/* Responsive Design */
@media (max-width: 768px) {
    .profile-header {
        text-align: center;
        padding: 20px 0;
    }
    
    .profile-header .text-end {
        text-align: center !important;
        margin-top: 20px;
    }
    
    .profile-stats {
        justify-content: center;
        gap: 15px;
    }
    
    .user-badges {
        justify-content: center;
    }
    
    .profile-sidebar {
        margin-bottom: 20px;
    }
    
    .sidebar-menu {
        flex-direction: row;
        overflow-x: auto;
    }
    
    .menu-item {
        white-space: nowrap;
        min-width: 150px;
        border-bottom: none;
        border-right: 1px solid #f3f4f6;
    }
    
    .menu-item:last-child {
        border-right: none;
    }
    
    .user-stats {
        padding: 15px;
    }
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    console.log('✅ SIMPLIFIED User Profile loaded - 2025-10-24 18:48:19 UTC');
    console.log('👨‍💻 Simplified by: tuaanshuuysv');
    console.log('👤 Current user: ${authUser.email}');
    console.log('🔧 Profile mode: ${profileMode}');
    console.log('📊 REAL DATA ONLY: Orders=${totalOrders}, Spent=${totalSpent}, Points=${loyaltyPoints}');
    console.log('🗑️ REMOVED: Fake settings, mock features');
    console.log('✅ KEPT: Only real database operations');
    
    // Form validation
    const forms = document.querySelectorAll('.needs-validation');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            if (!form.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();
            }
            
            // Password confirmation check
            const newPassword = form.querySelector('#newPassword');
            const confirmPassword = form.querySelector('#confirmPassword');
            
            if (newPassword && confirmPassword) {
                if (newPassword.value !== confirmPassword.value) {
                    e.preventDefault();
                    confirmPassword.setCustomValidity('Xác nhận mật khẩu không khớp');
                } else {
                    confirmPassword.setCustomValidity('');
                }
            }
            
            form.classList.add('was-validated');
        });
    });
    
    // Real-time password confirmation
    const confirmPasswordInput = document.querySelector('#confirmPassword');
    if (confirmPasswordInput) {
        confirmPasswordInput.addEventListener('input', function() {
            const newPassword = document.querySelector('#newPassword').value;
            if (this.value !== newPassword) {
                this.setCustomValidity('Xác nhận mật khẩu không khớp');
            } else {
                this.setCustomValidity('');
            }
        });
    }
    
    // Phone number formatting
    const phoneInput = document.querySelector('#phone');
    if (phoneInput) {
        phoneInput.addEventListener('input', function() {
            this.value = this.value.replace(/\D/g, '');
            if (this.value.length > 11) {
                this.value = this.value.slice(0, 11);
            }
        });
    }
});
</script>
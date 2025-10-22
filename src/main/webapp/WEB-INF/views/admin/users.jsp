<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- UTESHOP-CPL Admin - User Management -->
<!-- Updated: 2025-10-21 14:20:16 UTC by tuaanshuuysv -->
<!-- Enhanced existing users.jsp file -->

<div class="admin-users-page">
    
    <!-- Page Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-1">
                <c:choose>
                    <c:when test="${formMode == 'add'}">Thêm người dùng mới</c:when>
                    <c:when test="${formMode == 'edit'}">Chỉnh sửa người dùng</c:when>
                    <c:otherwise>Quản lý người dùng</c:otherwise>
                </c:choose>
            </h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-0">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/admin">Dashboard</a></li>
                    <li class="breadcrumb-item active">Người dùng</li>
                </ol>
            </nav>
        </div>
        <div>
            <c:if test="${formMode != 'add' && formMode != 'edit'}">
                <a href="${pageContext.request.contextPath}/admin/users/add" class="btn btn-primary">
                    <i class="fas fa-plus me-1"></i>Thêm người dùng
                </a>
            </c:if>
        </div>
    </div>

    <c:choose>
        <c:when test="${formMode == 'add' || formMode == 'edit'}">
            <!-- User Form -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">
                        <c:choose>
                            <c:when test="${formMode == 'add'}">Thông tin người dùng mới</c:when>
                            <c:otherwise>Chỉnh sửa thông tin người dùng</c:otherwise>
                        </c:choose>
                    </h5>
                </div>
                <div class="card-body">
                    <form method="POST" action="${pageContext.request.contextPath}/admin/users">
                        <input type="hidden" name="action" value="${formMode == 'add' ? 'create' : 'update'}">
                        <c:if test="${formMode == 'edit'}">
                            <input type="hidden" name="userId" value="${userId}">
                        </c:if>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="fullName" class="form-label">Họ và tên <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" 
                                           value="${editUserFullName}" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="username" class="form-label">Tên đăng nhập <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="username" name="username" 
                                           value="${editUserUsername}" required>
                                </div>
                            </div>
                        </div>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="email" class="form-label">Email <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           value="${editUserEmail}" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="phone" class="form-label">Số điện thoại</label>
                                    <input type="tel" class="form-control" id="phone" name="phone" 
                                           value="${editUserPhone}">
                                </div>
                            </div>
                        </div>
                        
                        <c:if test="${formMode == 'add'}">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="password" class="form-label">Mật khẩu <span class="text-danger">*</span></label>
                                        <input type="password" class="form-control" id="password" name="password" required>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="confirmPassword" class="form-label">Xác nhận mật khẩu <span class="text-danger">*</span></label>
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        
                        <div class="row">
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label for="roleId" class="form-label">Vai trò <span class="text-danger">*</span></label>
                                    <select class="form-select" id="roleId" name="roleId" required>
                                        <option value="">Chọn vai trò</option>
                                        <option value="2" ${editUserRoleId == 2 ? 'selected' : ''}>User</option>
                                        <option value="3" ${editUserRoleId == 3 ? 'selected' : ''}>Vendor</option>
                                        <option value="4" ${editUserRoleId == 4 ? 'selected' : ''}>Admin</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="mb-3">
                                    <label class="form-label">Trạng thái</label>
                                    <div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" id="isActive" name="isActive" 
                                                   ${editUserIsActive ? 'checked' : ''}>
                                            <label class="form-check-label" for="isActive">Hoạt động</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" id="isVerified" name="isVerified" 
                                                   ${editUserIsVerified ? 'checked' : ''}>
                                            <label class="form-check-label" for="isVerified">Đã xác thực</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save me-1"></i>
                                <c:choose>
                                    <c:when test="${formMode == 'add'}">Tạo người dùng</c:when>
                                    <c:otherwise>Cập nhật</c:otherwise>
                                </c:choose>
                            </button>
                            <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-secondary">
                                <i class="fas fa-times me-1"></i>Hủy
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Users List -->
            
            <!-- Statistics Cards -->
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
                        <div class="stats-icon bg-warning">
                            <i class="fas fa-user-clock"></i>
                        </div>
                        <div class="stats-content">
                            <h4>${pendingUsers}</h4>
                            <p>Chờ xác thực</p>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-3 col-md-6 mb-3">
                    <div class="stats-card">
                        <div class="stats-icon bg-info">
                            <i class="fas fa-store"></i>
                        </div>
                        <div class="stats-content">
                            <h4>${totalVendors}</h4>
                            <p>Người bán</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Search and Filters -->
            <div class="card mb-4">
                <div class="card-body">
                    <form method="GET" action="${pageContext.request.contextPath}/admin/users">
                        <div class="row">
                            <div class="col-md-4">
                                <input type="text" class="form-control" name="search" 
                                       placeholder="Tìm kiếm theo email, tên..." value="${param.search}">
                            </div>
                            <div class="col-md-2">
                                <select class="form-select" name="role">
                                    <option value="">Tất cả vai trò</option>
                                    <option value="2" ${param.role == '2' ? 'selected' : ''}>User</option>
                                    <option value="3" ${param.role == '3' ? 'selected' : ''}>Vendor</option>
                                    <option value="4" ${param.role == '4' ? 'selected' : ''}>Admin</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <select class="form-select" name="status">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="active" ${param.status == 'active' ? 'selected' : ''}>Hoạt động</option>
                                    <option value="inactive" ${param.status == 'inactive' ? 'selected' : ''}>Không hoạt động</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-search"></i> Tìm kiếm
                                    </button>
                                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-outline-secondary">
                                        <i class="fas fa-refresh"></i> Reset
                                    </a>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Users Table -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Danh sách người dùng</h5>
                </div>
                
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Người dùng</th>
                                    <th>Email</th>
                                    <th>Vai trò</th>
                                    <th>Trạng thái</th>
                                    <th>Ngày tạo</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <!-- Mock data -->
                                <tr>
                                    <td><span class="fw-bold">#1001</span></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="user-avatar me-2">NA</div>
                                            <div>
                                                <div class="fw-semibold">Nguyễn Văn A</div>
                                                <small class="text-muted">@nguyenvana</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>nguyenvana@example.com</td>
                                    <td><span class="badge bg-primary">User</span></td>
                                    <td>
                                        <span class="badge bg-success">Hoạt động</span>
                                    </td>
                                    <td>15/01/2025</td>
                                    <td>
                                        <div class="btn-group btn-group-sm">
                                            <a href="${pageContext.request.contextPath}/admin/users/edit?id=1001" 
                                               class="btn btn-outline-primary" title="Chỉnh sửa">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <button class="btn btn-outline-warning" title="Khóa/Mở khóa">
                                                <i class="fas fa-ban"></i>
                                            </button>
                                            <button class="btn btn-outline-danger" title="Xóa">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                                
                                <tr>
                                    <td><span class="fw-bold">#1002</span></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <div class="user-avatar me-2">TB</div>
                                            <div>
                                                <div class="fw-semibold">Trần Thị B</div>
                                                <small class="text-muted">@tranthib</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td>tranthib@example.com</td>
                                    <td><span class="badge bg-info">Vendor</span></td>
                                    <td>
                                        <span class="badge bg-success">Hoạt động</span>
                                    </td>
                                    <td>20/01/2025</td>
                                    <td>
                                        <div class="btn-group btn-group-sm">
                                            <a href="${pageContext.request.contextPath}/admin/users/edit?id=1002" 
                                               class="btn btn-outline-primary" title="Chỉnh sửa">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <button class="btn btn-outline-warning" title="Khóa/Mở khóa">
                                                <i class="fas fa-ban"></i>
                                            </button>
                                            <button class="btn btn-outline-danger" title="Xóa">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                
                <!-- Pagination -->
                <div class="card-footer">
                    <nav>
                        <ul class="pagination justify-content-center mb-0">
                            <li class="page-item disabled">
                                <span class="page-link">Trước</span>
                            </li>
                            <li class="page-item active">
                                <span class="page-link">1</span>
                            </li>
                            <li class="page-item">
                                <a class="page-link" href="?page=2">2</a>
                            </li>
                            <li class="page-item">
                                <a class="page-link" href="?page=3">3</a>
                            </li>
                            <li class="page-item">
                                <a class="page-link" href="?page=2">Sau</a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<style>
/* Styles for admin users page */
.admin-users-page {
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
    background: #4f46e5;
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
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    console.log('✅ Admin Users Management loaded - 2025-10-21 14:20:16 UTC');
    console.log('👨‍💻 Enhanced by: tuaanshuuysv');
    
    // Form validation
    const form = document.querySelector('form');
    if (form && form.querySelector('#password')) {
        form.addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu xác nhận không khớp!');
                return false;
            }
        });
    }
    
    // Action buttons
    document.querySelectorAll('.btn-outline-warning').forEach(btn => {
        btn.addEventListener('click', function() {
            if (confirm('Bạn có chắc chắn muốn thay đổi trạng thái tài khoản này?')) {
                console.log('Toggle user status');
                // Implement toggle logic
            }
        });
    });
    
    document.querySelectorAll('.btn-outline-danger').forEach(btn => {
        btn.addEventListener('click', function() {
            if (confirm('Bạn có chắc chắn muốn xóa người dùng này? Hành động này không thể hoàn tác!')) {
                console.log('Delete user');
                // Implement delete logic
            }
        });
    });
});
</script>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hồ sơ cá nhân - UTESHOP</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body { background: #f8fafc;}
        .profile-gradient {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #ff6b6b 100%);
            color: white;
            border-radius: 24px;
            box-shadow: 0 8px 32px rgba(102,126,234,0.09);
            padding: 38px 42px 28px 42px;
            margin-bottom: 32px;
            position: relative;
        }
        .profile-avatar {
            width: 96px; height: 96px; border-radius: 50%; background: rgba(255,255,255,0.18);
            display: flex; align-items: center; justify-content: center;
            font-size: 3.1rem; font-weight: bold; border: 4px solid #fff; box-shadow: 0 4px 16px rgba(0,0,0,0.11);
        }
        .profile-name { font-size:2.2rem; font-weight:700; letter-spacing:0.01em;}
        .profile-meta { font-size:1.12rem; color: #f3f4fd;}
        .profile-badges .badge {font-size:1.08rem; margin-right:9px;}
        .profile-stats-box {
            display:flex; gap:22px; align-items:center; justify-content:flex-end; margin-top:10px;
        }
        .profile-stat {
            background:rgba(255,255,255,0.17); border-radius:12px; min-width:120px;
            text-align:center; padding:14px 0 10px 0;
        }
        .profile-stat .stat-val { font-size:2rem; font-weight:bold; color:#ffd700;}
        .profile-stat .stat-label { font-size:1.1rem; color:#f3f4fd;}
        .profile-container { max-width:1100px; margin:auto;}
        .profile-sidebar {
            background: white; border-radius:18px; box-shadow:0 6px 32px rgba(102,126,234,0.08);
            padding:32px 22px 24px 22px; margin-bottom:30px;
        }
        .sidebar-link {
            display: flex; align-items: center; gap: 14px; color: #374151; text-decoration: none; font-weight: 550;
            font-size:1.15rem; padding:14px 0; border-bottom: 1px solid #f3f4f6; transition:all .20s;
            border-radius:8px;
        }
        .sidebar-link:last-child{border-bottom:none;}
        .sidebar-link.active, .sidebar-link:hover {
            color: #764ba2; background: #f3f4fd; border-radius:8px;
        }
        .profile-stat-list .stat-mini-card {
            border-radius:9px; font-size:1.03rem; padding:9px 16px; margin-bottom:8px; display:flex; align-items:center; font-weight:540;
            box-shadow:0 2px 8px rgba(102,126,234,0.05);
        }
        .profile-section {
            background:white; border-radius:18px; box-shadow:0 4px 24px rgba(0,0,0,0.07); padding:32px 28px; margin-bottom:32px;
        }
        .section-title { font-size:1.28rem; font-weight:700; color:#667eea; margin-bottom:28px;}
        .info-label { font-weight:600; color:#667eea; margin-right:9px;}
        .info-value { font-weight:500; color:#374151;}
        .card-stat-list {display:flex; flex-wrap:wrap; gap:18px;}
        .card-stat {
            background:linear-gradient(135deg,#f4f6ff 0%,#e3e7ff 100%);
            border-radius:16px; padding:20px; min-width:160px; flex:1;
            text-align:center; box-shadow:0 2px 8px rgba(102,126,234,0.07);
        }
        .card-stat .card-icon {font-size:1.7rem; margin-bottom:8px;}
        .card-stat .card-label {font-size:1.13rem; color:#667eea;}
        .card-stat .card-val {font-size:1.35rem; font-weight:650; color:#764ba2;}
        .btn-edit, .btn-change {
            font-weight:600; border-radius:7px; padding:10px 22px; border:none;
        }
        .btn-edit { background: linear-gradient(135deg,#667eea 0%,#764ba2 100%); color:white;}
        .btn-edit:hover { background: linear-gradient(135deg,#764ba2 0%,#667eea 100%);}
        .btn-change { background: linear-gradient(135deg,#ffd700 0%,#ff6b6b 100%); color:white;}
        .btn-change:hover { background: linear-gradient(135deg,#ff6b6b 0%,#ffd700 100%);}
        @media (max-width: 900px) { .profile-container{padding:0 8px;} }
        @media (max-width: 768px) {
            .profile-gradient{ padding:20px 8px 12px 8px;}
            .profile-container{padding:0 5px;}
            .profile-sidebar{padding:13px;}
            .profile-section{padding:15px 7px;}
            .profile-avatar{width:60px;height:60px;font-size:1.45rem;}
            .profile-name{font-size:1.16rem;}
            .card-stat-list{flex-direction:column;}
            .card-stat{min-width:100px;}
        }
    </style>
</head>
<body>
<div class="profile-container">
    <!-- Header gradient -->
    <div class="profile-gradient mb-1">
        <div class="d-flex align-items-center">
            <div class="profile-avatar">${authUser.fullName.substring(0, 1).toUpperCase()}</div>
            <div class="ms-4 flex-grow-1">
                <h2 class="profile-name mb-1">${authUser.fullName}</h2>
                <div class="profile-meta">
                    <span><i class="fas fa-user me-1"></i>Khách hàng thân thiết</span>
                    <span class="ms-3"><i class="fas fa-calendar me-1"></i>Thành viên từ: <span class="badge bg-light text-dark">${memberSinceStr}</span></span>
                </div>
                <div class="profile-badges mt-2">
                    <span class="badge bg-success px-3 py-2 me-2"><i class="fas fa-check-circle me-1"></i>${accountStatus}</span>
                    <span class="badge bg-info px-3 py-2"><i class="fas fa-shield-alt me-1"></i>${verificationStatus}</span>
                </div>
            </div>
            <div class="profile-stats-box d-none d-md-flex ms-auto">
                <div class="profile-stat">
                    <div class="stat-val">${loyaltyPoints}</div>
                    <div class="stat-label">Điểm tích lũy</div>
                </div>
                <div class="profile-stat">
                    <div class="stat-val">${totalOrders}</div>
                    <div class="stat-label">Đơn hàng</div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <!-- Sidebar -->
        <div class="col-lg-3 mb-4">
            <div class="profile-sidebar">
                <a href="${pageContext.request.contextPath}/user/profile" class="sidebar-link ${profileMode == 'view' ? 'active' : ''}">
                    <i class="fas fa-user"></i> Thông tin cá nhân
                </a>
                <a href="${pageContext.request.contextPath}/user/profile/edit" class="sidebar-link ${profileMode == 'edit' ? 'active' : ''}">
                    <i class="fas fa-edit"></i> Chỉnh sửa hồ sơ
                </a>
                <a href="${pageContext.request.contextPath}/user/profile/change-password" class="sidebar-link ${profileMode == 'change-password' ? 'active' : ''}">
                    <i class="fas fa-key"></i> Đổi mật khẩu
                </a>
                <div class="profile-stat-list mt-4">
                    <div class="stat-mini-card bg-primary-subtle mb-2"><i class="fas fa-shopping-cart me-2"></i><b>${totalOrders}</b> đơn hàng</div>
                    <div class="stat-mini-card bg-success-subtle mb-2"><i class="fas fa-money-bill-wave me-2"></i><b>${totalSpent}</b> đã chi tiêu</div>
                    <div class="stat-mini-card bg-warning-subtle mb-2"><i class="fas fa-star me-2"></i><b>${loyaltyPoints}</b> điểm tích lũy</div>
                    <div class="stat-mini-card bg-info-subtle"><i class="fas fa-heart me-2"></i><b>${wishlistCount}</b> yêu thích</div>
                </div>
            </div>
        </div>
        <!-- Main Content -->
        <div class="col-lg-9">
            <c:choose>
                <c:when test="${profileMode == 'view' || empty profileMode}">
                    <div class="profile-section mb-4">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="section-title"><i class="fas fa-address-card me-2"></i>Thông tin cá nhân</span>
                            <a href="${pageContext.request.contextPath}/user/profile/edit" class="btn btn-edit btn-sm"><i class="fas fa-edit me-1"></i>Chỉnh sửa</a>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3"><span class="info-label">Họ tên:</span> <span class="info-value">${authUser.fullName}</span></div>
                                <div class="mb-3"><span class="info-label">Email:</span> <span class="info-value">${authUser.email}</span></div>
                                <div class="mb-3"><span class="info-label">SĐT:</span> <span class="info-value">${authUser.phone != null ? authUser.phone : 'Chưa cập nhật'}</span></div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3"><span class="info-label">Tên đăng nhập:</span> <span class="info-value">${authUser.username}</span></div>
                                <div class="mb-3"><span class="info-label">Trạng thái:</span> <span class="badge bg-success">${accountStatus}</span></div>
                                <div class="mb-3"><span class="info-label">Xác thực email:</span> <span class="badge bg-info">${verificationStatus}</span></div>
                            </div>
                        </div>
                    </div>
                    <div class="profile-section mb-2">
                        <span class="section-title"><i class="fas fa-chart-bar me-2"></i>Thống kê tài khoản</span>
                        <div class="card-stat-list mt-3">
                            <div class="card-stat">
                                <div class="card-icon text-primary"><i class="fas fa-shopping-cart"></i></div>
                                <div class="card-label">Đơn hàng</div>
                                <div class="card-val">${totalOrders}</div>
                            </div>
                            <div class="card-stat">
                                <div class="card-icon text-success"><i class="fas fa-money-bill-wave"></i></div>
                                <div class="card-label">Chi tiêu</div>
                                <div class="card-val">${totalSpent}</div>
                            </div>
                            <div class="card-stat">
                                <div class="card-icon text-warning"><i class="fas fa-star"></i></div>
                                <div class="card-label">Điểm tích lũy</div>
                                <div class="card-val">${loyaltyPoints}</div>
                            </div>
                            <div class="card-stat">
                                <div class="card-icon text-danger"><i class="fas fa-heart"></i></div>
                                <div class="card-label">Yêu thích</div>
                                <div class="card-val">${wishlistCount}</div>
                            </div>
                            <div class="card-stat">
                                <div class="card-icon text-info"><i class="fas fa-comment"></i></div>
                                <div class="card-label">Đánh giá</div>
                                <div class="card-val">${reviewCount}</div>
                            </div>
                            <div class="card-stat">
                                <div class="card-icon text-secondary"><i class="fas fa-map-marker-alt"></i></div>
                                <div class="card-label">Địa chỉ</div>
                                <div class="card-val">${addressCount}</div>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:when test="${profileMode == 'edit'}">
                    <div class="profile-section mb-4">
                        <span class="section-title"><i class="fas fa-edit me-2"></i>Chỉnh sửa thông tin cá nhân</span>
                        <form method="POST" action="${pageContext.request.contextPath}/user/profile" class="needs-validation" novalidate>
                            <input type="hidden" name="action" value="update-profile">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="fullName" class="form-label">👤 Họ và tên <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="fullName" name="fullName" value="${authUser.fullName}" required>
                                        <div class="invalid-feedback">Vui lòng nhập họ và tên</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="phone" class="form-label">📞 Số điện thoại</label>
                                        <input type="tel" class="form-control" id="phone" name="phone" value="${authUser.phone}" pattern="[0-9]{10,11}">
                                        <div class="invalid-feedback">Số điện thoại phải có 10-11 chữ số</div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="email" class="form-label">📧 Email</label>
                                        <input type="email" class="form-control" id="email" name="email" value="${authUser.email}" readonly>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="username" class="form-label">🔑 Tên đăng nhập</label>
                                        <input type="text" class="form-control" id="username" name="username" value="${authUser.username}" readonly>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-edit"><i class="fas fa-save me-1"></i>Lưu thay đổi</button>
                                <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-secondary"><i class="fas fa-times me-1"></i>Hủy</a>
                                <a href="${pageContext.request.contextPath}/user/profile/change-password" class="btn btn-change ms-auto"><i class="fas fa-key me-1"></i>Đổi mật khẩu</a>
                            </div>
                        </form>
                    </div>
                </c:when>
                <c:when test="${profileMode == 'change-password'}">
                    <div class="profile-section mb-4">
                        <span class="section-title"><i class="fas fa-key me-2"></i>Đổi mật khẩu</span>
                        <form method="POST" action="${pageContext.request.contextPath}/user/profile" class="needs-validation" novalidate>
                            <input type="hidden" name="action" value="change-password">
                            <div class="mb-3">
                                <label for="currentPassword" class="form-label">🔒 Mật khẩu hiện tại <span class="text-danger">*</span></label>
                                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                <div class="invalid-feedback">Vui lòng nhập mật khẩu hiện tại</div>
                            </div>
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="newPassword" class="form-label">🆕 Mật khẩu mới <span class="text-danger">*</span></label>
                                        <input type="password" class="form-control" id="newPassword" name="newPassword" required minlength="6">
                                        <div class="invalid-feedback">Mật khẩu phải có ít nhất 6 ký tự</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="confirmPassword" class="form-label">✅ Xác nhận mật khẩu mới <span class="text-danger">*</span></label>
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                        <div class="invalid-feedback">Xác nhận mật khẩu không khớp</div>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-change"><i class="fas fa-key me-1"></i>Đổi mật khẩu</button>
                                <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-secondary"><i class="fas fa-times me-1"></i>Hủy</a>
                            </div>
                        </form>
                    </div>
                </c:when>
            </c:choose>
        </div>
    </div>
</div>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const forms = document.querySelectorAll('.needs-validation');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            if (!form.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();
            }
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
</body>
</html>
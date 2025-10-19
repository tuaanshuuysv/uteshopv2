<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="auth-body">

<div class="auth-container">
    <div class="auth-wrapper register-wrapper">
        <!-- Form Section -->
        <div class="auth-form-container">
            <div class="auth-form">
                <!-- Header -->
                <div class="form-header text-center">
                    <div class="brand-mini mb-3">
                        <i class="fas fa-shopping-bag me-2"></i>
                        <span>UTESHOP-CPL</span>
                    </div>
                    <h3>Tạo tài khoản mới</h3>
                    <p>Gia nhập cộng đồng mua sắm thông minh</p>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Register Form -->
                <form method="post" action="${pageContext.request.contextPath}/auth/register" class="register-form">
                    
                    <!-- Role Selection -->
                    <div class="role-section mb-4">
                        <label class="form-label fw-bold">
                            <i class="fas fa-users me-2"></i>Loại tài khoản
                        </label>
                        <div class="row">
                            <div class="col-6">
                                <input type="radio" class="btn-check" name="role" id="role-user" value="user" checked>
                                <label class="btn btn-outline-primary w-100 role-btn" for="role-user">
                                    <i class="fas fa-user d-block mb-1"></i>
                                    <small>Khách hàng</small>
                                </label>
                            </div>
                            <div class="col-6">
                                <input type="radio" class="btn-check" name="role" id="role-vendor" value="vendor">
                                <label class="btn btn-outline-success w-100 role-btn" for="role-vendor">
                                    <i class="fas fa-store d-block mb-1"></i>
                                    <small>Người bán</small>
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Personal Info -->
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="fullName" class="form-label">
                                <i class="fas fa-id-card me-1"></i>Họ và tên
                            </label>
                            <input type="text" 
                                   class="form-control" 
                                   id="fullName" 
                                   name="fullName" 
                                   value="${formData.fullName}"
                                   placeholder="VD: Nguyễn Văn An"
                                   required>
                        </div>
                        <div class="col-md-6">
                            <label for="phone" class="form-label">
                                <i class="fas fa-phone me-1"></i>Số điện thoại
                            </label>
                            <input type="tel" 
                                   class="form-control" 
                                   id="phone" 
                                   name="phone" 
                                   value="${formData.phone}"
                                   placeholder="VD: 0987654321"
                                   pattern="[0-9]{10,11}">
                        </div>
                    </div>

                    <!-- Account Info -->
                    <div class="mb-3">
                        <label for="email" class="form-label">
                            <i class="fas fa-envelope me-1"></i>Email
                        </label>
                        <input type="email" 
                               class="form-control" 
                               id="email" 
                               name="email" 
                               value="${formData.email}"
                               placeholder="example@gmail.com"
                               required>
                        <div class="form-text">
                            <i class="fas fa-info-circle me-1"></i>Chúng tôi sẽ gửi mã xác thực đến email này
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="username" class="form-label">
                            <i class="fas fa-at me-1"></i>Tên đăng nhập
                        </label>
                        <input type="text" 
                               class="form-control" 
                               id="username" 
                               name="username" 
                               value="${formData.username}"
                               placeholder="VD: nguyenvanan123"
                               pattern="[a-zA-Z0-9_]{3,30}"
                               required>
                        <div class="form-text">
                            <i class="fas fa-info-circle me-1"></i>3-30 ký tự, chỉ gồm chữ, số và dấu gạch dưới
                        </div>
                    </div>

                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="password" class="form-label">
                                <i class="fas fa-lock me-1"></i>Mật khẩu
                            </label>
                            <div class="input-group">
                                <input type="password" 
                                       class="form-control" 
                                       id="password" 
                                       name="password" 
                                       placeholder="Tối thiểu 6 ký tự"
                                       required>
                                <button type="button" class="btn btn-outline-secondary" onclick="togglePassword('password')">
                                    <i class="fas fa-eye" id="passwordIcon"></i>
                                </button>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label for="confirmPassword" class="form-label">
                                <i class="fas fa-lock me-1"></i>Xác nhận mật khẩu
                            </label>
                            <div class="input-group">
                                <input type="password" 
                                       class="form-control" 
                                       id="confirmPassword" 
                                       placeholder="Nhập lại mật khẩu"
                                       required>
                                <button type="button" class="btn btn-outline-secondary" onclick="togglePassword('confirmPassword')">
                                    <i class="fas fa-eye" id="confirmPasswordIcon"></i>
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Terms -->
                    <div class="mb-4">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="agreeTerms" required>
                            <label class="form-check-label" for="agreeTerms">
                                Tôi đồng ý với 
                                <a href="#" class="text-primary">Điều khoản sử ddụng</a> 
                                và 
                                <a href="#" class="text-primary">Chính sách bảo mật</a>
                            </label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="newsletter">
                            <label class="form-check-label" for="newsletter">
                                Nhận thông báo khuyến mãi và tin tức mới
                            </label>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="btn btn-register w-100 mb-3">
                        <i class="fas fa-user-plus me-2"></i>Tạo tài khoản
                    </button>
                </form>

                <!-- Login Link -->
                <div class="text-center">
                    <p class="mb-0">Đã có tài khoản? 
                        <a href="${pageContext.request.contextPath}/auth/login" class="login-link">
                            Đăng nhập ngay
                        </a>
                    </p>
                </div>
            </div>
        </div>

        <!-- Benefits Section -->
        <div class="auth-benefits">
            <div class="benefits-content">
                <h2>Tại sao chọn UTESHOP-CPL?</h2>
                
                <div class="benefit-items">
                    <div class="benefit-item">
                        <i class="fas fa-rocket"></i>
                        <div>
                            <h5>Giao hàng siêu tốc</h5>
                            <p>Nhận hàng trong 24h với dịch vụ giao hàng nhanh</p>
                        </div>
                    </div>
                    
                    <div class="benefit-item">
                        <i class="fas fa-shield-alt"></i>
                        <div>
                            <h5>Bảo mật tuyệt đối</h5>
                            <p>Thông tin và giao dịch được bảo vệ 100%</p>
                        </div>
                    </div>
                    
                    <div class="benefit-item">
                        <i class="fas fa-gift"></i>
                        <div>
                            <h5>Ưu đãi độc quyền</h5>
                            <p>Nhận voucher và khuyến mãi dành riêng cho thành viên</p>
                        </div>
                    </div>
                    
                    <div class="benefit-item">
                        <i class="fas fa-headset"></i>
                        <div>
                            <h5>Hỗ trợ 24/7</h5>
                            <p>Đội ngũ chăm sóc khách hàng luôn sẵn sàng hỗ trợ</p>
                        </div>
                    </div>
                </div>

                <!-- Stats -->
                <div class="stats-section">
                    <div class="stat-item">
                        <div class="stat-number">10K+</div>
                        <div class="stat-label">Khách hàng</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">50K+</div>
                        <div class="stat-label">Sản phẩm</div>
                    </div>
                    <div class="stat-item">
                        <div class="stat-number">99%</div>
                        <div class="stat-label">Hài lòng</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.auth-body {
    margin: 0;
    padding: 0;
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
}

.auth-container {
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
}

.register-wrapper {
    display: grid;
    grid-template-columns: 1.2fr 1fr;
    max-width: 1400px;
    width: 100%;
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    min-height: 700px;
}

.brand-mini {
    color: #4f46e5;
    font-size: 24px;
    font-weight: 700;
}

.auth-form-container {
    padding: 40px;
    display: flex;
    align-items: center;
}

.auth-form {
    width: 100%;
    max-width: 500px;
    margin: 0 auto;
}

.form-header h3 {
    font-size: 28px;
    font-weight: 700;
    color: #1f2937;
    margin-bottom: 8px;
}

.form-header p {
    color: #6b7280;
    margin: 0;
}

.role-btn {
    padding: 15px 10px;
    text-align: center;
}

.form-label {
    font-weight: 500;
    color: #374151;
    margin-bottom: 8px;
}

.form-control {
    padding: 12px 16px;
    border: 2px solid #e5e7eb;
    border-radius: 8px;
    transition: all 0.2s ease;
}

.form-control:focus {
    border-color: #4f46e5;
    box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
}

.btn-register {
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    color: white;
    border: none;
    padding: 14px 24px;
    border-radius: 10px;
    font-size: 16px;
    font-weight: 600;
    transition: all 0.3s ease;
}

.btn-register:hover {
    transform: translateY(-2px);
    box-shadow: 0 12px 28px rgba(16, 185, 129, 0.3);
    color: white;
}

.login-link {
    color: #4f46e5;
    text-decoration: none;
    font-weight: 600;
}

.login-link:hover {
    text-decoration: underline;
    color: #3730a3;
}

/* Benefits Section */
.auth-benefits {
    background: linear-gradient(135deg, #1f2937 0%, #111827 100%);
    color: white;
    padding: 40px;
    display: flex;
    align-items: center;
}

.benefits-content h2 {
    font-size: 24px;
    font-weight: 700;
    margin-bottom: 30px;
    text-align: center;
    color: #fbbf24;
}

.benefit-item {
    display: flex;
    align-items: flex-start;
    margin-bottom: 25px;
}

.benefit-item i {
    font-size: 24px;
    color: #4f46e5;
    margin-right: 15px;
    margin-top: 5px;
}

.benefit-item h5 {
    font-size: 16px;
    font-weight: 600;
    margin-bottom: 5px;
    color: white;
}

.benefit-item p {
    font-size: 14px;
    color: #d1d5db;
    margin: 0;
}

.stats-section {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 15px;
    margin-top: 30px;
}

.stat-item {
    text-align: center;
    padding: 15px;
    background: rgba(255, 255, 255, 0.1);
    border-radius: 10px;
}

.stat-number {
    font-size: 20px;
    font-weight: 700;
    color: #fbbf24;
}

.stat-label {
    font-size: 12px;
    color: #d1d5db;
}

/* Responsive */
@media (max-width: 1024px) {
    .register-wrapper {
        grid-template-columns: 1fr;
    }
    
    .auth-benefits {
        display: none;
    }
}

@media (max-width: 768px) {
    .auth-form-container {
        padding: 30px 20px;
    }
}
</style>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function togglePassword(inputId) {
    const input = document.getElementById(inputId);
    const icon = document.getElementById(inputId + 'Icon');
    
    if (input.type === 'password') {
        input.type = 'text';
        icon.className = 'fas fa-eye-slash';
    } else {
        input.type = 'password';
        icon.className = 'fas fa-eye';
    }
}

document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('fullName').focus();
    
    // Password match validation
    const password = document.getElementById('password');
    const confirmPassword = document.getElementById('confirmPassword');
    
    function checkPasswordMatch() {
        if (confirmPassword.value && password.value !== confirmPassword.value) {
            confirmPassword.setCustomValidity('Mật khẩu không khớp');
        } else {
            confirmPassword.setCustomValidity('');
        }
    }
    
    password.addEventListener('input', checkPasswordMatch);
    confirmPassword.addEventListener('input', checkPasswordMatch);
    
    // Form submission
    const form = document.querySelector('.register-form');
    form.addEventListener('submit', function() {
        const submitBtn = form.querySelector('button[type="submit"]');
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang tạo tài khoản...';
        submitBtn.disabled = true;
    });
});

console.log('✅ UTESHOP-CPL Register page loaded - ' + new Date().toISOString());
</script>

</body>
</html>
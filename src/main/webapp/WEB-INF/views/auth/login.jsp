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
    <div class="auth-wrapper">
        <!-- Left Side - Branding -->
        <div class="auth-branding">
            <div class="brand-content">
                <div class="brand-logo">
                    <i class="fas fa-shopping-bag"></i>
                    <h1>UTESHOP-CPL</h1>
                </div>
                <h2>Chào mừng trở lại!</h2>
                <p>Đăng nhập để tiếp tục mua sắm và khám phá hàng ngàn sản phẩm chất lượng.</p>
                
                <div class="features-list">
                    <div class="feature-item">
                        <i class="fas fa-shield-alt"></i>
                        <span>Bảo mật tuyệt đối</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-shipping-fast"></i>
                        <span>Giao hàng nhanh chóng</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-headset"></i>
                        <span>Hỗ trợ 24/7</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Side - Login Form -->
        <div class="auth-form-container">
            <div class="auth-form">
                <div class="form-header">
                    <h3>Đăng nhập</h3>
                    <p>Nhập thông tin để truy cập tài khoản</p>
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

                <!-- Login Form -->
                <form method="post" action="${pageContext.request.contextPath}/auth/login" class="login-form">
                    <div class="form-group mb-3">
                        <label for="usernameOrEmail" class="form-label">
                            <i class="fas fa-user me-2"></i>Email hoặc tên đăng nhập
                        </label>
                        <input type="text" 
                               class="form-control" 
                               id="usernameOrEmail" 
                               name="usernameOrEmail" 
                               value="${usernameOrEmail}"
                               placeholder="Nhập email hoặc tên đăng nhập"
                               required>
                    </div>

                    <div class="form-group mb-3">
                        <label for="password" class="form-label">
                            <i class="fas fa-lock me-2"></i>Mật khẩu
                        </label>
                        <div class="input-group">
                            <input type="password" 
                                   class="form-control" 
                                   id="password" 
                                   name="password" 
                                   placeholder="Nhập mật khẩu"
                                   required>
                            <button type="button" class="btn btn-outline-secondary" onclick="togglePassword()">
                                <i class="fas fa-eye" id="passwordToggleIcon"></i>
                            </button>
                        </div>
                    </div>

                    <div class="form-options mb-4">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="rememberMe" name="rememberMe">
                            <label class="form-check-label" for="rememberMe">
                                Ghi nhớ đăng nhập
                            </label>
                        </div>
                        <a href="${pageContext.request.contextPath}/auth/forgot-password" class="forgot-link">
                            Quên mật khẩu?
                        </a>
                    </div>

                    <button type="submit" class="btn btn-login w-100 mb-3">
                        <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                    </button>
                </form>

                <!-- Register Link -->
                <div class="text-center">
                    <p class="mb-0">Chưa có tài khoản? 
                        <a href="${pageContext.request.contextPath}/auth/register" class="register-link">
                            Đăng ký ngay
                        </a>
                    </p>
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

.auth-wrapper {
    display: grid;
    grid-template-columns: 1fr 1fr;
    max-width: 1200px;
    width: 100%;
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    min-height: 600px;
}

.auth-branding {
    background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
    color: white;
    padding: 60px 40px;
    display: flex;
    align-items: center;
    position: relative;
}

.brand-content {
    position: relative;
    z-index: 1;
}

.brand-logo {
    display: flex;
    align-items: center;
    margin-bottom: 30px;
}

.brand-logo i {
    font-size: 48px;
    margin-right: 15px;
    color: white;
}

.brand-logo h1 {
    font-size: 32px;
    font-weight: 700;
    margin: 0;
    letter-spacing: -1px;
    color: white;
}

.auth-branding h2 {
    font-size: 28px;
    font-weight: 600;
    margin-bottom: 15px;
    line-height: 1.2;
    color: white;
}

.auth-branding p {
    font-size: 16px;
    opacity: 0.9;
    line-height: 1.6;
    margin-bottom: 40px;
    color: white;
}

.features-list {
    display: flex;
    flex-direction: column;
    gap: 15px;
}

.feature-item {
    display: flex;
    align-items: center;
    font-size: 14px;
    color: white;
}

.feature-item i {
    margin-right: 12px;
    font-size: 16px;
    opacity: 0.8;
    width: 20px;
}

.auth-form-container {
    padding: 60px 40px;
    display: flex;
    align-items: center;
}

.auth-form {
    width: 100%;
    max-width: 400px;
    margin: 0 auto;
}

.form-header {
    text-align: center;
    margin-bottom: 40px;
}

.form-header h3 {
    font-size: 28px;
    font-weight: 700;
    color: #1f2937;
    margin-bottom: 8px;
}

.form-header p {
    color: #6b7280;
    font-size: 14px;
    margin: 0;
}

.form-label {
    font-weight: 500;
    color: #374151;
    margin-bottom: 8px;
}

.form-control {
    padding: 12px 16px;
    border: 2px solid #e5e7eb;
    border-radius: 10px;
    font-size: 14px;
    transition: all 0.2s ease;
    background: #f9fafb;
}

.form-control:focus {
    border-color: #4f46e5;
    background: white;
    box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
}

.form-options {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.form-check-label {
    font-size: 14px;
    color: #6b7280;
}

.forgot-link, .register-link {
    color: #4f46e5;
    text-decoration: none;
    font-size: 14px;
    font-weight: 500;
}

.forgot-link:hover, .register-link:hover {
    text-decoration: underline;
    color: #3730a3;
}

.btn-login {
    background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
    color: white;
    border: none;
    padding: 14px 24px;
    border-radius: 10px;
    font-size: 16px;
    font-weight: 600;
    transition: all 0.3s ease;
}

.btn-login:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(79, 70, 229, 0.3);
    color: white;
}

.btn-outline-secondary {
    border-color: #e5e7eb;
}

.btn-outline-secondary:hover {
    background-color: #f3f4f6;
    border-color: #d1d5db;
}

/* Responsive */
@media (max-width: 768px) {
    .auth-wrapper {
        grid-template-columns: 1fr;
        max-width: 400px;
    }
    
    .auth-branding {
        padding: 40px 30px;
        text-align: center;
    }
    
    .auth-form-container {
        padding: 40px 30px;
    }
}

@media (max-width: 480px) {
    .auth-container {
        padding: 10px;
    }
    
    .auth-branding, .auth-form-container {
        padding: 30px 20px;
    }
}
</style>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
function togglePassword() {
    const passwordInput = document.getElementById('password');
    const toggleIcon = document.getElementById('passwordToggleIcon');
    
    if (passwordInput.type === 'password') {
        passwordInput.type = 'text';
        toggleIcon.className = 'fas fa-eye-slash';
    } else {
        passwordInput.type = 'password';
        toggleIcon.className = 'fas fa-eye';
    }
}

document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('usernameOrEmail').focus();
    
    const form = document.querySelector('.login-form');
    form.addEventListener('submit', function() {
        const submitBtn = form.querySelector('button[type="submit"]');
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang đăng nhập...';
        submitBtn.disabled = true;
    });
});

console.log('✅ UTESHOP-CPL Login page loaded - ' + new Date().toISOString());
</script>

</body>
</html>
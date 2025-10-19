<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="row justify-content-center">
    <div class="col-md-6 col-lg-5">
        <div class="card shadow-lg">
            <div class="card-header bg-primary text-white text-center">
                <h3 class="mb-0">🔐 Đăng nhập UTESHOP-CPL</h3>
                <small>Created by tuaanshuuysv on 2025-10-19</small>
            </div>
            <div class="card-body p-4">
                
                <!-- Success message -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle"></i> ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <!-- Error message -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <form method="post" action="${pageContext.request.contextPath}/auth/login" id="loginForm">
                    <div class="mb-3">
                        <label for="usernameOrEmail" class="form-label">
                            <i class="fas fa-user"></i> Email hoặc Tên đăng nhập
                        </label>
                        <input type="text" class="form-control" id="usernameOrEmail" name="usernameOrEmail" 
                               value="${usernameOrEmail}" placeholder="Nhập email hoặc tên đăng nhập" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="password" class="form-label">
                            <i class="fas fa-lock"></i> Mật khẩu
                        </label>
                        <div class="input-group">
                            <input type="password" class="form-control" id="password" name="password" 
                                   placeholder="Nhập mật khẩu" required>
                            <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                <i class="fas fa-eye"></i>
                            </button>
                        </div>
                    </div>
                    
                    <div class="d-grid mb-3">
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-sign-in-alt"></i> Đăng nhập
                        </button>
                    </div>
                </form>
                
                <div class="text-center">
                    <a href="${pageContext.request.contextPath}/auth/forgot-password" class="text-decoration-none">
                        <i class="fas fa-key"></i> Quên mật khẩu?
                    </a>
                </div>
                
                <hr class="my-4">
                
                <div class="text-center">
                    <p class="mb-2">Chưa có tài khoản?</p>
                    <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-outline-success">
                        <i class="fas fa-user-plus"></i> Đăng ký ngay
                    </a>
                </div>
                
                <div class="text-center mt-4">
                    <small class="text-muted">
                        © 2025 UTESHOP-CPL by tuaanshuuysv<br>
                        Build: 2025-10-19 16:38:02 UTC
                    </small>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
// Toggle password visibility
document.getElementById('togglePassword').addEventListener('click', function() {
    const password = document.getElementById('password');
    const icon = this.querySelector('i');
    
    if (password.type === 'password') {
        password.type = 'text';
        icon.classList.remove('fa-eye');
        icon.classList.add('fa-eye-slash');
    } else {
        password.type = 'password';
        icon.classList.remove('fa-eye-slash');
        icon.classList.add('fa-eye');
    }
});

// Form validation
document.getElementById('loginForm').addEventListener('submit', function(e) {
    const usernameOrEmail = document.getElementById('usernameOrEmail').value.trim();
    const password = document.getElementById('password').value;
    
    if (!usernameOrEmail) {
        e.preventDefault();
        alert('Vui lòng nhập email hoặc tên đăng nhập!');
        return false;
    }
    
    if (!password) {
        e.preventDefault();
        alert('Vui lòng nhập mật khẩu!');
        return false;
    }
});

// Auto focus on first input
document.getElementById('usernameOrEmail').focus();

console.log('✅ Login page loaded successfully - UTESHOP-CPL by tuaanshuuysv');
</script>

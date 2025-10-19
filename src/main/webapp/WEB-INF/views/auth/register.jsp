<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="row justify-content-center">
    <div class="col-md-10 col-lg-8">
        <div class="card shadow-lg">
            <div class="card-header bg-success text-white text-center">
                <h3 class="mb-0">👤 Đăng ký tài khoản UTESHOP-CPL</h3>
                <small>Created by tuaanshuuysv | Build: 2025-10-19</small>
            </div>
            <div class="card-body p-4">
                
                <!-- Error message -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <form method="post" action="${pageContext.request.contextPath}/auth/register" id="registerForm">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="username" class="form-label">
                                    <i class="fas fa-user"></i> Tên đăng nhập <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="username" name="username" 
                                       value="${formData.username}" placeholder="Ít nhất 3 ký tự" required minlength="3">
                                <div class="form-text">Tên đăng nhập phải có ít nhất 3 ký tự, không có khoảng trắng</div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="email" class="form-label">
                                    <i class="fas fa-envelope"></i> Email <span class="text-danger">*</span>
                                </label>
                                <input type="email" class="form-control" id="email" name="email" 
                                       value="${formData.email}" placeholder="example@gmail.com" required>
                                <div class="form-text">Email sẽ được dùng để gửi mã OTP xác thực</div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="fullName" class="form-label">
                            <i class="fas fa-id-card"></i> Họ và tên <span class="text-danger">*</span>
                        </label>
                        <input type="text" class="form-control" id="fullName" name="fullName" 
                               value="${formData.fullName}" placeholder="Nhập họ và tên đầy đủ" required>
                    </div>
                    
                    <div class="mb-3">
                        <label for="phone" class="form-label">
                            <i class="fas fa-phone"></i> Số điện thoại
                        </label>
                        <input type="tel" class="form-control" id="phone" name="phone" 
                               value="${formData.phone}" placeholder="0987654321">
                        <div class="form-text">Số điện thoại (không bắt buộc)</div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="password" class="form-label">
                                    <i class="fas fa-lock"></i> Mật khẩu <span class="text-danger">*</span>
                                </label>
                                <div class="input-group">
                                    <input type="password" class="form-control" id="password" name="password" 
                                           placeholder="Ít nhất 6 ký tự" required minlength="6">
                                    <button class="btn btn-outline-secondary" type="button" id="togglePassword">
                                        <i class="fas fa-eye"></i>
                                    </button>
                                </div>
                                <div class="form-text">Mật khẩu phải có ít nhất 6 ký tự</div>
                            </div>
                        </div>
                        
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="confirmPassword" class="form-label">
                                    <i class="fas fa-lock"></i> Xác nhận mật khẩu <span class="text-danger">*</span>
                                </label>
                                <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                       placeholder="Nhập lại mật khẩu" required>
                                <div id="passwordMatch" class="form-text"></div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label class="form-label">
                            <i class="fas fa-user-tag"></i> Loại tài khoản <span class="text-danger">*</span>
                        </label>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="card border-primary h-100">
                                    <div class="card-body text-center">
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="role" id="roleUser" 
                                                   value="user" ${formData.roleId == 2 || empty formData ? 'checked' : ''}>
                                            <label class="form-check-label w-100" for="roleUser">
                                                <i class="fas fa-shopping-cart fa-2x text-primary mb-2"></i><br>
                                                <strong>🛍️ KHÁCH HÀNG</strong><br>
                                                <small class="text-muted">Mua sắm và đặt hàng trên UTESHOP-CPL</small>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card border-success h-100">
                                    <div class="card-body text-center">
                                        <div class="form-check">
                                            <input class="form-check-input" type="radio" name="role" id="roleVendor" 
                                                   value="vendor" ${formData.roleId == 3 ? 'checked' : ''}>
                                            <label class="form-check-label w-100" for="roleVendor">
                                                <i class="fas fa-store fa-2x text-success mb-2"></i><br>
                                                <strong>🏪 NGƯỜI BÁN</strong><br>
                                                <small class="text-muted">Mở shop và bán hàng trên UTESHOP-CPL</small>
                                            </label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="form-text mt-2">
                            <i class="fas fa-info-circle"></i> <strong>Lưu ý:</strong> Chỉ được tạo tài khoản Khách hàng hoặc Người bán. 
                            Không được tạo tài khoản Admin.
                        </div>
                    </div>
                    
                    <div class="mb-3 form-check">
                        <input type="checkbox" class="form-check-input" id="agreeTerms" required>
                        <label class="form-check-label" for="agreeTerms">
                            Tôi đồng ý với <a href="#" target="_blank">Điều khoản sử dụng</a> 
                            và <a href="#" target="_blank">Chính sách bảo mật</a> của UTESHOP-CPL
                        </label>
                    </div>
                    
                    <div class="d-grid mb-3">
                        <button type="submit" class="btn btn-success btn-lg">
                            <i class="fas fa-user-plus"></i> Đăng ký tài khoản
                        </button>
                    </div>
                </form>
                
                <hr>
                
                <div class="text-center">
                    <p class="mb-2">Đã có tài khoản?</p>
                    <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-outline-primary">
                        <i class="fas fa-sign-in-alt"></i> Đăng nhập ngay
                    </a>
                </div>
                
                <div class="text-center mt-4">
                    <small class="text-muted">
                        © 2025 UTESHOP-CPL by tuaanshuuysv<br>
                        🛡️ Thông tin của bạn được bảo mật tuyệt đối
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

// Check password match
document.getElementById('confirmPassword').addEventListener('input', function() {
    const password = document.getElementById('password').value;
    const confirmPassword = this.value;
    const matchDiv = document.getElementById('passwordMatch');
    
    if (confirmPassword) {
        if (password === confirmPassword) {
            matchDiv.innerHTML = '<i class="fas fa-check text-success"></i> Mật khẩu khớp';
            matchDiv.className = 'form-text text-success';
        } else {
            matchDiv.innerHTML = '<i class="fas fa-times text-danger"></i> Mật khẩu không khớp';
            matchDiv.className = 'form-text text-danger';
        }
    } else {
        matchDiv.innerHTML = '';
    }
});

// Form validation
document.getElementById('registerForm').addEventListener('submit', function(e) {
    const username = document.getElementById('username').value.trim();
    const email = document.getElementById('email').value.trim();
    const fullName = document.getElementById('fullName').value.trim();
    const password = document.getElementById('password').value;
    const confirmPassword = document.getElementById('confirmPassword').value;
    const agreeTerms = document.getElementById('agreeTerms').checked;
    
    if (!username || username.length < 3) {
        e.preventDefault();
        alert('Tên đăng nhập phải có ít nhất 3 ký tự!');
        return false;
    }
    
    if (username.includes(' ')) {
        e.preventDefault();
        alert('Tên đăng nhập không được chứa khoảng trắng!');
        return false;
    }
    
    if (!email || !email.includes('@')) {
        e.preventDefault();
        alert('Vui lòng nhập email hợp lệ!');
        return false;
    }
    
    if (!fullName) {
        e.preventDefault();
        alert('Vui lòng nhập họ và tên!');
        return false;
    }
    
    if (!password || password.length < 6) {
        e.preventDefault();
        alert('Mật khẩu phải có ít nhất 6 ký tự!');
        return false;
    }
    
    if (password !== confirmPassword) {
        e.preventDefault();
        alert('Mật khẩu xác nhận không khớp!');
        return false;
    }
    
    if (!agreeTerms) {
        e.preventDefault();
        alert('Vui lòng đồng ý với điều khoản sử dụng!');
        return false;
    }
    
    // Show loading
    const submitBtn = this.querySelector('button[type="submit"]');
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
    submitBtn.disabled = true;
});

// Auto focus on first input
document.getElementById('username').focus();

console.log('✅ Register page loaded successfully - UTESHOP-CPL by tuaanshuuysv');
</script>
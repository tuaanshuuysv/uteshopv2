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
        <!-- Left Side - Form -->
        <div class="auth-form-container">
            <div class="auth-form">
                <!-- Header -->
                <div class="form-header text-center">
                    <div class="brand-mini mb-3">
                        <i class="fas fa-shopping-bag me-2"></i>
                        <span>UTESHOP-CPL</span>
                    </div>
                    
                    <div class="reset-icon mb-3">
                        <i class="fas fa-lock"></i>
                    </div>
                    
                    <h3>Đặt lại mật khẩu</h3>
                    <p>Tạo mật khẩu mới cho tài khoản của bạn</p>
                </div>

                <!-- User Info -->
                <div class="user-info mb-4">
                    <div class="user-card">
                        <i class="fas fa-user-circle me-2"></i>
                        <div>
                            <small class="text-muted">Đặt lại mật khẩu cho:</small>
                            <div class="fw-bold">${email}</div>
                        </div>
                    </div>
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

                <!-- Reset Password Form -->
                <form method="post" action="${pageContext.request.contextPath}/auth/reset-password" class="reset-form">
                    <!-- Hidden Fields -->
                    <input type="hidden" name="email" value="${email}">
                    <input type="hidden" name="otpCode" value="${otpCode}">
                    
                    <!-- OTP Verification (if not verified yet) -->
                    <c:if test="${empty otpCode}">
                        <div class="form-group mb-3">
                            <label for="otpCodeInput" class="form-label">
                                <i class="fas fa-key me-2"></i>Mã xác thực OTP
                            </label>
                            <input type="text" 
                                   class="form-control" 
                                   id="otpCodeInput" 
                                   name="otpCode" 
                                   placeholder="Nhập mã 6 chữ số từ email"
                                   maxlength="6"
                                   pattern="[0-9]{6}"
                                   required>
                            <div class="form-text">
                                <i class="fas fa-info-circle me-1"></i>
                                Kiểm tra email để lấy mã xác thực
                            </div>
                        </div>
                    </c:if>

                    <!-- New Password -->
                    <div class="form-group mb-3">
                        <label for="newPassword" class="form-label">
                            <i class="fas fa-lock me-2"></i>Mật khẩu mới
                        </label>
                        <div class="input-group">
                            <input type="password" 
                                   class="form-control" 
                                   id="newPassword" 
                                   name="newPassword" 
                                   placeholder="Nhập mật khẩu mới"
                                   required
                                   autocomplete="new-password">
                            <button type="button" class="btn btn-outline-secondary" onclick="togglePassword('newPassword')">
                                <i class="fas fa-eye" id="newPasswordIcon"></i>
                            </button>
                        </div>
                        
                        <!-- Password Strength Indicator -->
                        <div class="password-strength mt-2">
                            <div class="strength-bar">
                                <div class="strength-fill" id="strengthFill"></div>
                            </div>
                            <small class="strength-text" id="strengthText">Nhập mật khẩu mới</small>
                        </div>
                    </div>

                    <!-- Confirm Password -->
                    <div class="form-group mb-4">
                        <label for="confirmPassword" class="form-label">
                            <i class="fas fa-lock me-2"></i>Xác nhận mật khẩu
                        </label>
                        <div class="input-group">
                            <input type="password" 
                                   class="form-control" 
                                   id="confirmPassword" 
                                   placeholder="Nhập lại mật khẩu mới"
                                   required
                                   autocomplete="new-password">
                            <button type="button" class="btn btn-outline-secondary" onclick="togglePassword('confirmPassword')">
                                <i class="fas fa-eye" id="confirmPasswordIcon"></i>
                            </button>
                        </div>
                        <div class="password-match mt-2" id="passwordMatch"></div>
                    </div>

                    <!-- Password Requirements -->
                    <div class="password-requirements mb-4">
                        <h6><i class="fas fa-shield-alt me-2"></i>Yêu cầu mật khẩu</h6>
                        <div class="requirements-list">
                            <div class="requirement" id="req-length">
                                <i class="fas fa-times"></i>
                                <span>Ít nhất 6 ký tự</span>
                            </div>
                            <div class="requirement" id="req-lowercase">
                                <i class="fas fa-times"></i>
                                <span>Có chữ thường (a-z)</span>
                            </div>
                            <div class="requirement" id="req-uppercase">
                                <i class="fas fa-times"></i>
                                <span>Có chữ hoa (A-Z)</span>
                            </div>
                            <div class="requirement" id="req-number">
                                <i class="fas fa-times"></i>
                                <span>Có số (0-9)</span>
                            </div>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="btn btn-reset w-100 mb-3" id="submitBtn" disabled>
                        <i class="fas fa-check-circle me-2"></i>Đặt lại mật khẩu
                    </button>
                </form>

                <!-- Back Options -->
                <div class="text-center">
                    <div class="row">
                        <div class="col-6">
                            <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-outline-secondary w-100 btn-sm">
                                <i class="fas fa-arrow-left me-1"></i>Về đăng nhập
                            </a>
                        </div>
                        <div class="col-6">
                            <a href="${pageContext.request.contextPath}/auth/forgot-password" class="btn btn-outline-warning w-100 btn-sm">
                                <i class="fas fa-key me-1"></i>Gửi lại OTP
                            </a>
                        </div>
                    </div>
                </div>

                <!-- Footer -->
                <div class="text-center mt-4">
                    <small class="text-muted">
                        © 2025 UTESHOP-CPL by <strong>tuaanshuuysv</strong><br>
                        <i class="fas fa-shield-alt me-1"></i>Mật khẩu sẽ được mã hóa an toàn
                    </small>
                </div>
            </div>
        </div>

        <!-- Right Side - Security Info -->
        <div class="auth-security">
            <div class="security-content">
                <div class="security-header">
                    <i class="fas fa-shield-alt"></i>
                    <h4>Bảo mật tài khoản</h4>
                    <p>Tạo mật khẩu mạnh để bảo vệ tài khoản của bạn</p>
                </div>

                <!-- Security Tips -->
                <div class="security-tips">
                    <h6><i class="fas fa-lightbulb me-2"></i>Mẹo tạo mật khẩu mạnh</h6>
                    
                    <div class="tip-item">
                        <i class="fas fa-check"></i>
                        <div>
                            <strong>Sử dụng ít nhất 8 ký tự</strong>
                            <p>Mật khẩu càng dài càng an toàn</p>
                        </div>
                    </div>

                    <div class="tip-item">
                        <i class="fas fa-check"></i>
                        <div>
                            <strong>Kết hợp nhiều loại ký tự</strong>
                            <p>Chữ hoa, chữ thường, số và ký tự đặc biệt</p>
                        </div>
                    </div>

                    <div class="tip-item">
                        <i class="fas fa-check"></i>
                        <div>
                            <strong>Tránh thông tin cá nhân</strong>
                            <p>Không dùng tên, ngày sinh, số điện thoại</p>
                        </div>
                    </div>

                    <div class="tip-item">
                        <i class="fas fa-check"></i>
                        <div>
                            <strong>Tránh mật khẩu phổ biến</strong>
                            <p>Không dùng 123456, password, qwerty...</p>
                        </div>
                    </div>
                </div>

                <!-- Security Features -->
                <div class="security-features">
                    <h6><i class="fas fa-lock me-2"></i>Tính năng bảo mật</h6>
                    
                    <div class="feature-item">
                        <i class="fas fa-encryption"></i>
                        <div>
                            <strong>Mã hóa BCrypt</strong>
                            <p>Mật khẩu được mã hóa với thuật toán BCrypt an toàn</p>
                        </div>
                    </div>

                    <div class="feature-item">
                        <i class="fas fa-clock"></i>
                        <div>
                            <strong>Phiên đăng nhập</strong>
                            <p>Tự động đăng xuất sau thời gian không hoạt động</p>
                        </div>
                    </div>

                    <div class="feature-item">
                        <i class="fas fa-history"></i>
                        <div>
                            <strong>Lịch sử đăng nhập</strong>
                            <p>Theo dõi các lần đăng nhập gần đây</p>
                        </div>
                    </div>
                </div>

                <!-- What's Next -->
                <div class="whats-next">
                    <div class="next-card">
                        <i class="fas fa-arrow-right"></i>
                        <div>
                            <h6>Sau khi đặt lại</h6>
                            <p>Bạn sẽ được chuyển đến trang đăng nhập để sử dụng mật khẩu mới</p>
                        </div>
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

.auth-wrapper {
    display: grid;
    grid-template-columns: 1fr 1fr;
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

.reset-icon {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto;
    box-shadow: 0 10px 30px rgba(220, 38, 38, 0.3);
}

.reset-icon i {
    font-size: 32px;
    color: white;
}

.auth-form-container {
    padding: 50px 40px;
    display: flex;
    align-items: center;
}

.auth-form {
    width: 100%;
    max-width: 450px;
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

.user-card {
    background: #dbeafe;
    border: 2px solid #bfdbfe;
    border-radius: 12px;
    padding: 16px 20px;
    display: flex;
    align-items: center;
}

.user-card i {
    color: #2563eb;
    font-size: 20px;
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
    border-color: #dc2626;
    background: white;
    box-shadow: 0 0 0 3px rgba(220, 38, 38, 0.1);
}

/* Password Strength */
.password-strength {
    margin-top: 8px;
}

.strength-bar {
    width: 100%;
    height: 4px;
    background: #e5e7eb;
    border-radius: 2px;
    overflow: hidden;
    margin-bottom: 4px;
}

.strength-fill {
    height: 100%;
    width: 0%;
    transition: all 0.3s ease;
    border-radius: 2px;
}

.strength-text {
    font-size: 12px;
    color: #6b7280;
}

.password-match {
    font-size: 12px;
    display: flex;
    align-items: center;
}

.password-match.match {
    color: #10b981;
}

.password-match.no-match {
    color: #ef4444;
}

.password-match i {
    margin-right: 4px;
}

/* Password Requirements */
.password-requirements {
    background: #f8fafc;
    border: 1px solid #e2e8f0;
    border-radius: 10px;
    padding: 16px;
}

.password-requirements h6 {
    color: #475569;
    margin-bottom: 12px;
    font-weight: 600;
    font-size: 14px;
}

.requirements-list {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 8px;
}

.requirement {
    display: flex;
    align-items: center;
    font-size: 12px;
    color: #64748b;
}

.requirement i {
    margin-right: 6px;
    font-size: 10px;
    color: #ef4444;
}

.requirement.valid i {
    color: #10b981;
}

.requirement.valid {
    color: #059669;
}

.btn-reset {
    background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
    color: white;
    border: none;
    padding: 14px 24px;
    border-radius: 12px;
    font-size: 16px;
    font-weight: 600;
    transition: all 0.3s ease;
}

.btn-reset:hover:not(:disabled) {
    transform: translateY(-2px);
    box-shadow: 0 12px 28px rgba(220, 38, 38, 0.3);
    color: white;
}

.btn-reset:disabled {
    background: #9ca3af;
    cursor: not-allowed;
    transform: none;
    box-shadow: none;
}

/* Right Side - Security */
.auth-security {
    background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
    color: white;
    padding: 50px 40px;
    display: flex;
    align-items: center;
}

.security-content {
    width: 100%;
}

.security-header {
    text-align: center;
    margin-bottom: 30px;
}

.security-header i {
    font-size: 48px;
    color: #dc2626;
    margin-bottom: 15px;
    display: block;
}

.security-header h4 {
    font-size: 24px;
    font-weight: 700;
    color: white;
    margin-bottom: 8px;
}

.security-header p {
    color: #cbd5e1;
    margin: 0;
}

.security-tips, .security-features {
    margin-bottom: 25px;
}

.security-tips h6, .security-features h6 {
    color: #dc2626;
    margin-bottom: 15px;
    font-weight: 600;
}

.tip-item, .feature-item {
    display: flex;
    align-items: flex-start;
    margin-bottom: 15px;
    padding: 12px;
    background: rgba(255, 255, 255, 0.05);
    border-radius: 8px;
}

.tip-item i, .feature-item i {
    color: #10b981;
    margin-right: 10px;
    margin-top: 2px;
    font-size: 14px;
}

.tip-item strong, .feature-item strong {
    color: white;
    font-size: 13px;
    display: block;
    margin-bottom: 2px;
}

.tip-item p, .feature-item p {
    color: #cbd5e1;
    font-size: 11px;
    margin: 0;
    line-height: 1.3;
}

.whats-next {
    margin-top: 25px;
}

.next-card {
    display: flex;
    align-items: flex-start;
    padding: 16px;
    background: rgba(220, 38, 38, 0.1);
    border: 1px solid rgba(220, 38, 38, 0.3);
    border-radius: 12px;
}

.next-card i {
    color: #dc2626;
    margin-right: 12px;
    margin-top: 2px;
    font-size: 16px;
}

.next-card h6 {
    color: white;
    margin-bottom: 4px;
    font-weight: 600;
    font-size: 14px;
}

.next-card p {
    color: #cbd5e1;
    font-size: 12px;
    margin: 0;
    line-height: 1.4;
}

/* Responsive */
@media (max-width: 1024px) {
    .auth-wrapper {
        grid-template-columns: 1.2fr 1fr;
    }
    
    .requirements-list {
        grid-template-columns: 1fr;
    }
}

@media (max-width: 768px) {
    .auth-wrapper {
        grid-template-columns: 1fr;
    }
    
    .auth-security {
        display: none;
    }
    
    .auth-form-container {
        padding: 40px 30px;
    }
}

@media (max-width: 480px) {
    .auth-container {
        padding: 10px;
    }
    
    .auth-form-container {
        padding: 30px 20px;
    }
}
</style>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const newPasswordInput = document.getElementById('newPassword');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    const submitBtn = document.getElementById('submitBtn');
    const form = document.querySelector('.reset-form');
    
    // Focus first input
    const firstInput = document.querySelector('input[type="text"], input[type="password"]');
    if (firstInput) firstInput.focus();
    
    // Password strength checking
    newPasswordInput.addEventListener('input', function() {
        checkPasswordStrength(this.value);
        checkPasswordMatch();
        checkFormValidity();
    });
    
    confirmPasswordInput.addEventListener('input', function() {
        checkPasswordMatch();
        checkFormValidity();
    });
    
    // OTP input validation (if exists)
    const otpInput = document.getElementById('otpCodeInput');
    if (otpInput) {
        otpInput.addEventListener('input', function() {
            this.value = this.value.replace(/[^0-9]/g, '');
            checkFormValidity();
        });
    }
    
    function checkPasswordStrength(password) {
        const strengthFill = document.getElementById('strengthFill');
        const strengthText = document.getElementById('strengthText');
        
        let strength = 0;
        let text = '';
        let color = '';
        
        // Check requirements
        const requirements = {
            length: password.length >= 6,
            lowercase: /[a-z]/.test(password),
            uppercase: /[A-Z]/.test(password),
            number: /[0-9]/.test(password)
        };
        
        // Update requirement indicators
        Object.keys(requirements).forEach(req => {
            const element = document.getElementById('req-' + req);
            if (requirements[req]) {
                element.classList.add('valid');
                element.querySelector('i').className = 'fas fa-check';
            } else {
                element.classList.remove('valid');
                element.querySelector('i').className = 'fas fa-times';
            }
        });
        
        // Calculate strength
        strength = Object.values(requirements).filter(Boolean).length;
        
        switch (strength) {
            case 0:
            case 1:
                text = 'Rất yếu';
                color = '#ef4444';
                break;
            case 2:
                text = 'Yếu';
                color = '#f97316';
                break;
            case 3:
                text = 'Trung bình';
                color = '#eab308';
                break;
            case 4:
                text = 'Mạnh';
                color = '#10b981';
                break;
        }
        
        strengthFill.style.width = (strength * 25) + '%';
        strengthFill.style.background = color;
        strengthText.textContent = text;
        strengthText.style.color = color;
    }
    
    function checkPasswordMatch() {
        const password = newPasswordInput.value;
        const confirmPassword = confirmPasswordInput.value;
        const matchDiv = document.getElementById('passwordMatch');
        
        if (confirmPassword === '') {
            matchDiv.innerHTML = '';
            return false;
        }
        
        if (password === confirmPassword) {
            matchDiv.innerHTML = '<i class="fas fa-check"></i> Mật khẩu khớp';
            matchDiv.className = 'password-match match';
            return true;
        } else {
            matchDiv.innerHTML = '<i class="fas fa-times"></i> Mật khẩu không khớp';
            matchDiv.className = 'password-match no-match';
            return false;
        }
    }
    
    function checkFormValidity() {
        const password = newPasswordInput.value;
        const confirmPassword = confirmPasswordInput.value;
        const otpInput = document.getElementById('otpCodeInput');
        
        let isValid = true;
        
        // Check password requirements
        if (password.length < 6) isValid = false;
        if (password !== confirmPassword) isValid = false;
        if (confirmPassword === '') isValid = false;
        
        // Check OTP if required
        if (otpInput && otpInput.value.length !== 6) isValid = false;
        
        submitBtn.disabled = !isValid;
        
        if (isValid) {
            submitBtn.classList.add('btn-ready');
        } else {
            submitBtn.classList.remove('btn-ready');
        }
    }
    
    // Form submission
    form.addEventListener('submit', function(e) {
        const password = newPasswordInput.value;
        const confirmPassword = confirmPasswordInput.value;
        
        if (password !== confirmPassword) {
            e.preventDefault();
            showAlert('danger', 'Mật khẩu xác nhận không khớp!');
            return;
        }
        
        if (password.length < 6) {
            e.preventDefault();
            showAlert('danger', 'Mật khẩu phải có ít nhất 6 ký tự!');
            return;
        }
        
        // Show loading state
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang đặt lại...';
        submitBtn.disabled = true;
        
        // Safety timeout
        setTimeout(() => {
            submitBtn.innerHTML = '<i class="fas fa-check-circle me-2"></i>Đặt lại mật khẩu';
            submitBtn.disabled = false;
        }, 10000);
    });
});

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

function showAlert(type, message) {
    // Remove existing alerts
    const existingAlerts = document.querySelectorAll('.alert');
    existingAlerts.forEach(alert => alert.remove());
    
    // Create new alert
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-' + type + ' alert-dismissible fade show';
    
    const iconClass = type === 'success' ? 'check-circle' : 'exclamation-triangle';
    alertDiv.innerHTML = '<i class="fas fa-' + iconClass + ' me-2"></i>' + message + 
                        '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
    
    // Insert before form
    const form = document.querySelector('.reset-form');
    form.parentNode.insertBefore(alertDiv, form);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.remove();
        }
    }, 5000);
}

console.log('✅ UTESHOP-CPL Reset Password page loaded - 2025-10-19 22:46:24');
console.log('👤 Current user: tuaanshuuysv');
console.log('📧 Email: ${email}');
</script>

</body>
</html>
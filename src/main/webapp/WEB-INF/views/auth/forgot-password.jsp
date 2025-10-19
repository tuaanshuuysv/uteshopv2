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
                    
                    <div class="forgot-icon mb-3">
                        <i class="fas fa-key"></i>
                    </div>
                    
                    <h3>Quên mật khẩu</h3>
                    <p>Nhập email của bạn để nhận mã khôi phục</p>
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

                <!-- Forgot Password Form -->
                <form method="post" action="${pageContext.request.contextPath}/auth/forgot-password" class="forgot-form">
                    <div class="form-group mb-4">
                        <label for="email" class="form-label">
                            <i class="fas fa-envelope me-2"></i>Địa chỉ email
                        </label>
                        <input type="email" 
                               class="form-control" 
                               id="email" 
                               name="email" 
                               value="${email}"
                               placeholder="Nhập địa chỉ email của bạn"
                               required
                               autocomplete="email">
                        <div class="form-text">
                            <i class="fas fa-info-circle me-1"></i>
                            Chúng tôi sẽ gửi mã xác thực đến email này để đặt lại mật khẩu
                        </div>
                    </div>

                    <!-- Email Verification Info -->
                    <div class="verification-info mb-4">
                        <div class="info-card">
                            <div class="info-icon">
                                <i class="fas fa-shield-alt"></i>
                            </div>
                            <div class="info-content">
                                <h6>Bảo mật cao</h6>
                                <p>Mã OTP sẽ có hiệu lực trong 5 phút và chỉ sử dụng được 1 lần</p>
                            </div>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="btn btn-forgot w-100 mb-3" id="submitBtn">
                        <i class="fas fa-paper-plane me-2"></i>Gửi mã khôi phục
                    </button>
                </form>

                <!-- Back to Login -->
                <div class="text-center">
                    <p class="mb-3">Nhớ lại mật khẩu? 
                        <a href="${pageContext.request.contextPath}/auth/login" class="login-link">
                            Đăng nhập ngay
                        </a>
                    </p>
                    
                    <div class="other-options">
                        <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-outline-primary btn-sm">
                            <i class="fas fa-user-plus me-1"></i>Tạo tài khoản mới
                        </a>
                    </div>
                </div>

                <!-- Footer -->
                <div class="text-center mt-4">
                    <small class="text-muted">
                        © 2025 UTESHOP-CPL by <strong>tuaanshuuysv</strong><br>
                        <i class="fas fa-headset me-1"></i>Cần hỗ trợ? Liên hệ với chúng tôi 24/7
                    </small>
                </div>
            </div>
        </div>

        <!-- Right Side - Help Information -->
        <div class="auth-help">
            <div class="help-content">
                <div class="help-header">
                    <i class="fas fa-question-circle"></i>
                    <h4>Cần hỗ trợ?</h4>
                    <p>Chúng tôi sẵn sàng giúp bạn khôi phục tài khoản</p>
                </div>

                <!-- Process Steps -->
                <div class="process-steps">
                    <h6><i class="fas fa-list-ol me-2"></i>Quy trình khôi phục</h6>
                    
                    <div class="step-item">
                        <div class="step-number">1</div>
                        <div class="step-content">
                            <h6>Nhập email</h6>
                            <p>Nhập địa chỉ email bạn đã dùng để đăng ký tài khoản</p>
                        </div>
                    </div>

                    <div class="step-item">
                        <div class="step-number">2</div>
                        <div class="step-content">
                            <h6>Nhận mã OTP</h6>
                            <p>Kiểm tra hộp thư email để lấy mã xác thực 6 chữ số</p>
                        </div>
                    </div>

                    <div class="step-item">
                        <div class="step-number">3</div>
                        <div class="step-content">
                            <h6>Xác thực & đặt lại</h6>
                            <p>Nhập mã OTP và tạo mật khẩu mới cho tài khoản</p>
                        </div>
                    </div>
                </div>

                <!-- FAQ Section -->
                <div class="faq-section">
                    <h6><i class="fas fa-question me-2"></i>Câu hỏi thường gặp</h6>
                    
                    <div class="faq-item">
                        <div class="faq-question">
                            <i class="fas fa-chevron-right me-2"></i>
                            Không nhận được email?
                        </div>
                        <div class="faq-answer">
                            Kiểm tra thư mục spam/junk. Email có thể mất 2-3 phút để đến.
                        </div>
                    </div>

                    <div class="faq-item">
                        <div class="faq-question">
                            <i class="fas fa-chevron-right me-2"></i>
                            Quên email đăng ký?
                        </div>
                        <div class="faq-answer">
                            Liên hệ support@uteshop-cpl.com với thông tin cá nhân để được hỗ trợ.
                        </div>
                    </div>

                    <div class="faq-item">
                        <div class="faq-question">
                            <i class="fas fa-chevron-right me-2"></i>
                            Mã OTP không hợp lệ?
                        </div>
                        <div class="faq-answer">
                            Mã OTP có hiệu lực 5 phút. Hãy yêu cầu gửi lại nếu hết hạn.
                        </div>
                    </div>
                </div>

                <!-- Contact Support -->
                <div class="contact-support">
                    <div class="support-card">
                        <i class="fas fa-headset"></i>
                        <div>
                            <h6>Hỗ trợ trực tiếp</h6>
                            <p>Email: support@uteshop-cpl.com</p>
                            <p>Hotline: 1900 xxxx (24/7)</p>
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
    max-width: 1200px;
    width: 100%;
    background: white;
    border-radius: 20px;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.1);
    overflow: hidden;
    min-height: 600px;
}

.brand-mini {
    color: #4f46e5;
    font-size: 24px;
    font-weight: 700;
}

.forgot-icon {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto;
    box-shadow: 0 10px 30px rgba(245, 158, 11, 0.3);
}

.forgot-icon i {
    font-size: 32px;
    color: white;
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
    border-color: #f59e0b;
    background: white;
    box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.1);
}

.verification-info {
    margin-top: 20px;
}

.info-card {
    background: #fff7ed;
    border: 2px solid #fed7aa;
    border-radius: 12px;
    padding: 16px;
    display: flex;
    align-items: center;
}

.info-icon {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: #f59e0b;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 12px;
    flex-shrink: 0;
}

.info-icon i {
    color: white;
    font-size: 16px;
}

.info-content h6 {
    color: #92400e;
    margin-bottom: 4px;
    font-weight: 600;
    font-size: 14px;
}

.info-content p {
    color: #78350f;
    font-size: 12px;
    margin: 0;
    line-height: 1.4;
}

.btn-forgot {
    background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
    color: white;
    border: none;
    padding: 14px 24px;
    border-radius: 12px;
    font-size: 16px;
    font-weight: 600;
    transition: all 0.3s ease;
}

.btn-forgot:hover {
    transform: translateY(-2px);
    box-shadow: 0 12px 28px rgba(245, 158, 11, 0.3);
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

/* Right Side - Help */
.auth-help {
    background: linear-gradient(135deg, #0f172a 0%, #1e293b 100%);
    color: white;
    padding: 60px 40px;
    display: flex;
    align-items: center;
}

.help-content {
    width: 100%;
}

.help-header {
    text-align: center;
    margin-bottom: 40px;
}

.help-header i {
    font-size: 48px;
    color: #f59e0b;
    margin-bottom: 15px;
    display: block;
}

.help-header h4 {
    font-size: 24px;
    font-weight: 700;
    color: white;
    margin-bottom: 8px;
}

.help-header p {
    color: #cbd5e1;
    margin: 0;
}

.process-steps {
    margin-bottom: 30px;
}

.process-steps h6 {
    color: #f59e0b;
    margin-bottom: 20px;
    font-weight: 600;
}

.step-item {
    display: flex;
    align-items: flex-start;
    margin-bottom: 20px;
    padding: 15px;
    background: rgba(255, 255, 255, 0.05);
    border-radius: 12px;
    border: 1px solid rgba(245, 158, 11, 0.2);
}

.step-number {
    width: 30px;
    height: 30px;
    border-radius: 50%;
    background: #f59e0b;
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    font-size: 14px;
    margin-right: 12px;
    flex-shrink: 0;
}

.step-content h6 {
    color: white;
    margin-bottom: 4px;
    font-weight: 600;
    font-size: 14px;
}

.step-content p {
    color: #cbd5e1;
    font-size: 12px;
    margin: 0;
    line-height: 1.4;
}

.faq-section {
    margin-bottom: 30px;
}

.faq-section h6 {
    color: #f59e0b;
    margin-bottom: 15px;
    font-weight: 600;
}

.faq-item {
    margin-bottom: 15px;
    padding: 12px;
    background: rgba(255, 255, 255, 0.05);
    border-radius: 8px;
}

.faq-question {
    color: white;
    font-weight: 500;
    font-size: 13px;
    margin-bottom: 5px;
}

.faq-answer {
    color: #cbd5e1;
    font-size: 12px;
    line-height: 1.4;
    padding-left: 20px;
}

.contact-support {
    margin-top: 30px;
}

.support-card {
    display: flex;
    align-items: flex-start;
    padding: 20px;
    background: rgba(245, 158, 11, 0.1);
    border: 1px solid rgba(245, 158, 11, 0.3);
    border-radius: 12px;
}

.support-card i {
    font-size: 24px;
    color: #f59e0b;
    margin-right: 15px;
    margin-top: 2px;
}

.support-card h6 {
    color: white;
    margin-bottom: 8px;
    font-weight: 600;
    font-size: 14px;
}

.support-card p {
    color: #cbd5e1;
    font-size: 12px;
    margin-bottom: 3px;
    line-height: 1.3;
}

/* Responsive */
@media (max-width: 768px) {
    .auth-wrapper {
        grid-template-columns: 1fr;
    }
    
    .auth-help {
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
    const emailInput = document.getElementById('email');
    const form = document.querySelector('.forgot-form');
    const submitBtn = document.getElementById('submitBtn');
    
    // Auto focus email input
    emailInput.focus();
    
    // Email validation
    emailInput.addEventListener('input', function() {
        const email = this.value.trim();
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        
        if (email && emailRegex.test(email)) {
            this.style.borderColor = '#10b981';
            this.style.background = '#ecfdf5';
        } else if (email) {
            this.style.borderColor = '#ef4444';
            this.style.background = '#fef2f2';
        } else {
            this.style.borderColor = '#e5e7eb';
            this.style.background = '#f9fafb';
        }
    });
    
    // Form submission
    form.addEventListener('submit', function(e) {
        const email = emailInput.value.trim();
        
        if (!email) {
            e.preventDefault();
            showAlert('danger', 'Vui lòng nhập địa chỉ email!');
            emailInput.focus();
            return;
        }
        
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            e.preventDefault();
            showAlert('danger', 'Vui lòng nhập địa chỉ email hợp lệ!');
            emailInput.focus();
            return;
        }
        
        // Show loading state
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang gửi...';
        submitBtn.disabled = true;
        
        // Re-enable after timeout (safety)
        setTimeout(() => {
            submitBtn.innerHTML = '<i class="fas fa-paper-plane me-2"></i>Gửi mã khôi phục';
            submitBtn.disabled = false;
        }, 10000);
    });
    
    // FAQ interactions
    document.querySelectorAll('.faq-question').forEach(question => {
        question.addEventListener('click', function() {
            const answer = this.nextElementSibling;
            const icon = this.querySelector('i');
            
            if (answer.style.display === 'none' || !answer.style.display) {
                answer.style.display = 'block';
                icon.className = 'fas fa-chevron-down me-2';
            } else {
                answer.style.display = 'none';
                icon.className = 'fas fa-chevron-right me-2';
            }
        });
    });
    
    // Initialize FAQ answers as hidden
    document.querySelectorAll('.faq-answer').forEach(answer => {
        answer.style.display = 'none';
    });
});

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
    const form = document.querySelector('.forgot-form');
    form.parentNode.insertBefore(alertDiv, form);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.remove();
        }
    }, 5000);
}

console.log('✅ UTESHOP-CPL Forgot Password page loaded - 2025-10-19 22:39:23');
</script>

</body>
</html>
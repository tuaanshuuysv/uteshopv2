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
                    
                    <!-- Dynamic Header based on OTP Type -->
                    <c:choose>
                        <c:when test="${otpType == 'REGISTRATION'}">
                            <div class="otp-icon registration mb-3">
                                <i class="fas fa-user-check"></i>
                            </div>
                            <h3>Xác thực tài khoản</h3>
                            <p>Vui lòng nhập mã để kích hoạt tài khoản của bạn</p>
                        </c:when>
                        <c:when test="${otpType == 'FORGOT_PASSWORD'}">
                            <div class="otp-icon password mb-3">
                                <i class="fas fa-key"></i>
                            </div>
                            <h3>Đặt lại mật khẩu</h3>
                            <p>Vui lòng nhập mã để tiếp tục đặt lại mật khẩu</p>
                        </c:when>
                        <c:otherwise>
                            <div class="otp-icon default mb-3">
                                <i class="fas fa-shield-alt"></i>
                            </div>
                            <h3>Xác thực bảo mật</h3>
                            <p>Vui lòng nhập mã xác thực để tiếp tục</p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <!-- Email Information -->
                <div class="email-info mb-4">
                    <div class="email-card">
                        <i class="fas fa-envelope me-2"></i>
                        <div>
                            <small class="text-muted">Mã xác thực đã được gửi đến:</small>
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

                <!-- OTP Form -->
                <form method="post" action="${pageContext.request.contextPath}/auth/verify-otp" class="otp-form">
                    <!-- Hidden Fields -->
                    <input type="hidden" name="email" value="${email}">
                    <input type="hidden" name="otpType" value="${otpType}">
                    
                    <!-- OTP Input Section -->
                    <div class="otp-section mb-4">
                        <label class="form-label text-center w-100 mb-3">
                            <i class="fas fa-key me-2"></i>Nhập mã xác thực (6 chữ số)
                        </label>
                        
                        <!-- OTP Input Boxes -->
                        <div class="otp-inputs">
                            <input type="text" class="otp-input" maxlength="1" data-index="0">
                            <input type="text" class="otp-input" maxlength="1" data-index="1">
                            <input type="text" class="otp-input" maxlength="1" data-index="2">
                            <input type="text" class="otp-input" maxlength="1" data-index="3">
                            <input type="text" class="otp-input" maxlength="1" data-index="4">
                            <input type="text" class="otp-input" maxlength="1" data-index="5">
                        </div>
                        
                        <!-- Hidden input for form submission -->
                        <input type="hidden" name="otpCode" id="otpCode">
                        
                        <div class="text-center mt-3">
                            <small class="text-muted">
                                <i class="fas fa-clock me-1"></i>
                                Mã có hiệu lực trong <strong>5 phút</strong>
                            </small>
                        </div>
                    </div>

                    <!-- Submit Button -->
                    <button type="submit" class="btn btn-verify w-100 mb-3" id="submitBtn" disabled>
                        <i class="fas fa-check-circle me-2"></i>Xác thực
                    </button>
                </form>

                <!-- Resend Section -->
                <div class="resend-section text-center mb-4">
                    <p class="mb-2">Không nhận được mã?</p>
                    
                    <!-- Countdown -->
                    <div class="countdown" id="countdown">
                        <small class="text-muted">
                            Có thể gửi lại sau <span id="timer" class="fw-bold text-primary">60</span> giây
                        </small>
                    </div>
                    
                    <!-- Resend Button -->
                    <button class="btn btn-outline-primary btn-sm" id="resendBtn" onclick="resendOtp()" style="display: none;">
                        <i class="fas fa-paper-plane me-1"></i>Gửi lại mã
                    </button>
                </div>

                <!-- Action Links -->
                <div class="action-links">
                    <div class="row">
                        <div class="col-6">
                            <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-outline-secondary w-100 btn-sm">
                                <i class="fas fa-arrow-left me-1"></i>Về đăng nhập
                            </a>
                        </div>
                        <div class="col-6">
                            <c:choose>
                                <c:when test="${otpType == 'REGISTRATION'}">
                                    <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-outline-info w-100 btn-sm">
                                        <i class="fas fa-user-plus me-1"></i>Đăng ký lại
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/auth/forgot-password" class="btn btn-outline-warning w-100 btn-sm">
                                        <i class="fas fa-key me-1"></i>Thử lại
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Footer -->
                <div class="text-center mt-4">
                    <small class="text-muted">
                        © 2025 UTESHOP-CPL by <strong>tuaanshuuysv</strong><br>
                        <i class="fas fa-shield-alt me-1"></i>Mã OTP chỉ có hiệu lực trong 5 phút
                    </small>
                </div>
            </div>
        </div>

        <!-- Right Side - Instructions -->
        <div class="auth-instructions">
            <div class="instructions-content">
                <div class="instruction-header">
                    <i class="fas fa-info-circle"></i>
                    <h4>Hướng dẫn xác thực</h4>
                </div>

                <div class="instruction-steps">
                    <div class="step-item">
                        <div class="step-number">1</div>
                        <div class="step-content">
                            <h6>Kiểm tra email</h6>
                            <p>Mở hộp thư email và tìm email từ UTESHOP-CPL</p>
                        </div>
                    </div>

                    <div class="step-item">
                        <div class="step-number">2</div>
                        <div class="step-content">
                            <h6>Sao chép mã OTP</h6>
                            <p>Sao chép mã 6 chữ số trong email</p>
                        </div>
                    </div>

                    <div class="step-item">
                        <div class="step-number">3</div>
                        <div class="step-content">
                            <h6>Nhập mã xác thực</h6>
                            <p>Nhập từng chữ số vào các ô và nhấn "Xác thực"</p>
                        </div>
                    </div>
                </div>

                <!-- Tips -->
                <div class="tips-section">
                    <h6><i class="fas fa-lightbulb me-2"></i>Mẹo hữu ích</h6>
                    <ul class="tips-list">
                        <li><i class="fas fa-check me-1"></i>Kiểm tra thư mục spam nếu không thấy email</li>
                        <li><i class="fas fa-check me-1"></i>Mã OTP có hiệu lực trong 5 phút</li>
                        <li><i class="fas fa-check me-1"></i>Có thể gửi lại mã sau 60 giây</li>
                        <li><i class="fas fa-check me-1"></i>Mỗi mã chỉ sử dụng được 1 lần</li>
                    </ul>
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

.otp-icon {
    width: 80px;
    height: 80px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto;
    box-shadow: 0 10px 30px rgba(79, 70, 229, 0.3);
}

.otp-icon.registration {
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
}

.otp-icon.password {
    background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
}

.otp-icon.default {
    background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
}

.otp-icon i {
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

.email-card {
    background: #f0f9ff;
    border: 2px solid #e0f2fe;
    border-radius: 12px;
    padding: 16px 20px;
    display: flex;
    align-items: center;
    max-width: 100%;
}

.email-card i {
    color: #0284c7;
    font-size: 20px;
}

/* OTP Input Styles */
.otp-inputs {
    display: flex;
    justify-content: center;
    gap: 12px;
    margin-bottom: 20px;
}

.otp-input {
    width: 50px;
    height: 60px;
    border: 3px solid #e5e7eb;
    border-radius: 12px;
    text-align: center;
    font-size: 24px;
    font-weight: 700;
    color: #1f2937;
    background: #f9fafb;
    transition: all 0.3s ease;
}

.otp-input:focus {
    outline: none;
    border-color: #4f46e5;
    background: white;
    box-shadow: 0 0 0 3px rgba(79, 70, 229, 0.1);
    transform: translateY(-2px);
}

.otp-input.filled {
    border-color: #10b981;
    background: #ecfdf5;
    color: #065f46;
}

.otp-input.error {
    border-color: #ef4444;
    background: #fef2f2;
    animation: shake 0.5s ease-in-out;
}

@keyframes shake {
    0%, 100% { transform: translateX(0); }
    25% { transform: translateX(-5px); }
    75% { transform: translateX(5px); }
}

/* Buttons */
.btn-verify {
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    color: white;
    border: none;
    padding: 14px 24px;
    border-radius: 12px;
    font-size: 16px;
    font-weight: 600;
    transition: all 0.3s ease;
}

.btn-verify:hover:not(:disabled) {
    transform: translateY(-2px);
    box-shadow: 0 12px 28px rgba(16, 185, 129, 0.3);
    color: white;
}

.btn-verify:disabled {
    background: #9ca3af;
    cursor: not-allowed;
    transform: none;
    box-shadow: none;
}

/* Countdown */
.countdown {
    padding: 8px 16px;
    background: #f0f9ff;
    border-radius: 8px;
    display: inline-block;
}

#timer {
    color: #0284c7;
    font-weight: 700;
    font-size: 16px;
}

/* Right Side - Instructions */
.auth-instructions {
    background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
    padding: 50px 40px;
    display: flex;
    align-items: center;
}

.instructions-content {
    width: 100%;
}

.instruction-header {
    text-align: center;
    margin-bottom: 30px;
}

.instruction-header i {
    font-size: 48px;
    color: #4f46e5;
    margin-bottom: 15px;
    display: block;
}

.instruction-header h4 {
    font-size: 24px;
    font-weight: 700;
    color: #1f2937;
    margin: 0;
}

.step-item {
    display: flex;
    align-items: flex-start;
    margin-bottom: 25px;
    padding: 15px;
    background: white;
    border-radius: 12px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
}

.step-number {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    margin-right: 15px;
    flex-shrink: 0;
}

.step-content h6 {
    font-size: 16px;
    font-weight: 600;
    color: #1f2937;
    margin-bottom: 5px;
}

.step-content p {
    font-size: 14px;
    color: #6b7280;
    margin: 0;
    line-height: 1.5;
}

.tips-section {
    background: #fffbeb;
    border: 1px solid #fbbf24;
    border-radius: 12px;
    padding: 20px;
}

.tips-section h6 {
    color: #92400e;
    margin-bottom: 15px;
    font-weight: 600;
}

.tips-list {
    list-style: none;
    padding: 0;
    margin: 0;
}

.tips-list li {
    color: #78350f;
    margin-bottom: 8px;
    font-size: 14px;
}

.tips-list i {
    color: #f59e0b;
    margin-right: 8px;
}

/* Responsive */
@media (max-width: 768px) {
    .auth-wrapper {
        grid-template-columns: 1fr;
    }
    
    .auth-instructions {
        display: none;
    }
    
    .otp-inputs {
        gap: 8px;
    }
    
    .otp-input {
        width: 45px;
        height: 55px;
        font-size: 20px;
    }
}

@media (max-width: 480px) {
    .auth-form-container {
        padding: 30px 20px;
    }
    
    .otp-input {
        width: 40px;
        height: 50px;
        font-size: 18px;
    }
}
</style>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
// OTP Input Management
document.addEventListener('DOMContentLoaded', function() {
    const otpInputs = document.querySelectorAll('.otp-input');
    const submitBtn = document.getElementById('submitBtn');
    const otpCodeInput = document.getElementById('otpCode');
    
    // Focus first input
    otpInputs[0].focus();
    
    // Start countdown
    startCountdown();
    
    // OTP Input Events
    otpInputs.forEach((input, index) => {
        input.addEventListener('input', function(e) {
            const value = e.target.value.replace(/[^0-9]/g, '');
            e.target.value = value;
            
            if (value) {
                e.target.classList.add('filled');
                
                // Move to next input
                if (index < otpInputs.length - 1) {
                    otpInputs[index + 1].focus();
                }
            } else {
                e.target.classList.remove('filled');
            }
            
            updateOtpCode();
            checkFormCompletion();
        });
        
        input.addEventListener('keydown', function(e) {
            // Backspace handling
            if (e.key === 'Backspace' && !e.target.value && index > 0) {
                otpInputs[index - 1].focus();
                otpInputs[index - 1].value = '';
                otpInputs[index - 1].classList.remove('filled');
                updateOtpCode();
                checkFormCompletion();
            }
            
            // Arrow key navigation
            if (e.key === 'ArrowLeft' && index > 0) {
                otpInputs[index - 1].focus();
            }
            if (e.key === 'ArrowRight' && index < otpInputs.length - 1) {
                otpInputs[index + 1].focus();
            }
            
            // Enter to submit if complete
            if (e.key === 'Enter' && isOtpComplete()) {
                document.querySelector('.otp-form').submit();
            }
        });
        
        input.addEventListener('paste', function(e) {
            e.preventDefault();
            const pastedData = e.clipboardData.getData('text').replace(/[^0-9]/g, '');
            
            if (pastedData.length <= 6) {
                for (let i = 0; i < pastedData.length && (index + i) < otpInputs.length; i++) {
                    otpInputs[index + i].value = pastedData[i];
                    otpInputs[index + i].classList.add('filled');
                }
                
                // Focus next empty input or last input
                const nextEmpty = index + pastedData.length;
                if (nextEmpty < otpInputs.length) {
                    otpInputs[nextEmpty].focus();
                } else {
                    otpInputs[otpInputs.length - 1].focus();
                }
                
                updateOtpCode();
                checkFormCompletion();
            }
        });
    });
    
    function updateOtpCode() {
        const code = Array.from(otpInputs).map(input => input.value).join('');
        otpCodeInput.value = code;
    }
    
    function isOtpComplete() {
        return Array.from(otpInputs).every(input => input.value.length === 1);
    }
    
    function checkFormCompletion() {
        if (isOtpComplete()) {
            submitBtn.disabled = false;
            submitBtn.classList.add('btn-ready');
        } else {
            submitBtn.disabled = true;
            submitBtn.classList.remove('btn-ready');
        }
    }
    
    // Form submission
    document.querySelector('.otp-form').addEventListener('submit', function(e) {
        if (!isOtpComplete()) {
            e.preventDefault();
            showError('Vui lòng nhập đầy đủ 6 chữ số!');
            return;
        }
        
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang xác thực...';
        submitBtn.disabled = true;
    });
});

// Countdown Timer
let countdownInterval;

function startCountdown() {
    let timeLeft = 60;
    const timer = document.getElementById('timer');
    const countdown = document.getElementById('countdown');
    const resendBtn = document.getElementById('resendBtn');
    
    countdownInterval = setInterval(function() {
        timeLeft--;
        timer.textContent = timeLeft;
        
        if (timeLeft <= 0) {
            clearInterval(countdownInterval);
            countdown.style.display = 'none';
            resendBtn.style.display = 'inline-block';
        }
    }, 1000);
}

// Resend OTP
function resendOtp() {
    const resendBtn = document.getElementById('resendBtn');
    const countdown = document.getElementById('countdown');
    
    resendBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang gửi...';
    resendBtn.disabled = true;
    
    // Simulate API call
    setTimeout(() => {
        showSuccess('Mã OTP mới đã được gửi đến email của bạn!');
        
        // Clear current OTP
        document.querySelectorAll('.otp-input').forEach(input => {
            input.value = '';
            input.classList.remove('filled');
        });
        document.getElementById('otpCode').value = '';
        document.getElementById('submitBtn').disabled = true;
        document.querySelectorAll('.otp-input')[0].focus();
        
        // Restart countdown
        resendBtn.style.display = 'none';
        countdown.style.display = 'inline-block';
        startCountdown();
        
        resendBtn.innerHTML = '<i class="fas fa-paper-plane me-1"></i>Gửi lại mã';
        resendBtn.disabled = false;
    }, 2000);
}

// Utility functions
function showSuccess(message) {
    showAlert('success', message);
}

function showError(message) {
    showAlert('danger', message);
    
    // Add error animation to inputs
    document.querySelectorAll('.otp-input').forEach(input => {
        input.classList.add('error');
        setTimeout(() => input.classList.remove('error'), 500);
    });
}

function showAlert(type, message) {
    // Remove existing alerts
    const existingAlerts = document.querySelectorAll('.alert:not(.countdown)');
    existingAlerts.forEach(alert => alert.remove());
    
    // Create new alert
    const alertDiv = document.createElement('div');
    alertDiv.className = 'alert alert-' + type + ' alert-dismissible fade show';
    
    const iconClass = type === 'success' ? 'check-circle' : 'exclamation-triangle';
    alertDiv.innerHTML = '<i class="fas fa-' + iconClass + ' me-2"></i>' + message + 
                        '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
    
    // Insert before form
    const form = document.querySelector('.otp-form');
    form.parentNode.insertBefore(alertDiv, form);
    
    // Auto remove after 5 seconds
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.remove();
        }
    }, 5000);
}

console.log('✅ UTESHOP-CPL OTP Verification page loaded - 2025-10-19 22:33:19');
console.log('📧 Email: ' + '${email}');
console.log('🔑 OTP Type: ' + '${otpType}');
</script>

</body>
</html>
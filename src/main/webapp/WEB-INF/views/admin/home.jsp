<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- UTESHOP-CPL - Fixed Admin Dashboard Home -->
<!-- Fixed: 2025-10-22 04:17:30 UTC by tuaanshuuysv -->
<!-- Added: Correct links to UserManagementController -->

<div class="admin-dashboard">
    
    <!-- Welcome Header -->
    <section class="admin-welcome">
        <div class="container">
            <div class="welcome-card">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1>
                            <i class="fas fa-crown text-warning"></i>
                            Chào mừng Quản trị viên, <span class="text-warning">${authUser.fullName}</span>!
                        </h1>
                        <p class="lead">Quản lý toàn bộ hệ thống UTESHOP-CPL</p>
                        <div class="admin-info">
                            <span class="badge bg-danger me-2">
                                <i class="fas fa-shield-alt"></i> Super Admin
                            </span>
                            <span class="badge bg-success">
                                <i class="fas fa-clock"></i> Đăng nhập: ${serverTime}
                            </span>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="system-status text-end">
                            <div class="status-item">
                                <span class="badge bg-success">
                                    <i class="fas fa-database"></i> Database kết nối
                                </span>
                            </div>
                            <div class="status-item">
                                <span class="badge bg-info">
                                    <i class="fas fa-server"></i> Server: ${systemStatus}
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- System Overview -->
    <section class="admin-overview">
        <div class="container">
            <h3><i class="fas fa-chart-line"></i> Tổng quan hệ thống</h3>
            <div class="row">
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="overview-card">
                        <div class="overview-icon bg-primary">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="overview-content">
                            <h3>${totalUsers}</h3>
                            <p>Tổng người dùng</p>
                            <span class="trend positive">${usersTrend} tháng này</span>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="overview-card">
                        <div class="overview-icon bg-info">
                            <i class="fas fa-store"></i>
                        </div>
                        <div class="overview-content">
                            <h3>${totalShops}</h3>
                            <p>Tổng shop</p>
                            <span class="trend positive">${shopsTrend} tháng này</span>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="overview-card">
                        <div class="overview-icon bg-success">
                            <i class="fas fa-cube"></i>
                        </div>
                        <div class="overview-content">
                            <h3>${totalProducts}</h3>
                            <p>Tổng sản phẩm</p>
                            <span class="trend positive">${productsTrend} tháng này</span>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="overview-card">
                        <div class="overview-icon bg-warning">
                            <i class="fas fa-chart-bar"></i>
                        </div>
                        <div class="overview-content">
                            <h3>${monthlyRevenue}</h3>
                            <p>Doanh thu tháng</p>
                            <span class="trend positive">${revenueTrend} tháng này</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Quick Actions -->
    <section class="admin-actions">
        <div class="container">
            <h3><i class="fas fa-bolt"></i> Quản lý nhanh</h3>
            <div class="row">
                
                <!-- ✅ FIX: QUẢN LÝ NGƯỜI DÙNG - LINK ĐÚNG -->
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="admin-action-card">
                        <div class="action-header bg-primary">
                            <i class="fas fa-users"></i>
                            <h5>Quản lý người dùng</h5>
                        </div>
                        <div class="action-body">
                            <p>Tìm kiếm và quản lý tài khoản người dùng</p>
                            <div class="action-buttons">
                                <!-- ✅ LINK CHÍNH XÁC ĐẾN USERMANAGEMENTCONTROLLER -->
                                <a href="${pageContext.request.contextPath}/admin-direct/users" class="btn btn-primary btn-sm">
                                    <i class="fas fa-list"></i> Tìm kiếm User
                                </a>
                                <a href="${pageContext.request.contextPath}/admin-direct/users/add" class="btn btn-outline-primary btn-sm">
                                    <i class="fas fa-plus"></i> Thêm User
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- QUẢN LÝ SHOP -->
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="admin-action-card">
                        <div class="action-header bg-info">
                            <i class="fas fa-store"></i>
                            <h5>Quản lý Shop</h5>
                        </div>
                        <div class="action-body">
                            <p>Quản lý và duyệt cửa hàng</p>
                            <div class="action-buttons">
                                <button class="btn btn-info btn-sm">
                                    <i class="fas fa-list"></i> Danh sách Shop
                                </button>
                                <button class="btn btn-outline-info btn-sm">
                                    <i class="fas fa-clock"></i> Chờ duyệt (${pendingShops})
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- QUẢN LÝ SẢN PHẨM -->
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="admin-action-card">
                        <div class="action-header bg-success">
                            <i class="fas fa-cube"></i>
                            <h5>Quản lý sản phẩm</h5>
                        </div>
                        <div class="action-body">
                            <p>Kiểm duyệt và quản lý sản phẩm</p>
                            <div class="action-buttons">
                                <button class="btn btn-success btn-sm">
                                    <i class="fas fa-cube"></i> Tất cả sản phẩm
                                </button>
                                <button class="btn btn-outline-danger btn-sm">
                                    <i class="fas fa-flag"></i> Báo cáo (${reportedProducts})
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- QUẢN LÝ DANH MỤC -->
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="admin-action-card">
                        <div class="action-header bg-warning">
                            <i class="fas fa-tags"></i>
                            <h5>Quản lý danh mục</h5>
                        </div>
                        <div class="action-body">
                            <p>Tạo và quản lý danh mục sản phẩm</p>
                            <div class="action-buttons">
                                <button class="btn btn-warning btn-sm">
                                    <i class="fas fa-list"></i> Danh mục
                                </button>
                                <button class="btn btn-outline-warning btn-sm">
                                    <i class="fas fa-plus"></i> Thêm mới
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- CHIẾT KHẤU & KHUYẾN MÃI -->
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="admin-action-card">
                        <div class="action-header bg-danger">
                            <i class="fas fa-percentage"></i>
                            <h5>Chiết khấu & Khuyến mãi</h5>
                        </div>
                        <div class="action-body">
                            <p>Quản lý chiết khấu app và khuyến mãi</p>
                            <div class="action-buttons">
                                <button class="btn btn-danger btn-sm">
                                    <i class="fas fa-percent"></i> Chiết khấu
                                </button>
                                <button class="btn btn-outline-danger btn-sm">
                                    <i class="fas fa-fire"></i> Khuyến mãi
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- NHÀ VẬN CHUYỂN -->
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="admin-action-card">
                        <div class="action-header bg-secondary">
                            <i class="fas fa-truck"></i>
                            <h5>Nhà vận chuyển</h5>
                        </div>
                        <div class="action-body">
                            <p>Quản lý đối tác vận chuyển và phí ship</p>
                            <div class="action-buttons">
                                <button class="btn btn-secondary btn-sm">
                                    <i class="fas fa-truck"></i> Đối tác ship
                                </button>
                                <button class="btn btn-outline-secondary btn-sm">
                                    <i class="fas fa-dollar-sign"></i> Phí ship
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Recent Activities & System Alerts -->
    <section class="admin-notifications">
        <div class="container">
            <div class="row">
                <div class="col-lg-8">
                    <h3><i class="fas fa-history"></i> Hoạt động gần đây</h3>
                    <div class="notification-list">
                        <div class="notification-item">
                            <i class="fas fa-user-plus text-primary"></i>
                            <div class="notification-content">
                                <p><strong>Người dùng mới đăng ký:</strong> nguyenvana@example.com</p>
                                <small class="text-muted">5 phút trước</small>
                            </div>
                        </div>
                        <div class="notification-item">
                            <i class="fas fa-store text-info"></i>
                            <div class="notification-content">
                                <p><strong>Shop mới chờ duyệt:</strong> Cửa hàng ABC</p>
                                <small class="text-muted">15 phút trước</small>
                            </div>
                        </div>
                        <div class="notification-item">
                            <i class="fas fa-flag text-danger"></i>
                            <div class="notification-content">
                                <p><strong>Sản phẩm bị báo cáo:</strong> iPhone 15 Pro Max</p>
                                <small class="text-muted">30 phút trước</small>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-lg-4">
                    <h3><i class="fas fa-exclamation-triangle"></i> Cần xử lý</h3>
                    <div class="alert-list">
                        <div class="alert alert-warning">
                            <i class="fas fa-clock"></i>
                            <strong>${pendingShops}</strong> shop chờ duyệt
                        </div>
                        <div class="alert alert-danger">
                            <i class="fas fa-flag"></i>
                            <strong>${reportedProducts}</strong> sản phẩm vi phạm
                        </div>
                        <div class="alert alert-info">
                            <i class="fas fa-question-circle"></i>
                            <strong>${supportTickets}</strong> ticket hỗ trợ
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<style>
/* Admin Dashboard Styles */
.admin-dashboard {
    background: #f8fafc;
    min-height: calc(100vh - 120px);
    padding: 20px 0;
}

/* Welcome Section */
.admin-welcome {
    margin-bottom: 30px;
}

.welcome-card {
    background: linear-gradient(135deg, #dc2626, #b91c1c);
    color: white;
    border-radius: 15px;
    padding: 30px;
}

.welcome-card h1 {
    font-size: 1.8rem;
    margin-bottom: 15px;
}

.admin-info {
    margin-top: 20px;
}

.system-status {
    text-align: right;
}

.status-item {
    display: flex;
    align-items: center;
    justify-content: flex-end;
    gap: 8px;
    margin-bottom: 8px;
}

/* Overview Cards */
.admin-overview {
    margin-bottom: 30px;
}

.admin-overview h3 {
    margin-bottom: 20px;
    color: #1f2937;
}

.overview-card {
    background: white;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    border: 1px solid #e5e7eb;
    display: flex;
    align-items: center;
    gap: 15px;
    transition: transform 0.3s ease;
}

.overview-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 4px 20px rgba(0,0,0,0.15);
}

.overview-icon {
    width: 50px;
    height: 50px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 1.2rem;
}

.overview-content h3 {
    margin-bottom: 5px;
    color: #1f2937;
    font-size: 1.5rem;
    font-weight: bold;
}

.overview-content p {
    margin-bottom: 5px;
    color: #6b7280;
    font-size: 0.9rem;
}

.trend {
    font-size: 0.8rem;
    padding: 2px 8px;
    border-radius: 12px;
}

.trend.positive {
    background: #dcfce7;
    color: #16a34a;
}

/* Admin Actions */
.admin-actions {
    margin-bottom: 30px;
}

.admin-actions h3 {
    margin-bottom: 20px;
    color: #1f2937;
}

.admin-action-card {
    background: white;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    transition: transform 0.3s ease;
    height: 100%;
}

.admin-action-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 4px 20px rgba(0,0,0,0.15);
}

.action-header {
    padding: 20px;
    color: white;
    text-align: center;
}

.action-header i {
    font-size: 2rem;
    margin-bottom: 10px;
    display: block;
}

.action-header h5 {
    margin: 0;
    font-weight: 600;
}

.action-body {
    padding: 20px;
    text-align: center;
}

.action-body p {
    color: #6b7280;
    margin-bottom: 15px;
    font-size: 0.9rem;
}

.action-buttons {
    display: flex;
    gap: 8px;
    justify-content: center;
    flex-wrap: wrap;
}

.action-buttons .btn {
    font-size: 0.8rem;
    padding: 6px 12px;
}

/* Notifications */
.admin-notifications {
    margin-bottom: 30px;
}

.admin-notifications h3 {
    margin-bottom: 20px;
    color: #1f2937;
}

.notification-list {
    background: white;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.notification-item {
    display: flex;
    align-items: center;
    gap: 15px;
    padding: 15px 0;
    border-bottom: 1px solid #f3f4f6;
}

.notification-item:last-child {
    border-bottom: none;
}

.notification-item i {
    font-size: 1.2rem;
}

.notification-content {
    flex: 1;
}

.notification-content p {
    margin: 0;
    font-size: 0.9rem;
}

.alert-list {
    display: flex;
    flex-direction: column;
    gap: 10px;
}

.alert-list .alert {
    margin: 0;
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 0.9rem;
}

/* Responsive */
@media (max-width: 768px) {
    .welcome-card {
        text-align: center;
    }
    
    .system-status {
        text-align: center;
        margin-top: 20px;
    }
    
    .overview-card {
        flex-direction: column;
        text-align: center;
        gap: 10px;
    }
    
    .action-buttons {
        flex-direction: column;
    }
    
    .action-buttons .btn {
        width: 100%;
    }
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    console.log('✅ FIXED Admin Dashboard loaded - 2025-10-22 04:17:30 UTC');
    console.log('🕐 Load time: 2025-10-21 03:34:17 UTC');
    console.log('👨‍💻 Fixed by: tuaanshuuysv');
    console.log('👑 Admin: ${authUser.username}');
    console.log('🔗 Added correct links to UserManagementController');
    
    // Add click handlers for admin action cards
    document.querySelectorAll('.admin-action-card').forEach(card => {
        const actionButtons = card.querySelectorAll('.action-buttons .btn');
        
        // Skip cards that have actual links
        if (actionButtons.length > 0 && actionButtons[0].tagName.toLowerCase() === 'a') {
            console.log('✅ Card has real links, skipping click handler');
            return;
        }
        
        card.addEventListener('click', function() {
            const actionName = this.querySelector('h5').textContent;
            console.log('Admin action clicked:', actionName);
            
            // Show feedback
            const buttons = this.querySelectorAll('.btn');
            buttons.forEach(btn => {
                const originalText = btn.innerHTML;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tải...';
                
                setTimeout(() => {
                    btn.innerHTML = originalText;
                }, 1500);
            });
        });
    });
    
    // Notification item clicks
    document.querySelectorAll('.notification-item').forEach(item => {
        item.addEventListener('click', function() {
            console.log('Notification clicked:', this.querySelector('p').textContent);
        });
    });
    
    // Alert clicks
    document.querySelectorAll('.alert-list .alert').forEach(alert => {
        alert.addEventListener('click', function() {
            console.log('Alert clicked:', this.textContent.trim());
        });
    });
});
</script>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- UTESHOP-CPL - Admin Dashboard Home -->
<!-- Created: 2025-10-21 03:29:03 UTC by tuaanshuuysv -->

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
                            <span class="text-muted">
                                <i class="fas fa-clock"></i> Đăng nhập: ${serverTime}
                            </span>
                        </div>
                    </div>
                    <div class="col-md-4 text-end">
                        <div class="system-status">
                            <div class="status-item">
                                <span class="status-indicator online"></span>
                                <span>Hệ thống hoạt động</span>
                            </div>
                            <div class="status-item">
                                <span class="status-indicator online"></span>
                                <span>Database kết nối</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- System Overview -->
    <section class="system-overview">
        <div class="container">
            <h3><i class="fas fa-tachometer-alt"></i> Tổng quan hệ thống</h3>
            <div class="row">
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="overview-card">
                        <div class="overview-icon bg-primary">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="overview-content">
                            <h3>${totalUsers}</h3>
                            <p>Tổng người dùng</p>
                            <small class="text-success">${usersTrend} tháng này</small>
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
                            <small class="text-success">${shopsTrend} tháng này</small>
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
                            <small class="text-success">${productsTrend} tháng này</small>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="overview-card">
                        <div class="overview-icon bg-warning">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <div class="overview-content">
                            <h3>${monthlyRevenue}</h3>
                            <p>Doanh thu tháng</p>
                            <small class="text-success">${revenueTrend} tháng này</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Admin Quick Actions -->
    <section class="admin-actions">
        <div class="container">
            <h3><i class="fas fa-tools"></i> Quản lý nhanh</h3>
            <div class="row">
                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="admin-action-card">
                        <div class="action-header bg-primary">
                            <i class="fas fa-users-cog"></i>
                            <h5>Quản lý người dùng</h5>
                        </div>
                        <div class="action-body">
                            <p>Tìm kiếm và quản lý tài khoản người dùng</p>
                            <div class="action-buttons">
                                <button class="btn btn-primary btn-sm">
                                    <i class="fas fa-search"></i> Tìm kiếm User
                                </button>
                                <button class="btn btn-outline-primary btn-sm">
                                    <i class="fas fa-plus"></i> Thêm User
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="admin-action-card">
                        <div class="action-header bg-info">
                            <i class="fas fa-store-alt"></i>
                            <h5>Quản lý Shop</h5>
                        </div>
                        <div class="action-body">
                            <p>Quản lý và duyệt các cửa hàng</p>
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

                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="admin-action-card">
                        <div class="action-header bg-success">
                            <i class="fas fa-boxes"></i>
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

                <div class="col-lg-4 col-md-6 mb-4">
                    <div class="admin-action-card">
                        <div class="action-header bg-secondary">
                            <i class="fas fa-shipping-fast"></i>
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

    <!-- Notifications & System Status -->
    <section class="admin-notifications">
        <div class="container">
            <div class="row">
                <div class="col-lg-8">
                    <div class="card">
                        <div class="card-header">
                            <h4><i class="fas fa-history"></i> Hoạt động gần đây</h4>
                        </div>
                        <div class="card-body">
                            <div class="activity-list">
                                <div class="activity-item">
                                    <div class="activity-icon bg-success">
                                        <i class="fas fa-check"></i>
                                    </div>
                                    <div class="activity-content">
                                        <h6>Shop "TechStore VN" đã được duyệt</h6>
                                        <p class="text-muted">Shop bán thiết bị điện tử đã hoàn thành xác thực</p>
                                        <small class="text-muted">15 phút trước</small>
                                    </div>
                                </div>

                                <div class="activity-item">
                                    <div class="activity-icon bg-warning">
                                        <i class="fas fa-flag"></i>
                                    </div>
                                    <div class="activity-content">
                                        <h6>Báo cáo sản phẩm vi phạm</h6>
                                        <p class="text-muted">Sản phẩm "iPhone fake" bị báo cáo vi phạm bản quyền</p>
                                        <small class="text-muted">1 giờ trước</small>
                                    </div>
                                </div>

                                <div class="activity-item">
                                    <div class="activity-icon bg-info">
                                        <i class="fas fa-users"></i>
                                    </div>
                                    <div class="activity-content">
                                        <h6>Đăng ký tài khoản mới</h6>
                                        <p class="text-muted">234 tài khoản mới được đăng ký trong 24h qua</p>
                                        <small class="text-muted">2 giờ trước</small>
                                    </div>
                                </div>

                                <div class="activity-item">
                                    <div class="activity-icon bg-primary">
                                        <i class="fas fa-shipping-fast"></i>
                                    </div>
                                    <div class="activity-content">
                                        <h6>Cập nhật phí vận chuyển</h6>
                                        <p class="text-muted">Đối tác GHN cập nhật bảng giá mới</p>
                                        <small class="text-muted">3 giờ trước</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="card">
                        <div class="card-header">
                            <h4><i class="fas fa-bell"></i> Cần xử lý</h4>
                        </div>
                        <div class="card-body">
                            <div class="notification-list">
                                <div class="notification-item priority-high">
                                    <div class="notif-icon bg-danger">
                                        <i class="fas fa-exclamation-triangle"></i>
                                    </div>
                                    <div class="notif-content">
                                        <h6>${pendingShops} shop chờ duyệt</h6>
                                        <small>Cần xác thực thông tin</small>
                                    </div>
                                </div>

                                <div class="notification-item priority-medium">
                                    <div class="notif-icon bg-warning">
                                        <i class="fas fa-flag"></i>
                                    </div>
                                    <div class="notif-content">
                                        <h6>${reportedProducts} báo cáo sản phẩm</h6>
                                        <small>Cần kiểm duyệt nội dung</small>
                                    </div>
                                </div>

                                <div class="notification-item priority-low">
                                    <div class="notif-icon bg-info">
                                        <i class="fas fa-question-circle"></i>
                                    </div>
                                    <div class="notif-content">
                                        <h6>${supportTickets} ticket hỗ trợ</h6>
                                        <small>Khách hàng cần trợ giúp</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card mt-4">
                        <div class="card-header">
                            <h4><i class="fas fa-server"></i> Hệ thống</h4>
                        </div>
                        <div class="card-body">
                            <div class="system-metrics">
                                <div class="metric-item">
                                    <span class="metric-label">CPU Usage</span>
                                    <div class="metric-value">
                                        <div class="progress">
                                            <div class="progress-bar bg-success" style="width: ${cpuUsage}%"></div>
                                        </div>
                                        <span>${cpuUsage}%</span>
                                    </div>
                                </div>

                                <div class="metric-item">
                                    <span class="metric-label">Memory</span>
                                    <div class="metric-value">
                                        <div class="progress">
                                            <div class="progress-bar bg-warning" style="width: ${memoryUsage}%"></div>
                                        </div>
                                        <span>${memoryUsage}%</span>
                                    </div>
                                </div>

                                <div class="metric-item">
                                    <span class="metric-label">Storage</span>
                                    <div class="metric-value">
                                        <div class="progress">
                                            <div class="progress-bar bg-info" style="width: ${storageUsage}%"></div>
                                        </div>
                                        <span>${storageUsage}%</span>
                                    </div>
                                </div>
                            </div>
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
    font-size: 0.9rem;
}

.status-indicator {
    width: 8px;
    height: 8px;
    border-radius: 50%;
}

.status-indicator.online {
    background: #10b981;
    box-shadow: 0 0 8px rgba(16, 185, 129, 0.5);
}

/* System Overview */
.system-overview {
    margin-bottom: 30px;
}

.system-overview h3 {
    margin-bottom: 20px;
    color: #1f2937;
}

.overview-card {
    background: white;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    display: flex;
    align-items: center;
    gap: 15px;
    transition: transform 0.3s ease;
}

.overview-card:hover {
    transform: translateY(-3px);
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
    transform: translateY(-5px);
}

.action-header {
    padding: 20px;
    color: white;
    text-align: center;
}

.action-header i {
    font-size: 1.8rem;
    margin-bottom: 10px;
    display: block;
}

.action-header h5 {
    margin: 0;
    font-weight: 600;
    font-size: 1rem;
}

.action-body {
    padding: 20px;
}

.action-body p {
    color: #6b7280;
    margin-bottom: 15px;
    font-size: 0.9rem;
}

.action-buttons {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
}

.action-buttons .btn {
    flex: 1;
    font-size: 0.8rem;
    padding: 8px 12px;
}

/* Cards */
.card {
    border: none;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    border-radius: 12px;
    margin-bottom: 20px;
}

.card-header {
    background: white;
    border-bottom: 1px solid #e5e7eb;
    padding: 15px 20px;
    border-radius: 12px 12px 0 0;
}

.card-header h4 {
    margin: 0;
    color: #1f2937;
    font-size: 1.1rem;
}

/* Activity List */
.activity-list {
    max-height: 400px;
    overflow-y: auto;
}

.activity-item {
    display: flex;
    gap: 15px;
    padding: 15px 0;
    border-bottom: 1px solid #f3f4f6;
}

.activity-item:last-child {
    border-bottom: none;
}

.activity-icon {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 0.9rem;
    flex-shrink: 0;
}

.activity-content h6 {
    margin-bottom: 5px;
    color: #1f2937;
    font-weight: 600;
    font-size: 0.9rem;
}

.activity-content p {
    margin-bottom: 5px;
    color: #6b7280;
    font-size: 0.8rem;
}

/* Notifications */
.notification-list {
    max-height: 300px;
    overflow-y: auto;
}

.notification-item {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 12px;
    background: #f8fafc;
    border-radius: 8px;
    margin-bottom: 10px;
    transition: all 0.3s ease;
    cursor: pointer;
}

.notification-item:hover {
    background: #e5e7eb;
}

.notification-item.priority-high {
    border-left: 3px solid #dc2626;
}

.notification-item.priority-medium {
    border-left: 3px solid #f59e0b;
}

.notification-item.priority-low {
    border-left: 3px solid #10b981;
}

.notif-icon {
    width: 32px;
    height: 32px;
    border-radius: 6px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 0.8rem;
}

.notif-content h6 {
    margin-bottom: 2px;
    color: #1f2937;
    font-weight: 600;
    font-size: 0.8rem;
}

.notif-content small {
    color: #6b7280;
    font-size: 0.7rem;
}

/* System Metrics */
.system-metrics {
    space-y: 15px;
}

.metric-item {
    margin-bottom: 15px;
}

.metric-label {
    display: block;
    font-size: 0.8rem;
    color: #6b7280;
    margin-bottom: 6px;
}

.metric-value {
    display: flex;
    align-items: center;
    gap: 8px;
}

.metric-value .progress {
    flex: 1;
    height: 6px;
    border-radius: 3px;
}

.metric-value span {
    font-size: 0.7rem;
    color: #1f2937;
    font-weight: 600;
    min-width: 30px;
}

/* Responsive */
@media (max-width: 768px) {
    .welcome-card h1 {
        font-size: 1.4rem;
    }
    
    .system-status {
        text-align: left;
        margin-top: 15px;
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
        flex: none;
    }
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    console.log('✅ UTESHOP-CPL Admin Dashboard loaded');
    console.log('🕐 Load time: 2025-10-21 03:34:17 UTC');
    console.log('👨‍💻 Created by: tuaanshuuysv');
    console.log('👑 Admin: ${authUser.username}');
    
    // Add click handlers for admin action cards
    document.querySelectorAll('.admin-action-card').forEach(card => {
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
            const title = this.querySelector('h6').textContent;
            console.log('Notification clicked:', title);
            
            // Visual feedback
            this.style.background = '#dbeafe';
            setTimeout(() => {
                this.style.background = '#f8fafc';
            }, 1000);
        });
    });
    
    // Activity item hover effects
    document.querySelectorAll('.activity-item').forEach(item => {
        item.addEventListener('mouseenter', function() {
            this.style.background = '#f9fafb';
        });
        
        item.addEventListener('mouseleave', function() {
            this.style.background = 'transparent';
        });
    });
    
    // System metrics animation
    document.querySelectorAll('.progress-bar').forEach(bar => {
        const width = bar.style.width;
        bar.style.width = '0%';
        bar.style.transition = 'width 1s ease-in-out';
        
        setTimeout(() => {
            bar.style.width = width;
        }, 500);
    });
    
    // Auto-refresh system metrics (mock)
    setInterval(() => {
        document.querySelectorAll('.progress-bar').forEach(bar => {
            const currentWidth = parseInt(bar.style.width);
            const variation = Math.floor(Math.random() * 10) - 5; // ±5%
            const newWidth = Math.max(10, Math.min(90, currentWidth + variation));
            
            bar.style.width = newWidth + '%';
            bar.nextElementSibling.textContent = newWidth + '%';
        });
    }, 30000); // Update every 30 seconds
});
</script>
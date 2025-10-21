<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- UTESHOP-CPL - Vendor Dashboard Home -->
<!-- Created: 2025-10-21 03:29:03 UTC by tuaanshuuysv -->

<div class="vendor-dashboard">
    
    <!-- Welcome Header -->
    <section class="vendor-welcome">
        <div class="container">
            <div class="welcome-card">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h1>
                            <i class="fas fa-store text-success"></i>
                            Chào mừng Người bán, <span class="text-primary">${authUser.fullName}</span>!
                        </h1>
                        <p class="lead">Quản lý cửa hàng và sản phẩm của bạn một cách hiệu quả</p>
                        <div class="vendor-info">
                            <span class="badge bg-success me-2">
                                <i class="fas fa-check-circle"></i> Shop đã xác thực
                            </span>
                            <span class="text-muted">
                                <i class="fas fa-calendar"></i> Tham gia từ: ${shopJoinDate}
                            </span>
                        </div>
                    </div>
                    <div class="col-md-4 text-end">
                        <div class="quick-stats">
                            <div class="stat-item">
                                <span class="stat-number">${shopRating}</span>
                                <span class="stat-label">Đánh giá shop</span>
                            </div>
                            <div class="stat-item">
                                <span class="stat-number">${monthlyOrders}</span>
                                <span class="stat-label">Đơn hàng</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Quick Actions -->
    <section class="vendor-quick-actions">
        <div class="container">
            <h3><i class="fas fa-bolt"></i> Thao tác nhanh</h3>
            <div class="row">
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="action-card">
                        <div class="action-icon bg-primary">
                            <i class="fas fa-plus-circle"></i>
                        </div>
                        <div class="action-content">
                            <h5>Thêm sản phẩm</h5>
                            <p>Đăng bán sản phẩm mới</p>
                            <button class="btn btn-primary btn-sm">
                                <i class="fas fa-plus"></i> Thêm ngay
                            </button>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="action-card">
                        <div class="action-icon bg-info">
                            <i class="fas fa-box"></i>
                        </div>
                        <div class="action-content">
                            <h5>Quản lý đơn hàng</h5>
                            <p>Xem và xử lý đơn hàng</p>
                            <button class="btn btn-info btn-sm">
                                <i class="fas fa-eye"></i> Xem đơn hàng
                            </button>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="action-card">
                        <div class="action-icon bg-success">
                            <i class="fas fa-store"></i>
                        </div>
                        <div class="action-content">
                            <h5>Trang shop</h5>
                            <p>Tùy chỉnh giao diện shop</p>
                            <button class="btn btn-success btn-sm">
                                <i class="fas fa-edit"></i> Chỉnh sửa
                            </button>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="action-card">
                        <div class="action-icon bg-warning">
                            <i class="fas fa-percentage"></i>
                        </div>
                        <div class="action-content">
                            <h5>Khuyến mãi</h5>
                            <p>Tạo chương trình giảm giá</p>
                            <button class="btn btn-warning btn-sm">
                                <i class="fas fa-plus"></i> Tạo khuyến mãi
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Dashboard Stats -->
    <section class="vendor-stats">
        <div class="container">
            <div class="row">
                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-icon bg-primary">
                            <i class="fas fa-chart-line"></i>
                        </div>
                        <div class="stats-content">
                            <h3>${monthlyRevenue}₫</h3>
                            <p>Doanh thu tháng này</p>
                            <span class="trend up">
                                <i class="fas fa-arrow-up"></i> ${revenueTrend}
                            </span>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-icon bg-info">
                            <i class="fas fa-shopping-cart"></i>
                        </div>
                        <div class="stats-content">
                            <h3>${monthlyOrders}</h3>
                            <p>Đơn hàng tháng này</p>
                            <span class="trend up">
                                <i class="fas fa-arrow-up"></i> ${ordersTrend}
                            </span>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-icon bg-success">
                            <i class="fas fa-cube"></i>
                        </div>
                        <div class="stats-content">
                            <h3>${activeProducts}</h3>
                            <p>Sản phẩm đang bán</p>
                            <span class="trend neutral">
                                <i class="fas fa-minus"></i> ${productsTrend}
                            </span>
                        </div>
                    </div>
                </div>

                <div class="col-lg-3 col-md-6 mb-4">
                    <div class="stats-card">
                        <div class="stats-icon bg-warning">
                            <i class="fas fa-star"></i>
                        </div>
                        <div class="stats-content">
                            <h3>${avgRating}</h3>
                            <p>Đánh giá trung bình</p>
                            <span class="trend up">
                                <i class="fas fa-arrow-up"></i> ${ratingTrend}
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Recent Orders -->
    <section class="recent-orders">
        <div class="container">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h4><i class="fas fa-clock"></i> Đơn hàng gần đây</h4>
                    <button class="btn btn-outline-primary btn-sm">
                        Xem tất cả <i class="fas fa-arrow-right"></i>
                    </button>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Mã đơn</th>
                                    <th>Khách hàng</th>
                                    <th>Sản phẩm</th>
                                    <th>Số lượng</th>
                                    <th>Tổng tiền</th>
                                    <th>Trạng thái</th>
                                    <th>Thời gian</th>
                                    <th>Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td><strong>#ORD001</strong></td>
                                    <td>Nguyễn Văn A</td>
                                    <td>iPhone 15 Pro Max</td>
                                    <td>1</td>
                                    <td><strong>29,990,000₫</strong></td>
                                    <td><span class="badge bg-warning">Chờ xác nhận</span></td>
                                    <td>5 phút trước</td>
                                    <td>
                                        <button class="btn btn-success btn-sm">
                                            <i class="fas fa-check"></i>
                                        </button>
                                        <button class="btn btn-info btn-sm">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>#ORD002</strong></td>
                                    <td>Trần Thị B</td>
                                    <td>MacBook Air M2</td>
                                    <td>1</td>
                                    <td><strong>24,990,000₫</strong></td>
                                    <td><span class="badge bg-info">Đã xác nhận</span></td>
                                    <td>15 phút trước</td>
                                    <td>
                                        <button class="btn btn-primary btn-sm">
                                            <i class="fas fa-shipping-fast"></i>
                                        </button>
                                        <button class="btn btn-info btn-sm">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </td>
                                </tr>
                                <tr>
                                    <td><strong>#ORD003</strong></td>
                                    <td>Lê Văn C</td>
                                    <td>Samsung Galaxy S24</td>
                                    <td>2</td>
                                    <td><strong>53,980,000₫</strong></td>
                                    <td><span class="badge bg-primary">Đang giao</span></td>
                                    <td>2 giờ trước</td>
                                    <td>
                                        <button class="btn btn-warning btn-sm">
                                            <i class="fas fa-truck"></i>
                                        </button>
                                        <button class="btn btn-info btn-sm">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Analytics Chart -->
    <section class="vendor-analytics">
        <div class="container">
            <div class="card">
                <div class="card-header">
                    <h4><i class="fas fa-chart-area"></i> Thống kê doanh thu</h4>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-lg-8">
                            <div class="chart-placeholder">
                                <i class="fas fa-chart-line fa-3x text-muted"></i>
                                <p class="text-muted">Biểu đồ doanh thu 30 ngày gần đây</p>
                            </div>
                        </div>
                        <div class="col-lg-4">
                            <div class="analytics-summary">
                                <h6>Tóm tắt tháng này</h6>
                                <div class="summary-item">
                                    <span class="label">Lượt xem shop:</span>
                                    <span class="value">${totalViews}</span>
                                </div>
                                <div class="summary-item">
                                    <span class="label">Followers:</span>
                                    <span class="value">${totalFollowers}</span>
                                </div>
                                <div class="summary-item">
                                    <span class="label">Tỷ lệ chuyển đổi:</span>
                                    <span class="value text-success">${conversionRate}</span>
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
/* Vendor Dashboard Styles */
.vendor-dashboard {
    background: #f8fafc;
    min-height: calc(100vh - 120px);
    padding: 20px 0;
}

/* Welcome Section */
.vendor-welcome {
    margin-bottom: 30px;
}

.welcome-card {
    background: linear-gradient(135deg, #10b981, #059669);
    color: white;
    border-radius: 15px;
    padding: 30px;
}

.welcome-card h1 {
    font-size: 1.8rem;
    margin-bottom: 15px;
}

.vendor-info {
    margin-top: 20px;
}

.quick-stats {
    display: flex;
    gap: 20px;
}

.stat-item {
    text-align: center;
    background: rgba(255, 255, 255, 0.1);
    padding: 15px;
    border-radius: 10px;
}

.stat-number {
    font-size: 1.5rem;
    font-weight: bold;
    display: block;
}

.stat-label {
    font-size: 0.8rem;
    opacity: 0.9;
}

/* Quick Actions */
.vendor-quick-actions {
    margin-bottom: 30px;
}

.vendor-quick-actions h3 {
    margin-bottom: 20px;
    color: #1f2937;
}

.action-card {
    background: white;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    transition: transform 0.3s ease;
    text-align: center;
    height: 100%;
}

.action-card:hover {
    transform: translateY(-5px);
}

.action-icon {
    width: 50px;
    height: 50px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    margin: 0 auto 15px;
    color: white;
    font-size: 1.2rem;
}

.action-content h5 {
    margin-bottom: 10px;
    color: #1f2937;
    font-size: 1rem;
}

.action-content p {
    color: #6b7280;
    margin-bottom: 15px;
    font-size: 0.9rem;
}

/* Stats Cards */
.vendor-stats {
    margin-bottom: 30px;
}

.stats-card {
    background: white;
    border-radius: 12px;
    padding: 20px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    display: flex;
    align-items: center;
    gap: 15px;
}

.stats-icon {
    width: 50px;
    height: 50px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 1.2rem;
}

.stats-content h3 {
    margin-bottom: 5px;
    color: #1f2937;
    font-size: 1.5rem;
    font-weight: bold;
}

.stats-content p {
    margin-bottom: 8px;
    color: #6b7280;
    font-size: 0.9rem;
}

.trend {
    font-size: 0.8rem;
    font-weight: 500;
}

.trend.up {
    color: #10b981;
}

.trend.neutral {
    color: #6b7280;
}

/* Cards */
.card {
    border: none;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    border-radius: 12px;
    margin-bottom: 30px;
}

.card-header {
    background: white;
    border-bottom: 1px solid #e5e7eb;
    padding: 20px;
    border-radius: 12px 12px 0 0;
}

.card-header h4 {
    margin: 0;
    color: #1f2937;
    font-size: 1.2rem;
}

/* Table */
.table th {
    border-top: none;
    border-bottom: 2px solid #e5e7eb;
    color: #6b7280;
    font-weight: 600;
    font-size: 0.8rem;
}

.table td {
    border-top: 1px solid #f3f4f6;
    vertical-align: middle;
    padding: 12px;
    font-size: 0.9rem;
}

/* Chart */
.chart-placeholder {
    background: #f8fafc;
    border-radius: 10px;
    height: 250px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    color: #6b7280;
}

.analytics-summary {
    background: #f8fafc;
    border-radius: 10px;
    padding: 20px;
}

.analytics-summary h6 {
    margin-bottom: 15px;
    color: #1f2937;
    font-weight: 600;
}

.summary-item {
    display: flex;
    justify-content: space-between;
    margin-bottom: 12px;
    padding-bottom: 12px;
    border-bottom: 1px solid #e5e7eb;
    font-size: 0.9rem;
}

.summary-item:last-child {
    border-bottom: none;
    margin-bottom: 0;
    padding-bottom: 0;
}

.summary-item .label {
    color: #6b7280;
}

.summary-item .value {
    font-weight: 600;
    color: #1f2937;
}

/* Responsive */
@media (max-width: 768px) {
    .welcome-card h1 {
        font-size: 1.4rem;
    }
    
    .quick-stats {
        flex-direction: column;
        gap: 10px;
    }
    
    .stats-card {
        flex-direction: column;
        text-align: center;
        gap: 10px;
    }
    
    .table-responsive {
        font-size: 0.8rem;
    }
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    console.log('✅ UTESHOP-CPL Vendor Dashboard loaded');
    console.log('🕐 Load time: 2025-10-21 03:29:03 UTC');
    console.log('👨‍💻 Created by: tuaanshuuysv');
    console.log('🏪 Vendor: ${authUser.username}');
    
    // Add click handlers for action buttons
    document.querySelectorAll('.action-card').forEach(card => {
        card.addEventListener('click', function() {
            const actionName = this.querySelector('h5').textContent;
            console.log('Vendor action clicked:', actionName);
            
            // Show feedback
            const btn = this.querySelector('.btn');
            const originalText = btn.innerHTML;
            btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
            
            setTimeout(() => {
                btn.innerHTML = originalText;
            }, 1500);
        });
    });
    
    // Order management buttons
    document.querySelectorAll('.btn-success').forEach(btn => {
        btn.addEventListener('click', function(e) {
            e.stopPropagation();
            if (this.innerHTML.includes('fa-check')) {
                this.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';
                
                setTimeout(() => {
                    const statusBadge = this.closest('tr').querySelector('.badge');
                    statusBadge.textContent = 'Đã xác nhận';
                    statusBadge.className = 'badge bg-info';
                    
                    this.innerHTML = '<i class="fas fa-check-circle"></i>';
                    this.classList.remove('btn-success');
                    this.classList.add('btn-secondary');
                    this.disabled = true;
                }, 1000);
            }
        });
    });
});
</script>
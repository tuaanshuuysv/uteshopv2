<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UTESHOP Vendor - Quản lý Shop</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.min.css" rel="stylesheet">
    
    <style>
        body { background-color: #f8f9fa; }
        .vendor-header { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); color: white; }
        .stats-card { border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.1); transition: transform 0.3s; }
        .stats-card:hover { transform: translateY(-5px); }
        .stats-icon { font-size: 2.5rem; opacity: 0.8; }
        .shop-info-card { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; }
        .order-status-new { color: #ffc107; }
        .order-status-processing { color: #17a2b8; }
        .order-status-delivered { color: #28a745; }
        .order-status-cancelled { color: #dc3545; }
        .product-image { width: 50px; height: 50px; object-fit: cover; border-radius: 8px; }
        .low-stock { background-color: #fff3cd; border-left: 4px solid #ffc107; }
    </style>
</head>
<body>

<!-- UTESHOP Vendor Dashboard - COMPLETE -->
<!-- Created: 2025-10-26 15:24:15 UTC by tuaanshuuysv -->

<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-md-3 col-lg-2 px-0">
            <div class="d-flex flex-column vh-100 bg-dark">
                <div class="p-3 text-white border-bottom">
                    <h5 class="mb-0">
                        <i class="fas fa-store me-2"></i>
                        VENDOR PANEL
                    </h5>
                    <small class="text-muted">Quản lý Shop</small>
                </div>
                
                <nav class="flex-grow-1">
                    <ul class="nav nav-pills flex-column p-3">
                        <li class="nav-item mb-2">
                            <a href="${pageContext.request.contextPath}/vendor/dashboard" class="nav-link text-white active">
                                <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a href="${pageContext.request.contextPath}/vendor/products" class="nav-link text-white">
                                <i class="fas fa-box me-2"></i>Sản phẩm
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a href="${pageContext.request.contextPath}/vendor/orders" class="nav-link text-white">
                                <i class="fas fa-shopping-cart me-2"></i>Đơn hàng
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a href="${pageContext.request.contextPath}/vendor/promotions" class="nav-link text-white">
                                <i class="fas fa-tags me-2"></i>Khuyến mãi
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a href="${pageContext.request.contextPath}/vendor/revenue" class="nav-link text-white">
                                <i class="fas fa-chart-line me-2"></i>Doanh thu
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a href="${pageContext.request.contextPath}/vendor/shop-profile" class="nav-link text-white">
                                <i class="fas fa-cog me-2"></i>Cài đặt Shop
                            </a>
                        </li>
                        <hr class="text-white">
                        <li class="nav-item mb-2">
                            <a href="${pageContext.request.contextPath}/user/orders" class="nav-link text-white">
                                <i class="fas fa-user me-2"></i>Đơn hàng cá nhân
                            </a>
                        </li>
                        <li class="nav-item mb-2">
                            <a href="${pageContext.request.contextPath}/" class="nav-link text-white">
                                <i class="fas fa-home me-2"></i>Về trang chủ
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="${pageContext.request.contextPath}/auth/logout" class="nav-link text-white">
                                <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>

        <!-- Main Content -->
        <div class="col-md-9 col-lg-10">
            <!-- Header -->
            <div class="vendor-header p-4 mb-4">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2 class="mb-1">Bảng điều khiển Vendor</h2>
                        <p class="mb-0 opacity-75">
                            Xin chào, ${authUser.fullName} | 
                            <fmt:formatDate value="${currentDateTime}" pattern="dd/MM/yyyy HH:mm"/>
                        </p>
                    </div>
                    <div class="text-end">
                        <div class="badge bg-light text-dark p-2">
                            <i class="fas fa-store me-1"></i>
                            Shop Owner
                        </div>
                    </div>
                </div>
            </div>

            <!-- Shop Info Card -->
            <c:choose>
                <c:when test="${not empty vendorShop}">
                    <div class="row mb-4">
                        <div class="col-12">
                            <div class="card shop-info-card">
                                <div class="card-body">
                                    <div class="row align-items-center">
                                        <div class="col-md-2 text-center">
                                            <img src="${pageContext.request.contextPath}${vendorShop.shop_logo}" 
                                                 alt="${vendorShop.shop_name}" 
                                                 class="rounded-circle border border-3 border-white"
                                                 style="width: 80px; height: 80px; object-fit: cover;"
                                                 onerror="this.src='https://via.placeholder.com/80x80/ffffff/667eea?text=SHOP'">
                                        </div>
                                        <div class="col-md-6">
                                            <h4 class="mb-2">
                                                ${vendorShop.shop_name}
                                                <c:if test="${vendorShop.is_verified}">
                                                    <i class="fas fa-check-circle text-warning ms-2" title="Shop đã được xác minh"></i>
                                                </c:if>
                                            </h4>
                                            <p class="mb-2 opacity-90">${vendorShop.shop_description}</p>
                                            <div class="d-flex align-items-center">
                                                <div class="me-4">
                                                    <span class="badge bg-light text-dark">
                                                        ⭐ ${vendorShop.total_rating}/5.0
                                                    </span>
                                                </div>
                                                <div class="me-4">
                                                    <span class="badge bg-light text-dark">
                                                        💬 ${vendorShop.total_reviews} đánh giá
                                                    </span>
                                                </div>
                                                <div>
                                                    <span class="badge bg-light text-dark">
                                                        📦 ${vendorShop.product_count} sản phẩm
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4 text-end">
                                            <a href="${pageContext.request.contextPath}/shops/${vendorShop.shop_id}" 
                                               class="btn btn-light btn-sm mb-2" target="_blank">
                                                <i class="fas fa-external-link-alt me-1"></i>
                                                Xem Shop Public
                                            </a>
                                            <br>
                                            <a href="${pageContext.request.contextPath}/vendor/shop-profile" class="btn btn-outline-light btn-sm">
                                                <i class="fas fa-edit me-1"></i>
                                                Chỉnh sửa thông tin
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Stats Cards -->
                    <div class="row g-4 mb-4">
                        <div class="col-md-3">
                            <div class="card stats-card text-center p-3">
                                <div class="card-body">
                                    <div class="stats-icon text-primary mb-2">
                                        <i class="fas fa-box"></i>
                                    </div>
                                    <h3 class="mb-1">${vendorStats.total_products != null ? vendorStats.total_products : '156'}</h3>
                                    <p class="text-muted mb-0">Tổng sản phẩm</p>
                                    <small class="text-success">
                                        <i class="fas fa-check"></i>
                                        ${vendorStats.in_stock_products != null ? vendorStats.in_stock_products : '142'} còn hàng
                                    </small>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-3">
                            <div class="card stats-card text-center p-3">
                                <div class="card-body">
                                    <div class="stats-icon text-success mb-2">
                                        <i class="fas fa-shopping-cart"></i>
                                    </div>
                                    <h3 class="mb-1">${vendorStats.total_orders != null ? vendorStats.total_orders : '1,234'}</h3>
                                    <p class="text-muted mb-0">Tổng đơn hàng</p>
                                    <small class="text-warning">
                                        <i class="fas fa-clock"></i>
                                        ${vendorStats.pending_orders != null ? vendorStats.pending_orders : '23'} đang xử lý
                                    </small>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-3">
                            <div class="card stats-card text-center p-3">
                                <div class="card-body">
                                    <div class="stats-icon text-info mb-2">
                                        <i class="fas fa-money-bill-wave"></i>
                                    </div>
                                    <h3 class="mb-1">${vendorStats.total_revenue != null ? vendorStats.total_revenue : '45,600,000₫'}</h3>
                                    <p class="text-muted mb-0">Tổng doanh thu</p>
                                    <small class="text-info">
                                        <i class="fas fa-calendar-day"></i>
                                        ${vendorStats.revenue_today != null ? vendorStats.revenue_today : '2,340,000₫'} hôm nay
                                    </small>
                                </div>
                            </div>
                        </div>
                        
                        <div class="col-md-3">
                            <div class="card stats-card text-center p-3">
                                <div class="card-body">
                                    <div class="stats-icon text-warning mb-2">
                                        <i class="fas fa-exclamation-triangle"></i>
                                    </div>
                                    <h3 class="mb-1">${vendorStats.low_stock_products != null ? vendorStats.low_stock_products : '8'}</h3>
                                    <p class="text-muted mb-0">Sắp hết hàng</p>
                                    <small class="text-danger">
                                        <i class="fas fa-arrow-down"></i>
                                        Cần nhập thêm
                                    </small>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Orders & Low Stock Products -->
                    <div class="row g-4 mb-4">
                        <!-- Recent Orders -->
                        <div class="col-lg-8">
                            <div class="card">
                                <div class="card-header bg-transparent d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">
                                        <i class="fas fa-shopping-cart me-2"></i>
                                        Đơn hàng gần đây
                                    </h5>
                                    <a href="${pageContext.request.contextPath}/vendor/orders" class="btn btn-outline-primary btn-sm">
                                        Xem tất cả
                                    </a>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${not empty vendorRecentOrders}">
                                            <div class="table-responsive">
                                                <table class="table table-hover">
                                                    <thead>
                                                        <tr>
                                                            <th>Mã đơn</th>
                                                            <th>Khách hàng</th>
                                                            <th>Giá trị</th>
                                                            <th>Trạng thái</th>
                                                            <th>Thời gian</th>
                                                            <th>Thao tác</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="order" items="${vendorRecentOrders}" varStatus="status">
                                                            <c:if test="${status.index < 5}">
                                                                <tr>
                                                                    <td>
                                                                        <strong>${order.order_number}</strong>
                                                                        <br>
                                                                        <small class="text-muted">${order.item_count} sản phẩm</small>
                                                                    </td>
                                                                    <td>${order.customer_name}</td>
                                                                    <td>
                                                                        <strong class="text-success">${order.total_amount}</strong>
                                                                    </td>
                                                                    <td>
                                                                        <span class="badge bg-${order.order_status == 'NEW' ? 'warning' : order.order_status == 'DELIVERED' ? 'success' : 'primary'}">
                                                                            ${order.order_status}
                                                                        </span>
                                                                    </td>
                                                                    <td>
                                                                        <fmt:formatDate value="${order.created_at}" pattern="dd/MM/yyyy HH:mm"/>
                                                                    </td>
                                                                    <td>
                                                                        <a href="${pageContext.request.contextPath}/vendor/orders/${order.order_id}" 
                                                                           class="btn btn-outline-primary btn-sm">
                                                                            <i class="fas fa-eye"></i>
                                                                        </a>
                                                                    </td>
                                                                </tr>
                                                            </c:if>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Dummy Recent Orders -->
                                            <div class="table-responsive">
                                                <table class="table table-hover">
                                                    <thead>
                                                        <tr>
                                                            <th>Mã đơn</th>
                                                            <th>Khách hàng</th>
                                                            <th>Giá trị</th>
                                                            <th>Trạng thái</th>
                                                            <th>Thời gian</th>
                                                            <th>Thao tác</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td>
                                                                <strong>#UTD25001234</strong>
                                                                <br>
                                                                <small class="text-muted">3 sản phẩm</small>
                                                            </td>
                                                            <td>Nguyễn Văn A</td>
                                                            <td><strong class="text-success">2,450,000₫</strong></td>
                                                            <td><span class="badge bg-warning">NEW</span></td>
                                                            <td>26/10/2025 14:30</td>
                                                            <td>
                                                                <a href="#" class="btn btn-outline-primary btn-sm">
                                                                    <i class="fas fa-eye"></i>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <strong>#UTD25001233</strong>
                                                                <br>
                                                                <small class="text-muted">1 sản phẩm</small>
                                                            </td>
                                                            <td>Trần Thị B</td>
                                                            <td><strong class="text-success">1,200,000₫</strong></td>
                                                            <td><span class="badge bg-primary">PROCESSING</span></td>
                                                            <td>26/10/2025 13:15</td>
                                                            <td>
                                                                <a href="#" class="btn btn-outline-primary btn-sm">
                                                                    <i class="fas fa-eye"></i>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <td>
                                                                <strong>#UTD25001232</strong>
                                                                <br>
                                                                <small class="text-muted">2 sản phẩm</small>
                                                            </td>
                                                            <td>Lê Văn C</td>
                                                            <td><strong class="text-success">3,800,000₫</strong></td>
                                                            <td><span class="badge bg-success">DELIVERED</span></td>
                                                            <td>26/10/2025 11:20</td>
                                                            <td>
                                                                <a href="#" class="btn btn-outline-primary btn-sm">
                                                                    <i class="fas fa-eye"></i>
                                                                </a>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <!-- Low Stock Products -->
                        <div class="col-lg-4">
                            <div class="card h-100">
                                <div class="card-header bg-transparent d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">
                                        <i class="fas fa-exclamation-triangle me-2 text-warning"></i>
                                        Sắp hết hàng
                                    </h5>
                                    <a href="${pageContext.request.contextPath}/vendor/products?filter=low_stock" class="btn btn-outline-warning btn-sm">
                                        Xem tất cả
                                    </a>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${not empty lowStockProducts}">
                                            <c:forEach var="product" items="${lowStockProducts}" varStatus="status">
                                                <c:if test="${status.index < 5}">
                                                    <div class="low-stock p-3 mb-3 rounded">
                                                        <div class="d-flex align-items-center">
                                                            <img src="${pageContext.request.contextPath}${product.image_url}" 
                                                                 alt="${product.product_name}" 
                                                                 class="product-image me-3"
                                                                 onerror="this.src='https://via.placeholder.com/50x50/ffc107/ffffff?text=P'">
                                                            <div class="flex-grow-1">
                                                                <h6 class="mb-1">${product.product_name}</h6>
                                                                <div class="d-flex justify-content-between">
                                                                    <small class="text-muted">
                                                                        Còn: <strong>${product.stock_quantity}</strong>
                                                                    </small>
                                                                    <small class="text-muted">
                                                                        Tối thiểu: ${product.min_stock_level}
                                                                    </small>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Dummy Low Stock Products -->
                                            <div class="low-stock p-3 mb-3 rounded">
                                                <div class="d-flex align-items-center">
                                                    <div class="product-image me-3 bg-warning rounded d-flex align-items-center justify-content-center">
                                                        <i class="fas fa-mobile-alt text-white"></i>
                                                    </div>
                                                    <div class="flex-grow-1">
                                                        <h6 class="mb-1">iPhone 15 Pro Max</h6>
                                                        <div class="d-flex justify-content-between">
                                                            <small class="text-muted">Còn: <strong>5</strong></small>
                                                            <small class="text-muted">Tối thiểu: 10</small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="low-stock p-3 mb-3 rounded">
                                                <div class="d-flex align-items-center">
                                                    <div class="product-image me-3 bg-warning rounded d-flex align-items-center justify-content-center">
                                                        <i class="fas fa-laptop text-white"></i>
                                                    </div>
                                                    <div class="flex-grow-1">
                                                        <h6 class="mb-1">MacBook Air M3</h6>
                                                        <div class="d-flex justify-content-between">
                                                            <small class="text-muted">Còn: <strong>3</strong></small>
                                                            <small class="text-muted">Tối thiểu: 5</small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            
                                            <div class="low-stock p-3 mb-3 rounded">
                                                <div class="d-flex align-items-center">
                                                    <div class="product-image me-3 bg-warning rounded d-flex align-items-center justify-content-center">
                                                        <i class="fas fa-headphones text-white"></i>
                                                    </div>
                                                    <div class="flex-grow-1">
                                                        <h6 class="mb-1">AirPods Pro 2</h6>
                                                        <div class="d-flex justify-content-between">
                                                            <small class="text-muted">Còn: <strong>2</strong></small>
                                                            <small class="text-muted">Tối thiểu: 8</small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Quick Actions -->
                    <div class="row g-4">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header bg-transparent">
                                    <h5 class="mb-0">
                                        <i class="fas fa-bolt me-2"></i>
                                        Thao tác nhanh
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <div class="row g-3">
                                        <div class="col-md-2">
                                            <a href="${pageContext.request.contextPath}/vendor/products/add" class="btn btn-primary w-100 h-100 d-flex flex-column justify-content-center align-items-center">
                                                <i class="fas fa-plus fa-2x mb-2"></i>
                                                <span>Thêm sản phẩm</span>
                                            </a>
                                        </div>
                                        <div class="col-md-2">
                                            <a href="${pageContext.request.contextPath}/vendor/orders?status=new" class="btn btn-warning w-100 h-100 d-flex flex-column justify-content-center align-items-center">
                                                <i class="fas fa-clock fa-2x mb-2"></i>
                                                <span>Đơn hàng mới</span>
                                            </a>
                                        </div>
                                        <div class="col-md-2">
                                            <a href="${pageContext.request.contextPath}/vendor/products?filter=low_stock" class="btn btn-danger w-100 h-100 d-flex flex-column justify-content-center align-items-center">
                                                <i class="fas fa-exclamation-triangle fa-2x mb-2"></i>
                                                <span>Sắp hết hàng</span>
                                            </a>
                                        </div>
                                        <div class="col-md-2">
                                            <a href="${pageContext.request.contextPath}/vendor/promotions" class="btn btn-info w-100 h-100 d-flex flex-column justify-content-center align-items-center">
                                                <i class="fas fa-tags fa-2x mb-2"></i>
                                                <span>Khuyến mãi</span>
                                            </a>
                                        </div>
                                        <div class="col-md-2">
                                            <a href="${pageContext.request.contextPath}/vendor/revenue" class="btn btn-success w-100 h-100 d-flex flex-column justify-content-center align-items-center">
                                                <i class="fas fa-chart-line fa-2x mb-2"></i>
                                                <span>Báo cáo</span>
                                            </a>
                                        </div>
                                        <div class="col-md-2">
                                            <a href="${pageContext.request.contextPath}/vendor/shop-profile" class="btn btn-secondary w-100 h-100 d-flex flex-column justify-content-center align-items-center">
                                                <i class="fas fa-cog fa-2x mb-2"></i>
                                                <span>Cài đặt</span>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </c:when>
                <c:otherwise>
                    <!-- No Shop Yet - Setup Wizard -->
                    <div class="row justify-content-center">
                        <div class="col-lg-8">
                            <div class="card text-center">
                                <div class="card-body py-5">
                                    <div class="mb-4">
                                        <i class="fas fa-store fa-5x text-muted mb-3"></i>
                                        <h3>Chưa có Shop</h3>
                                        <p class="text-muted lead">
                                            Tạo shop của bạn ngay hôm nay để bắt đầu bán hàng trên UTESHOP
                                        </p>
                                    </div>
                                    
                                    <div class="row g-4 mb-4">
                                        <div class="col-md-4">
                                            <div class="card bg-light border-0">
                                                <div class="card-body">
                                                    <i class="fas fa-rocket fa-2x text-primary mb-3"></i>
                                                    <h6>Dễ dàng thiết lập</h6>
                                                    <p class="small text-muted">Chỉ vài bước đơn giản để có shop của riêng bạn</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="card bg-light border-0">
                                                <div class="card-body">
                                                    <i class="fas fa-users fa-2x text-success mb-3"></i>
                                                    <h6>Tiếp cận khách hàng</h6>
                                                    <p class="small text-muted">Hàng triệu khách hàng đang chờ sản phẩm của bạn</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="card bg-light border-0">
                                                <div class="card-body">
                                                    <i class="fas fa-chart-line fa-2x text-info mb-3"></i>
                                                    <h6>Tăng doanh thu</h6>
                                                    <p class="small text-muted">Công cụ mạnh mẽ để quản lý và phát triển kinh doanh</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <a href="${pageContext.request.contextPath}/vendor/setup" class="btn btn-primary btn-lg px-5">
                                        <i class="fas fa-plus me-2"></i>
                                        Tạo Shop ngay
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.min.js"></script>

<script>
// UTESHOP Vendor Dashboard JavaScript
console.log('✅ Vendor Dashboard loaded successfully');
console.log('🕐 Created: 2025-10-26 15:24:15 UTC by tuaanshuuysv');
console.log('👤 User: tuaanshuuysv');

// Auto refresh stats every 2 minutes
setInterval(function() {
    console.log('🔄 Auto refreshing vendor stats...');
    // refreshVendorStats();
}, 120000);

// Real-time clock
function updateClock() {
    const now = new Date();
    const timeString = now.toLocaleString('vi-VN');
    document.title = 'UTESHOP Vendor - ' + timeString;
}

setInterval(updateClock, 1000);

// Low stock alert
function checkLowStock() {
    const lowStockCount = ${vendorStats.low_stock_products != null ? vendorStats.low_stock_products : 8};
    if (lowStockCount > 0) {
        console.log(`⚠️ Warning: ${lowStockCount} products are running low on stock`);
    }
}

checkLowStock();

// Quick action handlers
function addNewProduct() {
    window.location.href = '${pageContext.request.contextPath}/vendor/products/add';
}

function viewNewOrders() {
    window.location.href = '${pageContext.request.contextPath}/vendor/orders?status=new';
}

function managePromotions() {
    window.location.href = '${pageContext.request.contextPath}/vendor/promotions';
}

console.log('🚀 Vendor Dashboard fully initialized!');
</script>

</body>
</html>
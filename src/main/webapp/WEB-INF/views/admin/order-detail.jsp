<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- UTESHOP Admin Order Detail - ADMIN FOLDER -->
<!-- Created: 2025-10-24 23:40:59 UTC by tuaanshuuysv -->
<!-- Path: /WEB-INF/views/admin/order-detail.jsp -->

<div class="admin-order-detail-page">
    
    <!-- Order Header with Admin Controls -->
    <div class="admin-order-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h1 class="page-title">
                        <i class="fas fa-shield-alt me-2"></i>
                        Admin: Đơn hàng #${order.order_number}
                    </h1>
                    <div class="order-meta">
                        <span class="order-date">
                            <i class="fas fa-calendar me-1"></i>
                            Đặt: <fmt:formatDate value="${order.created_at}" pattern="dd/MM/yyyy HH:mm"/>
                        </span>
                        <span class="shop-info ms-3">
                            <i class="fas fa-store me-1"></i>
                            ${order.shop_name}
                        </span>
                        <span class="customer-info ms-3">
                            <i class="fas fa-user me-1"></i>
                            ${order.customer_name}
                        </span>
                    </div>
                </div>
                <div class="col-md-6 text-end">
                    <div class="admin-controls">
                        <div class="order-status-admin">
                            <span class="status-badge status-${order.order_status.toLowerCase()}">
                                <c:choose>
                                    <c:when test="${order.order_status == 'NEW'}">Đơn mới</c:when>
                                    <c:when test="${order.order_status == 'CONFIRMED'}">Đã xác nhận</c:when>
                                    <c:when test="${order.order_status == 'PROCESSING'}">Đang xử lý</c:when>
                                    <c:when test="${order.order_status == 'SHIPPING'}">Đang giao</c:when>
                                    <c:when test="${order.order_status == 'DELIVERED'}">Đã giao</c:when>
                                    <c:when test="${order.order_status == 'CANCELLED'}">Đã hủy</c:when>
                                    <c:when test="${order.order_status == 'RETURNED'}">Đã trả</c:when>
                                    <c:otherwise>${order.order_status}</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="order-amount-admin mt-2">
                            <span class="amount">${order.total_amount}</span>
                        </div>
                        <div class="admin-quick-actions mt-3">
                            <button type="button" class="btn btn-outline-light btn-sm" onclick="exportOrderDetails()">
                                <i class="fas fa-download me-1"></i>Xuất PDF
                            </button>
                            <button type="button" class="btn btn-outline-light btn-sm" onclick="viewOrderLogs()">
                                <i class="fas fa-history me-1"></i>Lịch sử
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Admin System Overview -->
    <div class="container mt-4">
        <div class="admin-system-overview">
            <div class="row">
                <div class="col-md-3">
                    <div class="system-metric">
                        <div class="metric-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="metric-info">
                            <h4><fmt:formatDate value="${order.created_at}" pattern="HH:mm:ss"/></h4>
                            <p>Giờ đặt hàng</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="system-metric">
                        <div class="metric-icon">
                            <i class="fas fa-credit-card"></i>
                        </div>
                        <div class="metric-info">
                            <h4>
                                <span class="payment-badge payment-${order.payment_status.toLowerCase()}">
                                    <c:choose>
                                        <c:when test="${order.payment_status == 'PAID'}">✓ Đã TT</c:when>
                                        <c:when test="${order.payment_status == 'PENDING'}">⏳ Chờ TT</c:when>
                                        <c:when test="${order.payment_status == 'FAILED'}">✗ Thất bại</c:when>
                                        <c:otherwise>${order.payment_status}</c:otherwise>
                                    </c:choose>
                                </span>
                            </h4>
                            <p>Thanh toán</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="system-metric">
                        <div class="metric-icon">
                            <i class="fas fa-box"></i>
                        </div>
                        <div class="metric-info">
                            <h4>${orderItems.size()}</h4>
                            <p>Sản phẩm</p>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="system-metric">
                        <div class="metric-icon">
                            <i class="fas fa-truck"></i>
                        </div>
                        <div class="metric-info">
                            <h4>
                                <c:choose>
                                    <c:when test="${not empty order.tracking_number}">${order.tracking_number}</c:when>
                                    <c:otherwise>---</c:otherwise>
                                </c:choose>
                            </h4>
                            <p>Mã vận đơn</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Admin Action Panel -->
    <div class="container mt-4">
        <div class="admin-action-panel">
            <div class="panel-header">
                <h5>
                    <i class="fas fa-tools me-2"></i>
                    Bảng điều khiển Admin
                </h5>
            </div>
            <div class="panel-body">
                <div class="row">
                    <div class="col-md-4">
                        <div class="action-group">
                            <h6>⚡ Thao tác nhanh:</h6>
                            <div class="btn-group-vertical w-100" role="group">
                                <c:if test="${order.order_status == 'NEW'}">
                                    <button type="button" class="btn btn-success btn-sm" onclick="adminUpdateStatus('CONFIRMED')">
                                        <i class="fas fa-check me-1"></i>Admin Xác nhận
                                    </button>
                                </c:if>
                                <c:if test="${order.order_status == 'CONFIRMED' || order.order_status == 'NEW'}">
                                    <button type="button" class="btn btn-info btn-sm" onclick="adminUpdateStatus('PROCESSING')">
                                        <i class="fas fa-cogs me-1"></i>Chuyển xử lý
                                    </button>
                                </c:if>
                                <c:if test="${order.order_status == 'PROCESSING' || order.order_status == 'CONFIRMED'}">
                                    <button type="button" class="btn btn-warning btn-sm" onclick="adminUpdateStatus('SHIPPING')">
                                        <i class="fas fa-truck me-1"></i>Giao hàng ngay
                                    </button>
                                </c:if>
                                <c:if test="${order.order_status == 'SHIPPING'}">
                                    <button type="button" class="btn btn-primary btn-sm" onclick="adminUpdateStatus('DELIVERED')">
                                        <i class="fas fa-check-double me-1"></i>Hoàn thành
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="action-group">
                            <h6>🚨 Thao tác đặc biệt:</h6>
                            <div class="btn-group-vertical w-100" role="group">
                                <c:if test="${order.order_status != 'CANCELLED' && order.order_status != 'DELIVERED'}">
                                    <button type="button" class="btn btn-danger btn-sm" onclick="adminCancelOrder()">
                                        <i class="fas fa-ban me-1"></i>Admin Hủy đơn
                                    </button>
                                </c:if>
                                <c:if test="${order.order_status == 'DELIVERED'}">
                                    <button type="button" class="btn btn-warning btn-sm" onclick="adminReturnOrder()">
                                        <i class="fas fa-undo me-1"></i>Xử lý trả hàng
                                    </button>
                                </c:if>
                                <button type="button" class="btn btn-secondary btn-sm" onclick="adminAddNote()">
                                    <i class="fas fa-sticky-note me-1"></i>Thêm ghi chú
                                </button>
                                <button type="button" class="btn btn-info btn-sm" onclick="adminContactShop()">
                                    <i class="fas fa-phone me-1"></i>Liên hệ Shop
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="action-group">
                            <h6>📊 Phân tích & Báo cáo:</h6>
                            <div class="btn-group-vertical w-100" role="group">
                                <button type="button" class="btn btn-outline-primary btn-sm" onclick="viewCustomerHistory()">
                                    <i class="fas fa-user-clock me-1"></i>Lịch sử KH
                                </button>
                                <button type="button" class="btn btn-outline-success btn-sm" onclick="viewShopStats()">
                                    <i class="fas fa-chart-bar me-1"></i>Thống kê Shop
                                </button>
                                <button type="button" class="btn btn-outline-warning btn-sm" onclick="auditTrail()">
                                    <i class="fas fa-search me-1"></i>Audit Trail
                                </button>
                                <button type="button" class="btn btn-outline-info btn-sm" onclick="systemReport()">
                                    <i class="fas fa-file-alt me-1"></i>Báo cáo hệ thống
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container mt-4">
        <div class="row">
            <!-- Order Items with Admin View -->
            <div class="col-lg-8">
                <div class="admin-order-items-card">
                    <div class="card-header">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h5 class="mb-0">
                                    <i class="fas fa-database me-2"></i>
                                    Chi tiết sản phẩm (${orderItems.size()} items)
                                </h5>
                            </div>
                            <div class="col-md-4 text-end">
                                <button type="button" class="btn btn-outline-secondary btn-sm" onclick="checkInventory()">
                                    <i class="fas fa-warehouse me-1"></i>Kiểm kho
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <div class="admin-items-table">
                            <div class="table-header">
                                <div class="row">
                                    <div class="col-md-2">Sản phẩm</div>
                                    <div class="col-md-4">Thông tin</div>
                                    <div class="col-md-2">Giá gốc/Bán</div>
                                    <div class="col-md-1">SL</div>
                                    <div class="col-md-2">Thành tiền</div>
                                    <div class="col-md-1">Thao tác</div>
                                </div>
                            </div>
                            <c:forEach var="item" items="${orderItems}" varStatus="status">
                                <div class="admin-order-item">
                                    <div class="row align-items-center">
                                        <div class="col-md-2">
                                            <div class="admin-product-image">
                                                <c:choose>
                                                    <c:when test="${not empty item.image_url}">
                                                        <img src="${pageContext.request.contextPath}${item.image_url}" 
                                                             alt="${item.product_name}"
                                                             onerror="this.src='${pageContext.request.contextPath}/assets/images/default-product.jpg'">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="no-image">
                                                            <i class="fas fa-image"></i>
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                                <div class="item-index">#${status.index + 1}</div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="admin-product-info">
                                                <h6 class="product-name">
                                                    <a href="${pageContext.request.contextPath}/admin/products/${item.product_id}" target="_blank">
                                                        ${item.product_name}
                                                    </a>
                                                </h6>
                                                <div class="product-meta">
                                                    <span class="product-id">ID: ${item.product_id}</span>
                                                    <c:if test="${not empty item.selected_attributes}">
                                                        <span class="product-attributes">| ${item.selected_attributes}</span>
                                                    </c:if>
                                                </div>
                                                <div class="stock-status">
                                                    <span class="badge bg-success">Còn hàng</span>
                                                    <span class="current-price">Giá hiện tại: ${item.current_price}</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="price-comparison">
                                                <div class="order-price">
                                                    <strong>${item.product_price}</strong>
                                                    <small class="text-muted d-block">Giá đặt hàng</small>
                                                </div>
                                                <c:if test="${item.current_price != item.product_price}">
                                                    <div class="price-change mt-1">
                                                        <span class="badge bg-warning">Giá đã thay đổi</span>
                                                    </div>
                                                </c:if>
                                            </div>
                                        </div>
                                        <div class="col-md-1 text-center">
                                            <div class="quantity-info">
                                                <span class="quantity-number">${item.quantity}</span>
                                            </div>
                                        </div>
                                        <div class="col-md-2">
                                            <div class="admin-subtotal">
                                                <strong>${item.subtotal}</strong>
                                            </div>
                                        </div>
                                        <div class="col-md-1">
                                            <div class="item-actions">
                                                <div class="btn-group-vertical" role="group">
                                                    <button type="button" class="btn btn-outline-primary btn-xs" 
                                                            onclick="viewProductDetails('${item.product_id}')" title="Xem chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                    </button>
                                                    <button type="button" class="btn btn-outline-warning btn-xs" 
                                                            onclick="checkProductStock('${item.product_id}')" title="Kiểm tra kho">
                                                        <i class="fas fa-warehouse"></i>
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Admin Order History & Logs -->
                <div class="admin-order-logs-card mt-4">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-history me-2"></i>
                            Lịch sử thay đổi & System Logs
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="timeline">
                            <c:forEach var="history" items="${orderHistory}">
                                <div class="timeline-item">
                                    <div class="timeline-marker">
                                        <i class="fas fa-circle"></i>
                                    </div>
                                    <div class="timeline-content">
                                        <div class="timeline-header">
                                            <strong>${history.action}</strong>
                                            <small class="text-muted ms-2">
                                                bởi ${history.action_by}
                                            </small>
                                        </div>
                                        <div class="timeline-time">
                                            <fmt:formatDate value="${history.action_time}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Navigation -->
                <div class="admin-navigation-card mt-4">
                    <div class="card-body">
                        <div class="d-flex gap-2 flex-wrap">
                            <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-1"></i>Quay lại danh sách
                            </a>
                            <button type="button" class="btn btn-outline-primary" onclick="printAdminOrder()">
                                <i class="fas fa-print me-1"></i>In đơn hàng
                            </button>
                            <button type="button" class="btn btn-outline-success" onclick="exportOrderData()">
                                <i class="fas fa-file-excel me-1"></i>Xuất Excel
                            </button>
                            <button type="button" class="btn btn-outline-info" onclick="shareOrderLink()">
                                <i class="fas fa-share me-1"></i>Chia sẻ
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Admin Sidebar -->
            <div class="col-lg-4">
                <!-- Complete Order Summary -->
                <div class="admin-order-summary-card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-calculator me-2"></i>
                            Chi tiết tài chính
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="financial-breakdown">
                            <div class="summary-row">
                                <span>Tạm tính sản phẩm:</span>
                                <span>${order.subtotal}</span>
                            </div>
                            <div class="summary-row">
                                <span>Giảm giá áp dụng:</span>
                                <span class="text-success">-${order.discount_amount}</span>
                            </div>
                            <div class="summary-row">
                                <span>Phí vận chuyển:</span>
                                <span>${order.shipping_fee}</span>
                            </div>
                            <hr>
                            <div class="summary-row total">
                                <span>Tổng khách hàng trả:</span>
                                <span class="total-amount">${order.total_amount}</span>
                            </div>
                            
                            <div class="admin-finance-details mt-3 pt-3 border-top">
                                <h6>Phân tích doanh thu:</h6>
                                <div class="finance-row">
                                    <span>Doanh thu Shop:</span>
                                    <span class="text-success">${order.subtotal}</span>
                                </div>
                                <div class="finance-row">
                                    <span>Hoa hồng hệ thống (5%):</span>
                                    <span class="text-info">
                                        <c:set var="commission" value="${order.subtotal * 0.05}"/>
                                        <fmt:formatNumber value="${commission}" pattern="#,###"/>₫
                                    </span>
                                </div>
                                <div class="finance-row">
                                    <span>Doanh thu vận chuyển:</span>
                                    <span class="text-warning">${order.shipping_fee}</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Comprehensive Customer Info -->
                <div class="admin-customer-info-card mt-4">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-user-shield me-2"></i>
                            Thông tin khách hàng
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="customer-profile">
                            <div class="customer-header">
                                <h6>${order.customer_name}</h6>
                                <span class="customer-badge badge bg-primary">Khách hàng</span>
                            </div>
                            
                            <div class="customer-contacts mt-3">
                                <div class="contact-item">
                                    <i class="fas fa-envelope me-2"></i>
                                    <a href="mailto:${order.customer_email}">${order.customer_email}</a>
                                    <button type="button" class="btn btn-outline-primary btn-xs ms-2" onclick="emailCustomer()">
                                        <i class="fas fa-paper-plane"></i>
                                    </button>
                                </div>
                                <div class="contact-item mt-2">
                                    <i class="fas fa-phone me-2"></i>
                                    <a href="tel:${order.customer_phone}">${order.customer_phone}</a>
                                    <button type="button" class="btn btn-outline-success btn-xs ms-2" onclick="callCustomer()">
                                        <i class="fas fa-phone"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <div class="shipping-address mt-3">
                                <h6>Địa chỉ giao hàng:</h6>
                                <div class="address-display">
                                    <c:set var="address" value="${order.shipping_address}" />
                                    <p class="mb-2">${address}</p>
                                    <button type="button" class="btn btn-outline-info btn-sm" onclick="viewOnMap()">
                                        <i class="fas fa-map-marker-alt me-1"></i>Xem trên bản đồ
                                    </button>
                                </div>
                            </div>
                            
                            <div class="customer-stats mt-3">
                                <small class="text-muted">
                                    <i class="fas fa-chart-line me-1"></i>
                                    <button type="button" class="btn btn-link btn-sm p-0" onclick="viewCustomerHistory()">
                                        Xem lịch sử mua hàng
                                    </button>
                                </small>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Shop Information for Admin -->
                <div class="admin-shop-info-card mt-4">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-store me-2"></i>
                            Thông tin Shop
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="shop-profile">
                            <div class="shop-header">
                                <h6>${order.shop_name}</h6>
                                <span class="shop-badge badge bg-success">Vendor</span>
                            </div>
                            
                            <div class="shop-contacts mt-3">
                                <div class="contact-item">
                                    <i class="fas fa-phone me-2"></i>
                                    <a href="tel:${order.shop_phone}">${order.shop_phone}</a>
                                    <button type="button" class="btn btn-outline-success btn-xs ms-2" onclick="callShop()">
                                        <i class="fas fa-phone"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <div class="shop-actions mt-3">
                                <div class="d-flex gap-2 flex-wrap">
                                    <button type="button" class="btn btn-outline-primary btn-sm" onclick="viewShopProfile()">
                                        <i class="fas fa-eye me-1"></i>Xem shop
                                    </button>
                                    <button type="button" class="btn btn-outline-warning btn-sm" onclick="contactShop()">
                                        <i class="fas fa-envelope me-1"></i>Nhắn tin
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- System Information -->
                <div class="admin-system-info-card mt-4">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-cogs me-2"></i>
                            Thông tin hệ thống
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="system-details">
                            <div class="detail-row">
                                <span>Order ID:</span>
                                <span class="fw-bold">${order.order_id}</span>
                            </div>
                            <div class="detail-row">
                                <span>Thời gian tạo:</span>
                                <span><fmt:formatDate value="${order.created_at}" pattern="dd/MM/yyyy HH:mm:ss"/></span>
                            </div>
                            <div class="detail-row">
                                <span>Lần cập nhật cuối:</span>
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty order.updated_at}">
                                            <fmt:formatDate value="${order.updated_at}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                        </c:when>
                                        <c:otherwise>Chưa cập nhật</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="detail-row">
                                <span>Payment Method:</span>
                                <span>${order.payment_method}</span>
                            </div>
                            <div class="detail-row">
                                <span>Carrier:</span>
                                <span>
                                    <c:choose>
                                        <c:when test="${not empty order.carrier_name}">${order.carrier_name}</c:when>
                                        <c:otherwise>Chưa chọn</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Admin Status Update Modal -->
<div class="modal fade" id="adminStatusModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-shield-alt me-2"></i>
                    Admin: Cập nhật trạng thái
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="adminStatusForm" method="POST" action="${pageContext.request.contextPath}/admin/orders">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update-status">
                    <input type="hidden" name="order_id" value="${order.order_id}">
                    <input type="hidden" name="new_status" id="adminNewStatus">
                    
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        <strong>CẢNH BÁO:</strong> Bạn đang sử dụng quyền Admin để cập nhật trạng thái đơn hàng.
                        Thao tác này sẽ được ghi lại trong log hệ thống.
                    </div>
                    
                    <div class="mb-3">
                        <label for="adminNotes" class="form-label">Lý do cập nhật (bắt buộc)</label>
                        <textarea name="notes" id="adminNotes" class="form-control" rows="3" 
                                  placeholder="Nhập lý do admin can thiệp..." required></textarea>
                    </div>
                    
                    <div class="mb-3">
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="confirmAdminAction" required>
                            <label class="form-check-label" for="confirmAdminAction">
                                Tôi xác nhận đây là thao tác admin được phép và có lý do chính đáng
                            </label>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Hủy
                    </button>
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-shield-alt me-1"></i>Thực hiện với quyền Admin
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
/* Admin Order Detail Styles */
.admin-order-detail-page {
    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
    min-height: calc(100vh - 120px);
}

.admin-order-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 40px 0;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
}

.page-title {
    font-size: 2.5rem;
    font-weight: bold;
    margin-bottom: 15px;
}

.order-meta {
    font-size: 1rem;
    opacity: 0.9;
}

.admin-controls {
    text-align: right;
}

.order-amount-admin .amount {
    font-size: 2rem;
    font-weight: bold;
    color: white;
}

.admin-quick-actions .btn {
    margin-left: 8px;
}

.admin-system-overview {
    background: white;
    border-radius: 16px;
    padding: 25px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    border: 1px solid #e2e8f0;
}

.system-metric {
    display: flex;
    align-items: center;
    gap: 15px;
    padding: 15px;
    border-radius: 12px;
    background: #f8fafc;
    border: 1px solid #e2e8f0;
}

.metric-icon {
    width: 50px;
    height: 50px;
    border-radius: 12px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 1.3rem;
}

.metric-info h4 {
    font-size: 1.5rem;
    font-weight: bold;
    margin-bottom: 5px;
    color: #2d3748;
}

.metric-info p {
    margin: 0;
    color: #4a5568;
    font-size: 0.9rem;
}

.admin-action-panel {
    background: white;
    border-radius: 16px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    border: 1px solid #e2e8f0;
    overflow: hidden;
}

.panel-header {
    background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
    padding: 20px 25px;
    border-bottom: 2px solid #e2e8f0;
}

.panel-body {
    padding: 25px;
}

.action-group h6 {
    color: #2d3748;
    margin-bottom: 15px;
    font-weight: 600;
}

.admin-order-items-card, .admin-order-logs-card, .admin-navigation-card,
.admin-order-summary-card, .admin-customer-info-card, .admin-shop-info-card, .admin-system-info-card {
    background: white;
    border-radius: 16px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    border: 1px solid #e2e8f0;
    overflow: hidden;
}

.card-header {
    background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
    border-bottom: 2px solid #e2e8f0;
    padding: 20px 25px;
}

.card-body {
    padding: 25px;
}

.admin-items-table .table-header {
    background: #f1f5f9;
    padding: 15px 20px;
    font-weight: 600;
    color: #374151;
    border-bottom: 1px solid #e2e8f0;
}

.admin-order-item {
    padding: 20px;
    border-bottom: 1px solid #f1f5f9;
    transition: background-color 0.2s ease;
}

.admin-order-item:hover {
    background-color: #f8fafc;
}

.admin-order-item:last-child {
    border-bottom: none;
}

.admin-product-image {
    position: relative;
    width: 80px;
    height: 80px;
    border-radius: 8px;
    overflow: hidden;
    border: 1px solid #e2e8f0;
}

.admin-product-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.item-index {
    position: absolute;
    top: -5px;
    right: -5px;
    background: #667eea;
    color: white;
    font-size: 0.7rem;
    font-weight: bold;
    padding: 2px 6px;
    border-radius: 10px;
    min-width: 20px;
    text-align: center;
}

.admin-product-info .product-name a {
    color: #2d3748;
    text-decoration: none;
    font-weight: 600;
}

.admin-product-info .product-name a:hover {
    color: #667eea;
}

.product-meta {
    font-size: 0.85rem;
    color: #718096;
    margin: 5px 0;
}

.stock-status {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-top: 8px;
}

.current-price {
    font-size: 0.8rem;
    color: #4a5568;
}

.price-comparison .order-price {
    font-size: 1rem;
}

.quantity-number {
    font-size: 1.3rem;
    font-weight: bold;
    color: #2d3748;
}

.admin-subtotal {
    font-size: 1.1rem;
    font-weight: bold;
    color: #059669;
}

.item-actions .btn-xs {
    padding: 4px 8px;
    font-size: 0.7rem;
}

.timeline {
    position: relative;
}

.timeline::before {
    content: '';
    position: absolute;
    left: 20px;
    top: 0;
    bottom: 0;
    width: 2px;
    background: #e2e8f0;
}

.timeline-item {
    position: relative;
    padding-left: 50px;
    margin-bottom: 20px;
}

.timeline-marker {
    position: absolute;
    left: 14px;
    top: 5px;
    color: #667eea;
}

.timeline-content {
    background: #f8fafc;
    padding: 15px;
    border-radius: 8px;
    border-left: 3px solid #667eea;
}

.timeline-header {
    font-weight: 600;
    margin-bottom: 5px;
}

.timeline-time {
    font-size: 0.85rem;
    color: #718096;
}

.financial-breakdown .summary-row, .finance-row {
    display: flex;
    justify-content: space-between;
    margin-bottom: 8px;
    padding: 5px 0;
}

.summary-row.total {
    font-weight: bold;
    font-size: 1.2rem;
    color: #2d3748;
    border-top: 2px solid #e2e8f0;
    padding-top: 15px;
    margin-top: 15px;
}

.total-amount {
    color: #059669;
    font-size: 1.4rem;
}

.admin-finance-details {
    background: #f0f9ff;
    padding: 15px;
    border-radius: 8px;
    border: 1px solid #bae6fd;
}

.customer-profile, .shop-profile {
    font-size: 0.95rem;
}

.customer-header, .shop-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 15px;
}

.contact-item {
    display: flex;
    align-items: center;
    margin-bottom: 8px;
}

.contact-item a {
    color: #4a5568;
    text-decoration: none;
    flex: 1;
}

.contact-item a:hover {
    color: #667eea;
}

.address-display {
    background: #f8fafc;
    padding: 15px;
    border-radius: 8px;
    border-left: 4px solid #667eea;
}

.system-details .detail-row {
    display: flex;
    justify-content: space-between;
    margin-bottom: 8px;
    padding: 5px 0;
    font-size: 0.9rem;
}

.payment-badge {
    padding: 4px 8px;
    border-radius: 12px;
    font-size: 0.8rem;
    font-weight: 600;
}

.payment-paid { background: #d1fae5; color: #065f46; }
.payment-pending { background: #fef3c7; color: #92400e; }
.payment-failed { background: #fee2e2; color: #991b1b; }

/* Status Badge Colors */
.status-badge {
    padding: 8px 16px;
    border-radius: 25px;
    font-size: 0.9rem;
    font-weight: 600;
    text-transform: uppercase;
    display: inline-block;
}

.status-new { background: #fee2e2; color: #991b1b; }
.status-confirmed { background: #dbeafe; color: #1e40af; }
.status-processing { background: #fef3c7; color: #92400e; }
.status-shipping { background: #e0e7ff; color: #3730a3; }
.status-delivered { background: #d1fae5; color: #065f46; }
.status-cancelled { background: #fee2e2; color: #991b1b; }
.status-returned { background: #fef2f2; color: #b91c1c; }

/* Responsive Design */
@media (max-width: 768px) {
    .admin-order-header {
        text-align: center;
        padding: 30px 0;
    }
    
    .page-title {
        font-size: 2rem;
    }
    
    .admin-controls {
        text-align: center;
        margin-top: 20px;
    }
    
    .system-metric {
        margin-bottom: 15px;
    }
    
    .action-group {
        margin-bottom: 20px;
    }
    
    .admin-items-table .table-header {
        display: none;
    }
    
    .admin-order-item {
        border: 1px solid #e2e8f0;
        border-radius: 8px;
        margin-bottom: 15px;
    }
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    console.log('✅ Admin Order Detail UI loaded - 2025-10-24 23:40:59 UTC');
    console.log('👨‍💻 Created by: tuaanshuuysv');
    console.log('📂 Path: /WEB-INF/views/admin/order-detail.jsp');
    console.log('👑 Admin viewing order: ${order.order_number} | Status: ${order.order_status}');
});

// Admin status update
function adminUpdateStatus(newStatus) {
    document.getElementById('adminNewStatus').value = newStatus;
    const modal = new bootstrap.Modal(document.getElementById('adminStatusModal'));
    modal.show();
}

// Admin special actions
function adminCancelOrder() {
    const reason = prompt('Nhập lý do admin hủy đơn hàng:');
    if (reason && reason.trim()) {
        const confirmed = confirm(`⚠️ ADMIN ACTION\n\nBạn có chắc muốn HỦY đơn hàng với lý do:\n"${reason}"\n\nThao tác này sẽ được ghi log và không thể hoàn tác.`);
        if (confirmed) {
            // Implementation for admin cancel
            alert('Chức năng admin hủy đơn đang được phát triển...');
        }
    }
}

function adminReturnOrder() {
    const reason = prompt('Nhập lý do admin xử lý trả hàng:');
    if (reason && reason.trim()) {
        const confirmed = confirm(`⚠️ ADMIN ACTION\n\nBạn có chắc muốn XỬ LÝ TRẢ HÀNG với lý do:\n"${reason}"\n\nThao tác này sẽ được ghi log.`);
        if (confirmed) {
            // Implementation for admin return
            alert('Chức năng admin xử lý trả hàng đang được phát triển...');
        }
    }
}

function adminAddNote() {
    const note = prompt('Nhập ghi chú admin:');
    if (note && note.trim()) {
        // Implementation for adding admin note
        alert('Chức năng thêm ghi chú admin đang được phát triển...');
    }
}

// Analysis & Reports
function viewCustomerHistory() {
    window.open(`${pageContext.request.contextPath}/admin/customers/${order.customer_email}/orders`, '_blank');
}

function viewShopStats() {
    window.open(`${pageContext.request.contextPath}/admin/shops/${order.shop_id}/analytics`, '_blank');
}

function auditTrail() {
    window.open(`${pageContext.request.contextPath}/admin/audit/orders/${order.order_id}`, '_blank');
}

function systemReport() {
    alert('Chức năng báo cáo hệ thống đang được phát triển...');
}

// Product actions
function viewProductDetails(productId) {
    window.open(`${pageContext.request.contextPath}/admin/products/${productId}`, '_blank');
}

function checkProductStock(productId) {
    window.open(`${pageContext.request.contextPath}/admin/inventory/${productId}`, '_blank');
}

function checkInventory() {
    alert('Chức năng kiểm tra kho đang được phát triển...');
}

// Communication
function emailCustomer() {
    const email = '${order.customer_email}';
    const subject = 'Về đơn hàng ${order.order_number} - UTESHOP Admin';
    const body = `Xin chào ${order.customer_name},\n\nChúng tôi liên hệ về đơn hàng ${order.order_number}.\n\nTrân trọng,\nUTESHOP Admin Team`;
    window.open(`mailto:${email}?subject=${encodeURIComponent(subject)}&body=${encodeURIComponent(body)}`);
}

function callCustomer() {
    window.open(`tel:${order.customer_phone}`);
}

function callShop() {
    window.open(`tel:${order.shop_phone}`);
}

function adminContactShop() {
    alert('Chức năng liên hệ shop từ admin đang được phát triển...');
}

function contactShop() {
    alert('Chức năng nhắn tin shop đang được phát triển...');
}

// Map and location
function viewOnMap() {
    const address = encodeURIComponent('${order.shipping_address}');
    window.open(`https://www.google.com/maps/search/?api=1&query=${address}`, '_blank');
}

// Export and sharing
function exportOrderDetails() {
    alert('Chức năng xuất PDF đang được phát triển...');
}

function exportOrderData() {
    alert('Chức năng xuất Excel đang được phát triển...');
}

function printAdminOrder() {
    window.print();
}

function shareOrderLink() {
    const url = window.location.href;
    navigator.clipboard.writeText(url).then(function() {
        alert('Đã copy link đơn hàng!');
    });
}

// Other functions
function viewOrderLogs() {
    window.open(`${pageContext.request.contextPath}/admin/logs/orders/${order.order_id}`, '_blank');
}

function viewShopProfile() {
    window.open(`${pageContext.request.contextPath}/admin/shops/${order.shop_id}`, '_blank');
}
</script>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- UTESHOP Vendor Order Detail - VENDOR FOLDER -->
<!-- Created: 2025-10-24 23:36:50 UTC by tuaanshuuysv -->
<!-- Path: /WEB-INF/views/vendor/order-detail.jsp -->

<div class="vendor-order-detail-page">
    
    <!-- Order Header -->
    <div class="vendor-order-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="page-title">
                        <i class="fas fa-receipt me-2"></i>
                        Chi tiết đơn hàng #${order.order_number}
                    </h1>
                    <div class="order-meta">
                        <span class="order-date">
                            <i class="fas fa-calendar me-1"></i>
                            Đặt ngày: <fmt:formatDate value="${order.created_at}" pattern="dd/MM/yyyy HH:mm"/>
                        </span>
                        <span class="shop-info ms-3">
                            <i class="fas fa-store me-1"></i>
                            ${order.shop_name}
                        </span>
                    </div>
                </div>
                <div class="col-md-4 text-end">
                    <div class="order-status-display">
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
                        <div class="order-amount mt-2">
                            <span class="amount">${order.total_amount}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Vendor Order Progress -->
    <div class="container mt-4">
        <div class="vendor-progress-card">
            <h5 class="mb-3">
                <i class="fas fa-tasks me-2"></i>Quy trình xử lý đơn hàng
            </h5>
            <div class="vendor-order-progress">
                <div class="progress-step ${order.order_status == 'NEW' || order.order_status == 'CONFIRMED' || order.order_status == 'PROCESSING' || order.order_status == 'SHIPPING' || order.order_status == 'DELIVERED' ? 'completed' : ''}">
                    <div class="step-icon">
                        <i class="fas fa-plus-circle"></i>
                    </div>
                    <div class="step-info">
                        <h6>Đơn hàng mới</h6>
                        <p><fmt:formatDate value="${order.created_at}" pattern="dd/MM HH:mm"/></p>
                        <c:if test="${order.order_status == 'NEW'}">
                            <button class="btn btn-success btn-sm mt-2" onclick="updateOrderStatus('CONFIRMED')">
                                <i class="fas fa-check me-1"></i>Xác nhận ngay
                            </button>
                        </c:if>
                    </div>
                </div>
                
                <div class="progress-step ${order.order_status == 'CONFIRMED' || order.order_status == 'PROCESSING' || order.order_status == 'SHIPPING' || order.order_status == 'DELIVERED' ? 'completed' : order.order_status == 'NEW' ? 'next' : ''}">
                    <div class="step-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="step-info">
                        <h6>Xác nhận đơn</h6>
                        <p>Kiểm tra và xác nhận</p>
                        <c:if test="${order.order_status == 'CONFIRMED'}">
                            <button class="btn btn-info btn-sm mt-2" onclick="updateOrderStatus('PROCESSING')">
                                <i class="fas fa-cogs me-1"></i>Bắt đầu xử lý
                            </button>
                        </c:if>
                    </div>
                </div>
                
                <div class="progress-step ${order.order_status == 'PROCESSING' || order.order_status == 'SHIPPING' || order.order_status == 'DELIVERED' ? 'completed' : order.order_status == 'CONFIRMED' ? 'next' : ''}">
                    <div class="step-icon">
                        <i class="fas fa-cogs"></i>
                    </div>
                    <div class="step-info">
                        <h6>Đang xử lý</h6>
                        <p>Chuẩn bị và đóng gói</p>
                        <c:if test="${order.order_status == 'PROCESSING'}">
                            <button class="btn btn-warning btn-sm mt-2" onclick="showShippingModal()">
                                <i class="fas fa-truck me-1"></i>Giao cho shipper
                            </button>
                        </c:if>
                    </div>
                </div>
                
                <div class="progress-step ${order.order_status == 'SHIPPING' || order.order_status == 'DELIVERED' ? 'completed' : order.order_status == 'PROCESSING' ? 'next' : ''}">
                    <div class="step-icon">
                        <i class="fas fa-truck"></i>
                    </div>
                    <div class="step-info">
                        <h6>Đang giao hàng</h6>
                        <p>
                            <c:if test="${not empty order.tracking_number}">
                                Mã vận đơn: <strong>${order.tracking_number}</strong>
                            </c:if>
                        </p>
                        <c:if test="${order.order_status == 'SHIPPING'}">
                            <button class="btn btn-primary btn-sm mt-2" onclick="updateOrderStatus('DELIVERED')">
                                <i class="fas fa-check-double me-1"></i>Đã giao xong
                            </button>
                        </c:if>
                    </div>
                </div>
                
                <div class="progress-step ${order.order_status == 'DELIVERED' ? 'completed' : order.order_status == 'SHIPPING' ? 'next' : ''}">
                    <div class="step-icon">
                        <i class="fas fa-home"></i>
                    </div>
                    <div class="step-info">
                        <h6>Hoàn thành</h6>
                        <p>
                            <c:if test="${order.order_status == 'DELIVERED' && not empty order.delivered_at}">
                                <fmt:formatDate value="${order.delivered_at}" pattern="dd/MM HH:mm"/>
                            </c:if>
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container mt-4">
        <div class="row">
            <!-- Order Items -->
            <div class="col-lg-8">
                <div class="vendor-order-items-card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-box me-2"></i>
                            Sản phẩm trong đơn hàng (${orderItems.size()} sản phẩm)
                        </h5>
                    </div>
                    <div class="card-body p-0">
                        <c:forEach var="item" items="${orderItems}">
                            <div class="vendor-order-item">
                                <div class="row align-items-center">
                                    <div class="col-md-2">
                                        <div class="product-image">
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
                                        </div>
                                    </div>
                                    <div class="col-md-5">
                                        <div class="product-info">
                                            <h6 class="product-name">
                                                <a href="${pageContext.request.contextPath}/vendor/products/${item.product_id}">
                                                    ${item.product_name}
                                                </a>
                                            </h6>
                                            <c:if test="${not empty item.selected_attributes}">
                                                <div class="product-attributes">
                                                    <small class="text-muted">
                                                        Thuộc tính: ${item.selected_attributes}
                                                    </small>
                                                </div>
                                            </c:if>
                                            <div class="product-sku">
                                                <small class="text-muted">SKU: ${item.product_id}</small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2 text-center">
                                        <div class="product-price">
                                            <span class="price">${item.product_price}</span>
                                        </div>
                                    </div>
                                    <div class="col-md-1 text-center">
                                        <div class="product-quantity">
                                            <span class="quantity">x${item.quantity}</span>
                                        </div>
                                    </div>
                                    <div class="col-md-2 text-end">
                                        <div class="product-total">
                                            <span class="total">${item.subtotal}</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>

                <!-- Vendor Order Actions -->
                <div class="vendor-order-actions-card mt-4">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-tools me-2"></i>Thao tác đơn hàng
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <div class="action-group">
                                    <h6>Cập nhật trạng thái:</h6>
                                    <div class="d-flex gap-2 flex-wrap">
                                        <c:if test="${order.order_status == 'NEW'}">
                                            <button type="button" class="btn btn-success" onclick="updateOrderStatus('CONFIRMED')">
                                                <i class="fas fa-check me-1"></i>Xác nhận đơn
                                            </button>
                                        </c:if>
                                        
                                        <c:if test="${order.order_status == 'CONFIRMED'}">
                                            <button type="button" class="btn btn-info" onclick="updateOrderStatus('PROCESSING')">
                                                <i class="fas fa-cogs me-1"></i>Bắt đầu xử lý
                                            </button>
                                        </c:if>
                                        
                                        <c:if test="${order.order_status == 'PROCESSING'}">
                                            <button type="button" class="btn btn-warning" onclick="showShippingModal()">
                                                <i class="fas fa-truck me-1"></i>Giao cho shipper
                                            </button>
                                        </c:if>
                                        
                                        <c:if test="${order.order_status == 'SHIPPING'}">
                                            <button type="button" class="btn btn-primary" onclick="updateOrderStatus('DELIVERED')">
                                                <i class="fas fa-check-double me-1"></i>Đã giao xong
                                            </button>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="action-group">
                                    <h6>Khác:</h6>
                                    <div class="d-flex gap-2 flex-wrap">
                                        <a href="${pageContext.request.contextPath}/vendor/orders" class="btn btn-outline-secondary">
                                            <i class="fas fa-arrow-left me-1"></i>Quay lại
                                        </a>
                                        
                                        <button type="button" class="btn btn-outline-info" onclick="printOrder()">
                                            <i class="fas fa-print me-1"></i>In đơn hàng
                                        </button>
                                        
                                        <button type="button" class="btn btn-outline-primary" onclick="contactCustomer()">
                                            <i class="fas fa-phone me-1"></i>Liên hệ KH
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Order Details Sidebar -->
            <div class="col-lg-4">
                <!-- Customer Information -->
                <div class="customer-info-card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-user me-2"></i>
                            Thông tin khách hàng
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="customer-details">
                            <div class="customer-name">
                                <strong>${order.customer_name}</strong>
                            </div>
                            <div class="customer-contact">
                                <div class="mb-2">
                                    <i class="fas fa-envelope me-2"></i>
                                    <a href="mailto:${order.customer_email}">${order.customer_email}</a>
                                </div>
                                <div class="mb-2">
                                    <i class="fas fa-phone me-2"></i>
                                    <a href="tel:${order.customer_phone}">${order.customer_phone}</a>
                                </div>
                            </div>
                            <div class="shipping-address mt-3">
                                <h6>Địa chỉ giao hàng:</h6>
                                <div class="address-info">
                                    <c:set var="address" value="${order.shipping_address}" />
                                    <p class="mb-0">${address}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Order Summary -->
                <div class="vendor-order-summary-card mt-4">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-calculator me-2"></i>
                            Tổng kết đơn hàng
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="summary-row">
                            <span>Tạm tính:</span>
                            <span>${order.subtotal}</span>
                        </div>
                        <div class="summary-row">
                            <span>Giảm giá:</span>
                            <span class="text-success">-${order.discount_amount}</span>
                        </div>
                        <div class="summary-row">
                            <span>Phí vận chuyển:</span>
                            <span>${order.shipping_fee}</span>
                        </div>
                        <hr>
                        <div class="summary-row total">
                            <span>Tổng cộng:</span>
                            <span class="total-amount">${order.total_amount}</span>
                        </div>
                        
                        <div class="vendor-commission mt-3 pt-3 border-top">
                            <div class="summary-row">
                                <span>Doanh thu shop:</span>
                                <span class="text-success fw-bold">${order.total_amount}</span>
                            </div>
                            <small class="text-muted">
                                *Phí hoa hồng sẽ được trừ khi thanh toán
                            </small>
                        </div>
                    </div>
                </div>

                <!-- Payment & Shipping Info -->
                <div class="payment-shipping-info-card mt-4">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-info-circle me-2"></i>
                            Thông tin thanh toán & vận chuyển
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="payment-info">
                            <h6>Thanh toán:</h6>
                            <div class="payment-method">
                                <strong>Phương thức:</strong>
                                <span class="ms-2">
                                    <c:choose>
                                        <c:when test="${order.payment_method == 'COD'}">Thu hộ (COD)</c:when>
                                        <c:when test="${order.payment_method == 'VNPAY'}">VNPay</c:when>
                                        <c:when test="${order.payment_method == 'MOMO'}">MoMo</c:when>
                                        <c:when test="${order.payment_method == 'BANK_TRANSFER'}">Chuyển khoản</c:when>
                                        <c:otherwise>${order.payment_method}</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                            <div class="payment-status mt-2">
                                <strong>Trạng thái:</strong>
                                <span class="payment-badge payment-${order.payment_status.toLowerCase()} ms-2">
                                    <c:choose>
                                        <c:when test="${order.payment_status == 'PENDING'}">Chờ thanh toán</c:when>
                                        <c:when test="${order.payment_status == 'PAID'}">Đã thanh toán</c:when>
                                        <c:when test="${order.payment_status == 'FAILED'}">Thất bại</c:when>
                                        <c:when test="${order.payment_status == 'REFUNDED'}">Đã hoàn tiền</c:when>
                                        <c:otherwise>${order.payment_status}</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        
                        <div class="shipping-info mt-3">
                            <h6>Vận chuyển:</h6>
                            <c:if test="${not empty order.carrier_name}">
                                <div class="carrier-info">
                                    <strong>Đơn vị:</strong>
                                    <span class="ms-2">${order.carrier_name}</span>
                                </div>
                            </c:if>
                            
                            <c:if test="${not empty order.tracking_number}">
                                <div class="tracking-info mt-2">
                                    <strong>Mã vận đơn:</strong>
                                    <span class="ms-2 fw-bold text-primary">${order.tracking_number}</span>
                                    <button type="button" class="btn btn-outline-primary btn-sm ms-2" onclick="copyTrackingNumber()">
                                        <i class="fas fa-copy"></i>
                                    </button>
                                </div>
                            </c:if>
                            
                            <c:if test="${empty order.tracking_number && order.order_status == 'SHIPPING'}">
                                <div class="mt-2">
                                    <button type="button" class="btn btn-outline-warning btn-sm" onclick="addTrackingNumber()">
                                        <i class="fas fa-plus me-1"></i>Thêm mã vận đơn
                                    </button>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Shipping Modal -->
<div class="modal fade" id="shippingModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-truck me-2"></i>
                    Giao cho đơn vị vận chuyển
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form id="shippingForm" method="POST" action="${pageContext.request.contextPath}/vendor/orders">
                <div class="modal-body">
                    <input type="hidden" name="action" value="update-status">
                    <input type="hidden" name="order_id" value="${order.order_id}">
                    <input type="hidden" name="new_status" value="SHIPPING">
                    
                    <div class="mb-3">
                        <label for="trackingNumber" class="form-label">Mã vận đơn</label>
                        <input type="text" name="tracking_number" id="trackingNumber" class="form-control" 
                               placeholder="Nhập mã vận đơn từ shipper">
                    </div>
                    
                    <div class="mb-3">
                        <label for="shippingNotes" class="form-label">Ghi chú giao hàng</label>
                        <textarea name="notes" id="shippingNotes" class="form-control" rows="3" 
                                  placeholder="Ghi chú cho shipper (tùy chọn)"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Hủy
                    </button>
                    <button type="submit" class="btn btn-warning">
                        <i class="fas fa-truck me-1"></i>Giao cho shipper
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Hidden form for status updates -->
<form id="statusUpdateForm" method="POST" action="${pageContext.request.contextPath}/vendor/orders" style="display: none;">
    <input type="hidden" name="action" value="update-status">
    <input type="hidden" name="order_id" value="${order.order_id}">
    <input type="hidden" name="new_status" id="newStatusValue">
    <input type="hidden" name="notes" id="statusNotes">
</form>

<style>
/* Vendor Order Detail Styles */
.vendor-order-detail-page {
    background: #f8fafc;
    min-height: calc(100vh - 120px);
}

.vendor-order-header {
    background: linear-gradient(135deg, #16a085 0%, #f4d03f 100%);
    color: white;
    padding: 40px 0;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.page-title {
    font-size: 2.2rem;
    font-weight: bold;
    margin-bottom: 15px;
}

.order-meta {
    font-size: 1rem;
    opacity: 0.9;
}

.order-status-display {
    text-align: center;
}

.status-badge {
    padding: 8px 16px;
    border-radius: 25px;
    font-size: 0.9rem;
    font-weight: 600;
    text-transform: uppercase;
    display: inline-block;
}

.order-amount .amount {
    font-size: 1.8rem;
    font-weight: bold;
    color: white;
}

.vendor-progress-card, .vendor-order-items-card, .vendor-order-actions-card, 
.customer-info-card, .vendor-order-summary-card, .payment-shipping-info-card {
    background: white;
    border-radius: 12px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    border: 1px solid #e5e7eb;
    overflow: hidden;
}

.card-header {
    background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
    border-bottom: 2px solid #e5e7eb;
    padding: 20px 25px;
}

.card-body {
    padding: 25px;
}

.vendor-order-progress {
    display: flex;
    justify-content: space-between;
    position: relative;
    margin-top: 20px;
}

.vendor-order-progress::before {
    content: '';
    position: absolute;
    top: 30px;
    left: 60px;
    right: 60px;
    height: 2px;
    background: #e5e7eb;
    z-index: 1;
}

.progress-step {
    display: flex;
    flex-direction: column;
    align-items: center;
    flex: 1;
    position: relative;
    z-index: 2;
}

.step-icon {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    background: #e5e7eb;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 1.5rem;
    color: #9ca3af;
    transition: all 0.3s ease;
    margin-bottom: 15px;
}

.progress-step.completed .step-icon {
    background: linear-gradient(135deg, #16a085 0%, #f4d03f 100%);
    color: white;
}

.progress-step.next .step-icon {
    background: #fef3c7;
    color: #92400e;
    border: 2px solid #f59e0b;
}

.step-info {
    text-align: center;
}

.step-info h6 {
    font-weight: 600;
    margin-bottom: 5px;
    color: #374151;
}

.step-info p {
    font-size: 0.85rem;
    color: #6b7280;
    margin: 0;
}

.vendor-order-item {
    padding: 20px 25px;
    border-bottom: 1px solid #f3f4f6;
}

.vendor-order-item:last-child {
    border-bottom: none;
}

.product-image {
    width: 80px;
    height: 80px;
    border-radius: 8px;
    overflow: hidden;
    border: 1px solid #e5e7eb;
}

.product-image img {
    width: 100%;
    height: 100%;
    object-fit: cover;
}

.no-image {
    width: 100%;
    height: 100%;
    background: #f3f4f6;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #9ca3af;
    font-size: 1.5rem;
}

.product-name {
    font-weight: 600;
    margin-bottom: 8px;
}

.product-name a {
    color: #1f2937;
    text-decoration: none;
}

.product-name a:hover {
    color: #16a085;
}

.product-attributes, .product-sku {
    margin-bottom: 4px;
}

.product-price .price {
    font-weight: 600;
    color: #059669;
}

.product-quantity .quantity {
    font-size: 1.1rem;
    font-weight: 600;
    color: #374151;
}

.product-total .total {
    font-size: 1.2rem;
    font-weight: bold;
    color: #059669;
}

.action-group h6 {
    color: #374151;
    margin-bottom: 10px;
}

.customer-details .customer-name {
    font-size: 1.1rem;
    margin-bottom: 10px;
}

.customer-contact a {
    color: #16a085;
    text-decoration: none;
}

.customer-contact a:hover {
    text-decoration: underline;
}

.address-info {
    background: #f8fafc;
    padding: 15px;
    border-radius: 8px;
    border-left: 4px solid #16a085;
}

.summary-row {
    display: flex;
    justify-content: space-between;
    margin-bottom: 10px;
    padding: 5px 0;
}

.summary-row.total {
    font-weight: bold;
    font-size: 1.1rem;
    color: #1f2937;
    border-top: 2px solid #e5e7eb;
    padding-top: 15px;
    margin-top: 15px;
}

.total-amount {
    color: #16a085;
    font-size: 1.3rem;
}

.vendor-commission {
    background: #f0f9ff;
    padding: 15px;
    border-radius: 8px;
    border: 1px solid #bae6fd;
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
.status-new { background: #fee2e2; color: #991b1b; }
.status-confirmed { background: #dbeafe; color: #1e40af; }
.status-processing { background: #fef3c7; color: #92400e; }
.status-shipping { background: #e0e7ff; color: #3730a3; }
.status-delivered { background: #d1fae5; color: #065f46; }
.status-cancelled { background: #fee2e2; color: #991b1b; }
.status-returned { background: #fef2f2; color: #b91c1c; }

/* Responsive Design */
@media (max-width: 768px) {
    .vendor-order-header {
        text-align: center;
        padding: 30px 0;
    }
    
    .page-title {
        font-size: 1.8rem;
    }
    
    .vendor-order-progress {
        flex-direction: column;
        gap: 20px;
    }
    
    .vendor-order-progress::before {
        display: none;
    }
    
    .progress-step {
        flex-direction: row;
        text-align: left;
        gap: 15px;
    }
    
    .step-info {
        text-align: left;
    }
    
    .action-group {
        margin-bottom: 20px;
    }
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    console.log('✅ Vendor Order Detail UI loaded - 2025-10-24 23:36:50 UTC');
    console.log('👨‍💻 Created by: tuaanshuuysv');
    console.log('📂 Path: /WEB-INF/views/vendor/order-detail.jsp');
    console.log('🏪 Order: ${order.order_number} | Status: ${order.order_status}');
});

// Update order status
function updateOrderStatus(newStatus) {
    const statusNames = {
        'CONFIRMED': 'xác nhận đơn hàng',
        'PROCESSING': 'chuyển sang xử lý',
        'DELIVERED': 'đánh dấu đã giao xong'
    };
    
    const confirmed = confirm(`Bạn có chắc muốn ${statusNames[newStatus]}?`);
    if (confirmed) {
        document.getElementById('newStatusValue').value = newStatus;
        document.getElementById('statusNotes').value = `Cập nhật trạng thái: ${statusNames[newStatus]}`;
        document.getElementById('statusUpdateForm').submit();
    }
}

// Show shipping modal
function showShippingModal() {
    const modal = new bootstrap.Modal(document.getElementById('shippingModal'));
    modal.show();
}

// Print order
function printOrder() {
    window.print();
}

// Contact customer
function contactCustomer() {
    const phone = '${order.customer_phone}';
    const email = '${order.customer_email}';
    
    const action = confirm(`Liên hệ khách hàng:\n\n📞 Gọi điện: ${phone}\n📧 Email: ${email}\n\nChọn OK để gọi điện, Cancel để gửi email`);
    
    if (action) {
        window.open(`tel:${phone}`);
    } else {
        window.open(`mailto:${email}?subject=Về đơn hàng ${order.order_number}&body=Xin chào ${order.customer_name},\n\nChúng tôi liên hệ về đơn hàng ${order.order_number}.\n\nTrân trọng,\n${order.shop_name}`);
    }
}

// Copy tracking number
function copyTrackingNumber() {
    const trackingNumber = '${order.tracking_number}';
    navigator.clipboard.writeText(trackingNumber).then(function() {
        alert('Đã copy mã vận đơn: ' + trackingNumber);
    });
}

// Add tracking number
function addTrackingNumber() {
    const trackingNumber = prompt('Nhập mã vận đơn:');
    if (trackingNumber && trackingNumber.trim()) {
        // Implementation for adding tracking number
        alert('Chức năng thêm mã vận đơn đang được phát triển...');
    }
}
</script>
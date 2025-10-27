<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- UTESHOP User Order Detail - USER FOLDER -->
<!-- Created: 2025-10-25 01:12:30 UTC by tuaanshuuysv -->
<!-- Path: /WEB-INF/views/user/order-detail.jsp -->

<div class="user-order-detail-page">
    
    <!-- Order Header -->
    <div class="order-detail-header">
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
                                <c:when test="${order.order_status == 'NEW'}">Mới</c:when>
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

    <!-- Order Progress Tracking -->
    <div class="container mt-4">
        <div class="progress-card">
            <h5 class="mb-3">
                <i class="fas fa-truck me-2"></i>Trạng thái đơn hàng
            </h5>
            <div class="order-progress">
                <div class="progress-step ${order.order_status == 'NEW' || order.order_status == 'CONFIRMED' || order.order_status == 'PROCESSING' || order.order_status == 'SHIPPING' || order.order_status == 'DELIVERED' ? 'completed' : ''}">
                    <div class="step-icon">
                        <i class="fas fa-shopping-cart"></i>
                    </div>
                    <div class="step-info">
                        <h6>Đặt hàng</h6>
                        <p><fmt:formatDate value="${order.created_at}" pattern="dd/MM HH:mm"/></p>
                    </div>
                </div>
                
                <div class="progress-step ${order.order_status == 'CONFIRMED' || order.order_status == 'PROCESSING' || order.order_status == 'SHIPPING' || order.order_status == 'DELIVERED' ? 'completed' : ''}">
                    <div class="step-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="step-info">
                        <h6>Xác nhận</h6>
                        <p>Shop đã xác nhận</p>
                    </div>
                </div>
                
                <div class="progress-step ${order.order_status == 'PROCESSING' || order.order_status == 'SHIPPING' || order.order_status == 'DELIVERED' ? 'completed' : ''}">
                    <div class="step-icon">
                        <i class="fas fa-box"></i>
                    </div>
                    <div class="step-info">
                        <h6>Đóng gói</h6>
                        <p>Đang chuẩn bị hàng</p>
                    </div>
                </div>
                
                <div class="progress-step ${order.order_status == 'SHIPPING' || order.order_status == 'DELIVERED' ? 'completed' : ''}">
                    <div class="step-icon">
                        <i class="fas fa-truck"></i>
                    </div>
                    <div class="step-info">
                        <h6>Vận chuyển</h6>
                        <p>
                            <c:if test="${not empty order.tracking_number}">
                                Mã vận đơn: ${order.tracking_number}
                            </c:if>
                        </p>
                    </div>
                </div>
                
                <div class="progress-step ${order.order_status == 'DELIVERED' ? 'completed' : ''}">
                    <div class="step-icon">
                        <i class="fas fa-home"></i>
                    </div>
                    <div class="step-info">
                        <h6>Đã giao</h6>
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
                <div class="order-items-card">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-box me-2"></i>
                            Sản phẩm trong đơn hàng (${orderItems.size()} sản phẩm)
                        </h5>
                    </div>
                    <div class="card-body p-0">
                        <c:forEach var="item" items="${orderItems}">
                            <div class="order-item">
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
                                    <div class="col-md-6">
                                        <div class="product-info">
                                            <h6 class="product-name">
                                                <a href="${pageContext.request.contextPath}/products/${item.product_id}">
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
                                            <div class="product-price">
                                                Giá: <span class="price">${item.product_price}</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2 text-center">
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

                <!-- Order Actions -->
                <div class="order-actions-card mt-4">
                    <div class="card-body">
                        <div class="d-flex gap-2 flex-wrap">
                            <a href="${pageContext.request.contextPath}/user/orders" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-1"></i>Quay lại danh sách
                            </a>
                            
                            <c:if test="${canCancel}">
                                <button type="button" class="btn btn-outline-danger" 
                                        onclick="showCancelModal('${order.order_id}', '${order.order_number}')">
                                    <i class="fas fa-times me-1"></i>Hủy đơn hàng
                                </button>
                            </c:if>
                            
                            <c:if test="${canReturn}">
                                <button type="button" class="btn btn-outline-warning" 
                                        onclick="showReturnModal('${order.order_id}', '${order.order_number}')">
                                    <i class="fas fa-undo me-1"></i>Yêu cầu trả hàng
                                </button>
                            </c:if>
                            
                            <c:if test="${order.order_status == 'DELIVERED'}">
                                <a href="${pageContext.request.contextPath}/products/${orderItems[0].product_id}/review?order_id=${order.order_id}" 
                                   class="btn btn-primary">
                                    <i class="fas fa-star me-1"></i>Đánh giá sản phẩm
                                </a>
                            </c:if>
                            
                            <button type="button" class="btn btn-outline-info" onclick="contactShop()">
                                <i class="fas fa-phone me-1"></i>Liên hệ Shop
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Order Summary -->
            <div class="col-lg-4">
                <!-- Order Summary Card -->
                <div class="order-summary-card">
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
                    </div>
                </div>

                <!-- Payment Info Card -->
                <div class="payment-info-card mt-4">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-credit-card me-2"></i>
                            Thông tin thanh toán
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="payment-method">
                            <strong>Phương thức:</strong>
                            <span class="ms-2">
                                <c:choose>
                                    <c:when test="${order.payment_method == 'COD'}">Thanh toán khi nhận hàng</c:when>
                                    <c:when test="${order.payment_method == 'VNPAY'}">VNPay</c:when>
                                    <c:when test="${order.payment_method == 'MOMO'}">MoMo</c:when>
                                    <c:when test="${order.payment_method == 'BANK_TRANSFER'}">Chuyển khoản ngân hàng</c:when>
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
                </div>

                <!-- Shipping Info Card -->
                <div class="shipping-info-card mt-4">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-truck me-2"></i>
                            Thông tin giao hàng
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty order.shipping_address}">
                            <div class="shipping-address">
                                <strong>Địa chỉ giao hàng:</strong>
                                <div class="address-info mt-2">
                                    <p class="mb-1">
                                        <i class="fas fa-user me-1"></i>
                                        ${order.customer_name}
                                    </p>
                                    <p class="mb-1">
                                        <i class="fas fa-phone me-1"></i>
                                        ${order.customer_phone}
                                    </p>
                                    <p class="mb-0">
                                        <i class="fas fa-map-marker-alt me-1"></i>
                                        ${order.shipping_address}
                                    </p>
                                </div>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty order.carrier_name}">
                            <div class="carrier-info mt-3">
                                <strong>Đơn vị vận chuyển:</strong>
                                <span class="ms-2">${order.carrier_name}</span>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty order.tracking_number}">
                            <div class="tracking-info mt-2">
                                <strong>Mã vận đơn:</strong>
                                <span class="ms-2 fw-bold text-primary">${order.tracking_number}</span>
                                <button type="button" class="btn btn-outline-primary btn-sm ms-2" onclick="trackPackage()">
                                    <i class="fas fa-search me-1"></i>Tra cứu
                                </button>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Shop Info Card -->
                <div class="shop-info-card mt-4">
                    <div class="card-header">
                        <h5 class="mb-0">
                            <i class="fas fa-store me-2"></i>
                            Thông tin Shop
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="shop-details">
                            <h6>${order.shop_name}</h6>
                            <c:if test="${not empty order.shop_phone}">
                                <div class="shop-contact">
                                    <i class="fas fa-phone me-2"></i>
                                    <a href="tel:${order.shop_phone}">${order.shop_phone}</a>
                                </div>
                            </c:if>
                            
                            <div class="shop-actions mt-3">
                                <button type="button" class="btn btn-outline-primary btn-sm" onclick="viewShop()">
                                    <i class="fas fa-store me-1"></i>Xem Shop
                                </button>
                                <button type="button" class="btn btn-outline-success btn-sm" onclick="contactShop()">
                                    <i class="fas fa-comment me-1"></i>Chat với Shop
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Cancel Order Modal -->
<div class="modal fade" id="cancelOrderModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-times-circle text-danger me-2"></i>
                    Hủy đơn hàng
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/orders">
                <div class="modal-body">
                    <input type="hidden" name="action" value="cancel-order">
                    <input type="hidden" name="order_id" id="cancelOrderId" value="${order.order_id}">
                    
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Bạn có chắc chắn muốn hủy đơn hàng <strong id="cancelOrderNumber">${order.order_number}</strong>?
                    </div>
                    
                    <div class="mb-3">
                        <label for="cancelReason" class="form-label">Lý do hủy đơn <span class="text-danger">*</span></label>
                        <select name="cancel_reason" id="cancelReason" class="form-select" required>
                            <option value="">Chọn lý do</option>
                            <option value="Đổi ý không muốn mua nữa">Đổi ý không muốn mua nữa</option>
                            <option value="Tìm được giá rẻ hơn ở nơi khác">Tìm được giá rẻ hơn ở nơi khác</option>
                            <option value="Đặt nhầm sản phẩm">Đặt nhầm sản phẩm</option>
                            <option value="Shop phản hồi chậm">Shop phản hồi chậm</option>
                            <option value="Khác">Khác</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Đóng
                    </button>
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-times-circle me-1"></i>Xác nhận hủy
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Return Order Modal -->
<div class="modal fade" id="returnOrderModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-undo text-warning me-2"></i>
                    Yêu cầu trả hàng
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/orders">
                <div class="modal-body">
                    <input type="hidden" name="action" value="return-order">
                    <input type="hidden" name="order_id" id="returnOrderId" value="${order.order_id}">
                    
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        Yêu cầu trả hàng cho đơn <strong id="returnOrderNumber">${order.order_number}</strong>
                    </div>
                    
                    <div class="mb-3">
                        <label for="returnReason" class="form-label">Lý do trả hàng <span class="text-danger">*</span></label>
                        <select name="return_reason" id="returnReason" class="form-select" required>
                            <option value="">Chọn lý do</option>
                            <option value="Sản phẩm bị lỗi/hỏng">Sản phẩm bị lỗi/hỏng</option>
                            <option value="Sản phẩm không đúng mô tả">Sản phẩm không đúng mô tả</option>
                            <option value="Sản phẩm không vừa size">Sản phẩm không vừa size</option>
                            <option value="Nhận được sai sản phẩm">Nhận được sai sản phẩm</option>
                            <option value="Chất lượng không như mong đợi">Chất lượng không như mong đợi</option>
                            <option value="Khác">Khác</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-1"></i>Đóng
                    </button>
                    <button type="submit" class="btn btn-warning">
                        <i class="fas fa-undo me-1"></i>Gửi yêu cầu
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<style>
/* User Order Detail Styles */
.user-order-detail-page {
    background: #f8fafc;
    min-height: calc(100vh - 120px);
}

.order-detail-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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

.progress-card, .order-items-card, .order-actions-card, 
.order-summary-card, .payment-info-card, .shipping-info-card, .shop-info-card {
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

.order-progress {
    display: flex;
    justify-content: space-between;
    position: relative;
    margin-top: 20px;
}

.order-progress::before {
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
    background: linear-gradient(135deg, #10b981 0%, #059669 100%);
    color: white;
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

.order-item {
    padding: 20px 25px;
    border-bottom: 1px solid #f3f4f6;
}

.order-item:last-child {
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
    color: #667eea;
}

.product-attributes {
    margin-bottom: 8px;
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
    color: #059669;
    font-size: 1.3rem;
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

.address-info {
    background: #f8fafc;
    padding: 15px;
    border-radius: 8px;
    border-left: 4px solid #667eea;
}

.shop-contact a {
    color: #667eea;
    text-decoration: none;
}

.shop-contact a:hover {
    text-decoration: underline;
}

/* Status Badge Colors */
.status-new { background: #fef3c7; color: #92400e; }
.status-confirmed { background: #dbeafe; color: #1e40af; }
.status-processing { background: #e0e7ff; color: #3730a3; }
.status-shipping { background: #cffafe; color: #0f766e; }
.status-delivered { background: #d1fae5; color: #065f46; }
.status-cancelled { background: #fee2e2; color: #991b1b; }
.status-returned { background: #fef2f2; color: #b91c1c; }

/* Responsive Design */
@media (max-width: 768px) {
    .order-detail-header {
        text-align: center;
        padding: 30px 0;
    }
    
    .page-title {
        font-size: 1.8rem;
    }
    
    .order-progress {
        flex-direction: column;
        gap: 20px;
    }
    
    .order-progress::before {
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
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    console.log('✅ User Order Detail UI loaded - 2025-10-25 01:12:30 UTC');
    console.log('👨‍💻 Created by: tuaanshuuysv');
    console.log('📂 Path: /WEB-INF/views/user/order-detail.jsp');
    console.log('👤 Order: ${order.order_number} | Status: ${order.order_status}');
});

// Show cancel order modal
function showCancelModal(orderId, orderNumber) {
    document.getElementById('cancelOrderId').value = orderId;
    document.getElementById('cancelOrderNumber').textContent = orderNumber;
    
    const modal = new bootstrap.Modal(document.getElementById('cancelOrderModal'));
    modal.show();
}

// Show return order modal
function showReturnModal(orderId, orderNumber) {
    document.getElementById('returnOrderId').value = orderId;
    document.getElementById('returnOrderNumber').textContent = orderNumber;
    
    const modal = new bootstrap.Modal(document.getElementById('returnOrderModal'));
    modal.show();
}

// Track package
function trackPackage() {
    const trackingNumber = '${order.tracking_number}';
    if (trackingNumber) {
        // Open tracking page in new window
        window.open(`https://www.google.com/search?q=tra+cứu+vận+đơn+${encodeURIComponent(trackingNumber)}`, '_blank');
    } else {
        alert('Chưa có mã vận đơn để tra cứu!');
    }
}

// Contact shop
function contactShop() {
    const shopPhone = '${order.shop_phone}';
    const shopName = '${order.shop_name}';
    const orderNumber = '${order.order_number}';
    
    if (shopPhone) {
        const confirmed = confirm(`Gọi điện cho ${shopName}?\nSố điện thoại: ${shopPhone}`);
        if (confirmed) {
            window.open(`tel:${shopPhone}`);
        }
    } else {
        alert('Thông tin liên hệ shop chưa có sẵn. Vui lòng thử lại sau!');
    }
}

// View shop
function viewShop() {
    const shopId = '${order.shop_id}';
    if (shopId) {
        window.open(`${pageContext.request.contextPath}/shops/${shopId}`, '_blank');
    } else {
        alert('Không thể truy cập trang shop!');
    }
}
</script>
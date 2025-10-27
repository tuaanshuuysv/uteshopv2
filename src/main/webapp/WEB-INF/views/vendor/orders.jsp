<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- UTESHOP Vendor Personal Orders - Similar to Customer -->
<!-- Created: 2025-10-24 23:47:30 UTC by tuaanshuuysv -->
<!-- Path: /WEB-INF/views/vendor/orders.jsp -->
<!-- Purpose: Personal orders when vendor acts as a customer -->

<div class="vendor-personal-orders-page">
    
    <!-- Page Header -->
    <div class="orders-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="page-title">
                        <i class="fas fa-shopping-bag me-2"></i>
                        🛒 Đơn hàng cá nhân của tôi
                    </h1>
                    <p class="page-subtitle">Theo dõi các đơn hàng mua từ các shop khác</p>
                </div>
                <div class="col-md-4 text-end">
                    <div class="quick-nav">
                        <a href="${pageContext.request.contextPath}/vendor/shop/orders" class="btn btn-outline-light">
                            <i class="fas fa-store me-1"></i>Quản lý shop
                        </a>
                        <div class="order-summary mt-2">
                            <div class="summary-item">
                                <span class="number">${orderStats.total_orders}</span>
                                <span class="label">Đơn mua</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Success/Error Messages -->
    <div class="container mt-4">
        <c:if test="${param.success != null}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                <c:choose>
                    <c:when test="${param.success == 'order_cancelled'}">✅ Đơn hàng đã được hủy thành công!</c:when>
                    <c:when test="${param.success == 'return_requested'}">✅ Yêu cầu trả hàng đã được gửi!</c:when>
                    <c:otherwise>✅ Thao tác thành công!</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <c:choose>
                    <c:when test="${param.error == 'cancel_failed'}">❌ Không thể hủy đơn hàng!</c:when>
                    <c:when test="${param.error == 'return_failed'}">❌ Không thể yêu cầu trả hàng!</c:when>
                    <c:otherwise>❌ Có lỗi xảy ra: ${param.error}</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
    </div>

    <!-- Vendor Notice -->
    <div class="container mt-4">
        <div class="vendor-notice-card">
            <div class="notice-content">
                <div class="notice-icon">
                    <i class="fas fa-info-circle"></i>
                </div>
                <div class="notice-text">
                    <h6>Đây là các đơn hàng mà bạn mua từ các shop khác</h6>
                    <p>Để quản lý đơn hàng của shop bạn, vui lòng truy cập 
                        <a href="${pageContext.request.contextPath}/vendor/shop/orders" class="fw-bold">
                            Quản lý Shop → Đơn hàng
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- Filter & Search Section (Same as User) -->
    <div class="container mt-4">
        <div class="orders-filter-card">
            <form method="GET" action="${pageContext.request.contextPath}/vendor/orders" class="filter-form">
                <div class="row g-3">
                    <div class="col-md-2">
                        <select name="status" class="form-select">
                            <option value="">Tất cả trạng thái</option>
                            <option value="NEW" ${filterStatus == 'NEW' ? 'selected' : ''}>Mới</option>
                            <option value="CONFIRMED" ${filterStatus == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                            <option value="PROCESSING" ${filterStatus == 'PROCESSING' ? 'selected' : ''}>Đang xử lý</option>
                            <option value="SHIPPING" ${filterStatus == 'SHIPPING' ? 'selected' : ''}>Đang giao</option>
                            <option value="DELIVERED" ${filterStatus == 'DELIVERED' ? 'selected' : ''}>Đã giao</option>
                            <option value="CANCELLED" ${filterStatus == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                            <option value="RETURNED" ${filterStatus == 'RETURNED' ? 'selected' : ''}>Đã trả</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <input type="date" name="date_from" class="form-control" value="${filterDateFrom}" placeholder="Từ ngày">
                    </div>
                    <div class="col-md-2">
                        <input type="date" name="date_to" class="form-control" value="${filterDateTo}" placeholder="Đến ngày">
                    </div>
                    <div class="col-md-4">
                        <input type="text" name="search" class="form-control" value="${filterSearch}" placeholder="Tìm theo mã đơn, shop...">
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="fas fa-search me-1"></i>Lọc
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Orders Statistics Cards (Same as User) -->
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-3">
                <div class="stat-card stat-new">
                    <div class="stat-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-info">
                        <h3>${orderStats.new_orders}</h3>
                        <p>Đơn mới</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card stat-shipping">
                    <div class="stat-icon">
                        <i class="fas fa-truck"></i>
                    </div>
                    <div class="stat-info">
                        <h3>${orderStats.shipping_orders}</h3>
                        <p>Đang giao</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card stat-delivered">
                    <div class="stat-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="stat-info">
                        <h3>${orderStats.delivered_orders}</h3>
                        <p>Đã giao</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stat-card stat-total">
                    <div class="stat-icon">
                        <i class="fas fa-chart-line"></i>
                    </div>
                    <div class="stat-info">
                        <h3>${orderStats.total_revenue}</h3>
                        <p>Tổng chi tiêu</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Orders List (Same as User) -->
    <div class="container mt-4">
        <div class="orders-list-card">
            <div class="card-header">
                <h5 class="mb-0">
                    <i class="fas fa-list me-2"></i>Đơn hàng cá nhân (${totalOrders} đơn)
                </h5>
            </div>
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${empty orders}">
                        <div class="empty-orders">
                            <div class="empty-icon">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                            <h4>Chưa có đơn hàng nào</h4>
                            <p>Bạn chưa mua gì từ các shop khác. Hãy bắt đầu mua sắm!</p>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                                <i class="fas fa-shopping-bag me-1"></i>Mua sắm ngay
                            </a>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="orders-table">
                            <c:forEach var="order" items="${orders}">
                                <div class="order-item" data-order-id="${order.order_id}">
                                    <div class="order-header">
                                        <div class="order-info">
                                            <h6 class="order-number">
                                                <i class="fas fa-receipt me-1"></i>
                                                ${order.order_number}
                                            </h6>
                                            <span class="order-date">
                                                <fmt:formatDate value="${order.created_at}" pattern="dd/MM/yyyy HH:mm"/>
                                            </span>
                                        </div>
                                        <div class="order-status">
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
                                        </div>
                                        <div class="order-amount">
                                            <span class="amount">${order.total_amount}</span>
                                        </div>
                                    </div>
                                    
                                    <div class="order-body">
                                        <div class="row">
                                            <div class="col-md-4">
                                                <div class="shop-info">
                                                    <i class="fas fa-store me-1"></i>
                                                    <strong>${order.shop_name}</strong>
                                                </div>
                                                <div class="item-count">
                                                    <i class="fas fa-box me-1"></i>
                                                    ${order.item_count} sản phẩm
                                                </div>
                                            </div>
                                            <div class="col-md-4">
                                                <div class="payment-info">
                                                    <i class="fas fa-credit-card me-1"></i>
                                                    <c:choose>
                                                        <c:when test="${order.payment_method == 'COD'}">Thanh toán khi nhận hàng</c:when>
                                                        <c:when test="${order.payment_method == 'VNPAY'}">VNPay</c:when>
                                                        <c:when test="${order.payment_method == 'MOMO'}">MoMo</c:when>
                                                        <c:when test="${order.payment_method == 'BANK_TRANSFER'}">Chuyển khoản</c:when>
                                                        <c:otherwise>${order.payment_method}</c:otherwise>
                                                    </c:choose>
                                                </div>
                                                <div class="payment-status">
                                                    <span class="payment-badge payment-${order.payment_status.toLowerCase()}">
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
                                            <div class="col-md-4">
                                                <div class="order-actions">
                                                    <a href="${pageContext.request.contextPath}/vendor/orders/detail/${order.order_id}" 
                                                       class="btn btn-outline-primary btn-sm">
                                                        <i class="fas fa-eye me-1"></i>Chi tiết
                                                    </a>
                                                    
                                                    <c:if test="${order.order_status == 'NEW' || order.order_status == 'CONFIRMED'}">
                                                        <button type="button" class="btn btn-outline-danger btn-sm" 
                                                                onclick="showCancelModal('${order.order_id}', '${order.order_number}')">
                                                            <i class="fas fa-times me-1"></i>Hủy
                                                        </button>
                                                    </c:if>
                                                    
                                                    <c:if test="${order.order_status == 'DELIVERED'}">
                                                        <button type="button" class="btn btn-outline-warning btn-sm" 
                                                                onclick="showReturnModal('${order.order_id}', '${order.order_number}')">
                                                            <i class="fas fa-undo me-1"></i>Trả hàng
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <!-- Pagination (Same as User) -->
    <c:if test="${totalPages > 1}">
        <div class="container mt-4">
            <nav aria-label="Orders pagination">
                <ul class="pagination justify-content-center">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage - 1}&status=${filterStatus}&date_from=${filterDateFrom}&date_to=${filterDateTo}&search=${filterSearch}">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                        </li>
                    </c:if>
                    
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:if test="${i >= currentPage - 2 && i <= currentPage + 2}">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}&status=${filterStatus}&date_from=${filterDateFrom}&date_to=${filterDateTo}&search=${filterSearch}">
                                    ${i}
                                </a>
                            </li>
                        </c:if>
                    </c:forEach>
                    
                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage + 1}&status=${filterStatus}&date_from=${filterDateFrom}&date_to=${filterDateTo}&search=${filterSearch}">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </div>
    </c:if>
</div>

<!-- Cancel Order Modal (Same as User) -->
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
                    <input type="hidden" name="order_id" id="cancelOrderId">
                    
                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        Bạn có chắc chắn muốn hủy đơn hàng <strong id="cancelOrderNumber"></strong>?
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

<!-- Return Order Modal (Same as User) -->
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
                    <input type="hidden" name="order_id" id="returnOrderId">
                    
                    <div class="alert alert-info">
                        <i class="fas fa-info-circle me-2"></i>
                        Yêu cầu trả hàng cho đơn <strong id="returnOrderNumber"></strong>
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
/* Vendor Personal Orders Styles - Similar to Customer */
.vendor-personal-orders-page {
    background: #f8fafc;
    min-height: calc(100vh - 120px);
}

.orders-header {
    background: linear-gradient(135deg, #16a085 0%, #f4d03f 100%);
    color: white;
    padding: 40px 0;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.page-title {
    font-size: 2.5rem;
    font-weight: bold;
    margin-bottom: 10px;
}

.page-subtitle {
    font-size: 1.1rem;
    opacity: 0.9;
    margin-bottom: 0;
}

.quick-nav .btn {
    margin-bottom: 15px;
}

.order-summary {
    display: flex;
    gap: 30px;
    justify-content: flex-end;
}

.summary-item {
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    background: rgba(255,255,255,0.1);
    padding: 20px;
    border-radius: 12px;
    min-width: 100px;
}

.summary-item .number {
    font-size: 2rem;
    font-weight: bold;
    margin-bottom: 5px;
}

.summary-item .label {
    font-size: 0.9rem;
    opacity: 0.9;
}

/* Vendor Notice Card */
.vendor-notice-card {
    background: linear-gradient(135deg, #e8f4fd 0%, #d1ecf1 100%);
    border-radius: 12px;
    border: 1px solid #bee5eb;
    overflow: hidden;
}

.notice-content {
    display: flex;
    align-items: center;
    padding: 20px 25px;
    gap: 20px;
}

.notice-icon {
    flex-shrink: 0;
    width: 50px;
    height: 50px;
    background: linear-gradient(135deg, #17a2b8 0%, #138496 100%);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 1.5rem;
}

.notice-text h6 {
    color: #0c5460;
    margin-bottom: 8px;
    font-weight: 600;
}

.notice-text p {
    color: #0c5460;
    margin: 0;
    font-size: 0.95rem;
}

.notice-text a {
    color: #0c5460;
    text-decoration: none;
}

.notice-text a:hover {
    text-decoration: underline;
}

/* Rest of styles same as customer orders */
.orders-filter-card {
    background: white;
    border-radius: 12px;
    padding: 25px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    border: 1px solid #e5e7eb;
}

.stat-card {
    background: white;
    border-radius: 12px;
    padding: 25px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    border-left: 4px solid #16a085;
    display: flex;
    align-items: center;
    gap: 20px;
    transition: transform 0.2s ease;
}

.stat-card:hover {
    transform: translateY(-2px);
}

.stat-card.stat-new { border-left-color: #f59e0b; }
.stat-card.stat-shipping { border-left-color: #3b82f6; }
.stat-card.stat-delivered { border-left-color: #10b981; }
.stat-card.stat-total { border-left-color: #8b5cf6; }

.stat-icon {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    background: linear-gradient(135deg, #16a085 0%, #f4d03f 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 1.5rem;
}

.stat-card.stat-new .stat-icon { background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); }
.stat-card.stat-shipping .stat-icon { background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%); }
.stat-card.stat-delivered .stat-icon { background: linear-gradient(135deg, #10b981 0%, #059669 100%); }
.stat-card.stat-total .stat-icon { background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%); }

.stat-info h3 {
    font-size: 2rem;
    font-weight: bold;
    margin-bottom: 5px;
    color: #1f2937;
}

.stat-info p {
    margin: 0;
    color: #6b7280;
    font-weight: 500;
}

.orders-list-card {
    background: white;
    border-radius: 12px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    border: 1px solid #e5e7eb;
    overflow: hidden;
}

.orders-list-card .card-header {
    background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
    border-bottom: 2px solid #e5e7eb;
    padding: 20px 25px;
}

.order-item {
    border-bottom: 1px solid #f3f4f6;
    transition: background-color 0.2s ease;
}

.order-item:hover {
    background-color: #f9fafb;
}

.order-item:last-child {
    border-bottom: none;
}

.order-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px 25px 15px;
    background: #fafbfc;
    border-bottom: 1px solid #f0f1f3;
}

.order-number {
    font-size: 1.1rem;
    font-weight: bold;
    color: #1f2937;
    margin-bottom: 5px;
}

.order-date {
    font-size: 0.9rem;
    color: #6b7280;
}

.status-badge {
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 0.85rem;
    font-weight: 600;
    text-transform: uppercase;
}

.status-new { background: #fef3c7; color: #92400e; }
.status-confirmed { background: #dbeafe; color: #1e40af; }
.status-processing { background: #e0e7ff; color: #3730a3; }
.status-shipping { background: #cffafe; color: #0f766e; }
.status-delivered { background: #d1fae5; color: #065f46; }
.status-cancelled { background: #fee2e2; color: #991b1b; }
.status-returned { background: #fef2f2; color: #b91c1c; }

.order-amount .amount {
    font-size: 1.3rem;
    font-weight: bold;
    color: #16a085;
}

.order-body {
    padding: 20px 25px;
}

.shop-info, .item-count, .payment-info {
    margin-bottom: 8px;
    color: #4b5563;
    font-size: 0.95rem;
}

.shop-info strong {
    color: #1f2937;
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

.order-actions {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
}

.empty-orders {
    text-align: center;
    padding: 80px 20px;
    color: #6b7280;
}

.empty-icon {
    font-size: 5rem;
    color: #d1d5db;
    margin-bottom: 20px;
}

.empty-orders h4 {
    color: #374151;
    margin-bottom: 10px;
}

/* Responsive Design */
@media (max-width: 768px) {
    .orders-header {
        text-align: center;
        padding: 30px 0;
    }
    
    .page-title {
        font-size: 2rem;
    }
    
    .quick-nav {
        text-align: center;
        margin-top: 20px;
    }
    
    .order-summary {
        justify-content: center;
        margin-top: 15px;
        gap: 15px;
    }
    
    .summary-item {
        min-width: 80px;
        padding: 15px;
    }
    
    .notice-content {
        flex-direction: column;
        text-align: center;
    }
    
    .order-header {
        flex-direction: column;
        align-items: stretch;
        gap: 10px;
    }
    
    .order-amount {
        text-align: center;
    }
    
    .stat-card {
        margin-bottom: 15px;
    }
    
    .order-actions {
        justify-content: center;
    }
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    console.log('✅ Vendor Personal Orders UI loaded - 2025-10-24 23:47:30 UTC');
    console.log('👨‍💻 Created by: tuaanshuuysv');
    console.log('📂 Path: /WEB-INF/views/vendor/orders.jsp');
    console.log('🛒 Vendor personal orders: ${totalOrders} orders loaded');
    console.log('📋 Note: Personal orders when vendor acts as customer');
    
    // Auto-hide alerts
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert-dismissible');
        alerts.forEach(alert => {
            const closeBtn = alert.querySelector('.btn-close');
            if (closeBtn) {
                closeBtn.click();
            }
        });
    }, 5000);
});

// Show cancel order modal (same as customer)
function showCancelModal(orderId, orderNumber) {
    document.getElementById('cancelOrderId').value = orderId;
    document.getElementById('cancelOrderNumber').textContent = orderNumber;
    
    const modal = new bootstrap.Modal(document.getElementById('cancelOrderModal'));
    modal.show();
}

// Show return order modal (same as customer)
function showReturnModal(orderId, orderNumber) {
    document.getElementById('returnOrderId').value = orderId;
    document.getElementById('returnOrderNumber').textContent = orderNumber;
    
    const modal = new bootstrap.Modal(document.getElementById('returnOrderModal'));
    modal.show();
}
</script>
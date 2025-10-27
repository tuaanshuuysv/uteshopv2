<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- UTESHOP Admin Personal Orders - Similar to Customer -->
<!-- Created: 2025-10-24 23:54:38 UTC by tuaanshuuysv -->
<!-- Path: /WEB-INF/views/admin/orders.jsp -->
<!-- Purpose: Personal orders when admin acts as a customer -->

<div class="admin-personal-orders-page">
    
    <!-- Page Header -->
    <div class="orders-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="page-title">
                        <i class="fas fa-shopping-bag me-2"></i>
                        👑 Đơn hàng cá nhân của tôi
                    </h1>
                    <p class="page-subtitle">Theo dõi các đơn hàng mua từ các shop trên hệ thống</p>
                </div>
                <div class="col-md-4 text-end">
                    <div class="admin-quick-nav">
                        <a href="${pageContext.request.contextPath}/admin/system/orders" class="btn btn-outline-light">
                            <i class="fas fa-cogs me-1"></i>Quản lý hệ thống
                        </a>
                        <a href="${pageContext.request.contextPath}/admin/analytics" class="btn btn-outline-light">
                            <i class="fas fa-chart-bar me-1"></i>Analytics
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

    <!-- Admin Notice -->
    <div class="container mt-4">
        <div class="admin-notice-card">
            <div class="notice-content">
                <div class="notice-icon">
                    <i class="fas fa-user-shield"></i>
                </div>
                <div class="notice-text">
                    <h6>Đây là các đơn hàng mà bạn mua từ các shop trên hệ thống</h6>
                    <p>Để quản lý toàn bộ đơn hàng hệ thống, vui lòng truy cập 
                        <a href="${pageContext.request.contextPath}/admin/system/orders" class="fw-bold">
                            Quản lý hệ thống → Đơn hàng
                        </a>
                        | 
                        <a href="${pageContext.request.contextPath}/admin/analytics" class="fw-bold">
                            Analytics & Reports
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <!-- Filter & Search Section (Same as User) -->
    <div class="container mt-4">
        <div class="orders-filter-card">
            <form method="GET" action="${pageContext.request.contextPath}/admin/orders" class="filter-form">
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

    <!-- Admin Privilege Notice -->
    <div class="container mt-4">
        <div class="admin-privilege-card">
            <div class="privilege-content">
                <div class="privilege-icon">
                    <i class="fas fa-shield-alt"></i>
                </div>
                <div class="privilege-text">
                    <h6>Quyền Admin</h6>
                    <p>Với tư cách Admin, bạn có thể can thiệp vào bất kỳ đơn hàng nào trong hệ thống nếu cần thiết.</p>
                    <div class="privilege-actions">
                        <button type="button" class="btn btn-outline-warning btn-sm" onclick="enableAdminMode()">
                            <i class="fas fa-cogs me-1"></i>Bật chế độ Admin
                        </button>
                        <button type="button" class="btn btn-outline-info btn-sm" onclick="viewSystemLogs()">
                            <i class="fas fa-history me-1"></i>Xem System Logs
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Orders List (Same as User but with Admin hints) -->
    <div class="container mt-4">
        <div class="orders-list-card">
            <div class="card-header">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <h5 class="mb-0">
                            <i class="fas fa-list me-2"></i>Đơn hàng cá nhân (${totalOrders} đơn)
                        </h5>
                    </div>
                    <div class="col-md-4 text-end">
                        <div class="admin-mode-toggle">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="adminModeToggle">
                                <label class="form-check-label" for="adminModeToggle">
                                    <small>Chế độ Admin</small>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${empty orders}">
                        <div class="empty-orders">
                            <div class="empty-icon">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                            <h4>Chưa có đơn hàng nào</h4>
                            <p>Bạn chưa mua gì từ các shop trên hệ thống. Hãy bắt đầu mua sắm!</p>
                            <div class="empty-actions">
                                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                                    <i class="fas fa-shopping-bag me-1"></i>Mua sắm ngay
                                </a>
                                <a href="${pageContext.request.contextPath}/admin/system/orders" class="btn btn-outline-secondary">
                                    <i class="fas fa-cogs me-1"></i>Quản lý hệ thống
                                </a>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="orders-table">
                            <c:forEach var="order" items="${orders}">
                                <div class="order-item admin-order-item" data-order-id="${order.order_id}">
                                    <div class="order-header">
                                        <div class="order-info">
                                            <h6 class="order-number">
                                                <i class="fas fa-receipt me-1"></i>
                                                ${order.order_number}
                                                <span class="admin-order-id">ID: ${order.order_id}</span>
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
                                                    <button type="button" class="btn btn-link btn-sm p-0 ms-2 admin-hint" 
                                                            onclick="viewShopDetails('${order.shop_id}')" 
                                                            title="Admin: Xem chi tiết shop">
                                                        <i class="fas fa-external-link-alt"></i>
                                                    </button>
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
                                                    <a href="${pageContext.request.contextPath}/admin/orders/detail/${order.order_id}" 
                                                       class="btn btn-outline-primary btn-sm">
                                                        <i class="fas fa-eye me-1"></i>Chi tiết
                                                    </a>
                                                    
                                                    <!-- Regular customer actions -->
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
                                                    
                                                    <!-- Admin actions (hidden by default) -->
                                                    <div class="admin-actions" style="display: none;">
                                                        <button type="button" class="btn btn-warning btn-sm" 
                                                                onclick="adminIntervention('${order.order_id}')">
                                                            <i class="fas fa-shield-alt me-1"></i>Admin
                                                        </button>
                                                    </div>
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

<!-- Admin Intervention Modal -->
<div class="modal fade" id="adminInterventionModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    <i class="fas fa-shield-alt text-warning me-2"></i>
                    Admin Intervention
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    <strong>CẢNH BÁO:</strong> Bạn đang sử dụng quyền Admin để can thiệp vào đơn hàng cá nhân của mình.
                    Thao tác này sẽ được ghi lại trong log hệ thống.
                </div>
                
                <div class="admin-intervention-options">
                    <h6>Chọn hành động Admin:</h6>
                    <div class="btn-group-vertical w-100" role="group">
                        <button type="button" class="btn btn-outline-success" onclick="adminForceConfirm()">
                            <i class="fas fa-check me-1"></i>Force Confirm Order
                        </button>
                        <button type="button" class="btn btn-outline-info" onclick="adminForceShip()">
                            <i class="fas fa-truck me-1"></i>Force Ship Order
                        </button>
                        <button type="button" class="btn btn-outline-primary" onclick="adminForceDeliver()">
                            <i class="fas fa-check-double me-1"></i>Force Complete Order
                        </button>
                        <button type="button" class="btn btn-outline-danger" onclick="adminForceCancel()">
                            <i class="fas fa-ban me-1"></i>Force Cancel Order
                        </button>
                    </div>
                </div>
                
                <div class="mt-3">
                    <label class="form-label">Lý do can thiệp:</label>
                    <textarea id="adminReason" class="form-control" rows="3" 
                              placeholder="Nhập lý do admin can thiệp vào đơn hàng này..."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                    <i class="fas fa-times me-1"></i>Hủy
                </button>
            </div>
        </div>
    </div>
</div>

<style>
/* Admin Personal Orders Styles - Similar to Customer but with Admin touches */
.admin-personal-orders-page {
    background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
    min-height: calc(100vh - 120px);
}

.orders-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 40px 0;
    box-shadow: 0 8px 32px rgba(0, 0, 0, 0.12);
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

.admin-quick-nav .btn {
    margin-left: 8px;
    margin-bottom: 10px;
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

/* Admin Notice Card */
.admin-notice-card {
    background: linear-gradient(135deg, #fef7e0 0%, #fef3c7 100%);
    border-radius: 12px;
    border: 1px solid #f59e0b;
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
    background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 1.5rem;
}

.notice-text h6 {
    color: #92400e;
    margin-bottom: 8px;
    font-weight: 600;
}

.notice-text p {
    color: #92400e;
    margin: 0;
    font-size: 0.95rem;
}

.notice-text a {
    color: #92400e;
    text-decoration: none;
}

.notice-text a:hover {
    text-decoration: underline;
}

/* Admin Privilege Card */
.admin-privilege-card {
    background: linear-gradient(135deg, #ede9fe 0%, #e0e7ff 100%);
    border-radius: 12px;
    border: 1px solid #8b5cf6;
    overflow: hidden;
}

.privilege-content {
    display: flex;
    align-items: center;
    padding: 20px 25px;
    gap: 20px;
}

.privilege-icon {
    flex-shrink: 0;
    width: 50px;
    height: 50px;
    background: linear-gradient(135deg, #8b5cf6 0%, #7c3aed 100%);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
    font-size: 1.5rem;
}

.privilege-text h6 {
    color: #5b21b6;
    margin-bottom: 8px;
    font-weight: 600;
}

.privilege-text p {
    color: #5b21b6;
    margin-bottom: 10px;
    font-size: 0.95rem;
}

.privilege-actions .btn {
    margin-right: 8px;
}

/* Admin Mode Toggle */
.admin-mode-toggle {
    display: flex;
    align-items: center;
    justify-content: flex-end;
}

.form-check-input:checked {
    background-color: #8b5cf6;
    border-color: #8b5cf6;
}

/* Admin Order Item Enhancements */
.admin-order-item .admin-order-id {
    font-size: 0.8rem;
    color: #6b7280;
    font-weight: normal;
    margin-left: 10px;
}

.admin-hint {
    color: #8b5cf6 !important;
    font-size: 0.8rem;
}

.admin-hint:hover {
    color: #7c3aed !important;
}

.admin-actions {
    margin-top: 8px;
}

/* Rest of styles same as customer orders */
.orders-filter-card {
    background: white;
    border-radius: 12px;
    padding: 25px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    border: 1px solid #e2e8f0;
}

.stat-card {
    background: white;
    border-radius: 12px;
    padding: 25px;
    box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    border-left: 4px solid #667eea;
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
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
    box-shadow: 0 4px 20px rgba(0,0,0,0.08);
    border: 1px solid #e2e8f0;
    overflow: hidden;
}

.orders-list-card .card-header {
    background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
    border-bottom: 2px solid #e2e8f0;
    padding: 20px 25px;
}

.order-item {
    border-bottom: 1px solid #f1f5f9;
    transition: background-color 0.2s ease;
}

.order-item:hover {
    background-color: #f8fafc;
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
    border-bottom: 1px solid #f1f5f9;
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
    color: #667eea;
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

.empty-actions {
    display: flex;
    gap: 10px;
    justify-content: center;
    flex-wrap: wrap;
}

.admin-intervention-options {
    margin: 15px 0;
}

.admin-intervention-options .btn {
    margin-bottom: 8px;
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
    
    .admin-quick-nav {
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
    
    .notice-content, .privilege-content {
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
    
    .empty-actions {
        flex-direction: column;
        align-items: center;
    }
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    console.log('✅ Admin Personal Orders UI loaded - 2025-10-24 23:54:38 UTC');
    console.log('👨‍💻 Created by: tuaanshuuysv');
    console.log('📂 Path: /WEB-INF/views/admin/orders.jsp');
    console.log('👑 Admin personal orders: ${totalOrders} orders loaded');
    console.log('📋 Note: Personal orders when admin acts as customer');
    
    // Initialize admin mode toggle
    initializeAdminMode();
    
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

// Initialize admin mode functionality
function initializeAdminMode() {
    const adminToggle = document.getElementById('adminModeToggle');
    const adminActions = document.querySelectorAll('.admin-actions');
    const adminHints = document.querySelectorAll('.admin-hint');
    
    if (adminToggle) {
        adminToggle.addEventListener('change', function() {
            if (this.checked) {
                // Show admin features
                adminActions.forEach(action => action.style.display = 'block');
                adminHints.forEach(hint => hint.style.display = 'inline');
                
                // Add admin styling
                document.querySelectorAll('.admin-order-item').forEach(item => {
                    item.classList.add('admin-mode-active');
                });
                
                console.log('🔓 Admin mode activated');
            } else {
                // Hide admin features
                adminActions.forEach(action => action.style.display = 'none');
                adminHints.forEach(hint => hint.style.display = 'none');
                
                // Remove admin styling
                document.querySelectorAll('.admin-order-item').forEach(item => {
                    item.classList.remove('admin-mode-active');
                });
                
                console.log('🔒 Admin mode deactivated');
            }
        });
    }
}

// Admin privilege functions
function enableAdminMode() {
    document.getElementById('adminModeToggle').checked = true;
    document.getElementById('adminModeToggle').dispatchEvent(new Event('change'));
    alert('🔓 Chế độ Admin đã được kích hoạt!');
}

function viewSystemLogs() {
    window.open('${pageContext.request.contextPath}/admin/system/logs', '_blank');
}

// Admin intervention
let currentAdminOrderId = null;

function adminIntervention(orderId) {
    currentAdminOrderId = orderId;
    const modal = new bootstrap.Modal(document.getElementById('adminInterventionModal'));
    modal.show();
}

function adminForceConfirm() {
    const reason = document.getElementById('adminReason').value;
    if (!reason.trim()) {
        alert('Vui lòng nhập lý do can thiệp!');
        return;
    }
    
    const confirmed = confirm(`⚠️ ADMIN INTERVENTION\n\nBạn có chắc muốn FORCE CONFIRM đơn hàng ${currentAdminOrderId}?\n\nLý do: ${reason}\n\nThao tác này sẽ được ghi log.`);
    if (confirmed) {
        // Implementation for admin force confirm
        alert('Chức năng admin force confirm đang được phát triển...');
        bootstrap.Modal.getInstance(document.getElementById('adminInterventionModal')).hide();
    }
}

function adminForceShip() {
    const reason = document.getElementById('adminReason').value;
    if (!reason.trim()) {
        alert('Vui lòng nhập lý do can thiệp!');
        return;
    }
    
    const confirmed = confirm(`⚠️ ADMIN INTERVENTION\n\nBạn có chắc muốn FORCE SHIP đơn hàng ${currentAdminOrderId}?\n\nLý do: ${reason}\n\nThao tác này sẽ được ghi log.`);
    if (confirmed) {
        // Implementation for admin force ship
        alert('Chức năng admin force ship đang được phát triển...');
        bootstrap.Modal.getInstance(document.getElementById('adminInterventionModal')).hide();
    }
}

function adminForceDeliver() {
    const reason = document.getElementById('adminReason').value;
    if (!reason.trim()) {
        alert('Vui lòng nhập lý do can thiệp!');
        return;
    }
    
    const confirmed = confirm(`⚠️ ADMIN INTERVENTION\n\nBạn có chắc muốn FORCE COMPLETE đơn hàng ${currentAdminOrderId}?\n\nLý do: ${reason}\n\nThao tác này sẽ được ghi log.`);
    if (confirmed) {
        // Implementation for admin force deliver
        alert('Chức năng admin force complete đang được phát triển...');
        bootstrap.Modal.getInstance(document.getElementById('adminInterventionModal')).hide();
    }
}

function adminForceCancel() {
    const reason = document.getElementById('adminReason').value;
    if (!reason.trim()) {
        alert('Vui lòng nhập lý do can thiệp!');
        return;
    }
    
    const confirmed = confirm(`⚠️ ADMIN INTERVENTION\n\nBạn có chắc muốn FORCE CANCEL đơn hàng ${currentAdminOrderId}?\n\nLý do: ${reason}\n\nThao tác này sẽ được ghi log và không thể hoàn tác.`);
    if (confirmed) {
        // Implementation for admin force cancel
        alert('Chức năng admin force cancel đang được phát triển...');
        bootstrap.Modal.getInstance(document.getElementById('adminInterventionModal')).hide();
    }
}

// Shop details view
function viewShopDetails(shopId) {
    window.open(`${pageContext.request.contextPath}/admin/system/shops/${shopId}`, '_blank');
}

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
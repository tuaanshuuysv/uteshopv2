<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn hàng của tôi - UTESHOP</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        body { background-color: #f8f9fa; }
        .orders-header { 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); 
            color: white; 
            padding: 2rem 0;
        }
        .order-card { 
            border: none; 
            box-shadow: 0 2px 10px rgba(0,0,0,0.1); 
            margin-bottom: 1rem;
            transition: transform 0.2s;
        }
        .order-card:hover { 
            transform: translateY(-2px); 
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }
        .order-status {
            font-weight: bold;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
        }
        .status-new { background-color: #fff3cd; color: #856404; }
        .status-confirmed { background-color: #cce5ff; color: #004085; }
        .status-processing { background-color: #e2e3e5; color: #383d41; }
        .status-shipping { background-color: #d4edda; color: #155724; }
        .status-delivered { background-color: #d1ecf1; color: #0c5460; }
        .status-cancelled { background-color: #f8d7da; color: #721c24; }
        .stats-card { 
            background: white; 
            border-radius: 10px; 
            padding: 1.5rem; 
            margin-bottom: 1rem;
            border: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .stats-number { 
            font-size: 2rem; 
            font-weight: bold; 
            margin-bottom: 0.5rem;
        }
        .filter-card {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            color: #dee2e6;
        }
    </style>
</head>
<body>

<!-- UTESHOP User Orders - COMPLETE WITH FIXED CSS -->
<!-- Created: 2025-10-26 15:55:30 UTC by tuaanshuuysv -->

<div class="container-fluid">
    <!-- Header Section -->
    <div class="orders-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="mb-2">
                        <i class="fas fa-shopping-bag me-3"></i>
                        Đơn hàng của tôi
                    </h1>
                    <p class="mb-0 opacity-90">
                        Theo dõi và quản lý đơn hàng của bạn | 
                        <span class="fw-bold">${authUser.fullName}</span>
                        <c:if test="${userRoleId == 3}">
                            <span class="badge bg-light text-dark ms-2">Vendor</span>
                        </c:if>
                        <c:if test="${userRoleId == 4}">
                            <span class="badge bg-light text-dark ms-2">Admin</span>
                        </c:if>
                    </p>
                </div>
                <div class="col-md-4 text-end">
                    <div class="d-flex gap-2 justify-content-end">
                        <a href="${pageContext.request.contextPath}/" class="btn btn-light">
                            <i class="fas fa-home me-1"></i>Trang chủ
                        </a>
                        <c:if test="${userRoleId == 3}">
                            <a href="${pageContext.request.contextPath}/vendor/dashboard" class="btn btn-outline-light">
                                <i class="fas fa-store me-1"></i>Vendor Panel
                            </a>
                        </c:if>
                        <c:if test="${userRoleId == 4}">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-light">
                                <i class="fas fa-crown me-1"></i>Admin Panel
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="container mt-4">
        <!-- Success/Error Messages -->
        <c:if test="${param.success != null}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                <c:choose>
                    <c:when test="${param.success == 'order_cancelled'}">✅ Đơn hàng đã được hủy thành công!</c:when>
                    <c:when test="${param.success == 'return_requested'}">📦 Yêu cầu trả hàng đã được gửi!</c:when>
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
                    <c:when test="${param.error == 'return_failed'}">❌ Không thể gửi yêu cầu trả hàng!</c:when>
                    <c:otherwise>❌ Có lỗi xảy ra: ${param.error}</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Order Statistics -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="stats-card text-center">
                    <div class="stats-number text-primary">
                        ${orderStats.total_orders != null ? orderStats.total_orders : 0}
                    </div>
                    <div class="text-muted">Tổng đơn hàng</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card text-center">
                    <div class="stats-number text-warning">
                        ${orderStats.new_orders != null ? orderStats.new_orders : 0}
                    </div>
                    <div class="text-muted">Đơn mới</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card text-center">
                    <div class="stats-number text-success">
                        ${orderStats.delivered_orders != null ? orderStats.delivered_orders : 0}
                    </div>
                    <div class="text-muted">Đã giao</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card text-center">
                    <div class="stats-number text-info">
                        ${orderStats.total_revenue != null ? orderStats.total_revenue : '0₫'}
                    </div>
                    <div class="text-muted">Tổng chi tiêu</div>
                </div>
            </div>
        </div>

        <!-- Filters -->
        <div class="filter-card">
            <form method="GET" action="${pageContext.request.contextPath}/user/orders">
                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">Trạng thái</label>
                        <select name="status" class="form-select">
                            <option value="">Tất cả trạng thái</option>
                            <option value="NEW" ${filterStatus == 'NEW' ? 'selected' : ''}>Đơn mới</option>
                            <option value="CONFIRMED" ${filterStatus == 'CONFIRMED' ? 'selected' : ''}>Đã xác nhận</option>
                            <option value="PROCESSING" ${filterStatus == 'PROCESSING' ? 'selected' : ''}>Đang xử lý</option>
                            <option value="SHIPPING" ${filterStatus == 'SHIPPING' ? 'selected' : ''}>Đang giao</option>
                            <option value="DELIVERED" ${filterStatus == 'DELIVERED' ? 'selected' : ''}>Đã giao</option>
                            <option value="CANCELLED" ${filterStatus == 'CANCELLED' ? 'selected' : ''}>Đã hủy</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Từ ngày</label>
                        <input type="date" name="date_from" class="form-control" value="${filterDateFrom}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Đến ngày</label>
                        <input type="date" name="date_to" class="form-control" value="${filterDateTo}">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Tìm kiếm</label>
                        <div class="input-group">
                            <input type="text" name="search" class="form-control" 
                                   placeholder="Tìm theo mã đơn, shop..." value="${filterSearch}">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <!-- Orders List -->
        <div class="row">
            <div class="col-12">
                <c:choose>
                    <c:when test="${not empty orders}">
                        <c:forEach var="order" items="${orders}">
                            <div class="order-card">
                                <div class="card">
                                    <div class="card-header bg-transparent">
                                        <div class="row align-items-center">
                                            <div class="col-md-6">
                                                <h6 class="mb-0">
                                                    <i class="fas fa-receipt me-2"></i>
                                                    <strong>${order.order_number}</strong>
                                                </h6>
                                                <small class="text-muted">
                                                    <i class="fas fa-store me-1"></i>
                                                    ${order.shop_name}
                                                </small>
                                            </div>
                                            <div class="col-md-3 text-center">
                                                <span class="order-status status-${order.order_status.toLowerCase()}">
                                                    <c:choose>
                                                        <c:when test="${order.order_status == 'NEW'}">🟡 Đơn mới</c:when>
                                                        <c:when test="${order.order_status == 'CONFIRMED'}">🔵 Đã xác nhận</c:when>
                                                        <c:when test="${order.order_status == 'PROCESSING'}">⚪ Đang xử lý</c:when>
                                                        <c:when test="${order.order_status == 'SHIPPING'}">🟢 Đang giao</c:when>
                                                        <c:when test="${order.order_status == 'DELIVERED'}">🔵 Đã giao</c:when>
                                                        <c:when test="${order.order_status == 'CANCELLED'}">🔴 Đã hủy</c:when>
                                                        <c:otherwise>❓ ${order.order_status}</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </div>
                                            <div class="col-md-3 text-end">
                                                <div class="fw-bold text-primary">
                                                    ${order.total_amount}
                                                </div>
                                                <small class="text-muted">
                                                    ${order.item_count} sản phẩm
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <div class="row align-items-center">
                                            <div class="col-md-8">
                                                <div class="row">
                                                    <div class="col-md-6">
                                                        <small class="text-muted d-block">Phương thức thanh toán</small>
                                                        <span class="fw-bold">
                                                            <i class="fas fa-${order.payment_method == 'COD' ? 'money-bill' : 'credit-card'} me-1"></i>
                                                            ${order.payment_method == 'COD' ? 'Thanh toán khi nhận hàng' : order.payment_method}
                                                        </span>
                                                    </div>
                                                    <div class="col-md-6">
                                                        <small class="text-muted d-block">Ngày đặt hàng</small>
                                                        <span class="fw-bold">
                                                            <fmt:formatDate value="${order.created_at}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-md-4 text-end">
                                                <div class="btn-group" role="group">
                                                    <a href="${pageContext.request.contextPath}/user/orders/detail/${order.order_id}" 
                                                       class="btn btn-outline-primary btn-sm">
                                                        <i class="fas fa-eye me-1"></i>Chi tiết
                                                    </a>
                                                    
                                                    <c:if test="${order.order_status == 'NEW' || order.order_status == 'CONFIRMED'}">
                                                        <button type="button" class="btn btn-outline-danger btn-sm" 
                                                                onclick="cancelOrder('${order.order_id}', '${order.order_number}')">
                                                            <i class="fas fa-times me-1"></i>Hủy
                                                        </button>
                                                    </c:if>
                                                    
                                                    <c:if test="${order.order_status == 'DELIVERED'}">
                                                        <button type="button" class="btn btn-outline-warning btn-sm" 
                                                                onclick="returnOrder('${order.order_id}', '${order.order_number}')">
                                                            <i class="fas fa-undo me-1"></i>Trả hàng
                                                        </button>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <nav aria-label="Orders pagination" class="mt-4">
                                <ul class="pagination justify-content-center">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage - 1}&status=${filterStatus}&date_from=${filterDateFrom}&date_to=${filterDateTo}&search=${filterSearch}">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                    
                                    <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                        <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="?page=${pageNum}&status=${filterStatus}&date_from=${filterDateFrom}&date_to=${filterDateTo}&search=${filterSearch}">
                                                ${pageNum}
                                            </a>
                                        </li>
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
                        </c:if>

                    </c:when>
                    <c:otherwise>
                        <!-- Empty State -->
                        <div class="empty-state">
                            <i class="fas fa-shopping-bag"></i>
                            <h4>Chưa có đơn hàng nào</h4>
                            <p class="text-muted mb-4">
                                Bạn chưa có đơn hàng nào. Hãy bắt đầu mua sắm ngay!
                            </p>
                            <a href="${pageContext.request.contextPath}/" class="btn btn-primary">
                                <i class="fas fa-shopping-cart me-2"></i>
                                Bắt đầu mua sắm
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- Debug Info (Remove in production) -->
        <div class="mt-4">
            <div class="card bg-light">
                <div class="card-body">
                    <h6>🔧 Debug Info:</h6>
                    <small class="text-muted">
                        User Role: ${userRoleId} (${userRoleDisplay}) | 
                        Orders Count: ${orders != null ? orders.size() : 0} | 
                        Current Page: ${currentPage} | 
                        Total Pages: ${totalPages} |
                        Fixed CSS: ✅ | 
                        Fixed Time: 2025-10-26 15:55:30 UTC
                    </small>
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
                    <i class="fas fa-times-circle me-2"></i>
                    Hủy đơn hàng
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/user/orders">
                <div class="modal-body">
                    <input type="hidden" name="action" value="cancel-order">
                    <input type="hidden" name="order_id" id="cancel_order_id">
                    
                    <p>Bạn có chắc chắn muốn hủy đơn hàng <strong id="cancel_order_number"></strong>?</p>
                    
                    <div class="mb-3">
                        <label class="form-label">Lý do hủy đơn</label>
                        <select name="cancel_reason" class="form-select" required>
                            <option value="">Chọn lý do...</option>
                            <option value="changed_mind">Thay đổi ý định</option>
                            <option value="found_better_price">Tìm thấy giá tốt hơn</option>
                            <option value="payment_issue">Vấn đề thanh toán</option>
                            <option value="delivery_time">Thời gian giao hàng không phù hợp</option>
                            <option value="other">Lý do khác</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-danger">
                        <i class="fas fa-times me-1"></i>Hủy đơn hàng
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
                    <i class="fas fa-undo me-2"></i>
                    Yêu cầu trả hàng
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form method="POST" action="${pageContext.request.contextPath}/user/orders">
                <div class="modal-body">
                    <input type="hidden" name="action" value="return-order">
                    <input type="hidden" name="order_id" id="return_order_id">
                    
                    <p>Yêu cầu trả hàng cho đơn hàng <strong id="return_order_number"></strong></p>
                    
                    <div class="mb-3">
                        <label class="form-label">Lý do trả hàng</label>
                        <select name="return_reason" class="form-select" required>
                            <option value="">Chọn lý do...</option>
                            <option value="defective">Hàng bị lỗi</option>
                            <option value="wrong_item">Giao sai hàng</option>
                            <option value="damaged">Hàng bị hỏng khi giao</option>
                            <option value="not_as_described">Không đúng mô tả</option>
                            <option value="other">Lý do khác</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-warning">
                        <i class="fas fa-undo me-1"></i>Gửi yêu cầu
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
// UTESHOP User Orders JavaScript - FIXED CSS VERSION
console.log('✅ User Orders page loaded with FIXED CSS');
console.log('🕐 Fixed: 2025-10-26 15:55:30 UTC by tuaanshuuysv');
console.log('🔧 Fixed: Complete CSS styling and responsive design');
console.log('👤 User Role: ${userRoleId} (${userRoleDisplay})');

// Cancel Order Modal
function cancelOrder(orderId, orderNumber) {
    console.log('❌ Cancel order:', orderId, orderNumber);
    document.getElementById('cancel_order_id').value = orderId;
    document.getElementById('cancel_order_number').textContent = orderNumber;
    
    const modal = new bootstrap.Modal(document.getElementById('cancelOrderModal'));
    modal.show();
}

// Return Order Modal
function returnOrder(orderId, orderNumber) {
    console.log('↩️ Return order:', orderId, orderNumber);
    document.getElementById('return_order_id').value = orderId;
    document.getElementById('return_order_number').textContent = orderNumber;
    
    const modal = new bootstrap.Modal(document.getElementById('returnOrderModal'));
    modal.show();
}

// Auto-hide alerts after 5 seconds
setTimeout(function() {
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(alert => {
        const closeBtn = alert.querySelector('.btn-close');
        if (closeBtn) {
            closeBtn.click();
        }
    });
}, 5000);

console.log('🚀 User Orders page fully initialized with fixed CSS!');
</script>

</body>
</html>
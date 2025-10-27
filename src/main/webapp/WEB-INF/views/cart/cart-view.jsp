<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <meta name="description" content="${pageDescription}">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .cart-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 2rem 0; }
        .cart-item { border: 1px solid #e0e0e0; border-radius: 10px; padding: 1.5rem; margin-bottom: 1rem; background: white; transition: all 0.3s ease; }
        .cart-item:hover { box-shadow: 0 4px 8px rgba(0,0,0,0.1); }
        .product-image { width: 100px; height: 100px; object-fit: cover; border-radius: 8px; }
        .quantity-controls { display: flex; align-items: center; gap: 10px; }
        .quantity-btn { width: 35px; height: 35px; border-radius: 50%; border: 1px solid #ddd; background: white; display: flex; align-items: center; justify-content: center; cursor: pointer; transition: all 0.2s ease; }
        .quantity-btn:hover { background: #f8f9fa; border-color: #667eea; }
        .quantity-input { width: 60px; text-align: center; border: 1px solid #ddd; border-radius: 5px; padding: 5px; }
        .cart-summary { background: #f8f9fa; border-radius: 10px; padding: 2rem; position: sticky; top: 100px; }
        .price-row { display:flex; justify-content: space-between; margin-bottom: 10px; }
        .total-row { border-top: 2px solid #667eea; padding-top: 15px; font-weight: bold; font-size: 1.2rem; }
        .checkout-btn { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); border: none; color: white; padding: 15px; border-radius: 10px; width:100%; font-size:1.1rem; font-weight:600; margin-top:1rem; }
        .empty-cart { text-align:center; padding:4rem 2rem; }
        .empty-cart-icon { font-size:4rem; color:#ddd; margin-bottom:2rem; }
        .badge-discount { background:#ff6b6b; color:white; padding:2px 8px; border-radius:12px; font-size:0.8rem; }
        .stock-warning { color:#dc3545; font-size:0.9rem; }
        .loading { opacity: 0.6; pointer-events: none; }
        .breadcrumb { background:none; padding:1rem 0; }
        .breadcrumb-item + .breadcrumb-item::before { content: "›"; color: #667eea; }
    </style>
    <script>
    const contextPath = '${pageContext.request.contextPath}';
    window.removeFromCartById = async function(cartId){
        if(!cartId || cartId <= 0){ alert('ID sản phẩm không hợp lệ'); return; }
        if(!confirm('Bạn có chắc muốn xóa sản phẩm này khỏi giỏ hàng?')) return;
        try {
            const params = new URLSearchParams();
            params.append('cartId', cartId.toString());
            const resp = await fetch(contextPath + '/api/cart/remove', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: params.toString()
            });
            const data = await resp.json();
            if (data && data.success) {
                alert(data.message || 'Đã xóa sản phẩm');
                const el = document.querySelector(`[data-cart-id="${cartId}"]`);
                if (el) el.remove();
                if (document.querySelectorAll('.cart-item').length === 0) setTimeout(()=>location.reload(),700);
            } else {
                alert((data && data.message) || 'Không thể xóa sản phẩm');
            }
        } catch (err) {
            alert('Lỗi hệ thống khi xóa');
        }
    };
    window.clearCart = async function(){
        if(!confirm('Bạn có chắc muốn xóa tất cả sản phẩm?')) return;
        const items = Array.from(document.querySelectorAll('.cart-item'));
        for(const it of items){
            const id = it.getAttribute('data-cart-id');
            if(!id) continue;
            try {
                const params = new URLSearchParams();
                params.append('cartId', id);
                await fetch(contextPath + '/api/cart/remove', {
                    method:'POST', headers:{ 'Content-Type':'application/x-www-form-urlencoded' },
                    body: params.toString()
                });
            } catch(e){}
        }
        alert('Đã xóa tất cả');
        setTimeout(()=>location.reload(),700);
    };
    function proceedToCheckout(){
        const isLoggedIn = ${isLoggedIn};
        if(!isLoggedIn){ alert('Vui lòng đăng nhập'); window.location.href = `${contextPath}/auth/login?redirect=${window.location.pathname}`; return; }
        window.location.href = `${contextPath}/checkout`;
    }
    document.addEventListener('DOMContentLoaded', function(){
        document.querySelectorAll('.quantity-input').forEach(input => {
            input.addEventListener('blur', function(){
                const newQ = Math.max(1, parseInt(this.value) || 1);
                const pid = this.getAttribute('data-product-id');
                if(pid && typeof updateQuantity === 'function') updateQuantity(pid, newQ);
            });
        });
    });
    </script>
</head>
<body>
<div class="cart-header">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-8">
                <h1 class="mb-2"><i class="fas fa-shopping-cart me-3"></i>Giỏ hàng của bạn</h1>
                <p class="mb-0">Quản lý các sản phẩm bạn muốn mua</p>
            </div>
            <div class="col-md-4 text-end">
                <c:if test="${hasItems}">
                    <div class="text-white">
                        <i class="fas fa-box me-2"></i>
                        <span class="h5">${cartSummary.totalItems} sản phẩm</span>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>
<div class="container">
    <nav aria-label="breadcrumb">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home">Trang chủ</a></li>
            <li class="breadcrumb-item active" aria-current="page">Giỏ hàng</li>
        </ol>
    </nav>
</div>
<div class="container">
    <c:choose>
        <c:when test="${!hasItems}">
            <div class="empty-cart">
                <div class="empty-cart-icon"><i class="fas fa-shopping-cart"></i></div>
                <h3 class="mb-3">Giỏ hàng của bạn đang trống</h3>
                <p class="text-muted mb-4">Hãy khám phá và thêm sản phẩm vào giỏ hàng!</p>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-primary btn-lg"><i class="fas fa-shopping-bag me-2"></i>Tiếp tục mua sắm</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row">
                <div class="col-lg-8">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h4>Sản phẩm trong giỏ hàng</h4>
                        <button type="button" class="btn btn-outline-danger btn-sm" id="clearCartBtn" onclick="clearCart()"><i class="fas fa-trash me-2"></i>Xóa tất cả</button>
                    </div>
                    <div id="cartItemsContainer">
                        <c:forEach items="${cartItems}" var="item">
                            <div class="cart-item" data-cart-id="${item.cartId}" data-product-id="${item.productId}">
                                <div class="row align-items-center">
                                    <div class="col-md-2">
                                        <img src="${item.imageUrl}" alt="${item.productName}" class="product-image">
                                        <c:if test="${item.hasDiscount}">
                                            <div class="mt-1"><span class="badge-discount">-${item.discountPercent}%</span></div>
                                        </c:if>
                                    </div>
                                    <div class="col-md-4">
                                        <h6 class="mb-1">${item.productName}</h6>
                                        <p class="text-muted mb-1"><i class="fas fa-tag me-1"></i>${item.brand}</p>
                                        <p class="text-muted mb-1"><i class="fas fa-store me-1"></i>${item.shopName}</p>
                                        <small class="text-muted">${item.categoryName}</small>
                                    </div>
                                    <div class="col-md-2 text-center">
                                        <div class="h6 text-primary mb-0">${item.formattedPrice}</div>
                                        <c:if test="${item.hasDiscount}">
                                            <small class="text-muted text-decoration-line-through">${item.price}₫</small>
                                        </c:if>
                                    </div>
                                    <div class="col-md-2">
                                        <div class="quantity-controls">
                                            <button type="button" class="quantity-btn" onclick="updateQuantity(${item.productId}, ${item.quantity - 1})"><i class="fas fa-minus"></i></button>
                                            <input type="number" class="quantity-input" value="${item.quantity}" min="1" max="${item.stockQuantity}" data-product-id="${item.productId}" />
                                            <button type="button" class="quantity-btn" onclick="updateQuantity(${item.productId}, ${item.quantity + 1})"><i class="fas fa-plus"></i></button>
                                        </div>
                                        <c:if test="${!item.inStock}"><div class="stock-warning mt-1"><i class="fas fa-exclamation-triangle me-1"></i>Hết hàng</div></c:if>
                                        <c:if test="${item.inStock && item.quantity > item.stockQuantity}"><div class="stock-warning mt-1"><i class="fas fa-exclamation-triangle me-1"></i>Chỉ còn ${item.stockQuantity}</div></c:if>
                                    </div>
                                    <div class="col-md-2 text-end">
                                        <div class="h6 text-success mb-2">${item.formattedTotal}</div>
                                        <button type="button" class="btn btn-outline-danger btn-sm"
                                                onclick="removeFromCartById(${item.cartId})"
                                                aria-label="Xóa sản phẩm">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="text-center mt-4">
                        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary"><i class="fas fa-arrow-left me-2"></i>Tiếp tục mua sắm</a>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="cart-summary">
                        <h5 class="mb-3"><i class="fas fa-receipt me-2"></i>Tóm tắt đơn hàng</h5>
                        <div class="price-row"><span>Tạm tính:</span><span class="fw-bold">${cartSummary.formattedSubtotal}</span></div>
                        <div class="price-row"><span>Phí vận chuyển:</span><span class="fw-bold">
                            <c:choose>
                                <c:when test="${cartSummary.freeShipping}"><span class="text-success">Miễn phí</span></c:when>
                                <c:otherwise>${cartSummary.formattedShipping}</c:otherwise>
                            </c:choose>
                        </span></div>
                        <c:if test="${cartSummary.discount > 0}"><div class="price-row"><span>Giảm giá:</span><span class="fw-bold text-danger">-${cartSummary.formattedDiscount}</span></div></c:if>
                        <hr>
                        <div class="price-row total-row"><span>Tổng cộng:</span><span class="text-primary">${cartSummary.formattedTotal}</span></div>
                        <c:if test="${!cartSummary.freeShipping}"><div class="alert alert-info mt-3"><i class="fas fa-truck me-2"></i><small>Mua thêm để được miễn phí vận chuyển!</small></div></c:if>
                        <button type="button" class="checkout-btn" onclick="proceedToCheckout()"><i class="fas fa-credit-card me-2"></i>Tiến hành thanh toán</button>
                        <div class="text-center mt-3"><small class="text-muted"><i class="fas fa-shield-alt me-1"></i>Thanh toán an toàn & bảo mật</small></div>
                    </div>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>
<div id="loadingOverlay" class="d-none">
    <div class="text-center">
        <div class="spinner-border text-primary" role="status"><span class="visually-hidden">Loading...</span></div>
        <p class="mt-2">Đang xử lý...</p>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
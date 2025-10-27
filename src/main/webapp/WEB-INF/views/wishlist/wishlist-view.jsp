<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <title>Danh sách yêu thích - UTESHOP</title>
    <meta name="description" content="Quản lý danh sách sản phẩm yêu thích của bạn tại UTESHOP">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* BEAUTIFUL WISHLIST STYLES - FIXED FOR tuaanshuuysv */
        .wishlist-hero {
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 50%, #ff8a80 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
        }
        
        .wishlist-hero h1 {
            font-weight: 800;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }
        
        .wishlist-item {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            border: 1px solid rgba(255,107,107,0.1);
            overflow: hidden;
            position: relative;
        }
        
        .wishlist-item:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 30px rgba(255,107,107,0.15);
        }
        
        .wishlist-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            background: linear-gradient(45deg, #ff6b6b, #ee5a52);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }
        
        .wishlist-item:hover::before {
            transform: scaleX(1);
        }
        
        .wishlist-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 15px 15px 0 0;
            transition: transform 0.3s ease;
        }
        
        .wishlist-item:hover .wishlist-image {
            transform: scale(1.05);
        }
        
        .remove-wishlist-btn {
            position: absolute;
            top: 15px;
            right: 15px;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: none;
            background: rgba(255,255,255,0.9);
            color: #ff6b6b;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            z-index: 10;
            cursor: pointer;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
        }
        
        .remove-wishlist-btn:hover {
            background: #ff6b6b;
            color: white;
            transform: scale(1.1) rotate(-10deg);
            box-shadow: 0 5px 15px rgba(255,107,107,0.3);
        }
        
        .add-to-cart-btn {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            color: white;
            border-radius: 10px;
            padding: 10px 20px;
            font-weight: 600;
            transition: all 0.3s ease;
            width: 100%;
        }
        
        .add-to-cart-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
            color: white;
        }
        
        .wishlist-empty {
            text-align: center;
            padding: 4rem 2rem;
            background: linear-gradient(135deg, #f8f9fa 0%, #e3f2fd 100%);
            border-radius: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.05);
        }
        
        .wishlist-empty i {
            font-size: 5rem;
            color: #ff6b6b;
            opacity: 0.7;
            margin-bottom: 2rem;
        }
        
        .rating-stars {
            color: #ffc107;
        }
        
        .rating-stars i {
            font-size: 0.9rem;
        }
        
        .badge-stock {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .badge-out-of-stock {
            background: linear-gradient(45deg, #dc3545, #c82333);
            color: white;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        
        .wishlist-stats {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            margin-bottom: 2rem;
        }
        
        .pagination .page-link {
            border-radius: 10px;
            margin: 0 3px;
            border: none;
            color: #667eea;
            font-weight: 500;
        }
        
        .pagination .page-link:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(102, 126, 234, 0.3);
        }
        
        .pagination .page-item.active .page-link {
            background: linear-gradient(45deg, #ff6b6b, #ee5a52);
            border-color: #ff6b6b;
            color: white;
        }
        
        .breadcrumb {
            background: transparent;
            padding: 0;
        }
        
        .breadcrumb-item + .breadcrumb-item::before {
            content: "›";
            font-weight: bold;
            color: #ff6b6b;
        }
        
        .breadcrumb-item a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        
        .breadcrumb-item a:hover {
            color: #ff6b6b;
        }
        
        .breadcrumb-item.active {
            color: #6c757d;
        }
    </style>
</head>
<body>

<!-- WISHLIST HERO SECTION -->
<div class="wishlist-hero">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <h1 class="display-5 mb-3">
                    <i class="fas fa-heart me-3"></i>Danh sách yêu thích
                </h1>
                <p class="lead opacity-90">
                    Quản lý những sản phẩm bạn yêu thích tại UTESHOP
                </p>
                <!-- Breadcrumb -->
                <nav aria-label="breadcrumb" class="mt-3">
                    <ol class="breadcrumb">
                        <li class="breadcrumb-item">
                            <a href="${pageContext.request.contextPath}/home">
                                <i class="fas fa-home me-1"></i>Trang chủ
                            </a>
                        </li>
                        <li class="breadcrumb-item active">Danh sách yêu thích</li>
                    </ol>
                </nav>
            </div>
            <div class="col-lg-4 text-center">
                <i class="fas fa-heart fa-6x opacity-50"></i>
            </div>
        </div>
    </div>
</div>

<div class="container mb-5">
    <!-- WISHLIST STATS -->
    <div class="wishlist-stats">
        <div class="row text-center">
            <div class="col-md-4">
                <div class="h4 text-danger fw-bold mb-1">
                    <i class="fas fa-heart me-2"></i>
                    ${not empty wishlistItems ? fn:length(wishlistItems) : 0}
                </div>
                <div class="text-muted">Sản phẩm yêu thích</div>
            </div>
            <div class="col-md-4">
                <div class="h4 text-success fw-bold mb-1">
                    <i class="fas fa-check-circle me-2"></i>
                    <c:set var="inStockCount" value="0" />
                    <c:forEach items="${wishlistItems}" var="item">
                        <c:if test="${item.inStock}">
                            <c:set var="inStockCount" value="${inStockCount + 1}" />
                        </c:if>
                    </c:forEach>
                    ${inStockCount}
                </div>
                <div class="text-muted">Còn hàng</div>
            </div>
            <div class="col-md-4">
                <div class="h4 text-primary fw-bold mb-1">
                    <i class="fas fa-shopping-cart me-2"></i>
                    <fmt:formatNumber value="${totalValue != null ? totalValue : 0}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                </div>
                <div class="text-muted">Tổng giá trị</div>
            </div>
        </div>
        
        <!-- QUICK ACTIONS -->
        <c:if test="${not empty wishlistItems and fn:length(wishlistItems) > 0}">
            <div class="row mt-4">
                <div class="col-md-6 text-center text-md-start">
                    <button type="button" class="btn btn-outline-success" onclick="addAllToCart()">
                        <i class="fas fa-cart-plus me-2"></i>Thêm tất cả vào giỏ hàng
                    </button>
                </div>
                <div class="col-md-6 text-center text-md-end">
                    <button type="button" class="btn btn-outline-danger" onclick="clearWishlist()">
                        <i class="fas fa-trash me-2"></i>Xóa tất cả
                    </button>
                </div>
            </div>
        </c:if>
    </div>

    <!-- WISHLIST ITEMS -->
    <c:choose>
        <c:when test="${not empty wishlistItems and fn:length(wishlistItems) > 0}">
            <div class="row g-4">
                <c:forEach items="${wishlistItems}" var="item" varStatus="status">
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="card wishlist-item h-100">
                            <!-- Remove Button -->
                            <button type="button" 
                                    class="remove-wishlist-btn"
                                    data-product-id="${item.productId}"
                                    onclick="removeFromWishlist(this, ${item.productId})"
                                    title="Xóa khỏi danh sách yêu thích">
                                <i class="fas fa-times"></i>
                            </button>
                            
                            <!-- Product Image -->
                            <img src="${not empty item.imageUrl ? item.imageUrl : '/uteshop-cpl/assets/images/default-product.png'}" 
                                 class="wishlist-image" 
                                 alt="${item.productName}"
                                 loading="lazy">
                            
                            <!-- Product Info -->
                            <div class="card-body p-3">
                                <h6 class="card-title fw-bold text-truncate mb-2" title="${item.productName}">
                                    ${item.productName}
                                </h6>
                                
                                <!-- Brand & Shop -->
                                <div class="mb-2">
                                    <small class="text-muted">
                                        <i class="fas fa-tag me-1"></i>
                                        ${not empty item.brand ? item.brand : 'UTESHOP'}
                                    </small>
                                </div>
                                
                                <div class="mb-2">
                                    <small class="text-muted">
                                        <i class="fas fa-store me-1"></i>
                                        ${not empty item.shopName ? item.shopName : 'UTESHOP Store'}
                                    </small>
                                </div>
                                
                                <!-- Price -->
                                <div class="mb-2">
                                    <span class="h6 text-danger fw-bold">
                                        <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                    </span>
                                    <c:if test="${not empty item.salePrice and item.salePrice > 0 and item.salePrice < item.price}">
                                        <div class="mt-1">
                                            <small class="text-muted text-decoration-line-through">
                                                <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                            </small>
                                            <small class="text-success ms-2 fw-bold">
                                                <i class="fas fa-arrow-down"></i>
                                                <fmt:formatNumber value="${((item.price - item.salePrice) / item.price) * 100}" maxFractionDigits="0"/>%
                                            </small>
                                        </div>
                                    </c:if>
                                </div>
                                
                                <!-- Rating -->
                                <div class="mb-2">
                                    <div class="rating-stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fas fa-star ${i <= (not empty item.rating ? item.rating : 5) ? '' : 'text-muted'}"></i>
                                        </c:forEach>
                                        <small class="text-muted ms-1">(${not empty item.reviewCount ? item.reviewCount : 0})</small>
                                    </div>
                                </div>
                                
                                <!-- Stock Status -->
                                <div class="mb-3">
                                    <c:choose>
                                        <c:when test="${item.inStock}">
                                            <span class="badge-stock">
                                                <i class="fas fa-check-circle me-1"></i>Còn hàng
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-out-of-stock">
                                                <i class="fas fa-times-circle me-1"></i>Hết hàng
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <!-- Actions -->
                                <div class="d-grid gap-2">
                                    <c:choose>
                                        <c:when test="${item.inStock}">
                                            <button type="button" 
                                                    class="add-to-cart-btn"
                                                    onclick="addToCartFromWishlist(${item.productId})">
                                                <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" class="btn btn-outline-secondary" disabled>
                                                <i class="fas fa-times me-2"></i>Hết hàng
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="${pageContext.request.contextPath}/products/${item.productId}" 
                                       class="btn btn-outline-primary btn-sm">
                                        <i class="fas fa-eye me-2"></i>Xem chi tiết
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
            
            <!-- PAGINATION -->
            <c:if test="${totalPages > 1}">
                <nav aria-label="Wishlist pagination" class="mt-5">
                    <ul class="pagination justify-content-center">
                        <!-- Previous Page -->
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage - 1}">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </li>
                        </c:if>
                        
                        <!-- Page Numbers -->
                        <c:forEach begin="1" end="${totalPages}" var="pageNum">
                            <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?page=${pageNum}">${pageNum}</a>
                            </li>
                        </c:forEach>
                        
                        <!-- Next Page -->
                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="?page=${currentPage + 1}">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </c:if>
            
        </c:when>
        <c:otherwise>
            <!-- EMPTY WISHLIST -->
            <div class="wishlist-empty">
                <i class="fas fa-heart-broken"></i>
                <h3 class="mb-3 text-muted">Danh sách yêu thích trống</h3>
                <p class="lead text-muted mb-4">
                    Bạn chưa có sản phẩm nào trong danh sách yêu thích.<br>
                    Hãy khám phá và thêm những sản phẩm bạn thích!
                </p>
                <div class="d-flex gap-3 justify-content-center flex-wrap">
                    <a href="${pageContext.request.contextPath}/search" class="btn btn-primary btn-lg">
                        <i class="fas fa-search me-2"></i>Khám phá sản phẩm
                    </a>
                    <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-primary btn-lg">
                        <i class="fas fa-home me-2"></i>Về trang chủ
                    </a>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- COMPLETE WISHLIST JAVASCRIPT - FIXED EL ERRORS -->
<script>
// Global variables
const contextPath = '${pageContext.request.contextPath}';
const currentUser = '${not empty authUser.username ? authUser.username : "tuaanshuuysv"}';
const wishlistCount = ${not empty wishlistItems ? fn:length(wishlistItems) : 0};

console.log('❤️ FIXED Wishlist page initialized at 2025-10-27 09:45:41 UTC');
console.log('👤 User: tuaanshuuysv');
console.log('📊 Wishlist items:', wishlistCount);
console.log('🔧 FIXED: EL expression errors resolved');

// Remove from wishlist
function removeFromWishlist(buttonElement, productId) {
    console.log('🗑️ Removing from wishlist - Product:', productId);
    
    if (!productId || productId <= 0) {
        showWishlistNotification('ID sản phẩm không hợp lệ', 'error');
        return;
    }
    
    // Show confirmation
    if (!confirm('Bạn có chắc muốn xóa sản phẩm này khỏi danh sách yêu thích?')) {
        return;
    }
    
    // Disable button
    buttonElement.disabled = true;
    buttonElement.style.opacity = '0.5';
    
    const params = new URLSearchParams();
    params.append('productId', productId.toString());
    
    fetch(contextPath + '/api/wishlist/toggle', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params.toString()
    })
    .then(response => response.json())
    .then(data => {
        console.log('📡 Remove wishlist response:', data);
        
        if (data.success) {
            showWishlistNotification(data.message, 'success');
            
            // Remove item from page with animation
            const wishlistItem = buttonElement.closest('.wishlist-item').parentElement;
            wishlistItem.style.transition = 'all 0.5s ease';
            wishlistItem.style.transform = 'scale(0)';
            wishlistItem.style.opacity = '0';
            
            setTimeout(() => {
                wishlistItem.remove();
                
                // Check if no items left
                const remainingItems = document.querySelectorAll('.wishlist-item');
                if (remainingItems.length === 0) {
                    location.reload(); // Reload to show empty state
                }
            }, 500);
            
            // Update counters
            updateWishlistCounters();
            
        } else {
            showWishlistNotification(data.message, 'error');
            buttonElement.disabled = false;
            buttonElement.style.opacity = '1';
        }
    })
    .catch(error => {
        console.error('❌ Remove wishlist error:', error);
        showWishlistNotification('Có lỗi xảy ra khi xóa sản phẩm', 'error');
        buttonElement.disabled = false;
        buttonElement.style.opacity = '1';
    });
}

// Add to cart from wishlist
function addToCartFromWishlist(productId) {
    console.log('🛒 Adding to cart from wishlist - Product:', productId);
    
    if (!productId || productId <= 0) {
        showWishlistNotification('ID sản phẩm không hợp lệ', 'error');
        return;
    }
    
    const params = new URLSearchParams();
    params.append('productId', productId.toString());
    params.append('quantity', '1');
    
    fetch(contextPath + '/api/cart/add', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params.toString()
    })
    .then(response => response.json())
    .then(data => {
        console.log('🛒 Add to cart response:', data);
        
        if (data.success) {
            showWishlistNotification('Đã thêm vào giỏ hàng từ danh sách yêu thích! 🎉', 'success');
            updateCartCounters();
        } else {
            showWishlistNotification(data.message, 'error');
        }
    })
    .catch(error => {
        console.error('❌ Add to cart error:', error);
        showWishlistNotification('Có lỗi xảy ra khi thêm vào giỏ hàng', 'error');
    });
}

// Add all to cart
function addAllToCart() {
    console.log('🛒 Adding all wishlist items to cart');
    
    if (!confirm('Bạn có muốn thêm tất cả sản phẩm vào giỏ hàng?')) {
        return;
    }
    
    const inStockItems = document.querySelectorAll('.wishlist-item .add-to-cart-btn:not(:disabled)');
    let addedCount = 0;
    let totalCount = inStockItems.length;
    
    if (totalCount === 0) {
        showWishlistNotification('Không có sản phẩm nào có thể thêm vào giỏ hàng', 'warning');
        return;
    }
    
    showWishlistNotification(`Đang thêm ${totalCount} sản phẩm vào giỏ hàng...`, 'info');
    
    inStockItems.forEach((button, index) => {
        const productId = button.closest('.wishlist-item').querySelector('.remove-wishlist-btn').dataset.productId;
        
        setTimeout(() => {
            const params = new URLSearchParams();
            params.append('productId', productId);
            params.append('quantity', '1');
            
            fetch(contextPath + '/api/cart/add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params.toString()
            })
            .then(response => response.json())
            .then(data => {
                addedCount++;
                
                if (addedCount === totalCount) {
                    showWishlistNotification(`Đã thêm ${addedCount} sản phẩm vào giỏ hàng thành công! 🎉`, 'success');
                    updateCartCounters();
                }
            })
            .catch(error => {
                console.error('❌ Bulk add to cart error:', error);
            });
            
        }, index * 200); // Stagger requests
    });
}

// Clear wishlist
function clearWishlist() {
    console.log('🗑️ Clearing entire wishlist');
    
    if (!confirm('Bạn có chắc muốn xóa TẤT CẢ sản phẩm khỏi danh sách yêu thích?')) {
        return;
    }
    
    if (!confirm('Hành động này không thể hoàn tác. Bạn có chắc chắn?')) {
        return;
    }
    
    const removeButtons = document.querySelectorAll('.remove-wishlist-btn');
    let removedCount = 0;
    let totalCount = removeButtons.length;
    
    showWishlistNotification(`Đang xóa ${totalCount} sản phẩm...`, 'info');
    
    removeButtons.forEach((button, index) => {
        const productId = button.dataset.productId;
        
        setTimeout(() => {
            const params = new URLSearchParams();
            params.append('productId', productId);
            
            fetch(contextPath + '/api/wishlist/toggle', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: params.toString()
            })
            .then(response => response.json())
            .then(data => {
                removedCount++;
                
                if (removedCount === totalCount) {
                    showWishlistNotification('Đã xóa tất cả sản phẩm khỏi danh sách yêu thích', 'success');
                    setTimeout(() => {
                        location.reload();
                    }, 1500);
                }
            })
            .catch(error => {
                console.error('❌ Bulk remove wishlist error:', error);
            });
            
        }, index * 100); // Stagger requests
    });
}

// Update counters
function updateWishlistCounters() {
    // Update header wishlist count
    const wishlistCountElements = document.querySelectorAll('.wishlist-count');
    wishlistCountElements.forEach(el => {
        const currentCount = parseInt(el.textContent) || 0;
        el.textContent = Math.max(0, currentCount - 1);
    });
}

function updateCartCounters() {
    // Update header cart count
    const cartCountElements = document.querySelectorAll('.cart-count');
    cartCountElements.forEach(el => {
        const currentCount = parseInt(el.textContent) || 0;
        el.textContent = currentCount + 1;
        el.style.animation = 'pulse 0.5s ease-in-out';
    });
}

// FIXED notification system
function showWishlistNotification(message, type) {
    type = type || 'info';
    
    const alertConfig = {
        'error': { className: 'alert-danger', icon: 'fa-exclamation-triangle', bgColor: '#ff6b6b' },
        'warning': { className: 'alert-warning', icon: 'fa-exclamation-circle', bgColor: '#ffc107' },
        'success': { className: 'alert-success', icon: 'fa-check-circle', bgColor: '#28a745' },
        'info': { className: 'alert-info', icon: 'fa-info-circle', bgColor: '#667eea' }
    };
    
    const config = alertConfig[type] || alertConfig.info;
    
    // Remove existing notifications
    document.querySelectorAll('.wishlist-notification').forEach(el => el.remove());
    
    // Create notification
    const notification = document.createElement('div');
    notification.className = 'wishlist-notification position-fixed';
    notification.style.cssText = `
        top: 20px; 
        right: 20px; 
        z-index: 9999; 
        min-width: 350px; 
        max-width: 450px;
        animation: slideInRight 0.3s ease-out;
    `;
    
    notification.innerHTML = `
        <div class="alert ${config.className} alert-dismissible fade show shadow-lg" 
             style="border: none; border-radius: 15px; background: ${config.bgColor}; color: white;">
            <div class="d-flex align-items-center">
                <i class="fas ${config.icon} fa-lg me-3"></i>
                <div class="flex-grow-1">
                    <strong>Wishlist!</strong>
                    <div>${message}</div>
                </div>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="alert"></button>
            </div>
        </div>
    `;
    
    document.body.appendChild(notification);
    
    // Auto remove after 4 seconds
    setTimeout(() => {
        if (notification.parentNode) {
            notification.style.animation = 'slideOutRight 0.3s ease-in';
            setTimeout(() => notification.remove(), 300);
        }
    }, 4000);
    
    console.log('📢 Wishlist notification:', type, '-', message);
}

// Page load
document.addEventListener('DOMContentLoaded', function() {
    console.log('✅ FIXED Wishlist page loaded successfully');
    console.log('❤️ User: tuaanshuuysv');
    console.log('📊 Items: ' + wishlistCount);
    console.log('🔧 EL errors resolved at 2025-10-27 09:45:41 UTC');
    
    // Add hover effects
    document.querySelectorAll('.wishlist-item').forEach(item => {
        item.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
        });
        
        item.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });
    });
});

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideInRight {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    
    @keyframes slideOutRight {
        from { transform: translateX(0); opacity: 1; }
        to { transform: translateX(100%); opacity: 0; }
    }
    
    @keyframes pulse {
        0% { transform: scale(1); }
        50% { transform: scale(1.1); }
        100% { transform: scale(1); }
    }
`;
document.head.appendChild(style);
</script>

</body>
</html>
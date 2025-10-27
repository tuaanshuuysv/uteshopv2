<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- COMPLETE HEADER với LOGIN BUTTONS cho tuaanshuuysv -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary sticky-top">
    <div class="container">
        <!-- Brand Logo -->
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">
            <i class="fas fa-store me-2"></i>UTESHOP
        </a>
        
        <!-- Mobile Toggle -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <!-- Navigation Content -->
        <div class="collapse navbar-collapse" id="navbarContent">
            <!-- Search Bar -->
            <div class="mx-auto" style="max-width: 400px;">
                <form class="d-flex" action="${pageContext.request.contextPath}/search" method="get">
                    <div class="input-group">
                        <input type="text" name="query" class="form-control" 
                               placeholder="Tìm kiếm sản phẩm..." 
                               value="${param.query}">
                        <button class="btn btn-warning" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- Right Navigation -->
            <ul class="navbar-nav ms-auto align-items-center">
                <!-- Cart -->
                <li class="nav-item me-3">
                    <a class="nav-link position-relative" href="${pageContext.request.contextPath}/cart">
                        <i class="fas fa-shopping-cart fa-lg"></i>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-warning text-dark cart-count">
                            0
                        </span>
                    </a>
                </li>
                
                <!-- Wishlist -->
                <li class="nav-item me-3">
                    <a class="nav-link position-relative" href="${pageContext.request.contextPath}/user/wishlist">
                        <i class="fas fa-heart fa-lg"></i>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger wishlist-count">
                            0
                        </span>
                    </a>
                </li>
                
                <!-- User Menu -->
                <c:choose>
                    <c:when test="${isLoggedIn}">
                        <!-- Logged In User -->
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" 
                               id="userDropdown" role="button" data-bs-toggle="dropdown">
                                <i class="fas fa-user-circle fa-lg me-2"></i>
                                <span class="d-none d-md-inline">
                                    <c:choose>
                                        <c:when test="${not empty authUser.fullName}">${authUser.fullName}</c:when>
                                        <c:when test="${not empty authUser.username}">${authUser.username}</c:when>
                                        <c:otherwise>Tài khoản</c:otherwise>
                                    </c:choose>
                                </span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end">
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile">
                                        <i class="fas fa-user me-2"></i>Hồ sơ cá nhân
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/user/orders">
                                        <i class="fas fa-receipt me-2"></i>Đơn hàng của tôi
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/user/wishlist">
                                        <i class="fas fa-heart me-2"></i>Sản phẩm yêu thích
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/auth/logout">
                                        <i class="fas fa-sign-out-alt me-2"></i>Đăng xuất
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <!-- Guest User -->
                        <li class="nav-item me-2">
                            <a class="btn btn-outline-light" href="${pageContext.request.contextPath}/auth/login">
                                <i class="fas fa-sign-in-alt me-1"></i>Đăng nhập
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-warning" href="${pageContext.request.contextPath}/auth/register">
                                <i class="fas fa-user-plus me-1"></i>Đăng ký
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<!-- Categories Navigation -->
<nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom">
    <div class="container">
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">
                        <i class="fas fa-home me-1"></i>Trang chủ
                    </a>
                </li>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-th-large me-1"></i>Danh mục
                    </a>
                    <ul class="dropdown-menu">
                        <c:choose>
                            <c:when test="${not empty categories}">
                                <c:forEach items="${categories}" var="category">
                                    <li>
                                        <a class="dropdown-item" href="${pageContext.request.contextPath}/search?category=${category.categoryId}">
                                            <i class="fas fa-tag me-2"></i>${category.categoryName}
                                        </a>
                                    </li>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/search">Tất cả sản phẩm</a></li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/search">
                        <i class="fas fa-search me-1"></i>Tìm kiếm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/shops">
                        <i class="fas fa-store me-1"></i>Cửa hàng
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<style>
.navbar-brand {
    font-size: 1.5rem;
}

.nav-link {
    font-weight: 500;
}

.badge {
    font-size: 0.6rem;
    min-width: 18px;
    height: 18px;
    line-height: 18px;
}

.dropdown-menu {
    border-radius: 10px;
    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
}

.input-group .form-control {
    border-radius: 20px 0 0 20px;
}

.input-group .btn {
    border-radius: 0 20px 20px 0;
}
</style>

<script>
// Load cart and wishlist counts on page load
document.addEventListener('DOMContentLoaded', function() {
    const isLoggedIn = ${isLoggedIn != null ? isLoggedIn : false};
    
    if (isLoggedIn) {
        // Load cart count
        fetch('${pageContext.request.contextPath}/api/cart/count')
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    updateCartCount(data.count);
                }
            })
            .catch(error => console.log('Cart count load failed:', error));
        
        // Load wishlist count  
        fetch('${pageContext.request.contextPath}/api/wishlist/count')
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    updateWishlistCount(data.count);
                }
            })
            .catch(error => console.log('Wishlist count load failed:', error));
    }
});

// Global functions to update counts
function updateCartCount(count) {
    const elements = document.querySelectorAll('.cart-count');
    elements.forEach(el => el.textContent = count || 0);
}

function updateWishlistCount(count) {
    const elements = document.querySelectorAll('.wishlist-count');
    elements.forEach(el => el.textContent = count || 0);
}

// Make functions global
window.updateCartCount = updateCartCount;
window.updateWishlistCount = updateWishlistCount;
</script>
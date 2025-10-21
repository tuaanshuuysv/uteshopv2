<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- UTESHOP-CPL - Simple UI Only Home Page -->
<!-- Created: 2025-10-21 03:00:15 UTC by tuaanshuuysv -->

<div class="home-page">
    
    <!-- Welcome Banner -->
    <section class="welcome-banner">
        <div class="container">
            <div class="row">
                <div class="col-12">
                    <div class="welcome-card">
                        <c:choose>
                            <c:when test="${isLoggedIn}">
                                <h1>Chào mừng trở lại, <span class="text-primary">${authUser.fullName}</span>!</h1>
                                <p>Khám phá những sản phẩm mới nhất và ưu đãi đặc biệt</p>
                                <div class="user-quick-stats">
                                    <div class="stat-item">
                                        <i class="fas fa-shopping-bag"></i>
                                        <span>12 Đơn hàng</span>
                                    </div>
                                    <div class="stat-item">
                                        <i class="fas fa-heart"></i>
                                        <span>45 Yêu thích</span>
                                    </div>
                                    <div class="stat-item">
                                        <i class="fas fa-star"></i>
                                        <span>4.8 Đánh giá</span>
                                    </div>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <h1>Chào mừng đến với <span class="text-primary">UTESHOP-CPL</span></h1>
                                <p>Nền tảng mua sắm trực tuyến hàng đầu với hàng nghìn sản phẩm chất lượng</p>
                                <div class="guest-actions">
                                    <a href="${pageContext.request.contextPath}/auth/register" class="btn btn-primary">
                                        <i class="fas fa-user-plus"></i> Đăng ký ngay
                                    </a>
                                    <a href="${pageContext.request.contextPath}/auth/login" class="btn btn-outline-primary">
                                        <i class="fas fa-sign-in-alt"></i> Đăng nhập
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Quick Access for Users -->
    <c:if test="${isLoggedIn}">
        <section class="quick-access">
            <div class="container">
                <h3>Truy cập nhanh</h3>
                <div class="row">
                    <div class="col-md-3 mb-3">
                        <div class="quick-card">
                            <i class="fas fa-shopping-cart"></i>
                            <h5>Giỏ hàng</h5>
                            <span class="badge bg-danger">3</span>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="quick-card">
                            <i class="fas fa-box"></i>
                            <h5>Đơn hàng</h5>
                            <small>2 đang giao</small>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="quick-card">
                            <i class="fas fa-heart"></i>
                            <h5>Yêu thích</h5>
                            <small>45 sản phẩm</small>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="quick-card">
                            <i class="fas fa-user"></i>
                            <h5>Tài khoản</h5>
                            <small>Hoàn thiện 85%</small>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </c:if>

    <!-- Categories -->
    <section class="categories">
        <div class="container">
            <h3>Danh mục sản phẩm</h3>
            <div class="row">
                <div class="col-md-2 col-6 mb-3">
                    <div class="category-item">
                        <i class="fas fa-laptop"></i>
                        <h6>Điện tử</h6>
                        <small>1,234 sản phẩm</small>
                    </div>
                </div>
                <div class="col-md-2 col-6 mb-3">
                    <div class="category-item">
                        <i class="fas fa-tshirt"></i>
                        <h6>Thời trang</h6>
                        <small>2,567 sản phẩm</small>
                    </div>
                </div>
                <div class="col-md-2 col-6 mb-3">
                    <div class="category-item">
                        <i class="fas fa-home"></i>
                        <h6>Nhà cửa</h6>
                        <small>891 sản phẩm</small>
                    </div>
                </div>
                <div class="col-md-2 col-6 mb-3">
                    <div class="category-item">
                        <i class="fas fa-running"></i>
                        <h6>Thể thao</h6>
                        <small>456 sản phẩm</small>
                    </div>
                </div>
                <div class="col-md-2 col-6 mb-3">
                    <div class="category-item">
                        <i class="fas fa-spa"></i>
                        <h6>Làm đẹp</h6>
                        <small>678 sản phẩm</small>
                    </div>
                </div>
                <div class="col-md-2 col-6 mb-3">
                    <div class="category-item">
                        <i class="fas fa-book"></i>
                        <h6>Sách</h6>
                        <small>234 sản phẩm</small>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Flash Sale -->
    <section class="flash-sale">
        <div class="container">
            <div class="flash-header">
                <h3><i class="fas fa-bolt"></i> Flash Sale</h3>
                <div class="countdown">
                    <span class="time-box">12:34:56</span>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-3 mb-4">
                    <div class="product-card">
                        <div class="product-image">
                            <img src="https://via.placeholder.com/300x300/4f46e5/ffffff?text=iPhone+15" alt="iPhone 15">
                            <span class="discount-badge">-50%</span>
                        </div>
                        <div class="product-info">
                            <h6>iPhone 15 Pro Max 256GB</h6>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                                <span>(4.5)</span>
                            </div>
                            <div class="price">
                                <span class="current">29.990.000₫</span>
                                <span class="original">59.990.000₫</span>
                            </div>
                            <button class="btn btn-primary w-100">
                                <i class="fas fa-cart-plus"></i> Thêm vào giỏ
                            </button>
                        </div>
                    </div>
                </div>

                <div class="col-md-3 mb-4">
                    <div class="product-card">
                        <div class="product-image">
                            <img src="https://via.placeholder.com/300x300/7c3aed/ffffff?text=MacBook" alt="MacBook">
                            <span class="discount-badge">-30%</span>
                        </div>
                        <div class="product-info">
                            <h6>MacBook Air M2 13inch 256GB</h6>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <span>(5.0)</span>
                            </div>
                            <div class="price">
                                <span class="current">24.990.000₫</span>
                                <span class="original">35.990.000₫</span>
                            </div>
                            <button class="btn btn-primary w-100">
                                <i class="fas fa-cart-plus"></i> Thêm vào giỏ
                            </button>
                        </div>
                    </div>
                </div>

                <div class="col-md-3 mb-4">
                    <div class="product-card">
                        <div class="product-image">
                            <img src="https://via.placeholder.com/300x300/06b6d4/ffffff?text=Samsung" alt="Samsung">
                            <span class="discount-badge">-40%</span>
                        </div>
                        <div class="product-info">
                            <h6>Samsung Galaxy S24 Ultra</h6>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="far fa-star"></i>
                                <span>(4.0)</span>
                            </div>
                            <div class="price">
                                <span class="current">26.990.000₫</span>
                                <span class="original">44.990.000₫</span>
                            </div>
                            <button class="btn btn-primary w-100">
                                <i class="fas fa-cart-plus"></i> Thêm vào giỏ
                            </button>
                        </div>
                    </div>
                </div>

                <div class="col-md-3 mb-4">
                    <div class="product-card">
                        <div class="product-image">
                            <img src="https://via.placeholder.com/300x300/10b981/ffffff?text=Sony" alt="Sony">
                            <span class="discount-badge">-25%</span>
                        </div>
                        <div class="product-info">
                            <h6>Sony WH-1000XM5 Wireless</h6>
                            <div class="rating">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                                <span>(4.7)</span>
                            </div>
                            <div class="price">
                                <span class="current">7.490.000₫</span>
                                <span class="original">9.990.000₫</span>
                            </div>
                            <button class="btn btn-primary w-100">
                                <i class="fas fa-cart-plus"></i> Thêm vào giỏ
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="text-center">
                <a href="#" class="btn btn-outline-danger btn-lg">
                    <i class="fas fa-bolt"></i> Xem tất cả Flash Sale
                </a>
            </div>
        </div>
    </section>

    <!-- Product Tabs -->
    <section class="product-tabs">
        <div class="container">
            <ul class="nav nav-pills justify-content-center">
                <li class="nav-item">
                    <a class="nav-link active" href="#new">
                        <i class="fas fa-sparkles"></i> Sản phẩm mới
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#bestseller">
                        <i class="fas fa-fire"></i> Bán chạy
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#rated">
                        <i class="fas fa-star"></i> Đánh giá cao
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#featured">
                        <i class="fas fa-crown"></i> Nổi bật
                    </a>
                </li>
            </ul>

            <div class="products-grid">
                <div class="row">
                    <!-- Product cards will be here -->
                    <div class="col-md-3 mb-4">
                        <div class="product-card">
                            <div class="product-image">
                                <img src="https://via.placeholder.com/300x300/f59e0b/ffffff?text=Product+1" alt="Product 1">
                            </div>
                            <div class="product-info">
                                <h6>Sản phẩm mới 1</h6>
                                <div class="rating">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="far fa-star"></i>
                                    <span>(4.2)</span>
                                </div>
                                <div class="price">
                                    <span class="current">1.990.000₫</span>
                                    <span class="original">2.990.000₫</span>
                                </div>
                                <button class="btn btn-primary w-100">
                                    <i class="fas fa-cart-plus"></i> Thêm vào giỏ
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-3 mb-4">
                        <div class="product-card">
                            <div class="product-image">
                                <img src="https://via.placeholder.com/300x300/ef4444/ffffff?text=Product+2" alt="Product 2">
                            </div>
                            <div class="product-info">
                                <h6>Sản phẩm mới 2</h6>
                                <div class="rating">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <span>(5.0)</span>
                                </div>
                                <div class="price">
                                    <span class="current">3.490.000₫</span>
                                    <span class="original">4.990.000₫</span>
                                </div>
                                <button class="btn btn-primary w-100">
                                    <i class="fas fa-cart-plus"></i> Thêm vào giỏ
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-3 mb-4">
                        <div class="product-card">
                            <div class="product-image">
                                <img src="https://via.placeholder.com/300x300/8b5cf6/ffffff?text=Product+3" alt="Product 3">
                            </div>
                            <div class="product-info">
                                <h6>Sản phẩm mới 3</h6>
                                <div class="rating">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star-half-alt"></i>
                                    <i class="far fa-star"></i>
                                    <span>(3.5)</span>
                                </div>
                                <div class="price">
                                    <span class="current">890.000₫</span>
                                    <span class="original">1.290.000₫</span>
                                </div>
                                <button class="btn btn-primary w-100">
                                    <i class="fas fa-cart-plus"></i> Thêm vào giỏ
                                </button>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-3 mb-4">
                        <div class="product-card">
                            <div class="product-image">
                                <img src="https://via.placeholder.com/300x300/14b8a6/ffffff?text=Product+4" alt="Product 4">
                            </div>
                            <div class="product-info">
                                <h6>Sản phẩm mới 4</h6>
                                <div class="rating">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star-half-alt"></i>
                                    <span>(4.6)</span>
                                </div>
                                <div class="price">
                                    <span class="current">5.990.000₫</span>
                                    <span class="original">7.990.000₫</span>
                                </div>
                                <button class="btn btn-primary w-100">
                                    <i class="fas fa-cart-plus"></i> Thêm vào giỏ
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="text-center">
                    <button class="btn btn-outline-primary btn-lg">
                        <i class="fas fa-plus"></i> Xem thêm sản phẩm
                    </button>
                </div>
            </div>
        </div>
    </section>

    <!-- Recently Viewed (for logged users) -->
    <c:if test="${isLoggedIn}">
        <section class="recently-viewed">
            <div class="container">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h3><i class="fas fa-history"></i> Sản phẩm đã xem</h3>
                    <a href="#" class="btn btn-outline-primary btn-sm">
                        Xem tất cả <i class="fas fa-arrow-right"></i>
                    </a>
                </div>

                <div class="row">
                    <div class="col-md-2 col-6 mb-3">
                        <div class="viewed-item">
                            <img src="https://via.placeholder.com/150x150/4f46e5/ffffff?text=iPhone" alt="iPhone">
                            <h6>iPhone 14 Pro</h6>
                            <span>25.990.000₫</span>
                            <small>2 giờ trước</small>
                        </div>
                    </div>
                    <div class="col-md-2 col-6 mb-3">
                        <div class="viewed-item">
                            <img src="https://via.placeholder.com/150x150/7c3aed/ffffff?text=MacBook" alt="MacBook">
                            <h6>MacBook Pro M3</h6>
                            <span>45.990.000₫</span>
                            <small>1 ngày trước</small>
                        </div>
                    </div>
                    <div class="col-md-2 col-6 mb-3">
                        <div class="viewed-item">
                            <img src="https://via.placeholder.com/150x150/06b6d4/ffffff?text=iPad" alt="iPad">
                            <h6>iPad Air M2</h6>
                            <span>16.990.000₫</span>
                            <small>2 ngày trước</small>
                        </div>
                    </div>
                    <div class="col-md-2 col-6 mb-3">
                        <div class="viewed-item">
                            <img src="https://via.placeholder.com/150x150/10b981/ffffff?text=Watch" alt="Watch">
                            <h6>Apple Watch S9</h6>
                            <span>8.990.000₫</span>
                            <small>3 ngày trước</small>
                        </div>
                    </div>
                    <div class="col-md-2 col-6 mb-3">
                        <div class="viewed-item">
                            <img src="https://via.placeholder.com/150x150/f59e0b/ffffff?text=AirPods" alt="AirPods">
                            <h6>AirPods Pro 2</h6>
                            <span>5.990.000₫</span>
                            <small>1 tuần trước</small>
                        </div>
                    </div>
                    <div class="col-md-2 col-6 mb-3">
                        <div class="viewed-item">
                            <img src="https://via.placeholder.com/150x150/ef4444/ffffff?text=Sony" alt="Sony">
                            <h6>Sony WH-1000XM5</h6>
                            <span>7.990.000₫</span>
                            <small>1 tuần trước</small>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </c:if>

    <!-- Newsletter -->
    <section class="newsletter">
        <div class="container">
            <div class="newsletter-card">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h3><i class="fas fa-envelope"></i> Đăng ký nhận tin</h3>
                        <p>Nhận thông báo về sản phẩm mới và khuyến mãi đặc biệt</p>
                    </div>
                    <div class="col-md-6">
                        <div class="input-group">
                            <input type="email" class="form-control" placeholder="Nhập email của bạn">
                            <button class="btn btn-light">
                                <i class="fas fa-paper-plane"></i> Đăng ký
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer Info -->
    <section class="footer-info">
        <div class="container">
            <div class="row text-center">
                <div class="col-md-3 mb-4">
                    <i class="fas fa-shipping-fast fa-3x text-primary mb-3"></i>
                    <h5>Giao hàng nhanh</h5>
                    <p>Giao trong 24h</p>
                </div>
                <div class="col-md-3 mb-4">
                    <i class="fas fa-shield-alt fa-3x text-success mb-3"></i>
                    <h5>Bảo mật tuyệt đối</h5>
                    <p>Thanh toán an toàn</p>
                </div>
                <div class="col-md-3 mb-4">
                    <i class="fas fa-headset fa-3x text-info mb-3"></i>
                    <h5>Hỗ trợ 24/7</h5>
                    <p>Luôn sẵn sàng hỗ trợ</p>
                </div>
                <div class="col-md-3 mb-4">
                    <i class="fas fa-undo fa-3x text-warning mb-3"></i>
                    <h5>Đổi trả dễ dàng</h5>
                    <p>30 ngày đổi trả</p>
                </div>
            </div>
            
            <hr>
            
            <div class="text-center">
                <p>
                    <strong>UTESHOP-CPL</strong> - Nền tảng thương mại điện tử hiện đại<br>
                    © 2025 Created by <strong>tuaanshuuysv</strong>
                    <c:if test="${isLoggedIn}">
                        | Xin chào, <strong>${authUser.username}</strong>! 👋
                    </c:if>
                </p>
            </div>
        </div>
    </section>
</div>

<style>
/* Simple Home Page Styles - UI Only */
.home-page {
    padding: 0;
    margin: 0;
}

/* Sections */
section {
    padding: 40px 0;
}

section:nth-child(even) {
    background-color: #f8f9fa;
}

/* Welcome Banner */
.welcome-banner {
    background: linear-gradient(135deg, #4f46e5, #7c3aed);
    color: white;
    padding: 60px 0;
}

.welcome-card {
    text-align: center;
    background: rgba(255, 255, 255, 0.1);
    backdrop-filter: blur(10px);
    border-radius: 15px;
    padding: 40px;
}

.welcome-card h1 {
    font-size: 2.5rem;
    margin-bottom: 20px;
}

.welcome-card p {
    font-size: 1.2rem;
    margin-bottom: 30px;
    opacity: 0.9;
}

.user-quick-stats {
    display: flex;
    justify-content: center;
    gap: 30px;
    margin-top: 30px;
}

.stat-item {
    display: flex;
    align-items: center;
    gap: 10px;
    background: rgba(255, 255, 255, 0.1);
    padding: 15px 20px;
    border-radius: 10px;
}

.stat-item i {
    font-size: 1.5rem;
    color: #fbbf24;
}

.guest-actions {
    display: flex;
    gap: 15px;
    justify-content: center;
    margin-top: 30px;
}

/* Quick Access */
.quick-access {
    background: #f8f9fa;
}

.quick-access h3 {
    text-align: center;
    margin-bottom: 40px;
    color: #1f2937;
}

.quick-card {
    background: white;
    border-radius: 12px;
    padding: 25px;
    text-align: center;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    transition: transform 0.3s ease;
    cursor: pointer;
}

.quick-card:hover {
    transform: translateY(-5px);
}

.quick-card i {
    font-size: 2.5rem;
    color: #4f46e5;
    margin-bottom: 15px;
}

.quick-card h5 {
    margin-bottom: 10px;
    color: #1f2937;
}

/* Categories */
.categories h3 {
    text-align: center;
    margin-bottom: 40px;
    color: #1f2937;
}

.category-item {
    background: white;
    border-radius: 12px;
    padding: 20px;
    text-align: center;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    transition: transform 0.3s ease;
    cursor: pointer;
}

.category-item:hover {
    transform: translateY(-5px);
}

.category-item i {
    font-size: 2.5rem;
    color: #4f46e5;
    margin-bottom: 15px;
}

.category-item h6 {
    margin-bottom: 5px;
    color: #1f2937;
}

.category-item small {
    color: #6b7280;
}

/* Flash Sale */
.flash-sale {
    background: #fef2f2;
}

.flash-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 40px;
    background: white;
    padding: 20px;
    border-radius: 12px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

.flash-header h3 {
    margin: 0;
    color: #dc2626;
}

.countdown .time-box {
    background: #dc2626;
    color: white;
    padding: 10px 15px;
    border-radius: 8px;
    font-weight: bold;
    font-size: 1.2rem;
}

/* Product Cards */
.product-card {
    background: white;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    transition: transform 0.3s ease;
}

.product-card:hover {
    transform: translateY(-5px);
}

.product-image {
    position: relative;
    overflow: hidden;
}

.product-image img {
    width: 100%;
    height: 250px;
    object-fit: cover;
}

.discount-badge {
    position: absolute;
    top: 10px;
    left: 10px;
    background: #dc2626;
    color: white;
    padding: 5px 10px;
    border-radius: 5px;
    font-size: 0.8rem;
    font-weight: bold;
}

.product-info {
    padding: 20px;
}

.product-info h6 {
    margin-bottom: 10px;
    color: #1f2937;
    font-weight: 600;
}

.rating {
    margin-bottom: 15px;
}

.rating i {
    color: #fbbf24;
    font-size: 0.9rem;
}

.rating span {
    color: #6b7280;
    font-size: 0.9rem;
    margin-left: 5px;
}

.price {
    margin-bottom: 15px;
}

.price .current {
    color: #dc2626;
    font-weight: bold;
    font-size: 1.1rem;
}

.price .original {
    color: #9ca3af;
    text-decoration: line-through;
    margin-left: 10px;
}

/* Product Tabs */
.product-tabs .nav-pills {
    margin-bottom: 40px;
}

.nav-pills .nav-link {
    border-radius: 25px;
    padding: 12px 25px;
    margin: 0 5px;
    border: 2px solid transparent;
    font-weight: 500;
}

.nav-pills .nav-link:not(.active) {
    background: #f3f4f6;
    color: #6b7280;
}

.nav-pills .nav-link.active {
    background: #4f46e5;
    color: white;
}

/* Recently Viewed */
.recently-viewed {
    background: #f8f9fa;
}

.viewed-item {
    background: white;
    border-radius: 10px;
    padding: 15px;
    text-align: center;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    transition: transform 0.3s ease;
    cursor: pointer;
}

.viewed-item:hover {
    transform: translateY(-3px);
}

.viewed-item img {
    width: 100%;
    height: 120px;
    object-fit: cover;
    border-radius: 8px;
    margin-bottom: 10px;
}

.viewed-item h6 {
    font-size: 0.9rem;
    margin-bottom: 5px;
    color: #1f2937;
}

.viewed-item span {
    color: #dc2626;
    font-weight: bold;
    font-size: 0.9rem;
}

.viewed-item small {
    color: #9ca3af;
    font-size: 0.8rem;
    display: block;
    margin-top: 5px;
}

/* Newsletter */
.newsletter {
    background: #1f2937;
    padding: 50px 0;
}

.newsletter-card {
    background: linear-gradient(135deg, #4f46e5, #7c3aed);
    border-radius: 15px;
    padding: 40px;
    color: white;
}

.newsletter-card h3 {
    margin-bottom: 10px;
}

.newsletter-card p {
    opacity: 0.9;
    margin-bottom: 0;
}

.newsletter .input-group {
    max-width: 400px;
    margin-left: auto;
}

.newsletter .form-control {
    border: none;
    padding: 12px 15px;
}

.newsletter .btn {
    border: none;
    padding: 12px 20px;
}

/* Footer Info */
.footer-info {
    background: white;
    padding: 50px 0;
}

.footer-info h5 {
    margin-bottom: 15px;
    color: #1f2937;
}

.footer-info p {
    color: #6b7280;
    margin-bottom: 0;
}

/* Responsive */
@media (max-width: 768px) {
    .welcome-card h1 {
        font-size: 2rem;
    }
    
    .user-quick-stats {
        flex-direction: column;
        gap: 15px;
    }
    
    .guest-actions {
        flex-direction: column;
        align-items: center;
    }
    
    .flash-header {
        flex-direction: column;
        gap: 20px;
        text-align: center;
    }
    
    .newsletter .input-group {
        margin-left: 0;
    }
}

@media (max-width: 576px) {
    section {
        padding: 30px 0;
    }
    
    .welcome-banner {
        padding: 40px 0;
    }
    
    .welcome-card {
        padding: 25px;
    }
    
    .product-info {
        padding: 15px;
    }
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    console.log('✅ UTESHOP-CPL Simple UI Home Page loaded');
    console.log('🕐 Load time: 2025-10-21 03:00:15 UTC');
    console.log('👨‍💻 Created by: tuaanshuuysv');
    console.log('🎨 UI Only - No complex logic');
    
    <c:if test="${isLoggedIn}">
        console.log('👤 Welcome: ${authUser.username}');
    </c:if>
    
    // Simple countdown timer (UI only)
    const countdownEl = document.querySelector('.countdown .time-box');
    if (countdownEl) {
        let timeLeft = 12 * 3600 + 34 * 60 + 56; // 12:34:56
        
        setInterval(() => {
            const hours = Math.floor(timeLeft / 3600);
            const minutes = Math.floor((timeLeft % 3600) / 60);
            const seconds = timeLeft % 60;
            
            countdownEl.textContent = 
                hours.toString().padStart(2, '0') + ':' +
                minutes.toString().padStart(2, '0') + ':' +
                seconds.toString().padStart(2, '0');
            
            timeLeft--;
            if (timeLeft < 0) timeLeft = 12 * 3600 + 34 * 60 + 56;
        }, 1000);
    }
    
    // Simple click handlers (UI feedback only)
    document.querySelectorAll('.btn').forEach(btn => {
        btn.addEventListener('click', function(e) {
            if (this.textContent.includes('Thêm vào giỏ')) {
                e.preventDefault();
                this.innerHTML = '<i class="fas fa-check"></i> Đã thêm';
                this.classList.add('btn-success');
                
                setTimeout(() => {
                    this.innerHTML = '<i class="fas fa-cart-plus"></i> Thêm vào giỏ';
                    this.classList.remove('btn-success');
                    this.classList.add('btn-primary');
                }, 2000);
            }
        });
    });
    
    // Tab switching (UI only)
    document.querySelectorAll('.nav-link').forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            document.querySelectorAll('.nav-link').forEach(l => l.classList.remove('active'));
            this.classList.add('active');
        });
    });
});
</script>
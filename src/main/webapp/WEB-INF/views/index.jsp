<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UTESHOP - Trang chủ mua sắm trực tuyến</title>
    <meta name="description" content="UTESHOP - Nơi mua sắm trực tuyến tốt nhất với hàng nghìn sản phẩm chất lượng cao">
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        /* BEAUTIFUL RESTORED STYLES */
        * {
            font-family: 'Poppins', sans-serif;
        }
        
        /* GORGEOUS NAVBAR */
        .navbar-brand {
            font-size: 1.8rem;
            font-weight: 800;
            background: linear-gradient(45deg, #fff, #f8f9fa);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
        }

        .navbar-nav .nav-link {
            font-weight: 500;
            color: rgba(255,255,255,0.9) !important;
            transition: all 0.3s ease;
            position: relative;
        }
        
        .navbar-nav .nav-link:hover {
            color: #ffc107 !important;
            transform: translateY(-2px);
        }
        
        .navbar-nav .nav-link::after {
            content: '';
            position: absolute;
            width: 0;
            height: 2px;
            bottom: 0;
            left: 50%;
            background: #ffc107;
            transition: all 0.3s ease;
        }
        
        .navbar-nav .nav-link:hover::after {
            width: 80%;
            left: 10%;
        }

        .badge {
            font-size: 0.65rem;
            min-width: 20px;
            height: 20px;
            line-height: 20px;
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); }
        }

        .dropdown-menu {
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            border: none;
            backdrop-filter: blur(10px);
        }

        .search-form .form-control {
            border-radius: 25px 0 0 25px;
            border: 2px solid rgba(255,255,255,0.2);
            background: rgba(255,255,255,0.1);
            color: white;
            backdrop-filter: blur(10px);
        }
        
        .search-form .form-control::placeholder {
            color: rgba(255,255,255,0.7);
        }
        
        .search-form .form-control:focus {
            border-color: #ffc107;
            box-shadow: 0 0 20px rgba(255,193,7,0.3);
            background: rgba(255,255,255,0.2);
        }

        .search-form .btn {
            border-radius: 0 25px 25px 0;
            border: 2px solid #ffc107;
            background: linear-gradient(45deg, #ffc107, #ffeb3b);
            color: #333;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .search-form .btn:hover {
            transform: scale(1.05);
            box-shadow: 0 5px 15px rgba(255,193,7,0.4);
        }
        
        /* GORGEOUS HERO SECTION */
        .hero-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #ff6b6b 100%);
            color: white;
            padding: 5rem 0;
            position: relative;
            overflow: hidden;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 100" fill="white" fill-opacity="0.1"><polygon points="0,100 0,0 1000,100"/></svg>');
            background-size: 100% 100%;
        }
        
        .hero-content {
            position: relative;
            z-index: 2;
        }
        
        .hero-section h1 {
            font-weight: 800;
            text-shadow: 0 4px 8px rgba(0,0,0,0.3);
            animation: fadeInUp 1s ease-out;
        }
        
        .hero-section .lead {
            font-weight: 400;
            text-shadow: 0 2px 4px rgba(0,0,0,0.3);
            animation: fadeInUp 1s ease-out 0.3s both;
        }
        
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        /* GORGEOUS BUTTONS */
        .btn-explore {
            background: linear-gradient(45deg, #ffa502, #ff6348, #ff4757);
            border: none;
            color: white;
            padding: 15px 35px;
            border-radius: 50px;
            font-weight: 700;
            font-size: 1.1rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.4s ease;
            box-shadow: 0 8px 25px rgba(255,165,2,0.3);
            position: relative;
            overflow: hidden;
        }
        
        .btn-explore::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s;
        }
        
        .btn-explore:hover::before {
            left: 100%;
        }
        
        .btn-explore:hover {
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 15px 40px rgba(255,165,2,0.4);
            color: white;
        }
        
        .btn-outline-light {
            border: 2px solid rgba(255,255,255,0.8);
            color: white;
            padding: 15px 35px;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1.1rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            transition: all 0.4s ease;
            backdrop-filter: blur(10px);
        }
        
        .btn-outline-light:hover {
            background: rgba(255,255,255,0.2);
            border-color: white;
            color: white;
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 15px 40px rgba(255,255,255,0.2);
        }
        
        /* GORGEOUS STATS SECTION */
        .stats-section {
            background: linear-gradient(135deg, #f8f9fa 0%, #e3f2fd 50%, #f3e5f5 100%);
            padding: 4rem 0;
            margin-top: -60px;
            position: relative;
            z-index: 3;
        }
        
        .stats-card {
            background: white;
            border-radius: 20px;
            padding: 2.5rem 1.5rem;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.08);
            transition: all 0.4s ease;
            border: 1px solid rgba(255,255,255,0.8);
            backdrop-filter: blur(10px);
        }
        
        .stats-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 20px 50px rgba(0,0,0,0.15);
        }
        
        .stats-card i {
            background: linear-gradient(45deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 1rem;
            animation: bounce 2s infinite;
        }
        
        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
            40% { transform: translateY(-10px); }
            60% { transform: translateY(-5px); }
        }
        
        .stats-card h4 {
            font-weight: 800;
            font-size: 2.5rem;
            margin-bottom: 0.5rem;
        }
        
        /* GORGEOUS CARDS */
        .category-card, .product-card, .shop-card {
            border: none;
            border-radius: 20px;
            transition: all 0.4s ease;
            background: white;
            box-shadow: 0 5px 20px rgba(0,0,0,0.08);
            overflow: hidden;
            position: relative;
        }
        
        .category-card::before, .product-card::before, .shop-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(45deg, #667eea, #764ba2, #ff6b6b);
            transform: scaleX(0);
            transition: transform 0.4s ease;
        }
        
        .category-card:hover::before, .product-card:hover::before, .shop-card:hover::before {
            transform: scaleX(1);
        }
        
        .category-card:hover, .product-card:hover, .shop-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 20px 50px rgba(0,0,0,0.15);
        }
        
        .product-image {
            width: 100%;
            height: 250px;
            object-fit: cover;
            transition: all 0.4s ease;
        }
        
        .product-card:hover .product-image {
            transform: scale(1.1);
        }
        
        /* GORGEOUS WISHLIST BUTTON */
        .wishlist-btn {
            position: absolute;
            top: 20px;
            right: 20px;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            border: none;
            background: rgba(255, 255, 255, 0.95);
            color: #ff6b6b;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            z-index: 10;
            cursor: pointer;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            backdrop-filter: blur(10px);
        }
        
        .wishlist-btn:hover {
            background: #ff6b6b;
            color: white;
            transform: scale(1.2) rotate(10deg);
            box-shadow: 0 8px 25px rgba(255, 107, 107, 0.4);
        }
        
        .wishlist-btn.active {
            background: #ff6b6b;
            color: white;
            animation: heartbeat 1.5s ease-in-out infinite;
        }
        
        @keyframes heartbeat {
            0% { transform: scale(1); }
            50% { transform: scale(1.2) rotate(5deg); }
            100% { transform: scale(1); }
        }
        
        /* GORGEOUS ADD TO CART BUTTON */
        .add-to-cart-btn {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            color: white;
            border-radius: 15px;
            padding: 12px 25px;
            font-weight: 600;
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .add-to-cart-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.3), transparent);
            transition: left 0.5s;
        }
        
        .add-to-cart-btn:hover::before {
            left: 100%;
        }
        
        .add-to-cart-btn:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        /* GORGEOUS BADGES */
        .badge-discount, .badge-new {
            position: absolute;
            top: 20px;
            left: 20px;
            padding: 10px 15px;
            border-radius: 25px;
            font-size: 0.85rem;
            font-weight: 700;
            z-index: 5;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            animation: glow 2s ease-in-out infinite alternate;
        }
        
        .badge-discount {
            background: linear-gradient(45deg, #ff6b6b, #ee5a52);
            box-shadow: 0 5px 15px rgba(255, 107, 107, 0.4);
        }
        
        .badge-new {
            background: linear-gradient(45deg, #28a745, #20c997);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
        }
        
        @keyframes glow {
            from { box-shadow: 0 5px 15px rgba(255, 107, 107, 0.4); }
            to { box-shadow: 0 8px 25px rgba(255, 107, 107, 0.6); }
        }
        
        /* GORGEOUS RATING STARS */
        .rating-stars {
            color: #ffc107;
        }
        
        .rating-stars i {
            transition: all 0.2s ease;
            cursor: pointer;
        }
        
        .rating-stars i:hover {
            transform: scale(1.2);
        }
        
        /* GORGEOUS SECTION TITLES */
        .section-title {
            position: relative;
            text-align: center;
            margin-bottom: 3rem;
        }
        
        .section-title h2 {
            font-weight: 800;
            font-size: 2.5rem;
            background: linear-gradient(45deg, #667eea, #764ba2, #ff6b6b);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            margin-bottom: 1rem;
        }
        
        .section-title::after {
            content: '';
            position: absolute;
            bottom: -10px;
            left: 50%;
            transform: translateX(-50%);
            width: 100px;
            height: 4px;
            background: linear-gradient(45deg, #667eea, #764ba2, #ff6b6b);
            border-radius: 2px;
        }
        
        /* GORGEOUS WELCOME MESSAGE */
        .welcome-message {
            background: linear-gradient(135deg, #e3f2fd 0%, #f3e5f5 50%, #fff3e0 100%);
            border-radius: 25px;
            padding: 3rem 2rem;
            margin-bottom: 4rem;
            text-align: center;
            border: 1px solid rgba(102, 126, 234, 0.1);
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            position: relative;
            overflow: hidden;
        }
        
        .welcome-message::before {
            content: '✨';
            position: absolute;
            top: 20px;
            right: 30px;
            font-size: 2rem;
            animation: sparkle 2s ease-in-out infinite;
        }
        
        @keyframes sparkle {
            0%, 100% { transform: scale(1) rotate(0deg); opacity: 0.7; }
            50% { transform: scale(1.2) rotate(180deg); opacity: 1; }
        }
        
        /* GORGEOUS FOOTER */
        footer {
            background: linear-gradient(135deg, #2c3e50 0%, #3498db 50%, #9b59b6 100%);
            color: white;
            padding: 3rem 0;
            margin-top: 4rem;
            position: relative;
            overflow: hidden;
        }
        
        footer::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 100" fill="white" fill-opacity="0.05"><polygon points="0,0 1000,0 0,100"/></svg>');
            background-size: 100% 100%;
        }
        
        footer .container {
            position: relative;
            z-index: 2;
        }
        
        footer h5 {
            font-weight: 800;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }
        
        /* RESPONSIVE ENHANCEMENTS */
        @media (max-width: 768px) {
            .hero-section {
                padding: 3rem 0;
            }
            
            .hero-section h1 {
                font-size: 2rem;
            }
            
            .btn-explore, .btn-outline-light {
                padding: 12px 25px;
                font-size: 1rem;
            }
            
            .section-title h2 {
                font-size: 2rem;
            }
            
            .stats-card {
                padding: 2rem 1rem;
                margin-bottom: 1rem;
            }
        }
        
        /* ANIMATION DELAYS */
        .category-card:nth-child(1) { animation-delay: 0.1s; }
        .category-card:nth-child(2) { animation-delay: 0.2s; }
        .category-card:nth-child(3) { animation-delay: 0.3s; }
        .category-card:nth-child(4) { animation-delay: 0.4s; }
        .category-card:nth-child(5) { animation-delay: 0.5s; }
        
        .product-card:nth-child(1) { animation-delay: 0.1s; }
        .product-card:nth-child(2) { animation-delay: 0.2s; }
        .product-card:nth-child(3) { animation-delay: 0.3s; }
        .product-card:nth-child(4) { animation-delay: 0.4s; }
        .product-card:nth-child(5) { animation-delay: 0.5s; }
        .product-card:nth-child(6) { animation-delay: 0.6s; }
        
        /* HOVER EFFECTS */
        .btn-outline-primary:hover {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border-color: #667eea;
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.3);
        }
        
        /* LOADING ANIMATION */
        .loading {
            opacity: 0;
            animation: fadeIn 0.8s ease-out forwards;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<!-- GORGEOUS NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark sticky-top" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 50%, #ff6b6b 100%); backdrop-filter: blur(10px);">
    <div class="container">
        <!-- Brand Logo -->
        <a class="navbar-brand" href="${pageContext.request.contextPath}/home">
            <i class="fas fa-store me-2"></i>UTESHOP
        </a>
        
        <!-- Mobile Toggle -->
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarContent">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <!-- Navigation Content -->
        <div class="collapse navbar-collapse" id="navbarContent">
            <!-- Search Bar -->
            <div class="mx-auto search-form" style="max-width: 450px;">
                <form class="d-flex" action="${pageContext.request.contextPath}/search" method="get">
                    <div class="input-group">
                        <input type="text" name="query" class="form-control" 
                               placeholder="Tìm kiếm sản phẩm yêu thích..." 
                               value="${param.query}">
                        <button class="btn" type="submit">
                            <i class="fas fa-search"></i>
                        </button>
                    </div>
                </form>
            </div>
            
            <!-- Right Navigation -->
            <ul class="navbar-nav ms-auto align-items-center">
                <!-- Cart -->
                <li class="nav-item me-3">
                    <a class="nav-link position-relative" href="${pageContext.request.contextPath}/cart" title="Giỏ hàng">
                        <i class="fas fa-shopping-cart fa-lg"></i>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-warning text-dark cart-count">
                            0
                        </span>
                    </a>
                </li>
                
                <!-- Wishlist -->
                <li class="nav-item me-3">
                    <a class="nav-link position-relative" href="${pageContext.request.contextPath}/user/wishlist" title="Yêu thích">
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
                                        <i class="fas fa-user me-2 text-primary"></i>Hồ sơ cá nhân
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/user/orders">
                                        <i class="fas fa-receipt me-2 text-success"></i>Đơn hàng của tôi
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item" href="${pageContext.request.contextPath}/user/wishlist">
                                        <i class="fas fa-heart me-2 text-danger"></i>Sản phẩm yêu thích
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
                            <a class="btn" href="${pageContext.request.contextPath}/auth/register" 
                               style="background: linear-gradient(45deg, #ffc107, #ffeb3b); color: #333; font-weight: 600; border: none; border-radius: 25px;">
                                <i class="fas fa-user-plus me-1"></i>Đăng ký
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<!-- GORGEOUS HERO SECTION -->
<div class="hero-section">
    <div class="container hero-content">
        <div class="row align-items-center">
            <div class="col-lg-8">
                <h1 class="display-3 fw-bold mb-4">
                    Chào mừng đến với 
                    <span class="d-block" style="background: linear-gradient(45deg, #ffc107, #ffeb3b); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                        UTESHOP ✨
                    </span>
                </h1>
                <p class="lead mb-4 fs-4">
                    🎯 Khám phá hàng nghìn sản phẩm chất lượng cao với giá cả hợp lý<br>
                    🚚 Mua sắm an toàn • Giao hàng nhanh chóng • Dịch vụ tận tâm
                </p>
                <div class="d-flex gap-3 flex-wrap">
                    <a href="${pageContext.request.contextPath}/search" class="btn btn-explore btn-lg">
                        <i class="fas fa-shopping-bag me-2"></i>Khám phá ngay
                    </a>
                    <a href="${pageContext.request.contextPath}/shops" class="btn btn-outline-light btn-lg">
                        <i class="fas fa-store me-2"></i>Cửa hàng
                    </a>
                </div>
            </div>
            <div class="col-lg-4 text-center">
                <div class="position-relative">
                    <i class="fas fa-store display-1" style="opacity: 0.3; color: white;"></i>
                    <div class="position-absolute top-50 start-50 translate-middle">
                        <i class="fas fa-heart fa-3x text-warning" style="animation: heartbeat 2s ease-in-out infinite;"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- GORGEOUS STATS SECTION -->
<div class="stats-section">
    <div class="container">
        <div class="row">
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="stats-card loading">
                    <i class="fas fa-box fa-4x"></i>
                    <h4 class="text-primary">
                        <c:choose>
                            <c:when test="${not empty products}">${fn:length(products)}+</c:when>
                            <c:otherwise>6+</c:otherwise>
                        </c:choose>
                    </h4>
                    <p class="text-muted fw-bold">Sản phẩm chất lượng</p>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="stats-card loading">
                    <i class="fas fa-store fa-4x"></i>
                    <h4 class="text-success">
                        <c:choose>
                            <c:when test="${not empty shops}">${fn:length(shops)}+</c:when>
                            <c:otherwise>5+</c:otherwise>
                        </c:choose>
                    </h4>
                    <p class="text-muted fw-bold">Cửa hàng uy tín</p>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="stats-card loading">
                    <i class="fas fa-users fa-4x"></i>
                    <h4 class="text-warning">1000+</h4>
                    <p class="text-muted fw-bold">Khách hàng tin tưởng</p>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="stats-card loading">
                    <i class="fas fa-heart fa-4x"></i>
                    <h4 class="text-danger">99%</h4>
                    <p class="text-muted fw-bold">Hài lòng</p>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- GORGEOUS WELCOME MESSAGE -->
<div class="container">
    <c:if test="${isLoggedIn}">
        <div class="welcome-message loading">
            <h3 class="text-primary mb-3 fw-bold">
                <i class="fas fa-user-circle me-2"></i>
                Xin chào, <c:choose>
                    <c:when test="${not empty authUser.fullName}">${authUser.fullName}</c:when>
                    <c:when test="${not empty authUser.username}">${authUser.username}</c:when>
                    <c:otherwise>Khách hàng thân thiết</c:otherwise>
                </c:choose>! 🎉
            </h3>
            <p class="text-muted mb-0 lead">
                Chúc bạn có những trải nghiệm mua sắm tuyệt vời tại UTESHOP
            </p>
        </div>
    </c:if>
</div>

<!-- GORGEOUS CATEGORIES -->
<div class="container my-5">
    <div class="section-title">
        <h2>
            <i class="fas fa-th-large me-3"></i>Danh mục nổi bật
        </h2>
        <p class="lead text-muted">Khám phá các danh mục sản phẩm phong phú và đa dạng</p>
    </div>
    
    <div class="row g-4">
        <c:choose>
            <c:when test="${not empty categories}">
                <c:forEach items="${categories}" var="category" varStatus="status">
                    <div class="col-lg-2 col-md-3 col-sm-4 col-6">
                        <div class="card category-card text-center h-100 loading">
                            <div class="card-body p-4">
                                <i class="fas fa-tag fa-4x text-primary mb-3"></i>
                                <h6 class="card-title fw-bold">${category.categoryName}</h6>
                                <p class="card-text text-muted small">Khám phá ngay</p>
                                <a href="${pageContext.request.contextPath}/search?category=${category.categoryId}" 
                                   class="btn btn-outline-primary btn-sm">
                                    <i class="fas fa-arrow-right me-1"></i>Xem thêm
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <c:forEach begin="1" end="5" var="i">
                    <div class="col-lg-2 col-md-3 col-sm-4 col-6">
                        <div class="card category-card text-center h-100 loading">
                            <div class="card-body p-4">
                                <i class="fas fa-tag fa-4x text-primary mb-3"></i>
                                <h6 class="card-title fw-bold">Danh mục ${i}</h6>
                                <p class="card-text text-muted small">Khám phá ngay</p>
                                <a href="${pageContext.request.contextPath}/search" 
                                   class="btn btn-outline-primary btn-sm">
                                    <i class="fas fa-arrow-right me-1"></i>Xem thêm
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- GORGEOUS PRODUCTS -->
<div class="container my-5">
    <div class="section-title">
        <h2>
            <i class="fas fa-fire me-3"></i>Sản phẩm nổi bật
        </h2>
        <p class="lead text-muted">Những sản phẩm được yêu thích nhất và bán chạy nhất</p>
    </div>
    
    <div class="row g-4">
        <c:choose>
            <c:when test="${not empty products}">
                <c:forEach items="${products}" var="product" varStatus="status">
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="card product-card h-100 loading">
                            <!-- Product badges -->
                            <c:choose>
                                <c:when test="${not empty product.hasDiscount and product.hasDiscount}">
                                    <span class="badge-discount">-${product.discountPercent}%</span>
                                </c:when>
                                <c:when test="${not empty product.isNew and product.isNew}">
                                    <span class="badge-new">Mới</span>
                                </c:when>
                            </c:choose>
                            
                            <!-- GORGEOUS Wishlist Button -->
                            <button type="button" 
                                    class="wishlist-btn" 
                                    data-product-id="${product.productId}"
                                    onclick="handleWishlistClick(this, ${product.productId})"
                                    title="Thêm vào danh sách yêu thích">
                                <i class="far fa-heart"></i>
                            </button>
                            
                            <!-- Product Image -->
                            <img src="${not empty product.imageUrl ? product.imageUrl : '/uteshop-cpl/assets/images/default-product.png'}" 
                                 class="product-image" 
                                 alt="${product.productName}"
                                 loading="lazy">
                            
                            <!-- Product Info -->
                            <div class="card-body p-4">
                                <h6 class="card-title text-truncate fw-bold mb-3" title="${product.productName}">
                                    ${product.productName}
                                </h6>
                                
                                <div class="mb-2">
                                    <small class="text-muted">
                                        <i class="fas fa-tag me-1"></i>${not empty product.brand ? product.brand : 'UTESHOP'}
                                    </small>
                                </div>
                                
                                <div class="mb-3">
                                    <small class="text-muted">
                                        <i class="fas fa-store me-1"></i>${not empty product.shopName ? product.shopName : 'UTESHOP Store'}
                                    </small>
                                </div>
                                
                                <!-- Price -->
                                <div class="mb-3">
                                    <span class="h5 text-danger fw-bold">
                                        <c:choose>
                                            <c:when test="${not empty product.formattedPrice}">${product.formattedPrice}</c:when>
                                            <c:otherwise>100,000₫</c:otherwise>
                                        </c:choose>
                                    </span>
                                    <c:if test="${not empty product.hasDiscount and product.hasDiscount and not empty product.originalPrice}">
                                        <div class="mt-1">
                                            <small class="text-muted text-decoration-line-through">
                                                ${product.originalPrice}
                                            </small>
                                            <small class="text-success ms-2 fw-bold">
                                                <i class="fas fa-arrow-down"></i>Tiết kiệm ${product.discountPercent}%
                                            </small>
                                        </div>
                                    </c:if>
                                </div>
                                
                                <!-- Rating & Stock -->
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <div class="rating-stars">
                                        <c:forEach begin="1" end="5" var="i">
                                            <i class="fas fa-star ${i <= (not empty product.ratingStars ? product.ratingStars : 5) ? '' : 'text-muted'}" 
                                               style="font-size: 0.9rem;"></i>
                                        </c:forEach>
                                        <small class="text-muted ms-1">(${not empty product.reviewCount ? product.reviewCount : 0})</small>
                                    </div>
                                    <small class="fw-bold">
                                        <c:choose>
                                            <c:when test="${empty product.inStock or product.inStock}">
                                                <i class="fas fa-check-circle text-success"></i>
                                                <span class="text-success">Còn hàng</span>
                                            </c:when>
                                            <c:otherwise>
                                                <i class="fas fa-times-circle text-danger"></i>
                                                <span class="text-danger">Hết hàng</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </small>
                                </div>
                                
                                <!-- Actions -->
                                <div class="d-grid gap-2">
                                    <c:choose>
                                        <c:when test="${empty product.inStock or product.inStock}">
                                            <button type="button" 
                                                    class="add-to-cart-btn"
                                                    onclick="handleAddToCart(${product.productId})">
                                                <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <button type="button" class="btn btn-outline-secondary" disabled>
                                                <i class="fas fa-times me-2"></i>Hết hàng
                                            </button>
                                        </c:otherwise>
                                    </c:choose>
                                    <a href="${pageContext.request.contextPath}/products/${product.productId}" 
                                       class="btn btn-outline-primary">
                                        <i class="fas fa-eye me-2"></i>Xem chi tiết
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <c:forEach begin="1" end="6" var="i">
                    <div class="col-lg-3 col-md-4 col-sm-6">
                        <div class="card product-card h-100 loading">
                            <button type="button" 
                                    class="wishlist-btn" 
                                    data-product-id="${i}"
                                    onclick="handleWishlistClick(this, ${i})"
                                    title="Thêm vào danh sách yêu thích">
                                <i class="far fa-heart"></i>
                            </button>
                            <img src="/uteshop-cpl/assets/images/default-product.png" 
                                 class="product-image" 
                                 alt="Sản phẩm ${i}">
                            <div class="card-body p-4">
                                <h6 class="card-title fw-bold mb-3">Sản phẩm ${i}</h6>
                                <div class="mb-2">
                                    <small class="text-muted">
                                        <i class="fas fa-tag me-1"></i>UTESHOP
                                    </small>
                                </div>
                                <div class="mb-3">
                                    <small class="text-muted">
                                        <i class="fas fa-store me-1"></i>UTESHOP Store
                                    </small>
                                </div>
                                <div class="mb-3">
                                    <span class="h5 text-danger fw-bold">${i}00,000₫</span>
                                </div>
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <div class="rating-stars">
                                        <c:forEach begin="1" end="5" var="j">
                                            <i class="fas fa-star" style="font-size: 0.9rem;"></i>
                                        </c:forEach>
                                        <small class="text-muted ms-1">(0)</small>
                                    </div>
                                    <small class="text-success fw-bold">
                                        <i class="fas fa-check-circle"></i>
                                        Còn hàng
                                    </small>
                                </div>
                                <div class="d-grid gap-2">
                                    <button type="button" 
                                            class="add-to-cart-btn"
                                            onclick="handleAddToCart(${i})">
                                        <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ
                                    </button>
                                    <a href="${pageContext.request.contextPath}/products/${i}" 
                                       class="btn btn-outline-primary">
                                        <i class="fas fa-eye me-2"></i>Xem chi tiết
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
    
    <!-- View More Products -->
    <div class="text-center mt-5">
        <a href="${pageContext.request.contextPath}/search" class="btn btn-explore btn-lg">
            <i class="fas fa-arrow-right me-2"></i>Xem tất cả sản phẩm
        </a>
    </div>
</div>

<!-- GORGEOUS FOOTER -->
<footer>
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-6">
                <h5>
                    <i class="fas fa-store me-2"></i>UTESHOP ✨
                </h5>
                <p class="text-light mb-0 opacity-75">
                    Nền tảng mua sắm trực tuyến hàng đầu Việt Nam<br>
                    🎯 Chất lượng • 🚚 Nhanh chóng • 💝 Uy tín
                </p>
            </div>
            <div class="col-md-6 text-md-end mt-3 mt-md-0">
                <p class="text-light mb-1 opacity-75">
                    &copy; 2025 UTESHOP. All rights reserved.
                </p>
                <p class="text-warning mb-0 fw-bold">
                    <i class="fas fa-code me-1"></i>Phát triển bởi tuaanshuuysv
                </p>
            </div>
        </div>
    </div>
</footer>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<!-- GORGEOUS JavaScript -->
<script>
// Global variables
const contextPath = '${pageContext.request.contextPath}';
const isLoggedIn = ${isLoggedIn != null ? isLoggedIn : false};

console.log('🎨 GORGEOUS Home page initialized at 2025-10-27 02:24:45 UTC');
console.log('🔐 User logged in:', isLoggedIn);
console.log('🌐 Context path:', contextPath);
console.log('👤 Current user: tuaanshuuysv');

// Load counts on page load
document.addEventListener('DOMContentLoaded', function() {
    console.log('✨ GORGEOUS Home page loaded for tuaanshuuysv');
    
    // Add loading animations
    setTimeout(() => {
        document.querySelectorAll('.loading').forEach((el, index) => {
            setTimeout(() => {
                el.style.opacity = '1';
                el.style.transform = 'translateY(0)';
            }, index * 100);
        });
    }, 100);
    
    if (isLoggedIn) {
        // Load cart count
        fetch(contextPath + '/api/cart/count')
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    updateCartCount(data.count);
                }
            })
            .catch(error => console.log('Cart count load failed:', error));
        
        // Load wishlist count  
        fetch(contextPath + '/api/wishlist/count')
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
    elements.forEach(el => {
        el.textContent = count || 0;
        if (count > 0) {
            el.style.animation = 'pulse 1s ease-in-out';
        }
    });
    console.log('🛒 Updated cart count to:', count);
}

function updateWishlistCount(count) {
    const elements = document.querySelectorAll('.wishlist-count');
    elements.forEach(el => {
        el.textContent = count || 0;
        if (count > 0) {
            el.style.animation = 'heartbeat 1s ease-in-out';
        }
    });
    console.log('❤️ Updated wishlist count to:', count);
}

// GORGEOUS wishlist handling
function handleWishlistClick(buttonElement, productId) {
    console.log('💖 GORGEOUS wishlist click for product:', productId);
    
    if (event) {
        event.preventDefault();
        event.stopPropagation();
    }
    
    if (!productId || productId <= 0 || isNaN(productId)) {
        console.error('❌ Invalid productId:', productId);
        showGorgeousNotification('ID sản phẩm không hợp lệ: ' + productId, 'error');
        return;
    }
    
    if (!isLoggedIn) {
        showGorgeousNotification('Vui lòng đăng nhập để sử dụng tính năng yêu thích', 'warning');
        setTimeout(() => {
            window.location.href = contextPath + '/auth/login';
        }, 2000);
        return;
    }
    
    // Add loading state
    buttonElement.disabled = true;
    buttonElement.style.opacity = '0.7';
    buttonElement.style.animation = 'spin 1s linear infinite';
    
    console.log('🔄 Sending GORGEOUS wishlist toggle request');
    
    const params = new URLSearchParams();
    params.append('productId', productId.toString());
    
    fetch(contextPath + '/api/wishlist/toggle', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params.toString()
    })
    .then(response => {
        console.log('📡 Response status:', response.status);
        return response.json();
    })
    .then(data => {
        console.log('📡 GORGEOUS API response:', data);
        
        if (data.success) {
            showGorgeousNotification(data.message, 'success');
            
            const icon = buttonElement.querySelector('i');
            if (data.isInWishlist) {
                icon.classList.remove('far');
                icon.classList.add('fas');
                buttonElement.classList.add('active');
                buttonElement.title = 'Xóa khỏi danh sách yêu thích';
                
                // Add sparkle effect
                createSparkleEffect(buttonElement);
            } else {
                icon.classList.remove('fas');
                icon.classList.add('far');
                buttonElement.classList.remove('active');
                buttonElement.title = 'Thêm vào danh sách yêu thích';
            }
            
            updateWishlistCount(data.wishlistCount);
            
        } else {
            console.error('❌ API Error:', data.message);
            showGorgeousNotification(data.message, 'error');
        }
    })
    .catch(error => {
        console.error('❌ Network error:', error);
        showGorgeousNotification('Có lỗi xảy ra khi cập nhật danh sách yêu thích', 'error');
    })
    .finally(() => {
        buttonElement.disabled = false;
        buttonElement.style.opacity = '1';
        buttonElement.style.animation = '';
    });
}

// GORGEOUS add to cart function
function handleAddToCart(productId) {
    console.log('🛒 GORGEOUS add to cart for product:', productId);
    
    if (!productId || productId <= 0 || isNaN(productId)) {
        console.error('❌ Invalid productId for cart:', productId);
        showGorgeousNotification('ID sản phẩm không hợp lệ', 'error');
        return;
    }
    
    if (!isLoggedIn) {
        showGorgeousNotification('Vui lòng đăng nhập để thêm vào giỏ hàng', 'warning');
        setTimeout(() => {
            window.location.href = contextPath + '/auth/login';
        }, 2000);
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
        console.log('🛒 GORGEOUS Cart API response:', data);
        
        if (data.success) {
            showGorgeousNotification('Đã thêm vào giỏ hàng thành công! 🎉', 'success');
            updateCartCount(data.cartCount);
            
            // Add cart animation
            createCartAnimation();
        } else {
            showGorgeousNotification(data.message, 'error');
        }
    })
    .catch(error => {
        console.error('❌ Cart error:', error);
        showGorgeousNotification('Có lỗi xảy ra khi thêm vào giỏ hàng', 'error');
    });
}

// GORGEOUS notification system
function showGorgeousNotification(message, type) {
    type = type || 'info';
    
    const alertConfig = {
        'error': { 
            className: 'alert-danger', 
            icon: 'fa-exclamation-triangle',
            gradient: 'linear-gradient(45deg, #ff6b6b, #ee5a52)',
            emoji: '❌'
        },
        'warning': { 
            className: 'alert-warning', 
            icon: 'fa-exclamation-circle',
            gradient: 'linear-gradient(45deg, #ffc107, #ffeb3b)',
            emoji: '⚠️'
        },
        'success': { 
            className: 'alert-success', 
            icon: 'fa-check-circle',
            gradient: 'linear-gradient(45deg, #28a745, #20c997)',
            emoji: '✅'
        },
        'info': { 
            className: 'alert-info', 
            icon: 'fa-info-circle',
            gradient: 'linear-gradient(45deg, #667eea, #764ba2)',
            emoji: 'ℹ️'
        }
    };
    
    const config = alertConfig[type] || alertConfig.info;
    
    // Remove existing notifications
    document.querySelectorAll('.gorgeous-notification').forEach(el => el.remove());
    
    // Create gorgeous notification
    const notification = document.createElement('div');
    notification.className = 'gorgeous-notification position-fixed';
    notification.style.cssText = `
        top: 20px; 
        right: 20px; 
        z-index: 9999; 
        min-width: 400px; 
        max-width: 500px;
        animation: slideInRight 0.5s ease-out;
    `;
    
    notification.innerHTML = `
        <div class="alert ${config.className} alert-dismissible fade show shadow-lg border-0" 
             style="
                background: ${config.gradient}; 
                color: white; 
                border-radius: 20px;
                backdrop-filter: blur(10px);
                box-shadow: 0 15px 35px rgba(0,0,0,0.2);
             ">
            <div class="d-flex align-items-center">
                <div class="me-3" style="font-size: 1.5rem;">
                    ${config.emoji}
                </div>
                <div class="flex-grow-1">
                    <div class="fw-bold mb-1">${type.charAt(0).toUpperCase() + type.slice(1)}!</div>
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
            notification.style.animation = 'slideOutRight 0.5s ease-in';
            setTimeout(() => notification.remove(), 500);
        }
    }, 4000);
    
    console.log('✨ GORGEOUS notification shown:', type, '-', message);
}

// Create sparkle effect for wishlist
function createSparkleEffect(element) {
    for (let i = 0; i < 6; i++) {
        const sparkle = document.createElement('div');
        sparkle.innerHTML = '✨';
        sparkle.style.cssText = `
            position: absolute;
            pointer-events: none;
            font-size: 1rem;
            z-index: 1000;
            animation: sparkleFloat 1s ease-out forwards;
        `;
        
        const rect = element.getBoundingClientRect();
        sparkle.style.left = (rect.left + Math.random() * rect.width) + 'px';
        sparkle.style.top = (rect.top + Math.random() * rect.height) + 'px';
        
        document.body.appendChild(sparkle);
        
        setTimeout(() => sparkle.remove(), 1000);
    }
}

// Create cart animation
function createCartAnimation() {
    const cartIcon = document.querySelector('.fa-shopping-cart');
    if (cartIcon) {
        cartIcon.style.animation = 'bounce 0.6s ease-in-out';
        setTimeout(() => {
            cartIcon.style.animation = '';
        }, 600);
    }
}

// Add gorgeous CSS animations
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
    
    @keyframes sparkleFloat {
        from { 
            transform: translateY(0) scale(1); 
            opacity: 1; 
        }
        to { 
            transform: translateY(-50px) scale(0.5); 
            opacity: 0; 
        }
    }
    
    @keyframes spin {
        from { transform: rotate(0deg); }
        to { transform: rotate(360deg); }
    }
    
    @keyframes bounce {
        0%, 20%, 50%, 80%, 100% { transform: translateY(0); }
        40% { transform: translateY(-10px); }
        60% { transform: translateY(-5px); }
    }
`;
document.head.appendChild(style);
</script>

</body>
</html>
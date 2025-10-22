<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<header class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container">
        <!-- Brand/logo -->
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/home">
            <i class="fas fa-shopping-cart"></i> UTESHOP-CPL
        </a>
        
        <!-- Mobile menu button -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <!-- Navigation menu -->
        <div class="collapse navbar-collapse" id="navbarNav">
            <!-- Main navigation -->
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">
                        <i class="fas fa-home"></i> Trang chủ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/products">
                        <i class="fas fa-box"></i> Sản phẩm
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/categories">
                        <i class="fas fa-tags"></i> Danh mục
                    </a>
                </li>
            </ul>
            
            <!-- User menu -->
            <ul class="navbar-nav">
                <c:choose>
                    <c:when test="${not empty authUser}">
                        <!-- Authenticated user menu -->
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown">
                                <i class="fas fa-user-circle"></i> ${authUser.fullName}
                            </a>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile">
                                    <i class="fas fa-user"></i> Hồ sơ cá nhân
                                </a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/orders">
                                    <i class="fas fa-shopping-cart"></i> Đơn hàng
                                </a></li>
                                <c:if test="${authUser.roleId == 3}">
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/vendor/dashboard">
                                        <i class="fas fa-store"></i> Quản lý shop
                                    </a></li>
                                </c:if>
                                <c:if test="${authUser.roleId == 4}">
                                    <li><hr class="dropdown-divider"></li>
                                    <!-- 🚨 FIXED: Sử dụng direct admin controller -->
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin-direct">
                                        <i class="fas fa-cogs"></i> Quản trị hệ thống
                                    </a></li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/auth/logout">
                                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                                </a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <!-- Guest user menu -->
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/auth/login">
                                <i class="fas fa-sign-in-alt"></i> Đăng nhập
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-primary ms-2" href="${pageContext.request.contextPath}/auth/register">
                                <i class="fas fa-user-plus"></i> Đăng ký
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</header>
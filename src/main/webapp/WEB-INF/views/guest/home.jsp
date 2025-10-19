<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<div class="container py-4">
    <!-- Welcome Hero Section -->
    <div class="row mb-5">
        <div class="col-12">
            <div class="bg-primary text-white p-5 rounded-3 text-center">
                <div class="row align-items-center">
                    <div class="col-md-8 mx-auto">
                        <h1 class="display-4 fw-bold mb-3">
                            <i class="fas fa-store"></i> Chào mừng đến với UTESHOP-CPL!
                        </h1>
                        <p class="lead mb-4">
                            Nền tảng thương mại điện tử hiện đại được phát triển bởi <strong>tuaanshuuysv</strong>
                        </p>
                        
                        <c:choose>
                            <c:when test="${not empty authUser}">
                                <div class="alert alert-success d-inline-block">
                                    <i class="fas fa-user-check"></i> 
                                    Xin chào <strong>${authUser.fullName}</strong>! 
                                    <c:choose>
                                        <c:when test="${authUser.roleId == 2}">
                                            <span class="badge bg-primary">Khách hàng</span>
                                        </c:when>
                                        <c:when test="${authUser.roleId == 3}">
                                            <span class="badge bg-success">Người bán</span>
                                        </c:when>
                                        <c:when test="${authUser.roleId == 4}">
                                            <span class="badge bg-danger">Quản trị viên</span>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="d-grid gap-2 d-md-flex justify-content-md-center">
                                    <a class="btn btn-light btn-lg me-md-2" href="${pageContext.request.contextPath}/auth/register" role="button">
                                        <i class="fas fa-user-plus"></i> Đăng ký ngay
                                    </a>
                                    <a class="btn btn-outline-light btn-lg" href="${pageContext.request.contextPath}/auth/login" role="button">
                                        <i class="fas fa-sign-in-alt"></i> Đăng nhập
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Features Section -->
    <div class="row mb-5">
        <div class="col-12 text-center mb-4">
            <h2 class="fw-bold">🌟 Tính năng nổi bật</h2>
            <p class="text-muted">Những tính năng mạnh mẽ được tích hợp trong UTESHOP-CPL</p>
        </div>
        
        <div class="col-md-4 mb-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body text-center">
                    <div class="mb-3">
                        <i class="fas fa-shopping-cart fa-3x text-primary"></i>
                    </div>
                    <h5 class="card-title">🛍️ Mua sắm dễ dàng</h5>
                    <p class="card-text">
                        Hàng ngàn sản phẩm chất lượng cao với giá cả hợp lý. 
                        Giao diện thân thiện, dễ sử dụng.
                    </p>
                </div>
            </div>
        </div>
        
        <div class="col-md-4 mb-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body text-center">
                    <div class="mb-3">
                        <i class="fas fa-truck fa-3x text-success"></i>
                    </div>
                    <h5 class="card-title">🚚 Giao hàng nhanh</h5>
                    <p class="card-text">
                        Giao hàng toàn quốc, thanh toán đa dạng, an toàn. 
                        Hỗ trợ COD, VNPAY, MoMo.
                    </p>
                </div>
            </div>
        </div>
        
        <div class="col-md-4 mb-4">
            <div class="card h-100 shadow-sm">
                <div class="card-body text-center">
                    <div class="mb-3">
                        <i class="fas fa-store fa-3x text-warning"></i>
                    </div>
                    <h5 class="card-title">🏪 Bán hàng online</h5>
                    <p class="card-text">
                        Mở shop trực tuyến, quản lý bán hàng hiệu quả. 
                        Dashboard thông minh cho người bán.
                    </p>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Technology Stack -->
    <div class="row mb-5">
        <div class="col-12">
            <div class="card border-info">
                <div class="card-header bg-info text-white">
                    <h5 class="mb-0"><i class="fas fa-code"></i> Technology Stack</h5>
                </div>
                <div class="card-body">
                    <div class="row text-center">
                        <div class="col-md-3 mb-3">
                            <i class="fab fa-java fa-2x text-primary"></i>
                            <h6 class="mt-2">Java 17+</h6>
                            <small class="text-muted">Backend Language</small>
                        </div>
                        <div class="col-md-3 mb-3">
                            <i class="fas fa-server fa-2x text-success"></i>
                            <h6 class="mt-2">Jakarta EE</h6>
                            <small class="text-muted">Servlet, JSP, JSTL</small>
                        </div>
                        <div class="col-md-3 mb-3">
                            <i class="fas fa-database fa-2x text-warning"></i>
                            <h6 class="mt-2">MySQL</h6>
                            <small class="text-muted">Database + HikariCP</small>
                        </div>
                        <div class="col-md-3 mb-3">
                            <i class="fab fa-bootstrap fa-2x text-primary"></i>
                            <h6 class="mt-2">Bootstrap 5</h6>
                            <small class="text-muted">Frontend Framework</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Call to Action -->
    <c:if test="${empty authUser}">
        <div class="row">
            <div class="col-12 text-center">
                <div class="bg-light p-5 rounded-3">
                    <h3 class="fw-bold mb-3">🚀 Bắt đầu hành trình của bạn với UTESHOP-CPL</h3>
                    <p class="text-muted mb-4">
                        Tham gia cộng đồng mua sắm và kinh doanh online lớn nhất
                    </p>
                    <div class="d-grid gap-2 d-md-flex justify-content-md-center">
                        <a href="${pageContext.request.contextPath}/auth/register?role=user" class="btn btn-primary btn-lg me-md-2">
                            <i class="fas fa-user"></i> Đăng ký làm khách hàng
                        </a>
                        <a href="${pageContext.request.contextPath}/auth/register?role=vendor" class="btn btn-success btn-lg">
                            <i class="fas fa-store"></i> Đăng ký làm người bán
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
    
    <!-- User Dashboard -->
    <c:if test="${not empty authUser}">
        <div class="row">
            <div class="col-12">
                <div class="card border-success">
                    <div class="card-header bg-success text-white">
                        <h5 class="mb-0"><i class="fas fa-tachometer-alt"></i> Dashboard - Thông tin tài khoản</h5>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <table class="table table-borderless">
                                    <tr>
                                        <td><strong>Họ tên:</strong></td>
                                        <td>${authUser.fullName}</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Email:</strong></td>
                                        <td>${authUser.email}</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Tên đăng nhập:</strong></td>
                                        <td>${authUser.username}</td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-md-6">
                                <table class="table table-borderless">
                                    <tr>
                                        <td><strong>Vai trò:</strong></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${authUser.roleId == 2}">
                                                    <span class="badge bg-primary fs-6">👤 Khách hàng</span>
                                                </c:when>
                                                <c:when test="${authUser.roleId == 3}">
                                                    <span class="badge bg-success fs-6">🏪 Người bán</span>
                                                </c:when>
                                                <c:when test="${authUser.roleId == 4}">
                                                    <span class="badge bg-danger fs-6">⚙️ Quản trị viên</span>
                                                </c:when>
                                            </c:choose>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td><strong>Trạng thái:</strong></td>
                                        <td>
                                            <c:if test="${authUser.isActive && authUser.isVerified}">
                                                <span class="badge bg-success">✅ Đã kích hoạt</span>
                                            </c:if>
                                            <c:if test="${!authUser.isActive || !authUser.isVerified}">
                                                <span class="badge bg-warning">⚠️ Chưa kích hoạt</span>
                                            </c:if>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                        
                        <hr>
                        
                        <div class="text-center">
                            <div class="btn-group" role="group">
                                <c:if test="${authUser.roleId == 3}">
                                    <a href="${pageContext.request.contextPath}/vendor/dashboard" class="btn btn-success">
                                        <i class="fas fa-store"></i> Quản lý shop
                                    </a>
                                </c:if>
                                <c:if test="${authUser.roleId == 4}">
                                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-danger">
                                        <i class="fas fa-cogs"></i> Quản trị hệ thống
                                    </a>
                                </c:if>
                                <a href="${pageContext.request.contextPath}/user/profile" class="btn btn-primary">
                                    <i class="fas fa-user-edit"></i> Cập nhật thông tin
                                </a>
                                <a href="${pageContext.request.contextPath}/user/orders" class="btn btn-info">
                                    <i class="fas fa-shopping-cart"></i> Đơn hàng của tôi
                                </a>
                                <a href="${pageContext.request.contextPath}/auth/logout" class="btn btn-outline-secondary">
                                    <i class="fas fa-sign-out-alt"></i> Đăng xuất
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </c:if>
</div>

<script>
console.log('✅ UTESHOP-CPL Home page loaded successfully');
console.log('📊 User authenticated: ${not empty authUser}');
<c:if test="${not empty authUser}">
console.log('👤 Current user: ${authUser.fullName}');
console.log('🎭 User role: ${authUser.roleId}');
</c:if>
</script>
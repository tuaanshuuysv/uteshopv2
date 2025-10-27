<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : 'Tìm kiếm sản phẩm - UTESHOP'}</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        .product-card { 
            transition: transform 0.3s; 
            border: none;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
        }
        .product-card:hover { 
            transform: translateY(-5px); 
        }
        .product-image { 
            height: 200px; 
            overflow: hidden;
            position: relative;
            background: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .product-image img { 
            width: 100%; 
            height: 100%; 
            object-fit: cover; 
        }
        /* FIXED: Prevent image loading errors */
        .product-image .placeholder {
            color: #6c757d;
            font-size: 2rem;
        }
    </style>
</head>
<body>

<!-- SEARCH RESULTS - FIXED VERSION -->
<!-- Updated: 2025-10-26 17:56:30 UTC by tuaanshuuysv -->

<div class="container-fluid">
    
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary sticky-top">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <i class="fas fa-shopping-cart me-2"></i>UTESHOP
            </a>
            
            <!-- Search Form -->
            <form action="${pageContext.request.contextPath}/search" method="GET" class="d-flex mx-auto" style="width: 50%;">
                <div class="input-group">
                    <select name="category" class="form-select" style="max-width: 150px;">
                        <option value="">Tất cả danh mục</option>
                        <c:forEach var="category" items="${categories}">
                            <option value="${category.category_id}" ${categoryId == category.category_id ? 'selected' : ''}>
                                ${category.category_name}
                            </option>
                        </c:forEach>
                    </select>
                    <input type="text" name="q" class="form-control" 
                           placeholder="Tìm kiếm sản phẩm..." 
                           value="${searchQuery}">
                    <button type="submit" class="btn btn-light">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </form>
            
            <!-- User Menu -->
            <ul class="navbar-nav ms-auto">
                <c:choose>
                    <c:when test="${isLoggedIn}">
                        <li class="nav-item">
                            <span class="nav-link">
                                <i class="fas fa-user me-1"></i>
                                ${authUser != null ? authUser.fullName : 'User'}
                                <span class="badge bg-light text-dark ms-1">${userRoleDisplay}</span>
                            </span>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/auth/logout">
                                <i class="fas fa-sign-out-alt me-1"></i>Đăng xuất
                            </a>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/auth/login">
                                <i class="fas fa-sign-in-alt me-1"></i>Đăng nhập
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </nav>

    <!-- Search Header -->
    <section class="bg-primary text-white py-4">
        <div class="container">
            <h1 class="mb-2">
                <i class="fas fa-search me-3"></i>
                <c:choose>
                    <c:when test="${not empty searchQuery}">
                        Kết quả tìm kiếm: "${searchQuery}"
                    </c:when>
                    <c:when test="${categoryId > 0}">
                        Sản phẩm theo danh mục
                    </c:when>
                    <c:otherwise>
                        Tất cả sản phẩm
                    </c:otherwise>
                </c:choose>
            </h1>
            <p class="mb-0">Tìm thấy <strong>${totalProducts}</strong> sản phẩm</p>
        </div>
    </section>

    <div class="container mt-4">
        <div class="row">
            
            <!-- Categories Filter -->
            <div class="col-lg-3">
                <div class="card">
                    <div class="card-header">
                        <h5><i class="fas fa-filter me-2"></i>Danh mục</h5>
                    </div>
                    <div class="card-body">
                        <div class="list-group">
                            <a href="${pageContext.request.contextPath}/search" 
                               class="list-group-item ${categoryId == 0 ? 'active' : ''}">
                                Tất cả sản phẩm
                            </a>
                            <c:forEach var="category" items="${categories}">
                                <a href="${pageContext.request.contextPath}/search?category=${category.category_id}" 
                                   class="list-group-item ${categoryId == category.category_id ? 'active' : ''}">
                                    ${category.category_name}
                                </a>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Products Grid -->
            <div class="col-lg-9">
                
                <!-- Sort Options -->
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <span class="text-muted">
                            Hiển thị ${(currentPage - 1) * 12 + 1} - 
                            ${currentPage * 12 > totalProducts ? totalProducts : currentPage * 12} 
                            trong ${totalProducts} sản phẩm
                        </span>
                    </div>
                    <div>
                        <form action="${pageContext.request.contextPath}/search" method="GET" class="d-inline">
                            <c:if test="${not empty searchQuery}">
                                <input type="hidden" name="q" value="${searchQuery}">
                            </c:if>
                            <c:if test="${categoryId > 0}">
                                <input type="hidden" name="category" value="${categoryId}">
                            </c:if>
                            
                            <select name="sort" class="form-select d-inline-block" style="width: auto;" onchange="this.form.submit()">
                                <option value="">Sắp xếp theo</option>
                                <option value="price_asc" ${sortBy == 'price_asc' ? 'selected' : ''}>Giá thấp đến cao</option>
                                <option value="price_desc" ${sortBy == 'price_desc' ? 'selected' : ''}>Giá cao đến thấp</option>
                                <option value="name" ${sortBy == 'name' ? 'selected' : ''}>Tên A-Z</option>
                            </select>
                        </form>
                    </div>
                </div>
                
                <!-- Products Grid -->
                <c:choose>
                    <c:when test="${not empty products}">
                        <div class="row g-3">
                            <c:forEach var="product" items="${products}">
                                <div class="col-lg-4 col-md-6">
                                    <div class="card product-card h-100">
                                        
                                        <!-- FIXED: Safe image loading -->
                                        <div class="product-image">
                                            <c:choose>
                                                <c:when test="${not empty product.image_url && product.image_url != '/assets/images/products/default.jpg'}">
                                                    <img src="${pageContext.request.contextPath}${product.image_url}" 
                                                         alt="${product.product_name}"
                                                         onerror="this.style.display='none'; this.parentNode.innerHTML='<i class=\"fas fa-image placeholder\"></i>';">
                                                </c:when>
                                                <c:otherwise>
                                                    <i class="fas fa-image placeholder"></i>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        
                                        <div class="card-body d-flex flex-column">
                                            <div class="mb-2">
                                                <small class="text-primary">
                                                    <i class="fas fa-store me-1"></i>${product.shop_name}
                                                    <c:if test="${product.shop_verified}">
                                                        <i class="fas fa-check-circle text-success ms-1"></i>
                                                    </c:if>
                                                </small>
                                            </div>
                                            
                                            <h6 class="card-title">${product.product_name}</h6>
                                            
                                            <div class="mb-2">
                                                <small class="text-muted">
                                                    <span class="text-warning">
                                                        ⭐ ${product.total_rating} (${product.total_reviews})
                                                    </span>
                                                    • ${product.category_name}
                                                </small>
                                            </div>
                                            
                                            <div class="mb-3 mt-auto">
                                                <span class="h5 text-danger fw-bold">${product.formatted_price}</span>
                                                <c:if test="${product.original_price != null}">
                                                    <small class="text-decoration-line-through text-muted ms-2">
                                                        ${product.original_price}
                                                    </small>
                                                </c:if>
                                            </div>
                                            
                                            <div class="d-grid gap-2">
                                                <button class="btn btn-primary btn-sm" onclick="addToCart('${product.product_id}')">
                                                    <i class="fas fa-shopping-cart me-1"></i>Thêm vào giỏ
                                                </button>
                                                <button class="btn btn-outline-primary btn-sm" onclick="viewProduct('${product.product_id}')">
                                                    <i class="fas fa-info-circle me-1"></i>Chi tiết
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <div class="d-flex justify-content-center mt-4">
                                <nav>
                                    <ul class="pagination">
                                        <c:if test="${currentPage > 1}">
                                            <li class="page-item">
                                                <a class="page-link" href="?category=${categoryId}&page=${currentPage - 1}">
                                                    <i class="fas fa-chevron-left"></i>
                                                </a>
                                            </li>
                                        </c:if>
                                        
                                        <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                            <c:if test="${pageNum <= 5}">
                                                <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                                    <a class="page-link" href="?category=${categoryId}&page=${pageNum}">
                                                        ${pageNum}
                                                    </a>
                                                </li>
                                            </c:if>
                                        </c:forEach>
                                        
                                        <c:if test="${currentPage < totalPages}">
                                            <li class="page-item">
                                                <a class="page-link" href="?category=${categoryId}&page=${currentPage + 1}">
                                                    <i class="fas fa-chevron-right"></i>
                                                </a>
                                            </li>
                                        </c:if>
                                    </ul>
                                </nav>
                            </div>
                        </c:if>
                        
                    </c:when>
                    <c:otherwise>
                        <!-- No Results -->
                        <div class="text-center py-5">
                            <i class="fas fa-search fa-4x text-muted mb-3"></i>
                            <h4>Không tìm thấy sản phẩm nào</h4>
                            <p class="text-muted mb-4">Thử thay đổi từ khóa tìm kiếm hoặc bộ lọc</p>
                            <a href="${pageContext.request.contextPath}/search" class="btn btn-primary">
                                <i class="fas fa-refresh me-2"></i>Xem tất cả sản phẩm
                            </a>
                        </div>
                    </c:otherwise>
                </c:choose>
                
                <div class="text-center mt-4">
                    <a href="${pageContext.request.contextPath}/" class="btn btn-outline-primary">
                        <i class="fas fa-home me-2"></i>Về trang chủ
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
console.log('✅ Search Results FIXED page loaded');
console.log('🔍 Category: ${categoryId}, Products: ${totalProducts}');

function addToCart(productId) {
    <c:choose>
        <c:when test="${isLoggedIn}">
            alert('Đã thêm sản phẩm vào giỏ hàng! (Demo)');
        </c:when>
        <c:otherwise>
            alert('Vui lòng đăng nhập để thêm sản phẩm vào giỏ hàng!');
            window.location.href = '${pageContext.request.contextPath}/auth/login';
        </c:otherwise>
    </c:choose>
}

function viewProduct(productId) {
    window.location.href = '${pageContext.request.contextPath}/products/' + productId;
}
</script>

</body>
</html>
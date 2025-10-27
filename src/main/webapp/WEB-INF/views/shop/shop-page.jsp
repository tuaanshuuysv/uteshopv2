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
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        .shop-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
        }
        
        .shop-logo {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid white;
            object-fit: cover;
        }
        
        .shop-stats {
            background: white;
            border-radius: 10px;
            padding: 1.5rem;
            margin-top: -50px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        
        .product-card {
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            transition: all 0.3s ease;
            height: 100%;
        }
        
        .product-card:hover {
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            transform: translateY(-5px);
        }
        
        .product-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 10px 10px 0 0;
        }
        
        .badge-new {
            position: absolute;
            top: 10px;
            left: 10px;
            background: #ff6b6b;
            color: white;
            padding: 5px 10px;
            border-radius: 15px;
            font-size: 0.8rem;
        }
        
        .badge-discount {
            position: absolute;
            top: 10px;
            right: 10px;
            background: #ffa502;
            color: white;
            padding: 5px 8px;
            border-radius: 50%;
            font-size: 0.8rem;
        }
        
        .rating-stars {
            color: #ffc107;
        }
        
        .filter-sidebar {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
        }
        
        .price-range {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .pagination .page-link {
            color: #667eea;
            border-color: #667eea;
        }
        
        .pagination .page-item.active .page-link {
            background-color: #667eea;
            border-color: #667eea;
        }
    </style>
</head>
<body>

<!-- Shop Header -->
<div class="shop-header">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-2 text-center">
                <img src="${shop.shop_logo}" alt="${shop.shop_name}" class="shop-logo">
            </div>
            <div class="col-md-7">
                <h1 class="mb-2">${shop.shop_name}</h1>
                <p class="mb-2">${shop.shop_description}</p>
                <div class="d-flex gap-3">
                    <span><i class="fas fa-map-marker-alt"></i> ${shop.shop_address}</span>
                    <c:if test="${not empty shop.shop_phone}">
                        <span><i class="fas fa-phone"></i> ${shop.shop_phone}</span>
                    </c:if>
                    <c:if test="${shop.is_verified}">
                        <span class="badge bg-success"><i class="fas fa-check-circle"></i> Đã xác thực</span>
                    </c:if>
                </div>
            </div>
            <div class="col-md-3 text-center">
                <div class="rating-stars mb-2">
                    <c:forEach begin="1" end="5" var="i">
                        <i class="fas fa-star ${i <= shopStats.rating_stars ? '' : 'text-muted'}"></i>
                    </c:forEach>
                    <span class="ms-2">${shopStats.avg_rating}</span>
                </div>
                <small>Thành viên từ <fmt:formatDate value="${shopStats.member_since}" pattern="MM/yyyy"/></small>
            </div>
        </div>
    </div>
</div>

<!-- Shop Stats -->
<div class="container">
    <div class="shop-stats">
        <div class="row text-center">
            <div class="col-md-3">
                <h4 class="text-primary mb-1">${shopStats.active_products}</h4>
                <small class="text-muted">Sản phẩm</small>
            </div>
            <div class="col-md-3">
                <h4 class="text-success mb-1">${shopStats.avg_rating}</h4>
                <small class="text-muted">Đánh giá trung bình</small>
            </div>
            <div class="col-md-3">
                <h4 class="text-warning mb-1">${shopStats.total_reviews}</h4>
                <small class="text-muted">Lượt đánh giá</small>
            </div>
            <div class="col-md-3">
                <h4 class="text-info mb-1">${totalProducts}</h4>
                <small class="text-muted">Sản phẩm hiển thị</small>
            </div>
        </div>
    </div>
</div>

<!-- Products Section -->
<div class="container mt-4">
    <div class="row">
        <!-- Filter Sidebar -->
        <div class="col-md-3">
            <div class="filter-sidebar">
                <h5 class="mb-3">Bộ lọc</h5>
                
                <form id="filterForm" method="get">
                    <!-- Search -->
                    <div class="mb-3">
                        <label class="form-label">Tìm kiếm</label>
                        <input type="text" class="form-control" name="q" value="${searchQuery}" 
                               placeholder="Tên sản phẩm, thương hiệu...">
                    </div>
                    
                    <!-- Categories -->
                    <div class="mb-3">
                        <label class="form-label">Danh mục</label>
                        <select class="form-select" name="category">
                            <option value="">Tất cả danh mục</option>
                            <c:forEach items="${categories}" var="cat">
                                <option value="${cat.category_id}" ${cat.category_id == selectedCategory ? 'selected' : ''}>
                                    ${cat.category_name} (${cat.product_count})
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <!-- Price Range -->
                    <div class="mb-3">
                        <label class="form-label">Khoảng giá</label>
                        <div class="price-range">
                            <input type="number" class="form-control" name="minPrice" value="${minPrice > 0 ? minPrice : ''}" 
                                   placeholder="Từ" min="0">
                            <span>-</span>
                            <input type="number" class="form-control" name="maxPrice" value="${maxPrice > 0 ? maxPrice : ''}" 
                                   placeholder="Đến" min="0">
                        </div>
                    </div>
                    
                    <!-- Sort -->
                    <div class="mb-3">
                        <label class="form-label">Sắp xếp</label>
                        <select class="form-select" name="sort">
                            <option value="newest" ${sortBy == 'newest' ? 'selected' : ''}>Mới nhất</option>
                            <option value="price_asc" ${sortBy == 'price_asc' ? 'selected' : ''}>Giá tăng dần</option>
                            <option value="price_desc" ${sortBy == 'price_desc' ? 'selected' : ''}>Giá giảm dần</option>
                            <option value="name_asc" ${sortBy == 'name_asc' ? 'selected' : ''}>Tên A-Z</option>
                            <option value="rating" ${sortBy == 'rating' ? 'selected' : ''}>Đánh giá cao</option>
                        </select>
                    </div>
                    
                    <button type="submit" class="btn btn-primary w-100 mb-2">
                        <i class="fas fa-filter"></i> Áp dụng bộ lọc
                    </button>
                    
                    <a href="${pageContext.request.contextPath}/shops/${currentShopId}" class="btn btn-outline-secondary w-100">
                        <i class="fas fa-redo"></i> Xóa bộ lọc
                    </a>
                </form>
            </div>
        </div>
        
        <!-- Products Grid -->
        <div class="col-md-9">
            <!-- Results Info -->
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5>Sản phẩm của ${shop.shop_name}</h5>
                <div class="d-flex align-items-center gap-2">
                    <span class="text-muted">Hiển thị ${products.size()} / ${totalProducts} sản phẩm</span>
                    <select class="form-select form-select-sm" style="width: 80px;" onchange="changePageSize(this.value)">
                        <c:forEach items="${pageSizeOptions}" var="size">
                            <option value="${size}" ${size == pageSize ? 'selected' : ''}>${size}</option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            
            <!-- Products Grid -->
            <div class="row">
                <c:choose>
                    <c:when test="${empty products}">
                        <div class="col-12 text-center py-5">
                            <i class="fas fa-search fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">Không tìm thấy sản phẩm</h5>
                            <p class="text-muted">Hãy thử thay đổi bộ lọc hoặc từ khóa tìm kiếm</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach items="${products}" var="product">
                            <div class="col-lg-4 col-md-6 mb-4">
                                <div class="card product-card position-relative">
                                    <!-- Product Badges -->
                                    <c:if test="${product.is_new}">
                                        <span class="badge-new">Mới</span>
                                    </c:if>
                                    <c:if test="${product.has_discount}">
                                        <span class="badge-discount">-${product.discount_percent}%</span>
                                    </c:if>
                                    
                                    <!-- Product Image -->
                                    <img src="${product.image_url}" class="product-image" alt="${product.product_name}">
                                    
                                    <!-- Product Info -->
                                    <div class="card-body">
                                        <h6 class="card-title text-truncate" title="${product.product_name}">
                                            ${product.product_name}
                                        </h6>
                                        
                                        <p class="text-muted small mb-2">${product.category_name}</p>
                                        
                                        <!-- Price -->
                                        <div class="mb-2">
                                            <span class="h6 text-danger">${product.formatted_price}</span>
                                            <c:if test="${not empty product.original_price}">
                                                <small class="text-muted text-decoration-line-through ms-2">
                                                    ${product.original_price}
                                                </small>
                                            </c:if>
                                        </div>
                                        
                                        <!-- Rating & Reviews -->
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <div class="rating-stars">
                                                <c:forEach begin="1" end="5" var="i">
                                                    <i class="fas fa-star ${i <= product.rating_stars ? '' : 'text-muted'}" style="font-size: 0.8rem;"></i>
                                                </c:forEach>
                                                <small class="text-muted ms-1">(${product.review_count})</small>
                                            </div>
                                            <small class="text-muted">
                                                <c:choose>
                                                    <c:when test="${product.in_stock}">
                                                        <i class="fas fa-check-circle text-success"></i> Còn hàng
                                                    </c:when>
                                                    <c:otherwise>
                                                        <i class="fas fa-times-circle text-danger"></i> Hết hàng
                                                    </c:otherwise>
                                                </c:choose>
                                            </small>
                                        </div>
                                        
                                        <!-- Actions -->
                                        <div class="d-grid gap-2">
                                            <a href="${pageContext.request.contextPath}/products/${product.product_id}" 
                                               class="btn btn-outline-primary btn-sm">
                                                <i class="fas fa-eye"></i> Xem chi tiết
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Pagination -->
            <c:if test="${totalPages > 1}">
                <nav aria-label="Shop products pagination">
                    <ul class="pagination justify-content-center">
                        <!-- Previous -->
                        <li class="page-item ${!hasPrevious ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${previousPage}&${pageContext.request.queryString != null ? pageContext.request.queryString.replaceAll('page=\\d+&?', '') : ''}">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                        </li>
                        
                        <!-- Pages -->
                        <c:forEach begin="${startPage}" end="${endPage}" var="i">
                            <li class="page-item ${i == currentPage ? 'active' : ''}">
                                <a class="page-link" href="?page=${i}&${pageContext.request.queryString != null ? pageContext.request.queryString.replaceAll('page=\\d+&?', '') : ''}">${i}</a>
                            </li>
                        </c:forEach>
                        
                        <!-- Next -->
                        <li class="page-item ${!hasNext ? 'disabled' : ''}">
                            <a class="page-link" href="?page=${nextPage}&${pageContext.request.queryString != null ? pageContext.request.queryString.replaceAll('page=\\d+&?', '') : ''}">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
function changePageSize(size) {
    const url = new URL(window.location);
    url.searchParams.set('pageSize', size);
    url.searchParams.set('page', '1'); // Reset to page 1
    window.location.href = url.toString();
}

// Auto-submit form on filter change
document.addEventListener('DOMContentLoaded', function() {
    const selects = document.querySelectorAll('#filterForm select');
    selects.forEach(select => {
        select.addEventListener('change', function() {
            document.getElementById('filterForm').submit();
        });
    });
});
</script>

</body>
</html>
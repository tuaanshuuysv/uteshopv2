<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!-- UTESHOP-CPL Vendor Profile - COMPLETE WITH REAL SHOP UPDATE -->
<!-- Updated: 2025-10-24 18:07:20 UTC by tuaanshuuysv -->
<!-- Features: Real shop CRUD operations with database integration -->

<div class="vendor-profile-page">

	<!-- Vendor Header -->
	<div class="vendor-header">
		<div class="container">
			<div class="row align-items-center">
				<div class="col-md-6">
					<div class="d-flex align-items-center">
						<div class="vendor-avatar">
							<i class="fas fa-store"></i>
						</div>
						<div class="ms-3">
							<h2 class="mb-1">${shopName}</h2>
							<p class="text-muted mb-0">
								<i class="fas fa-user me-1"></i>Chủ shop: ${authUser.fullName} <span
									class="ms-3"> <i class="fas fa-star me-1"></i> Rating:
									${shopRating}/5 (${shopReviews} đánh giá)
								</span>
							</p>
							<div class="shop-badges mt-2">
								<span class="badge bg-success"> <i
									class="fas fa-check-circle me-1"></i>Đang hoạt động
								</span> <span class="badge bg-info"> <i
									class="fas fa-calendar me-1"></i> Tham gia: <fmt:formatDate
										value="${shopSince}" pattern="dd/MM/yyyy" />
								</span>
								<c:if test="${shopPhone != null}">
									<span class="badge bg-secondary"> <i
										class="fas fa-phone me-1"></i>${shopPhone}
									</span>
								</c:if>
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-6 text-end">
					<div class="vendor-stats">
						<div class="stat-item">
							<span class="stat-number">${totalProducts}</span> <span
								class="stat-label">Sản phẩm</span>
						</div>
						<div class="stat-item">
							<span class="stat-number">${totalOrders}</span> <span
								class="stat-label">Đơn hàng</span>
						</div>
						<div class="stat-item">
							<span class="stat-number">${totalSales}</span> <span
								class="stat-label">Doanh thu</span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Success/Error Messages -->
	<div class="container mt-4">
		<c:if test="${param.success != null}">
			<div class="alert alert-success alert-dismissible fade show"
				role="alert">
				<i class="fas fa-check-circle me-2"></i>
				<c:choose>
					<c:when test="${param.success == 'profile_updated'}">✅ Cập nhật hồ sơ và thông tin shop thành công!</c:when>
					<c:when test="${param.success == 'password_changed'}">✅ Đổi mật khẩu thành công!</c:when>
					<c:when test="${param.success == 'settings_updated'}">✅ Cập nhật cài đặt thành công!</c:when>
					<c:otherwise>✅ Thao tác thành công!</c:otherwise>
				</c:choose>
				<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
			</div>
		</c:if>

		<c:if test="${param.error != null}">
			<div class="alert alert-danger alert-dismissible fade show"
				role="alert">
				<i class="fas fa-exclamation-triangle me-2"></i>
				<c:choose>
					<c:when test="${param.error == 'missing_fullname'}">❌ Vui lòng nhập họ tên!</c:when>
					<c:when test="${param.error == 'update_failed'}">❌ Cập nhật thất bại!</c:when>
					<c:when test="${param.error == 'current_password_incorrect'}">❌ Mật khẩu hiện tại không đúng!</c:when>
					<c:when test="${param.error == 'password_mismatch'}">❌ Xác nhận mật khẩu không khớp!</c:when>
					<c:when test="${param.error == 'password_too_short'}">❌ Mật khẩu phải có ít nhất 6 ký tự!</c:when>
					<c:otherwise>❌ Có lỗi xảy ra: ${param.error}</c:otherwise>
				</c:choose>
				<button type="button" class="btn-close" data-bs-dismiss="alert"></button>
			</div>
		</c:if>
	</div>

	<!-- Vendor Content -->
	<div class="container mt-4">
		<div class="row">

			<!-- Left Sidebar -->
			<div class="col-lg-3 mb-4">
				<div class="vendor-sidebar">
					<div class="sidebar-menu">
						<a href="${pageContext.request.contextPath}/vendor/profile"
							class="menu-item ${profileMode == 'view' ? 'active' : ''}"> <i
							class="fas fa-store"></i> <span>Thông tin Shop</span>
						</a> <a href="${pageContext.request.contextPath}/vendor/profile/edit"
							class="menu-item ${profileMode == 'edit' ? 'active' : ''}"> <i
							class="fas fa-edit"></i> <span>Chỉnh sửa hồ sơ</span>
						</a> <a
							href="${pageContext.request.contextPath}/vendor/profile/change-password"
							class="menu-item ${profileMode == 'change-password' ? 'active' : ''}">
							<i class="fas fa-lock"></i> <span>Đổi mật khẩu</span>
						</a>
					</div>

					<!-- Real Statistics from Database -->
					<div class="quick-stats mt-3">
						<h6 class="mb-3">📊 Thống kê từ Database</h6>
						<div class="alert alert-info mb-2">
							<i class="fas fa-cube me-2"></i> <strong>${totalProducts}</strong>
							sản phẩm
						</div>
						<div class="alert alert-success mb-2">
							<i class="fas fa-shopping-cart me-2"></i> <strong>${totalOrders}</strong>
							đơn hàng
						</div>
						<div class="alert alert-warning mb-2">
							<i class="fas fa-money-bill-wave me-2"></i> <strong>${totalSales}</strong>
							doanh thu
						</div>
						<div class="alert alert-secondary mb-0">
							<i class="fas fa-calendar me-2"></i> <strong>${monthlyRevenue}</strong>
							tháng này
						</div>
					</div>
				</div>
			</div>

			<!-- Main Content -->
			<div class="col-lg-9">

				<c:choose>
					<%-- VIEW VENDOR PROFILE --%>
					<c:when test="${profileMode == 'view' || empty profileMode}">
						<div class="row">
							<div class="col-lg-8">
								<div class="vendor-card">
									<div class="card-header">
										<h5 class="mb-0">
											<i class="fas fa-store me-2"></i>Thông tin Shop (Database)
										</h5>
										<a
											href="${pageContext.request.contextPath}/vendor/profile/edit"
											class="btn btn-outline-primary btn-sm"> <i
											class="fas fa-edit me-1"></i>Chỉnh sửa
										</a>
									</div>
									<div class="card-body">
										<div class="alert alert-info mb-3">
											<i class="fas fa-database me-2"></i> <strong>Thông
												tin này được lấy trực tiếp từ database:</strong> bảng shops & users
										</div>

										<div class="row">
											<div class="col-md-6">
												<div class="info-item">
													<label>Tên Shop:</label> <span>${shopName}</span>
												</div>
												<div class="info-item">
													<label>Chủ Shop:</label> <span>${authUser.fullName}</span>
												</div>
												<div class="info-item">
													<label>Email:</label> <span>${authUser.email}</span>
												</div>
												<div class="info-item">
													<label>Số điện thoại cá nhân:</label> <span>${authUser.phone != null ? authUser.phone : 'Chưa cập nhật'}</span>
												</div>
											</div>
											<div class="col-md-6">
												<div class="info-item">
													<label>Mô tả Shop:</label> <span>${shopDescription != null ? shopDescription : 'Chưa có mô tả'}</span>
												</div>
												<div class="info-item">
													<label>Số điện thoại Shop:</label> <span>${shopPhone != null ? shopPhone : 'Chưa cập nhật'}</span>
												</div>
												<div class="info-item">
													<label>Địa chỉ Shop:</label> <span>${shopAddress != null ? shopAddress : 'Chưa cập nhật'}</span>
												</div>
												<div class="info-item">
													<label>Tham gia từ:</label> <span><fmt:formatDate
															value="${shopSince}" pattern="dd/MM/yyyy HH:mm" /></span>
												</div>
											</div>
										</div>
									</div>
								</div>

								<!-- Real Business Overview từ Database -->
								<div class="vendor-card mt-4">
									<div class="card-header">
										<h6 class="mb-0">
											<i class="fas fa-chart-line me-2"></i>📈 Kinh doanh thực tế
											(từ Database)
										</h6>
									</div>
									<div class="card-body">
										<div class="row text-center">
											<div class="col-md-3">
												<div class="metric-card">
													<div class="metric-icon bg-primary">
														<i class="fas fa-cube"></i>
													</div>
													<h4>${totalProducts}</h4>
													<p>Sản phẩm đã đăng</p>
												</div>
											</div>
											<div class="col-md-3">
												<div class="metric-card">
													<div class="metric-icon bg-success">
														<i class="fas fa-shopping-cart"></i>
													</div>
													<h4>${totalOrders}</h4>
													<p>Đơn hàng đã bán</p>
												</div>
											</div>
											<div class="col-md-3">
												<div class="metric-card">
													<div class="metric-icon bg-warning">
														<i class="fas fa-money-bill-wave"></i>
													</div>
													<h4 style="font-size: 1.2rem;">${totalSales}</h4>
													<p>Tổng doanh thu</p>
												</div>
											</div>
											<div class="col-md-3">
												<div class="metric-card">
													<div class="metric-icon bg-info">
														<i class="fas fa-calendar-month"></i>
													</div>
													<h4 style="font-size: 1.2rem;">${monthlyRevenue}</h4>
													<p>Doanh thu tháng</p>
												</div>
											</div>
										</div>

										<hr class="my-4">

										<div class="row">
											<div class="col-md-4">
												<div
													class="d-flex justify-content-between align-items-center">
													<span><i class="fas fa-star text-warning me-1"></i>Đánh
														giá TB:</span> <strong class="text-warning">${shopRating}/5
														⭐</strong>
												</div>
											</div>
											<div class="col-md-4">
												<div
													class="d-flex justify-content-between align-items-center">
													<span><i class="fas fa-comment text-info me-1"></i>Nhận
														xét:</span> <strong class="text-info">${shopReviews}
														reviews</strong>
												</div>
											</div>
											<div class="col-md-4">
												<div
													class="d-flex justify-content-between align-items-center">
													<span><i class="fas fa-database text-secondary me-1"></i>Nguồn:</span>
													<strong class="text-secondary">MySQL DB</strong>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>

							<div class="col-lg-4">
								<!-- Real Shop Statistics từ Database -->
								<div class="vendor-card">
									<div class="card-header">
										<h6 class="mb-0">
											<i class="fas fa-chart-bar me-1"></i>📊 Thống kê thực
										</h6>
									</div>
									<div class="card-body">
										<div class="vendor-stats-list">
											<div class="stat-item">
												<i class="fas fa-cube text-primary"></i> <span
													class="stat-label">Tổng sản phẩm:</span> <span
													class="stat-value">${totalProducts}</span>
											</div>
											<div class="stat-item">
												<i class="fas fa-shopping-cart text-success"></i> <span
													class="stat-label">Tổng đơn hàng:</span> <span
													class="stat-value">${totalOrders}</span>
											</div>
											<div class="stat-item">
												<i class="fas fa-money-bill-wave text-warning"></i> <span
													class="stat-label">Tổng doanh thu:</span> <span
													class="stat-value">${totalSales}</span>
											</div>
											<div class="stat-item">
												<i class="fas fa-calendar text-info"></i> <span
													class="stat-label">Doanh thu tháng:</span> <span
													class="stat-value">${monthlyRevenue}</span>
											</div>
											<div class="stat-item">
												<i class="fas fa-star text-warning"></i> <span
													class="stat-label">Đánh giá TB:</span> <span
													class="stat-value">${shopRating}/5</span>
											</div>
											<div class="stat-item">
												<i class="fas fa-comment text-secondary"></i> <span
													class="stat-label">Số nhận xét:</span> <span
													class="stat-value">${shopReviews}</span>
											</div>
										</div>
									</div>
								</div>

								<!-- Real Activity từ Database -->
								<div class="vendor-card mt-3">
									<div class="card-header">
										<h6 class="mb-0">
											<i class="fas fa-clock me-1"></i>🔄 Tình trạng thực tế
										</h6>
									</div>
									<div class="card-body">
										<div class="activity-list">
											<div class="activity-item">
												<i
													class="fas fa-shopping-cart ${pendingOrders > 0 ? 'text-warning' : 'text-success'}"></i>
												<div class="activity-content">
													<p>${pendingOrders > 0 ? pendingOrders + ' đơn hàng chờ xử lý' : 'Không có đơn hàng chờ'}</p>
													<small class="text-muted">${pendingOrders > 0 ? 'Cần xử lý ngay' : 'Tất cả đã xử lý'}</small>
												</div>
											</div>
											<div class="activity-item">
												<i
													class="fas fa-exclamation-triangle ${lowStockProducts > 0 ? 'text-danger' : 'text-success'}"></i>
												<div class="activity-content">
													<p>${lowStockProducts > 0 ? lowStockProducts + ' sản phẩm sắp hết' : 'Kho hàng ổn định'}</p>
													<small class="text-muted">${lowStockProducts > 0 ? 'Cần nhập thêm hàng' : 'Đủ hàng trong kho'}</small>
												</div>
											</div>
											<div class="activity-item">
												<i class="fas fa-star text-warning"></i>
												<div class="activity-content">
													<p>Shop có ${shopReviews} đánh giá</p>
													<small class="text-muted">Rating: ${shopRating}/5
														sao từ khách hàng</small>
												</div>
											</div>
											<div class="activity-item">
												<i class="fas fa-database text-info"></i>
												<div class="activity-content">
													<p>Dữ liệu cập nhật realtime</p>
													<small class="text-muted">Từ bảng shops, products,
														orders</small>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</c:when>

					<%-- EDIT VENDOR PROFILE - REAL SHOP UPDATE --%>
					<c:when test="${profileMode == 'edit'}">
						<div class="vendor-card">
							<div class="card-header">
								<h5 class="mb-0">
									<i class="fas fa-edit me-2"></i>🔧 Chỉnh sửa hồ sơ & Shop
									(Database)
								</h5>
							</div>
							<div class="card-body">
								<form method="POST"
									action="${pageContext.request.contextPath}/vendor/profile"
									class="needs-validation" novalidate>
									<input type="hidden" name="action" value="update-profile">

									<div class="alert alert-success">
										<i class="fas fa-database me-2"></i> <strong>✅ Lưu ý:</strong>
										Thông tin sẽ được cập nhật trực tiếp vào database MySQL và
										hiển thị ngay lập tức.
									</div>

									<h6 class="mb-3">👤 Thông tin cá nhân</h6>
									<div class="row">
										<div class="col-md-6">
											<div class="mb-3">
												<label for="fullName" class="form-label"> Họ và tên
													<span class="text-danger">*</span>
												</label> <input type="text" class="form-control" id="fullName"
													name="fullName" value="${authUser.fullName}" required>
												<div class="invalid-feedback">Vui lòng nhập họ và tên</div>
												<small class="text-muted">Cập nhật vào bảng
													users.full_name</small>
											</div>
										</div>
										<div class="col-md-6">
											<div class="mb-3">
												<label for="phone" class="form-label">Số điện thoại
													cá nhân</label> <input type="tel" class="form-control" id="phone"
													name="phone" value="${authUser.phone}"
													pattern="[0-9]{10,11}">
												<div class="invalid-feedback">Số điện thoại phải có
													10-11 chữ số</div>
												<small class="text-muted">Cập nhật vào bảng
													users.phone</small>
											</div>
										</div>
									</div>

									<div class="row">
										<div class="col-md-6">
											<div class="mb-3">
												<label for="email" class="form-label">Email</label> <input
													type="email" class="form-control" id="email" name="email"
													value="${authUser.email}" readonly> <small
													class="text-muted">Email không thể thay đổi (unique
													key)</small>
											</div>
										</div>
										<div class="col-md-6">
											<div class="mb-3">
												<label for="username" class="form-label">Tên đăng
													nhập</label> <input type="text" class="form-control" id="username"
													name="username" value="${authUser.username}" readonly>
												<small class="text-muted">Username không thể thay
													đổi</small>
											</div>
										</div>
									</div>

									<hr>

									<h6 class="mb-3">🏪 Thông tin Shop (bảng shops)</h6>
									<div class="alert alert-info">
										<i class="fas fa-info-circle me-2"></i> <strong>Schema:</strong>
										shops table với các cột: shop_name, shop_description,
										shop_phone, shop_address, owner_id
									</div>

									<div class="mb-3">
										<label for="shopName" class="form-label"> 🏪 Tên Shop
											<span class="text-danger">*</span>
										</label> <input type="text" class="form-control" id="shopName"
											name="shopName" value="${shopName}" required> <small
											class="text-muted">➡️ Lưu vào: shops.shop_name</small>
										<div class="invalid-feedback">Vui lòng nhập tên shop</div>
									</div>

									<div class="mb-3">
										<label for="shopDescription" class="form-label">📝 Mô
											tả Shop</label>
										<textarea class="form-control" id="shopDescription"
											name="shopDescription" rows="4"
											placeholder="Mô tả về shop của bạn...">${shopDescription != null ? shopDescription : ''}</textarea>
										<small class="text-muted">➡️ Lưu vào:
											shops.shop_description</small>
									</div>

									<div class="row">
										<div class="col-md-6">
											<div class="mb-3">
												<label for="shopPhone" class="form-label">📞 Số điện
													thoại Shop</label> <input type="tel" class="form-control"
													id="shopPhone" name="shopPhone"
													value="${shopPhone != null ? shopPhone : authUser.phone}"
													pattern="[0-9]{10,11}"> <small class="text-muted">➡️
													Lưu vào: shops.shop_phone</small>
											</div>
										</div>
										<div class="col-md-6">
											<div class="mb-3">
												<label for="shopAddress" class="form-label">📍 Địa
													chỉ Shop</label> <input type="text" class="form-control"
													id="shopAddress" name="shopAddress"
													value="${shopAddress != null ? shopAddress : ''}"
													placeholder="Ví dụ: 123 Đường ABC, Quận 1, TP.HCM">
												<small class="text-muted">➡️ Lưu vào:
													shops.shop_address</small>
											</div>
										</div>
									</div>

									<div class="alert alert-warning">
										<i class="fas fa-database me-2"></i> <strong>Cơ chế
											hoạt động:</strong>
										<ul class="mb-0 mt-2">
											<li>Nếu shop đã tồn tại (owner_id = user_id): <strong>UPDATE</strong></li>
											<li>Nếu chưa có shop: <strong>INSERT</strong> record mới
											</li>
											<li>Tự động cập nhật updated_at = CURRENT_TIMESTAMP</li>
										</ul>
									</div>

									<hr>

									<div class="d-flex gap-2">
										<button type="submit" class="btn btn-primary">
											<i class="fas fa-save me-1"></i>💾 Lưu tất cả thay đổi
										</button>
										<a href="${pageContext.request.contextPath}/vendor/profile"
											class="btn btn-secondary"> <i class="fas fa-times me-1"></i>❌
											Hủy
										</a> <a
											href="${pageContext.request.contextPath}/vendor/profile/change-password"
											class="btn btn-warning ms-auto"> <i
											class="fas fa-key me-1"></i>🔐 Đổi mật khẩu
										</a>
									</div>
								</form>
							</div>
						</div>
					</c:when>

					<%-- CHANGE PASSWORD --%>
					<c:when test="${profileMode == 'change-password'}">
						<div class="vendor-card">
							<div class="card-header">
								<h5 class="mb-0">
									<i class="fas fa-lock me-2"></i>🔐 Đổi mật khẩu
								</h5>
							</div>
							<div class="card-body">
								<form method="POST"
									action="${pageContext.request.contextPath}/vendor/profile"
									class="needs-validation" novalidate>
									<input type="hidden" name="action" value="change-password">

									<div class="alert alert-info">
										<i class="fas fa-info-circle me-2"></i> <strong>Bảo
											mật:</strong> Vì lý do bảo mật, vui lòng nhập mật khẩu hiện tại để xác
										thực. <br> <small>Mật khẩu sẽ được hash bằng
											PasswordHasher với salt.</small>
									</div>

									<div class="mb-3">
										<label for="currentPassword" class="form-label"> 🔒
											Mật khẩu hiện tại <span class="text-danger">*</span>
										</label> <input type="password" class="form-control"
											id="currentPassword" name="currentPassword" required>
										<div class="invalid-feedback">Vui lòng nhập mật khẩu
											hiện tại</div>
										<small class="text-muted">Để xác thực danh tính</small>
									</div>

									<div class="row">
										<div class="col-md-6">
											<div class="mb-3">
												<label for="newPassword" class="form-label"> 🆕 Mật
													khẩu mới <span class="text-danger">*</span>
												</label> <input type="password" class="form-control"
													id="newPassword" name="newPassword" required minlength="6">
												<div class="invalid-feedback">Mật khẩu phải có ít nhất
													6 ký tự</div>
												<small class="text-muted">Tối thiểu 6 ký tự</small>
											</div>
										</div>
										<div class="col-md-6">
											<div class="mb-3">
												<label for="confirmPassword" class="form-label"> ✅
													Xác nhận mật khẩu mới <span class="text-danger">*</span>
												</label> <input type="password" class="form-control"
													id="confirmPassword" name="confirmPassword" required>
												<div class="invalid-feedback">Xác nhận mật khẩu không
													khớp</div>
												<small class="text-muted">Nhập lại mật khẩu mới</small>
											</div>
										</div>
									</div>

									<div class="alert alert-warning">
										<i class="fas fa-exclamation-triangle me-2"></i> <strong>Lưu
											ý quan trọng:</strong>
										<ul class="mb-0 mt-2">
											<li>Mật khẩu sẽ được hash an toàn trước khi lưu database</li>
											<li>Không thể khôi phục mật khẩu cũ sau khi đổi</li>
											<li>Sẽ cần đăng nhập lại với mật khẩu mới</li>
										</ul>
									</div>

									<hr>

									<div class="d-flex gap-2">
										<button type="submit" class="btn btn-warning">
											<i class="fas fa-key me-1"></i>🔐 Đổi mật khẩu
										</button>
										<a href="${pageContext.request.contextPath}/vendor/profile"
											class="btn btn-secondary"> <i class="fas fa-times me-1"></i>❌
											Hủy
										</a>
									</div>
								</form>
							</div>
						</div>
					</c:when>
				</c:choose>
			</div>
		</div>
	</div>
</div>

<style>
/* Vendor Profile Styles - Complete */
.vendor-profile-page {
	background: #f8fafc;
	min-height: calc(100vh - 120px);
}

.vendor-header {
	background: linear-gradient(135deg, #059669 0%, #047857 100%);
	color: white;
	padding: 30px 0;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.vendor-avatar {
	width: 80px;
	height: 80px;
	border-radius: 50%;
	background: rgba(255, 255, 255, 0.2);
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 2rem;
	border: 3px solid rgba(255, 255, 255, 0.3);
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
}

.shop-badges {
	display: flex;
	gap: 8px;
	flex-wrap: wrap;
}

.vendor-stats {
	display: flex;
	gap: 25px;
	justify-content: flex-end;
}

.vendor-stats .stat-item {
	display: flex;
	flex-direction: column;
	align-items: center;
	text-align: center;
	background: rgba(255, 255, 255, 0.1);
	padding: 15px;
	border-radius: 8px;
	min-width: 100px;
}

.vendor-stats .stat-number {
	font-size: 1.8rem;
	font-weight: bold;
	margin-bottom: 5px;
}

.vendor-stats .stat-label {
	font-size: 0.9rem;
	opacity: 0.9;
}

.vendor-sidebar {
	background: white;
	border-radius: 12px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
	overflow: hidden;
	border: 1px solid #e5e7eb;
}

.sidebar-menu {
	display: flex;
	flex-direction: column;
}

.menu-item {
	display: flex;
	align-items: center;
	padding: 16px 20px;
	color: #374151;
	text-decoration: none;
	border-bottom: 1px solid #f3f4f6;
	transition: all 0.3s ease;
	font-weight: 500;
}

.menu-item:hover {
	background: #f0fdf4;
	color: #059669;
	text-decoration: none;
	transform: translateX(2px);
}

.menu-item.active {
	background: #059669;
	color: white;
	box-shadow: inset 4px 0 0 #047857;
}

.menu-item i {
	width: 20px;
	margin-right: 12px;
	text-align: center;
	font-size: 1.1rem;
}

.quick-stats {
	padding: 18px 20px;
	background: #f8fafc;
}

.quick-stats h6 {
	color: #374151;
	font-weight: 600;
	margin-bottom: 15px;
}

.quick-stats .alert {
	padding: 12px 15px;
	margin-bottom: 10px;
	font-size: 0.9rem;
	border: none;
	font-weight: 500;
}

.vendor-card {
	background: white;
	border-radius: 12px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
	margin-bottom: 25px;
	overflow: hidden;
	border: 1px solid #e5e7eb;
}

.vendor-card .card-header {
	background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
	border-bottom: 2px solid #e5e7eb;
	padding: 20px 25px;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.vendor-card .card-header h5, .vendor-card .card-header h6 {
	margin: 0;
	color: #1f2937;
	font-weight: 600;
}

.vendor-card .card-body {
	padding: 25px;
}

.info-item {
	margin-bottom: 18px;
	padding-bottom: 8px;
	border-bottom: 1px solid #f3f4f6;
}

.info-item:last-child {
	border-bottom: none;
}

.info-item label {
	font-weight: 600;
	color: #374151;
	display: block;
	margin-bottom: 6px;
	font-size: 0.9rem;
}

.info-item span {
	color: #6b7280;
	font-weight: 500;
}

.metric-card {
	padding: 20px;
	text-align: center;
	transition: transform 0.2s ease;
}

.metric-card:hover {
	transform: translateY(-2px);
}

.metric-icon {
	width: 65px;
	height: 65px;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	margin: 0 auto 15px;
	color: white;
	font-size: 1.6rem;
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}

.metric-card h4 {
	margin: 12px 0 8px;
	font-size: 1.8rem;
	font-weight: bold;
	color: #1f2937;
}

.metric-card p {
	margin: 0;
	color: #6b7280;
	font-size: 0.9rem;
	font-weight: 500;
}

.vendor-stats-list {
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.vendor-stats-list .stat-item {
	display: flex;
	align-items: center;
	gap: 15px;
	padding: 12px 0;
	border-bottom: 1px solid #f3f4f6;
}

.vendor-stats-list .stat-item:last-child {
	border-bottom: none;
}

.vendor-stats-list .stat-item i {
	width: 24px;
	text-align: center;
	font-size: 1.1rem;
}

.vendor-stats-list .stat-label {
	flex: 1;
	font-size: 0.9rem;
	color: #6b7280;
	font-weight: 500;
}

.vendor-stats-list .stat-value {
	font-weight: 600;
	color: #1f2937;
	font-size: 0.95rem;
}

.activity-list {
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.activity-item {
	display: flex;
	align-items: flex-start;
	gap: 15px;
	padding: 12px 0;
	border-bottom: 1px solid #f3f4f6;
}

.activity-item:last-child {
	border-bottom: none;
}

.activity-item i {
	width: 24px;
	text-align: center;
	font-size: 1.1rem;
	margin-top: 2px;
}

.activity-content {
	flex: 1;
}

.activity-content p {
	margin: 0 0 4px 0;
	font-size: 0.9rem;
	font-weight: 500;
	color: #374151;
}

.activity-content small {
	color: #6b7280;
	font-size: 0.8rem;
}

/* Form Enhancements */
.form-control:focus {
	border-color: #059669;
	box-shadow: 0 0 0 0.2rem rgba(5, 150, 105, 0.25);
}

.btn-primary {
	background: linear-gradient(135deg, #059669 0%, #047857 100%);
	border: none;
	font-weight: 600;
	padding: 10px 20px;
}

.btn-primary:hover {
	background: linear-gradient(135deg, #047857 0%, #065f46 100%);
	transform: translateY(-1px);
	box-shadow: 0 4px 8px rgba(5, 150, 105, 0.3);
}

.btn-warning {
	background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
	border: none;
	color: white;
	font-weight: 600;
}

.btn-warning:hover {
	background: linear-gradient(135deg, #d97706 0%, #b45309 100%);
	color: white;
}

/* Alert Enhancements */
.alert {
	border: none;
	border-radius: 8px;
	font-weight: 500;
}

.alert-success {
	background: linear-gradient(135deg, #d1fae5 0%, #a7f3d0 100%);
	color: #065f46;
	border-left: 4px solid #059669;
}

.alert-info {
	background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
	color: #1e40af;
	border-left: 4px solid #3b82f6;
}

.alert-warning {
	background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
	color: #92400e;
	border-left: 4px solid #f59e0b;
}

/* Responsive Design */
@media ( max-width : 768px) {
	.vendor-header {
		text-align: center;
		padding: 20px 0;
	}
	.vendor-header .row {
		text-align: center;
	}
	.vendor-header .text-end {
		text-align: center !important;
		margin-top: 20px;
	}
	.vendor-stats {
		justify-content: center;
		gap: 15px;
	}
	.vendor-stats .stat-item {
		min-width: 80px;
		padding: 10px;
	}
	.shop-badges {
		justify-content: center;
	}
	.vendor-sidebar {
		margin-bottom: 20px;
	}
	.sidebar-menu {
		flex-direction: row;
		overflow-x: auto;
	}
	.menu-item {
		white-space: nowrap;
		min-width: 150px;
		border-bottom: none;
		border-right: 1px solid #f3f4f6;
	}
	.menu-item:last-child {
		border-right: none;
	}
	.quick-stats {
		padding: 15px;
	}
	.vendor-card .card-body {
		padding: 20px;
	}
	.metric-card {
		padding: 15px;
	}
	.metric-icon {
		width: 50px;
		height: 50px;
		font-size: 1.3rem;
	}
	.metric-card h4 {
		font-size: 1.5rem;
	}
}

/* Animation Effects */
@
keyframes fadeInUp {from { opacity:0;
	transform: translateY(20px);
}

to {
	opacity: 1;
	transform: translateY(0);
}

}
.vendor-card {
	animation: fadeInUp 0.5s ease-out;
}

.vendor-card:nth-child(2) {
	animation-delay: 0.1s;
}

.vendor-card:nth-child(3) {
	animation-delay: 0.2s;
}

/* Loading States */
.btn:disabled {
	opacity: 0.6;
	cursor: not-allowed;
}

.form-control:disabled {
	background-color: #f9fafb;
	opacity: 0.8;
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    console.log('✅ COMPLETE Vendor Profile loaded - 2025-10-24 18:11:02 UTC');
    console.log('👨‍💻 Completed by: tuaanshuuysv');
    console.log('🏪 Shop: ${shopName}');
    console.log('👤 Vendor: ${authUser.email}');
    console.log('🔧 Profile mode: ${profileMode}');
    console.log('📊 REAL DATABASE DATA:');
    console.log('   🛍️ Products: ${totalProducts}');
    console.log('   📦 Orders: ${totalOrders}');
    console.log('   💰 Sales: ${totalSales}');
    console.log('   📅 Monthly: ${monthlyRevenue}');
    console.log('   ⭐ Rating: ${shopRating}/5');
    console.log('   💬 Reviews: ${shopReviews}');
    console.log('🎯 REAL SHOP UPDATE: shops.shop_name, shop_description, shop_phone, shop_address');

    // Enhanced Form Validation
    const forms = document.querySelectorAll('.needs-validation');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            console.log('📝 Form submission started...');
            
            if (!form.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();
                console.log('❌ Form validation failed');
            }

            // Special validation for shop name
            const shopNameInput = form.querySelector('#shopName');
            if (shopNameInput && shopNameInput.value.trim().length < 3) {
                e.preventDefault();
                shopNameInput.setCustomValidity('Tên shop phải có ít nhất 3 ký tự');
                console.log('❌ Shop name too short');
            } else if (shopNameInput) {
                shopNameInput.setCustomValidity('');
            }

            // Password confirmation check
            const newPassword = form.querySelector('#newPassword');
            const confirmPassword = form.querySelector('#confirmPassword');

            if (newPassword && confirmPassword) {
                if (newPassword.value !== confirmPassword.value) {
                    e.preventDefault();
                    confirmPassword.setCustomValidity('Xác nhận mật khẩu không khớp');
                    console.log('❌ Password confirmation mismatch');
                } else {
                    confirmPassword.setCustomValidity('');
                }
            }

            form.classList.add('was-validated');
            
            if (form.checkValidity()) {
                console.log('✅ Form validation passed, submitting...');
                
                // Show loading state
                const submitBtn = form.querySelector('button[type="submit"]');
                if (submitBtn) {
                    submitBtn.disabled = true;
                    const originalText = submitBtn.innerHTML;
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang lưu...';
                    
                    // Re-enable after 5 seconds as fallback
                    setTimeout(() => {
                        submitBtn.disabled = false;
                        submitBtn.innerHTML = originalText;
                    }, 5000);
                }
            }
        });
    });

    // Real-time password confirmation
    const confirmPasswordInput = document.querySelector('#confirmPassword');
    if (confirmPasswordInput) {
        confirmPasswordInput.addEventListener('input', function() {
            const newPassword = document.querySelector('#newPassword').value;
            if (this.value !== newPassword) {
                this.setCustomValidity('Xác nhận mật khẩu không khớp');
            } else {
                this.setCustomValidity('');
            }
        });
    }

    // Phone number formatting
    const phoneInputs = document.querySelectorAll('input[type="tel"]');
    phoneInputs.forEach(phoneInput => {
        phoneInput.addEventListener('input', function() {
            this.value = this.value.replace(/\D/g, '');
            if (this.value.length > 11) {
                this.value = this.value.slice(0, 11);
            }
        });
    });

    // Shop name validation
    const shopNameInput = document.querySelector('#shopName');
    if (shopNameInput) {
        shopNameInput.addEventListener('input', function() {
            if (this.value.trim().length < 3) {
                this.setCustomValidity('Tên shop phải có ít nhất 3 ký tự');
            } else {
                this.setCustomValidity('');
            }
        });
    }

    // Auto-refresh stats every 60 seconds
    setInterval(function() {
        console.log('🔄 Auto-refresh stats (would fetch updated data in real app)');
        // In a real app, you would fetch updated stats via AJAX
        // updateVendorStats();
    }, 60000);

    // Enhanced logging for debugging
    console.log('🔧 Debugging info:');
    console.log('   📍 Current URL: ' + window.location.href);
    console.log('   🎯 Profile mode: ${profileMode}');
    console.log('   👤 User role: ${authUser.roleId}');
    console.log('   🏪 Shop data available: ' + (typeof '${shopName}' !== 'undefined'));
    
    // Log form fields for debugging
    const allInputs = document.querySelectorAll('input, textarea, select');
    console.log('📝 Form fields found: ' + allInputs.length);
    allInputs.forEach(input => {
        if (input.name) {
            console.log('   🔸 ' + input.name + ': ' + (input.value || 'empty'));
        }
    });

    // Performance monitoring
    console.log('⚡ Page load completed in: ' + (performance.now()).toFixed(2) + 'ms');
});

// Function to test shop update (for debugging)
function testShopUpdate() {
    console.log('🧪 Testing shop update functionality...');
    
    const shopForm = document.querySelector('form[action*="vendor/profile"]');
    if (shopForm) {
        const formData = new FormData(shopForm);
        console.log('📝 Form data that would be sent:');
        for (let [key, value] of formData.entries()) {
            console.log('   ' + key + ': ' + value);
        }
    } else {
        console.log('❌ Shop form not found');
    }
}

// Enhanced error handling
window.addEventListener('error', function(e) {
    console.error('❌ JavaScript error in vendor profile:', e.error);
});

// Success message auto-hide
setTimeout(function() {
    const alerts = document.querySelectorAll('.alert-success, .alert-danger');
    alerts.forEach(alert => {
        if (alert.querySelector('.btn-close')) {
            // Auto-fade success messages after 10 seconds
            setTimeout(() => {
                alert.style.transition = 'opacity 0.5s ease';
                alert.style.opacity = '0';
                setTimeout(() => {
                    if (alert.parentNode) {
                        alert.parentNode.removeChild(alert);
                    }
                }, 500);
            }, 10000);
        }
    });
}, 1000);
</script>

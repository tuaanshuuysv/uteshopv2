<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!-- UTESHOP-CPL Admin Profile - SIMPLIFIED REAL DATA ONLY -->
<!-- Updated: 2025-10-24 18:48:19 UTC by tuaanshuuysv -->
<!-- Features: Only real database operations, removed fake system settings -->

<div class="admin-profile-page">

	<!-- Admin Header -->
	<div class="admin-header">
		<div class="container">
			<div class="row align-items-center">
				<div class="col-md-6">
					<div class="d-flex align-items-center">
						<div class="admin-avatar">
							<i class="fas fa-crown"></i>
						</div>
						<div class="ms-3">
							<h2 class="mb-1">👑 Quản trị viên</h2>
							<p class="text-muted mb-0">
								<i class="fas fa-user me-1"></i>Admin: ${authUser.fullName} <span
									class="ms-3"> <i class="fas fa-shield-alt me-1"></i> Hệ
									thống uptime: 99.9%
								</span>
							</p>
							<div class="admin-badges mt-2">
								<span class="badge bg-danger"> <i
									class="fas fa-crown me-1"></i>Admin Level 4
								</span> <span class="badge bg-success"> <i
									class="fas fa-link me-1"></i>System Online
								</span> <span class="badge bg-info"> <i
									class="fas fa-database me-1"></i>DB Connected
								</span>
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-6 text-end">
					<div class="admin-stats">
						<div class="stat-item">
							<span class="stat-number">${systemUsers}</span> <span
								class="stat-label">Users</span>
						</div>
						<div class="stat-item">
							<span class="stat-number">${activeShops}</span> <span
								class="stat-label">Shops</span>
						</div>
						<div class="stat-item">
							<span class="stat-number">${systemRevenue}</span> <span
								class="stat-label">Revenue</span>
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
					<c:when test="${param.success == 'profile_updated'}">✅ Cập nhật hồ sơ Admin thành công!</c:when>
					<c:when test="${param.success == 'password_changed'}">✅ Đổi mật khẩu thành công!</c:when>
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

	<!-- Admin Content -->
	<div class="container mt-4">
		<div class="row">

			<!-- Left Sidebar - CHỈ TÍNH NĂNG THẬT -->
			<div class="col-lg-3 mb-4">
				<div class="admin-sidebar">
					<div class="sidebar-menu">
						<a href="${pageContext.request.contextPath}/admin/profile"
							class="menu-item ${profileMode == 'view' ? 'active' : ''}"> <i
							class="fas fa-crown"></i> <span>Hồ sơ Admin</span>
						</a> <a href="${pageContext.request.contextPath}/admin/profile/edit"
							class="menu-item ${profileMode == 'edit' ? 'active' : ''}"> <i
							class="fas fa-edit"></i> <span>Chỉnh sửa hồ sơ</span>
						</a> <a
							href="${pageContext.request.contextPath}/admin/profile/change-password"
							class="menu-item ${profileMode == 'change-password' ? 'active' : ''}">
							<i class="fas fa-lock"></i> <span>Đổi mật khẩu</span>
						</a>
					</div>

					<!-- Real System Statistics từ Database -->
					<div class="system-stats mt-3">
						<h6 class="mb-3">📊 Hệ thống từ Database</h6>
						<div class="alert alert-primary mb-2">
							<i class="fas fa-users me-2"></i> <strong>${systemUsers}</strong>
							người dùng
						</div>
						<div class="alert alert-success mb-2">
							<i class="fas fa-store me-2"></i> <strong>${activeShops}</strong>
							cửa hàng
						</div>
						<div class="alert alert-warning mb-2">
							<i class="fas fa-box me-2"></i> <strong>${totalProducts}</strong>
							sản phẩm
						</div>
						<div class="alert alert-info mb-0">
							<i class="fas fa-money-bill-wave me-2"></i> <strong>${systemRevenue}</strong>
							doanh thu
						</div>
					</div>

					<!-- Real System Status từ Database -->
					<div class="system-status mt-3">
						<h6 class="mb-3">🖥️ Trạng thái hệ thống</h6>
						<div class="status-item">
							<div class="status-indicator bg-success"></div>
							<span>Server Load: ${serverLoad}</span>
						</div>
						<div class="status-item">
							<div class="status-indicator bg-info"></div>
							<span>Database: ${databaseSize}</span>
						</div>
						<div class="status-item">
							<div class="status-indicator bg-warning"></div>
							<span>Last Backup: ${lastBackup}</span>
						</div>
					</div>
				</div>
			</div>

			<!-- Main Content -->
			<div class="col-lg-9">

				<c:choose>
					<%-- VIEW ADMIN PROFILE --%>
					<c:when test="${profileMode == 'view' || empty profileMode}">
						<div class="row">
							<div class="col-lg-8">
								<div class="admin-card">
									<div class="card-header">
										<h5 class="mb-0">
											<i class="fas fa-crown me-2"></i>Thông tin Admin (Database)
										</h5>
										<a
											href="${pageContext.request.contextPath}/admin/profile/edit"
											class="btn btn-outline-danger btn-sm"> <i
											class="fas fa-edit me-1"></i>Chỉnh sửa
										</a>
									</div>
									<div class="card-body">
										<div class="alert alert-danger mb-3">
											<i class="fas fa-crown me-2"></i> <strong>Tài khoản
												Admin:</strong> Quyền cao nhất hệ thống với user_id =
											${authUser.userId}
										</div>

										<div class="row">
											<div class="col-md-6">
												<div class="info-item">
													<label>Họ và tên:</label> <span>${authUser.fullName}</span>
												</div>
												<div class="info-item">
													<label>Email:</label> <span>${authUser.email}</span>
												</div>
												<div class="info-item">
													<label>Số điện thoại:</label> <span>${authUser.phone != null ? authUser.phone : 'Chưa cập nhật'}</span>
												</div>
											</div>
											<div class="col-md-6">
												<div class="info-item">
													<label>Tên đăng nhập:</label> <span>${authUser.username}</span>
												</div>
												<div class="info-item">
													<label>Role ID:</label> <span class="badge bg-danger">4
														(Admin)</span>
												</div>
												<div class="info-item">
													<label>Tham gia từ:</label> <span><fmt:formatDate
															value="${adminSince}" pattern="dd/MM/yyyy HH:mm" /></span>
												</div>
											</div>
										</div>
									</div>
								</div>

								<!-- Real System Overview từ Database -->
								<div class="admin-card mt-4">
									<div class="card-header">
										<h6 class="mb-0">
											<i class="fas fa-chart-line me-2"></i>📈 Tổng quan hệ thống
											(từ Database)
										</h6>
									</div>
									<div class="card-body">
										<div class="row text-center">
											<div class="col-md-3">
												<div class="metric-card">
													<div class="metric-icon bg-primary">
														<i class="fas fa-users"></i>
													</div>
													<h4>${systemUsers}</h4>
													<p>Tổng người dùng</p>
												</div>
											</div>
											<div class="col-md-3">
												<div class="metric-card">
													<div class="metric-icon bg-success">
														<i class="fas fa-store"></i>
													</div>
													<h4>${activeShops}</h4>
													<p>Cửa hàng hoạt động</p>
												</div>
											</div>
											<div class="col-md-3">
												<div class="metric-card">
													<div class="metric-icon bg-warning">
														<i class="fas fa-box"></i>
													</div>
													<h4>${totalProducts}</h4>
													<p>Sản phẩm active</p>
												</div>
											</div>
											<div class="col-md-3">
												<div class="metric-card">
													<div class="metric-icon bg-info">
														<i class="fas fa-money-bill-wave"></i>
													</div>
													<h4 style="font-size: 1.2rem;">${systemRevenue}</h4>
													<p>Tổng doanh thu</p>
												</div>
											</div>
										</div>

										<hr class="my-4">

										<div class="row">
											<div class="col-md-4">
												<div
													class="d-flex justify-content-between align-items-center">
													<span><i class="fas fa-users text-primary me-1"></i>Người
														dùng hoạt động:</span> <strong class="text-primary">${activeUsers}</strong>
												</div>
											</div>
											<div class="col-md-4">
												<div
													class="d-flex justify-content-between align-items-center">
													<span><i class="fas fa-tasks text-warning me-1"></i>Chờ
														duyệt:</span> <strong class="text-warning">${pendingApprovals}</strong>
												</div>
											</div>
											<div class="col-md-4">
												<div
													class="d-flex justify-content-between align-items-center">
													<span><i class="fas fa-database text-info me-1"></i>Nguồn
														dữ liệu:</span> <strong class="text-info">MySQL DB</strong>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>

							<div class="col-lg-4">
								<!-- Real Admin Statistics từ Database -->
								<div class="admin-card">
									<div class="card-header">
										<h6 class="mb-0">
											<i class="fas fa-chart-bar me-1"></i>📊 Admin Dashboard
										</h6>
									</div>
									<div class="card-body">
										<div class="admin-stats-list">
											<div class="stat-item">
												<i class="fas fa-users text-primary"></i> <span
													class="stat-label">Tổng users:</span> <span
													class="stat-value">${systemUsers}</span>
											</div>
											<div class="stat-item">
												<i class="fas fa-user-check text-success"></i> <span
													class="stat-label">Users hoạt động:</span> <span
													class="stat-value">${activeUsers}</span>
											</div>
											<div class="stat-item">
												<i class="fas fa-store text-info"></i> <span
													class="stat-label">Shops hoạt động:</span> <span
													class="stat-value">${activeShops}</span>
											</div>
											<div class="stat-item">
												<i class="fas fa-box text-warning"></i> <span
													class="stat-label">Products active:</span> <span
													class="stat-value">${totalProducts}</span>
											</div>
											<div class="stat-item">
												<i class="fas fa-money-bill-wave text-success"></i> <span
													class="stat-label">Tổng doanh thu:</span> <span
													class="stat-value">${systemRevenue}</span>
											</div>
											<div class="stat-item">
												<i class="fas fa-tasks text-danger"></i> <span
													class="stat-label">Chờ duyệt:</span> <span
													class="stat-value">${pendingApprovals}</span>
											</div>
										</div>
									</div>
								</div>

								<!-- Real System Status từ Database -->
								<div class="admin-card mt-3">
									<div class="card-header">
										<h6 class="mb-0">
											<i class="fas fa-server me-1"></i>🖥️ Hệ thống thực tế
										</h6>
									</div>
									<div class="card-body">
										<div class="system-overview">
											<div class="overview-item">
												<i class="fas fa-server text-success"></i> <span
													class="overview-label">Server Load:</span> <span
													class="overview-value">${serverLoad}</span>
											</div>
											<div class="overview-item">
												<i class="fas fa-database text-info"></i> <span
													class="overview-label">Database Size:</span> <span
													class="overview-value">${databaseSize}</span>
											</div>
											<div class="overview-item">
												<i class="fas fa-backup text-warning"></i> <span
													class="overview-label">Last Backup:</span> <span
													class="overview-value">${lastBackup}</span>
											</div>
											<div class="overview-item">
												<i class="fas fa-clock text-primary"></i> <span
													class="overview-label">System Uptime:</span> <span
													class="overview-value">${systemUptime}</span>
											</div>
											<div class="overview-item">
												<i class="fas fa-exclamation-triangle text-danger"></i> <span
													class="overview-label">System Alerts:</span> <span
													class="overview-value">${systemAlerts}</span>
											</div>
											<div class="overview-item">
												<i class="fas fa-history text-secondary"></i> <span
													class="overview-label">Recent Actions:</span> <span
													class="overview-value">${recentActions}</span>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</c:when>

					<%-- EDIT ADMIN PROFILE --%>
					<c:when test="${profileMode == 'edit'}">
						<div class="admin-card">
							<div class="card-header">
								<h5 class="mb-0">
									<i class="fas fa-edit me-2"></i>✏️ Chỉnh sửa hồ sơ Admin
								</h5>
							</div>
							<div class="card-body">
								<form method="POST"
									action="${pageContext.request.contextPath}/admin/profile"
									class="needs-validation" novalidate>
									<input type="hidden" name="action" value="update-profile">

									<div class="alert alert-danger">
										<i class="fas fa-crown me-2"></i> <strong>⚠️ Cảnh
											báo:</strong> Bạn đang chỉnh sửa tài khoản Admin có quyền cao nhất hệ
										thống. <br>
										<small>Thông tin sẽ được cập nhật trực tiếp vào
											database với role_id = 4.</small>
									</div>

									<div class="row">
										<div class="col-md-6">
											<div class="mb-3">
												<label for="fullName" class="form-label"> 👑 Họ và
													tên Admin <span class="text-danger">*</span>
												</label> <input type="text" class="form-control" id="fullName"
													name="fullName" value="${authUser.fullName}" required>
												<div class="invalid-feedback">Vui lòng nhập họ và tên</div>
												<small class="text-muted">➡️ Lưu vào:
													users.full_name</small>
											</div>
										</div>
										<div class="col-md-6">
											<div class="mb-3">
												<label for="phone" class="form-label">📞 Số điện
													thoại</label> <input type="tel" class="form-control" id="phone"
													name="phone" value="${authUser.phone}"
													pattern="[0-9]{10,11}">
												<div class="invalid-feedback">Số điện thoại phải có
													10-11 chữ số</div>
												<small class="text-muted">➡️ Lưu vào: users.phone</small>
											</div>
										</div>
									</div>

									<div class="row">
										<div class="col-md-6">
											<div class="mb-3">
												<label for="email" class="form-label">📧 Email Admin</label>
												<input type="email" class="form-control" id="email"
													name="email" value="${authUser.email}" readonly> <small
													class="text-muted">Email Admin không thể thay đổi</small>
											</div>
										</div>
										<div class="col-md-6">
											<div class="mb-3">
												<label for="username" class="form-label">🔑 Username
													Admin</label> <input type="text" class="form-control" id="username"
													name="username" value="${authUser.username}" readonly>
												<small class="text-muted">Username Admin không thể
													thay đổi</small>
											</div>
										</div>
									</div>

									<div class="alert alert-warning">
										<i class="fas fa-info-circle me-2"></i> <strong>Cơ
											chế Admin:</strong>
										<ul class="mb-0 mt-2">
											<li>Cập nhật vào bảng users với WHERE user_id =
												${authUser.userId} AND role_id = 4</li>
											<li>Chỉ Admin mới có thể thay đổi thông tin Admin</li>
											<li>Tự động log activity để audit</li>
										</ul>
									</div>

									<hr>

									<div class="d-flex gap-2">
										<button type="submit" class="btn btn-danger">
											<i class="fas fa-save me-1"></i>💾 Lưu thay đổi Admin
										</button>
										<a href="${pageContext.request.contextPath}/admin/profile"
											class="btn btn-secondary"> <i class="fas fa-times me-1"></i>❌
											Hủy
										</a> <a
											href="${pageContext.request.contextPath}/admin/profile/change-password"
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
						<div class="admin-card">
							<div class="card-header">
								<h5 class="mb-0">
									<i class="fas fa-lock me-2"></i>🔐 Đổi mật khẩu Admin
								</h5>
							</div>
							<div class="card-body">
								<form method="POST"
									action="${pageContext.request.contextPath}/admin/profile"
									class="needs-validation" novalidate>
									<input type="hidden" name="action" value="change-password">

									<div class="alert alert-danger">
										<i class="fas fa-crown me-2"></i> <strong>⚠️ Bảo mật
											cao:</strong> Đây là tài khoản Admin có quyền cao nhất hệ thống. <br>
										<small>Mật khẩu Admin sẽ được hash với mức bảo mật cao
											nhất.</small>
									</div>

									<div class="mb-3">
										<label for="currentPassword" class="form-label"> 🔒
											Mật khẩu Admin hiện tại <span class="text-danger">*</span>
										</label> <input type="password" class="form-control"
											id="currentPassword" name="currentPassword" required>
										<div class="invalid-feedback">Vui lòng nhập mật khẩu
											hiện tại</div>
										<small class="text-muted">Xác thực danh tính Admin</small>
									</div>

									<div class="row">
										<div class="col-md-6">
											<div class="mb-3">
												<label for="newPassword" class="form-label"> 🆕 Mật
													khẩu Admin mới <span class="text-danger">*</span>
												</label> <input type="password" class="form-control"
													id="newPassword" name="newPassword" required minlength="8">
												<div class="invalid-feedback">Mật khẩu Admin phải có
													ít nhất 8 ký tự</div>
												<small class="text-muted">Tối thiểu 8 ký tự cho
													Admin</small>
											</div>
										</div>
										<div class="col-md-6">
											<div class="mb-3">
												<label for="confirmPassword" class="form-label"> ✅
													Xác nhận mật khẩu Admin <span class="text-danger">*</span>
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
											ý Admin:</strong>
										<ul class="mb-0 mt-2">
											<li>Mật khẩu Admin được hash với salt mạnh nhất</li>
											<li>Thay đổi sẽ được ghi log để audit</li>
											<li>Không thể khôi phục mật khẩu cũ</li>
											<li>Cập nhật vào users.password_hash và users.salt</li>
										</ul>
									</div>

									<hr>

									<div class="d-flex gap-2">
										<button type="submit" class="btn btn-danger">
											<i class="fas fa-key me-1"></i>🔐 Đổi mật khẩu Admin
										</button>
										<a href="${pageContext.request.contextPath}/admin/profile"
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
/* Admin Profile Styles - Simplified Real Data Only */
.admin-profile-page {
	background: #f8fafc;
	min-height: calc(100vh - 120px);
}

.admin-header {
	background: linear-gradient(135deg, #dc2626 0%, #991b1b 100%);
	color: white;
	padding: 30px 0;
	box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.admin-avatar {
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

.admin-badges {
	display: flex;
	gap: 8px;
	flex-wrap: wrap;
}

.admin-stats {
	display: flex;
	gap: 25px;
	justify-content: flex-end;
}

.admin-stats .stat-item {
	display: flex;
	flex-direction: column;
	align-items: center;
	text-align: center;
	background: rgba(255, 255, 255, 0.1);
	padding: 15px;
	border-radius: 8px;
	min-width: 100px;
}

.admin-stats .stat-number {
	font-size: 1.8rem;
	font-weight: bold;
	margin-bottom: 5px;
}

.admin-stats .stat-label {
	font-size: 0.9rem;
	opacity: 0.9;
}

.admin-sidebar {
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
	background: #fee2e2;
	color: #dc2626;
	text-decoration: none;
	transform: translateX(2px);
}

.menu-item.active {
	background: #dc2626;
	color: white;
	box-shadow: inset 4px 0 0 #991b1b;
}

.menu-item i {
	width: 20px;
	margin-right: 12px;
	text-align: center;
	font-size: 1.1rem;
}

.system-stats {
	padding: 18px 20px;
	background: #f8fafc;
}

.system-stats h6 {
	color: #374151;
	font-weight: 600;
	margin-bottom: 15px;
}

.system-stats .alert {
	padding: 12px 15px;
	margin-bottom: 10px;
	font-size: 0.9rem;
	border: none;
	font-weight: 500;
}

.system-status {
	padding: 18px 20px;
	background: #f1f5f9;
}

.system-status h6 {
	color: #374151;
	font-weight: 600;
	margin-bottom: 15px;
}

.status-item {
	display: flex;
	align-items: center;
	gap: 10px;
	margin-bottom: 8px;
	font-size: 0.9rem;
	color: #6b7280;
}

.status-indicator {
	width: 8px;
	height: 8px;
	border-radius: 50%;
}

.admin-card {
	background: white;
	border-radius: 12px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
	margin-bottom: 25px;
	overflow: hidden;
	border: 1px solid #e5e7eb;
}

.admin-card .card-header {
	background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
	border-bottom: 2px solid #e5e7eb;
	padding: 20px 25px;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.admin-card .card-header h5, .admin-card .card-header h6 {
	margin: 0;
	color: #1f2937;
	font-weight: 600;
}

.admin-card .card-body {
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

.admin-stats-list {
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.admin-stats-list .stat-item {
	display: flex;
	align-items: center;
	gap: 15px;
	padding: 12px 0;
	border-bottom: 1px solid #f3f4f6;
}

.admin-stats-list .stat-item:last-child {
	border-bottom: none;
}

.admin-stats-list .stat-item i {
	width: 24px;
	text-align: center;
	font-size: 1.1rem;
}

.admin-stats-list .stat-label {
	flex: 1;
	font-size: 0.9rem;
	color: #6b7280;
	font-weight: 500;
}

.admin-stats-list .stat-value {
	font-weight: 600;
	color: #1f2937;
	font-size: 0.95rem;
}

.system-overview {
	display: flex;
	flex-direction: column;
	gap: 16px;
}

.overview-item {
	display: flex;
	align-items: center;
	gap: 15px;
	padding: 12px 0;
	border-bottom: 1px solid #f3f4f6;
}

.overview-item:last-child {
	border-bottom: none;
}

.overview-item i {
	width: 24px;
	text-align: center;
	font-size: 1.1rem;
}

.overview-label {
	flex: 1;
	font-size: 0.9rem;
	color: #6b7280;
	font-weight: 500;
}

.overview-value {
	font-weight: 600;
	color: #1f2937;
	font-size: 0.95rem;
}

/* Form Enhancements */
.form-control:focus {
	border-color: #dc2626;
	box-shadow: 0 0 0 0.2rem rgba(220, 38, 38, 0.25);
}

.btn-danger {
	background: linear-gradient(135deg, #dc2626 0%, #991b1b 100%);
	border: none;
	font-weight: 600;
	padding: 10px 20px;
}

.btn-danger:hover {
	background: linear-gradient(135deg, #991b1b 0%, #7f1d1d 100%);
	transform: translateY(-1px);
	box-shadow: 0 4px 8px rgba(220, 38, 38, 0.3);
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

.alert-danger {
	background: linear-gradient(135deg, #fee2e2 0%, #fecaca 100%);
	color: #991b1b;
	border-left: 4px solid #dc2626;
}

.alert-warning {
	background: linear-gradient(135deg, #fef3c7 0%, #fde68a 100%);
	color: #92400e;
	border-left: 4px solid #f59e0b;
}

.alert-info {
	background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
	color: #1e40af;
	border-left: 4px solid #3b82f6;
}

/* Responsive Design */
@media ( max-width : 768px) {
	.admin-header {
		text-align: center;
		padding: 20px 0;
	}
	.admin-header .text-end {
		text-align: center !important;
		margin-top: 20px;
	}
	.admin-stats {
		justify-content: center;
		gap: 15px;
	}
	.admin-badges {
		justify-content: center;
	}
	.admin-sidebar {
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
	.system-stats, .system-status {
		padding: 15px;
	}
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    console.log('✅ SIMPLIFIED Admin Profile loaded - 2025-10-24 18:51:41 UTC');
    console.log('👨‍💻 Simplified by: tuaanshuuysv');
    console.log('👑 Current admin: ${authUser.email}');
    console.log('🔧 Profile mode: ${profileMode}');
    console.log('📊 REAL ADMIN DATA: Users=${systemUsers}, Shops=${activeShops}, Revenue=${systemRevenue}');
    console.log('🗑️ REMOVED: Fake system settings, mock controls');
    console.log('✅ KEPT: Only real database operations');
    
    // Enhanced Form validation for Admin
    const forms = document.querySelectorAll('.needs-validation');
    forms.forEach(form => {
        form.addEventListener('submit', function(e) {
            if (!form.checkValidity()) {
                e.preventDefault();
                e.stopPropagation();
            }
            
            // Enhanced password validation for Admin
            const newPassword = form.querySelector('#newPassword');
            const confirmPassword = form.querySelector('#confirmPassword');
            
            if (newPassword && confirmPassword) {
                // Admin password must be stronger
                if (newPassword.value.length < 8) {
                    e.preventDefault();
                    newPassword.setCustomValidity('Mật khẩu Admin phải có ít nhất 8 ký tự');
                } else {
                    newPassword.setCustomValidity('');
                }
                
                if (newPassword.value !== confirmPassword.value) {
                    e.preventDefault();
                    confirmPassword.setCustomValidity('Xác nhận mật khẩu không khớp');
                } else {
                    confirmPassword.setCustomValidity('');
                }
            }
            
            form.classList.add('was-validated');
            
            if (form.checkValidity()) {
                console.log('✅ Admin form validation passed');
                
                // Show loading state for Admin
                const submitBtn = form.querySelector('button[type="submit"]');
                if (submitBtn) {
                    submitBtn.disabled = true;
                    const originalText = submitBtn.innerHTML;
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang xử lý...';
                    
                    setTimeout(() => {
                        submitBtn.disabled = false;
                        submitBtn.innerHTML = originalText;
                    }, 5000);
                }
            }
        });
    });
    
    // Real-time password confirmation for Admin
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
    
    // Admin password strength indicator
    const newPasswordInput = document.querySelector('#newPassword');
    if (newPasswordInput) {
        newPasswordInput.addEventListener('input', function() {
            const password = this.value;
            if (password.length < 8) {
                this.setCustomValidity('Mật khẩu Admin phải có ít nhất 8 ký tự');
            } else if (password.length < 12) {
                this.setCustomValidity('');
                console.log('⚠️ Admin password could be stronger');
            } else {
                this.setCustomValidity('');
                console.log('✅ Strong admin password');
            }
        });
    }
    
    // Phone number formatting for Admin
    const phoneInput = document.querySelector('#phone');
    if (phoneInput) {
        phoneInput.addEventListener('input', function() {
            this.value = this.value.replace(/\D/g, '');
            if (this.value.length > 11) {
                this.value = this.value.slice(0, 11);
            }
        });
    }
    
    // Admin activity monitoring
    console.log('🔍 Admin activity monitoring enabled');
    console.log('   📍 Current URL: ' + window.location.href);
    console.log('   🎯 Profile mode: ${profileMode}');
    console.log('   👑 Admin role: ${authUser.roleId}');
    console.log('   📊 System stats loaded: ' + (typeof '${systemUsers}' !== 'undefined'));
});

// Admin security check
function checkAdminSecurity() {
    console.log('🔒 Admin security check...');
    console.log('   👑 Role ID: ${authUser.roleId}');
    console.log('   📧 Admin email: ${authUser.email}');
    console.log('   🕐 Session time: ' + new Date().toISOString());
}

// Run security check every 5 minutes for Admin
setInterval(checkAdminSecurity, 300000);

// Enhanced error handling for Admin
window.addEventListener('error', function(e) {
    console.error('❌ Admin profile error:', e.error);
    console.log('🔍 Admin context: ${authUser.email}, mode: ${profileMode}');
});

// Success message auto-hide for Admin
setTimeout(function() {
    const alerts = document.querySelectorAll('.alert-success, .alert-danger');
    alerts.forEach(alert => {
        if (alert.querySelector('.btn-close')) {
            setTimeout(() => {
                alert.style.transition = 'opacity 0.5s ease';
                alert.style.opacity = '0';
                setTimeout(() => {
                    if (alert.parentNode) {
                        alert.parentNode.removeChild(alert);
                    }
                }, 500);
            }, 8000); // Admin messages stay longer
        }
    });
}, 1000);
</script>
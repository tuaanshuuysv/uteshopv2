<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<header class="p-3 border-bottom bg-light">
  <div class="container d-flex justify-content-between align-items-center">
    <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/">UTESHOP</a>
    <nav>
      <a class="me-3" href="${pageContext.request.contextPath}/">Trang chủ</a>
      <a class="me-3" href="${pageContext.request.contextPath}/auth/login">Đăng nhập</a>
      <a class="btn btn-primary" href="${pageContext.request.contextPath}/auth/register">Đăng ký</a>
    </nav>
  </div>
</header>

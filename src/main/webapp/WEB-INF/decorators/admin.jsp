<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html><html lang="vi"><head>
<meta charset="utf-8"/><meta name="viewport" content="width=device-width, initial-scale=1"/>
<title><c:out value="${pageTitle != null ? pageTitle : 'UTESHOP'}"/></title>
<link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet"/>
<link href="${pageContext.request.contextPath}/assets/css/custom.css" rel="stylesheet"/>
</head><body>
<jsp:include page="/WEB-INF/views/common/header.jsp"/>
<main class="container py-4">
  <jsp:include page="${requestScope.view}"/>
</main>
<jsp:include page="/WEB-INF/views/common/footer.jsp"/>
<script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/custom.js"></script>
</body></html>

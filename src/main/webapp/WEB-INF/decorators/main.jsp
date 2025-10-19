<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!doctype html>
<html lang="vi">
<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title><c:out value="${pageTitle != null ? pageTitle : 'UTESHOP-CPL by tuaanshuuysv'}"/></title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="${pageContext.request.contextPath}/assets/css/custom.css" rel="stylesheet"/>
    
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .navbar-brand {
            font-weight: bold;
            color: #007bff !important;
        }
        .footer {
            background-color: #f8f9fa;
            padding: 20px 0;
            margin-top: 50px;
            border-top: 1px solid #dee2e6;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <jsp:include page="/WEB-INF/views/common/header.jsp"/>
    
    <!-- Main Content -->
    <main class="container py-4">
        <jsp:include page="${requestScope.view}"/>
    </main>
    
    <!-- Footer -->
    <jsp:include page="/WEB-INF/views/common/footer.jsp"/>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom JS -->
    <script src="${pageContext.request.contextPath}/assets/js/custom.js"></script>
    
    <script>
        console.log('✅ UTESHOP-CPL Main Layout loaded successfully');
        console.log('📅 Built on: 2025-10-19 17:12:01 UTC');
        console.log('👨‍💻 Created by: tuaanshuuysv');
        console.log('🚀 Compatible with Tomcat 10.x / Jakarta EE');
    </script>
</body>
</html>
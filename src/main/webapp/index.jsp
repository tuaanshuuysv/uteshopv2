<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Updated: 2025-10-21 00:40:12 UTC - Fixed redirect to /home
    // Direct forward to HomeController without redirect loop
    response.sendRedirect(request.getContextPath() + "/home");
%>
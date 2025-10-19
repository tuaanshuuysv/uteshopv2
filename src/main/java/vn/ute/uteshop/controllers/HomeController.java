package vn.ute.uteshop.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import vn.ute.uteshop.model.User;
import vn.ute.uteshop.common.AppConstants;

import java.io.IOException;

@WebServlet(urlPatterns = {"/home"}) // Remove "/" to avoid conflict with index.jsp
public class HomeController extends HttpServlet {

    @Override
    public void init() throws ServletException {
        System.out.println("✅ HomeController initialized successfully");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("🔄 GET request to home page - " + java.time.LocalDateTime.now());
        
        // Get authenticated user if available
        User authUser = (User) request.getAttribute(AppConstants.AUTH_USER_ATTR);
        
        // Set page title
        request.setAttribute("pageTitle", "UTESHOP-CPL - Trang chủ by tuaanshuuysv");
        
        // Set user info for header
        if (authUser != null) {
            request.setAttribute("authUser", authUser);
            System.out.println("✅ Authenticated user: " + authUser.getEmail());
        } else {
            System.out.println("ℹ️ Anonymous user accessing home page");
        }
        
        // Set decorator
        request.setAttribute("view", "/WEB-INF/views/guest/home.jsp");
        
        // Forward to main decorator
        request.getRequestDispatcher("/WEB-INF/decorators/main.jsp").forward(request, response);
    }
}
package vn.ute.uteshop.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import vn.ute.uteshop.dto.AuthDtos;
import vn.ute.uteshop.model.User;
import vn.ute.uteshop.dao.UserDao;
import vn.ute.uteshop.dao.impl.UserDaoImpl;
import vn.ute.uteshop.services.SearchService;
import vn.ute.uteshop.services.SearchService.SearchParams;
import vn.ute.uteshop.services.SearchService.SearchResult;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;

/**
 * SearchController - COMPLETE VERSION
 * Updated: 2025-10-26 18:33:55 UTC by tuaanshuuysv
 */
@WebServlet(urlPatterns = {"/search", "/products", "/categories/*"})
public class SearchController extends HttpServlet {

    private UserDao userDao;
    private SearchService searchService;

    @Override
    public void init() throws ServletException {
        try {
            userDao = new UserDaoImpl();
            searchService = new SearchService();
            System.out.println("✅ SearchController initialized with SearchService");
        } catch (Exception e) {
            System.err.println("❌ Error initializing SearchController: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = getRequestPath(request);
        System.out.println("🔄 SearchController GET: " + path + " at " + LocalDateTime.now());
        
        try {
            User authUser = getAuthenticatedUser(request);
            setCommonAttributes(request, authUser);
            
            SearchParams searchParams = new SearchParams();
            searchParams.setQuery(request.getParameter("q"));
            searchParams.setCategoryId(getIntParameter(request, "category", 0));
            searchParams.setSortBy(request.getParameter("sort"));
            searchParams.setPage(getIntParameter(request, "page", 1));
            searchParams.setPageSize(12);
            
            System.out.println("🔍 Search params: " + searchParams);
            
            SearchResult searchResult = searchService.searchProducts(searchParams);
            List<Map<String, Object>> categories = getCategoriesFromDB();
            
            request.setAttribute("products", searchResult.getProducts());
            request.setAttribute("categories", categories);
            request.setAttribute("totalProducts", searchResult.getTotalProducts());
            request.setAttribute("totalPages", searchResult.getTotalPages());
            request.setAttribute("currentPage", searchResult.getCurrentPage());
            request.setAttribute("categoryId", searchParams.getCategoryId());
            request.setAttribute("searchQuery", searchParams.getQuery());
            request.setAttribute("sortBy", searchParams.getSortBy());
            request.setAttribute("searchParams", searchParams);
            request.setAttribute("searchResult", searchResult);
            
            String pageTitle = buildPageTitle(searchParams.getQuery(), searchParams.getCategoryId());
            request.setAttribute("pageTitle", pageTitle);
            
            System.out.println("✅ Search completed: " + searchResult.getProducts().size() + " products found");
            
            request.getRequestDispatcher("/WEB-INF/views/search/results.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("❌ Error in SearchController: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("products", new ArrayList<>());
            request.setAttribute("categories", new ArrayList<>());
            request.setAttribute("totalProducts", 0);
            request.setAttribute("totalPages", 0);
            request.setAttribute("currentPage", 1);
            request.setAttribute("categoryId", 0);
            request.setAttribute("searchQuery", "");
            request.setAttribute("sortBy", "");
            request.setAttribute("error", "Có lỗi xảy ra khi tìm kiếm: " + e.getMessage());
            request.setAttribute("pageTitle", "Tìm kiếm - UTESHOP");
            
            request.getRequestDispatcher("/WEB-INF/views/search/results.jsp").forward(request, response);
        }
    }

    private List<Map<String, Object>> getCategoriesFromDB() {
        try {
            return searchService.getAllCategories();
        } catch (Exception e) {
            System.err.println("Error loading categories: " + e.getMessage());
            List<Map<String, Object>> categories = new ArrayList<>();
            
            Map<String, Object> cat1 = new HashMap<>();
            cat1.put("category_id", 1);
            cat1.put("category_name", "Điện tử");
            cat1.put("product_count", 10);
            categories.add(cat1);
            
            Map<String, Object> cat2 = new HashMap<>();
            cat2.put("category_id", 2);
            cat2.put("category_name", "Thời trang");
            cat2.put("product_count", 15);
            categories.add(cat2);
            
            Map<String, Object> cat3 = new HashMap<>();
            cat3.put("category_id", 3);
            cat3.put("category_name", "Mỹ phẩm");
            cat3.put("product_count", 8);
            categories.add(cat3);
            
            return categories;
        }
    }

    private String buildPageTitle(String query, int categoryId) {
        if (query != null && !query.trim().isEmpty()) {
            return "Tìm kiếm: " + query + " - UTESHOP";
        } else if (categoryId > 0) {
            return "Sản phẩm theo danh mục - UTESHOP";
        } else {
            return "Tất cả sản phẩm - UTESHOP";
        }
    }

    private String getRequestPath(HttpServletRequest request) {
        String path = request.getRequestURI();
        String contextPath = request.getContextPath();
        return path.startsWith(contextPath) ? path.substring(contextPath.length()) : path;
    }

    private User getAuthenticatedUser(HttpServletRequest request) {
        try {
            HttpSession session = request.getSession(false);
            if (session == null) return null;
            
            Object sessionUser = session.getAttribute("user");
            if (sessionUser instanceof AuthDtos.UserResponse) {
                AuthDtos.UserResponse userResponse = (AuthDtos.UserResponse) sessionUser;
                return userDao != null ? userDao.findById(userResponse.getUserId()) : null;
            }
            
            return sessionUser instanceof User ? (User) sessionUser : null;
        } catch (Exception e) {
            System.err.println("⚠️ Error getting authenticated user: " + e.getMessage());
            return null;
        }
    }

    private void setCommonAttributes(HttpServletRequest request, User user) {
        request.setAttribute("authUser", user);
        request.setAttribute("isLoggedIn", user != null);
        request.setAttribute("userRoleId", user != null ? user.getRoleId() : 0);
        request.setAttribute("userRoleDisplay", user != null ? getRoleDisplay(user.getRoleId()) : "Guest");
    }

    private String getRoleDisplay(int roleId) {
        return switch (roleId) {
            case 4 -> "Admin";
            case 3 -> "Vendor";
            case 2 -> "Customer";
            default -> "Guest";
        };
    }

    private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
        try {
            String paramValue = request.getParameter(paramName);
            return paramValue != null && !paramValue.trim().isEmpty() ? Integer.parseInt(paramValue) : defaultValue;
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    @Override
    public void destroy() {
        System.out.println("🗑️ SearchController destroyed at: " + LocalDateTime.now());
        super.destroy();
    }
}
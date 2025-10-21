package vn.ute.uteshop.controllers;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import vn.ute.uteshop.model.User;
import vn.ute.uteshop.common.AppConstants;
import vn.ute.uteshop.dto.AuthDtos;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Enhanced HomeController for UTESHOP-CPL with User Display
 * Updated: 2025-10-21 00:28:23 UTC - Added debugging and session fallback
 * Compatible with existing architecture by tuaanshuuysv
 */
@WebServlet(urlPatterns = {"/home"}) // Remove "/" to avoid conflict with index.jsp
public class HomeController extends HttpServlet {

    @Override
    public void init() throws ServletException {
        System.out.println("✅ HomeController initialized successfully");
        System.out.println("🕐 Enhanced on: 2025-10-21 00:28:23 UTC");
        System.out.println("👨‍💻 Enhanced by: tuaanshuuysv");
        System.out.println("🔧 Compatible with existing decorator pattern");
        System.out.println("🔍 Added: Debug logging, session fallback, user display");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        System.out.println("🔄 GET request to home page - " + LocalDateTime.now());
        
        try {
            // ✅ DEBUG: Check what's in request attributes
            System.out.println("🔍 DEBUG: Request attributes check:");
            java.util.Enumeration<String> attrs = request.getAttributeNames();
            boolean hasAttributes = false;
            while (attrs.hasMoreElements()) {
                String attrName = attrs.nextElement();
                Object attrValue = request.getAttribute(attrName);
                System.out.println("   ✅ " + attrName + " = " + (attrValue != null ? attrValue.getClass().getSimpleName() + ":" + attrValue : "null"));
                hasAttributes = true;
            }
            if (!hasAttributes) {
                System.out.println("   ❌ No request attributes found");
            }
            
            // Get authenticated user from JWT filter (already set by JwtAuthFilter)
            User authUser = (User) request.getAttribute(AppConstants.AUTH_USER_ATTR);
            
            System.out.println("🔍 DEBUG: authUser from JwtFilter = " + (authUser != null ? authUser.getEmail() : "null"));
            
            // ✅ FALLBACK: Try to get user from session if JWT filter didn't set it
            if (authUser == null) {
                HttpSession session = request.getSession(false);
                if (session != null) {
                    Object sessionUser = session.getAttribute("user");
                    System.out.println("🔍 DEBUG: sessionUser = " + (sessionUser != null ? sessionUser.getClass().getSimpleName() : "null"));
                    
                    // If session user is AuthDtos.UserResponse, convert it to User
                    if (sessionUser instanceof AuthDtos.UserResponse) {
                        AuthDtos.UserResponse userResponse = (AuthDtos.UserResponse) sessionUser;
                        System.out.println("🔄 Converting UserResponse to User for display");
                        System.out.println("👤 UserResponse: " + userResponse.getEmail() + " (Role: " + userResponse.getRoleId() + ")");
                        
                        // Create a temporary User object for display
                        User tempUser = new User();
                        tempUser.setUserId(userResponse.getUserId());
                        tempUser.setUsername(userResponse.getUsername());
                        tempUser.setEmail(userResponse.getEmail());
                        tempUser.setFullName(userResponse.getFullName());
                        tempUser.setPhone(userResponse.getPhone());
                        tempUser.setRoleId(userResponse.getRoleId());
                        tempUser.setIsActive(true); // Assume active if in session
                        tempUser.setIsVerified(true); // Assume verified if in session
                        
                        authUser = tempUser;
                        
                        // Also set in request for consistency
                        request.setAttribute(AppConstants.AUTH_USER_ATTR, authUser);
                        System.out.println("✅ User converted and set from session: " + authUser.getEmail());
                    }
                } else {
                    System.out.println("🔍 DEBUG: No session found");
                }
            }
            
            // Set page title
            request.setAttribute("pageTitle", "UTESHOP-CPL - Trang chủ by tuaanshuuysv");
            
            // Enhanced user info processing
            if (authUser != null) {
                System.out.println("✅ Authenticated user found: " + authUser.getEmail());
                System.out.println("👤 User details: " + authUser.getFullName() + " (Role: " + authUser.getRoleId() + ")");
                
                // Set user info for JSP
                request.setAttribute("authUser", authUser);
                request.setAttribute("isLoggedIn", true);
                
                // Role-based content and display names
                setRoleBasedContent(request, authUser);
                
                // User statistics
                request.setAttribute("userLastLogin", authUser.getLastLogin());
                request.setAttribute("userCreatedAt", authUser.getCreatedAt());
                
            } else {
                System.out.println("ℹ️ Anonymous user accessing home page");
                request.setAttribute("authUser", null);
                request.setAttribute("isLoggedIn", false);
                
                // Set guest content
                setGuestContent(request);
            }
            
            // Set common attributes
            request.setAttribute("currentDateTime", LocalDateTime.now());
            request.setAttribute("serverTime", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
            
            // Debug final attributes
            System.out.println("🔍 Final attributes set:");
            System.out.println("   isLoggedIn: " + request.getAttribute("isLoggedIn"));
            System.out.println("   authUser: " + (request.getAttribute("authUser") != null ? "Present" : "null"));
            System.out.println("   userRoleDisplay: " + request.getAttribute("userRoleDisplay"));
            
            // Set view for decorator pattern
            request.setAttribute("view", "/WEB-INF/views/guest/home.jsp");
            
            // Forward to main decorator
            request.getRequestDispatcher("/WEB-INF/decorators/main.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("❌ Error in HomeController: " + e.getMessage());
            e.printStackTrace();
            
            // Error handling
            request.setAttribute("error", "Có lỗi xảy ra khi tải trang chủ. Vui lòng thử lại.");
            request.setAttribute("isLoggedIn", false);
            request.setAttribute("pageTitle", "Lỗi - UTESHOP-CPL");
            request.setAttribute("view", "/WEB-INF/views/guest/home.jsp");
            request.getRequestDispatcher("/WEB-INF/decorators/main.jsp").forward(request, response);
        }
    }

    /**
     * Set role-based content for authenticated users
     */
    private void setRoleBasedContent(HttpServletRequest request, User user) {
        Integer roleId = user.getRoleId();
        
        // Role display names based on Enums.UserRole
        String roleDisplayName;
        switch (roleId) {
            case 1: // GUEST
                roleDisplayName = "Khách";
                break;
            case 2: // USER  
                roleDisplayName = "Khách hàng";
                break;
            case 3: // VENDOR
                roleDisplayName = "Người bán";
                break;
            case 4: // ADMIN
                roleDisplayName = "Quản trị viên";
                break;
            default:
                roleDisplayName = "Khách";
        }
        
        request.setAttribute("userRoleDisplay", roleDisplayName);
        request.setAttribute("userRoleId", roleId);
        
        // Role-based permissions
        request.setAttribute("canAccessAdmin", roleId == 4);
        request.setAttribute("canAccessVendor", roleId == 3 || roleId == 4);
        request.setAttribute("canAccessUser", roleId >= 2);
        
        // Welcome message
        String welcomeMessage;
        switch (roleId) {
            case 4:
                welcomeMessage = "Chào mừng Quản trị viên " + user.getFullName() + "!";
                request.setAttribute("dashboardTitle", "Bảng điều khiển Quản trị");
                break;
            case 3:
                welcomeMessage = "Chào mừng Người bán " + user.getFullName() + "!";
                request.setAttribute("dashboardTitle", "Bảng điều khiển Bán hàng");
                break;
            case 2:
                welcomeMessage = "Chào mừng " + user.getFullName() + " đến với UTESHOP-CPL!";
                request.setAttribute("dashboardTitle", "Tài khoản của tôi");
                break;
            default:
                welcomeMessage = "Chào mừng " + user.getFullName() + "!";
                request.setAttribute("dashboardTitle", "Bảng điều khiển");
        }
        
        request.setAttribute("welcomeMessage", welcomeMessage);
        
        System.out.println("🎭 Role-based content set for: " + roleDisplayName + " (ID: " + roleId + ")");
        System.out.println("💬 Welcome message: " + welcomeMessage);
    }

    /**
     * Set content for guest/anonymous users
     */
    private void setGuestContent(HttpServletRequest request) {
        request.setAttribute("userRoleDisplay", "Khách");
        request.setAttribute("userRoleId", 1);
        request.setAttribute("canAccessAdmin", false);
        request.setAttribute("canAccessVendor", false);
        request.setAttribute("canAccessUser", false);
        request.setAttribute("welcomeMessage", "Chào mừng đến với UTESHOP-CPL!");
        request.setAttribute("dashboardTitle", "Khám phá sản phẩm");
        
        // Promotional content for guests
        request.setAttribute("showPromotion", true);
        request.setAttribute("promotionTitle", "Đăng ký ngay để nhận ưu đãi!");
        request.setAttribute("promotionMessage", "Tham gia UTESHOP-CPL để khám phá hàng nghìn sản phẩm chất lượng");
        
        System.out.println("🌐 Guest content set for anonymous user");
    }

    @Override
    public void destroy() {
        System.out.println("🗑️ HomeController destroying...");
        System.out.println("👋 HomeController destroyed at: 2025-10-21 00:28:23 UTC");
        super.destroy();
    }
}
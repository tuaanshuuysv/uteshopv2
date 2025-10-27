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
import vn.ute.uteshop.services.VendorService;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * VendorController - COMPLETE WITH REAL DATABASE INTEGRATION Updated:
 * 2025-10-26 16:57:23 UTC by tuaanshuuysv Features: Complete vendor shop
 * management with real database data
 */
@WebServlet(urlPatterns = { "/vendor", "/vendor/", "/vendor/dashboard", "/vendor/products", "/vendor/vendor-orders",
		"/vendor/promotions", "/vendor/revenue", "/vendor/shop-profile", "/vendor/setup" })
public class VendorController extends HttpServlet {

	private UserDao userDao;
	private VendorService vendorService;

	@Override
	public void init() throws ServletException {
		try {
			userDao = new UserDaoImpl();
			vendorService = new VendorService();
			System.out.println("✅ VendorController COMPLETE WITH REAL DATA initialized successfully");
			System.out.println("🕐 Updated: 2025-10-26 16:57:23 UTC");
			System.out.println("👨‍💻 Updated by: tuaanshuuysv");
			System.out.println("🔧 Features: Complete vendor shop management with real database data");
		} catch (Exception e) {
			System.err.println("❌ Error initializing VendorController: " + e.getMessage());
			e.printStackTrace();
		}
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String path = getRequestPath(request);
		System.out.println("🔄 VendorController GET: " + path + " at " + LocalDateTime.now());

		try {
			User authUser = getAuthenticatedUser(request);
			if (authUser == null || authUser.getRoleId() != 3) {
				System.out.println("⛔ Access denied for vendor path: " + path + " - User role: "
						+ (authUser != null ? authUser.getRoleId() : "null"));
				response.sendRedirect(request.getContextPath() + "/auth/login?error=access_denied");
				return;
			}

			setCommonAttributes(request, authUser);

			switch (path) {
			case "/vendor":
			case "/vendor/":
			case "/vendor/dashboard":
				handleDashboard(request, response, authUser);
				break;
			case "/vendor/products":
				handleProducts(request, response, authUser);
				break;
			case "/vendor/vendor-orders":
				handleOrders(request, response, authUser);
				break;
			case "/vendor/promotions":
				handlePromotions(request, response, authUser);
				break;
			case "/vendor/revenue":
				handleRevenue(request, response, authUser);
				break;
			case "/vendor/shop-profile":
				handleShopProfile(request, response, authUser);
				break;
			case "/vendor/setup":
				handleShopSetup(request, response, authUser);
				break;
			default:
				System.out.println("⚠️ Unknown vendor path: " + path + " - redirecting to dashboard");
				response.sendRedirect(request.getContextPath() + "/vendor/dashboard");
			}

		} catch (Exception e) {
			System.err.println("❌ Error in VendorController: " + e.getMessage());
			e.printStackTrace();
			request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
			request.setAttribute("authUser", getAuthenticatedUser(request));
			// Tiếp tục từ dòng cuối cùng...

			request.setAttribute("currentDateTime", LocalDateTime.now());
			request.getRequestDispatcher("/WEB-INF/views/vendor/home.jsp").forward(request, response);
		}
	}

	/**
	 * Handle Vendor Dashboard - WITH REAL DATA
	 */
	private void handleDashboard(HttpServletRequest request, HttpServletResponse response, User authUser)
			throws ServletException, IOException {

		System.out.println("🏪 Loading REAL vendor dashboard for: " + authUser.getEmail());

		try {
			// Get REAL vendor's shop from database
			Map<String, Object> vendorShop = vendorService.getVendorShop(authUser.getUserId());
			request.setAttribute("vendorShop", vendorShop);

			if (vendorShop != null && vendorShop.get("shop_id") != null) {
				int shopId = (Integer) vendorShop.get("shop_id");

				// Load REAL shop statistics from database
				Map<String, Object> vendorStats = vendorService.getShopStats(shopId);
				request.setAttribute("vendorStats", vendorStats);

				// Load REAL recent orders from database
				List<Map<String, Object>> recentOrders = vendorService.getRecentOrders(shopId, 10);
				request.setAttribute("vendorRecentOrders", recentOrders);

				// Load REAL low stock products from database
				List<Map<String, Object>> lowStockProducts = vendorService.getLowStockProducts(shopId, 10);
				request.setAttribute("lowStockProducts", lowStockProducts);

				System.out.println("✅ REAL vendor dashboard data loaded for shop: " + vendorShop.get("shop_name"));
				System.out.println("📊 Stats loaded: " + vendorStats.size() + " metrics");
				System.out.println("📋 Recent orders: " + recentOrders.size() + " orders");
				System.out.println("⚠️ Low stock products: " + lowStockProducts.size() + " products");

			} else {
				System.out.println("ℹ️ Vendor has no shop yet, redirecting to setup");
				response.sendRedirect(request.getContextPath() + "/vendor/setup");
				return;
			}

		} catch (Exception e) {
			System.err.println("⚠️ Error loading REAL vendor dashboard data: " + e.getMessage());
			e.printStackTrace();
			// Set fallback data
			request.setAttribute("vendorShop", createDummyVendorShop());
			request.setAttribute("vendorStats", createDummyVendorStats());
			request.setAttribute("vendorRecentOrders", createDummyRecentOrders());
			request.setAttribute("lowStockProducts", createDummyLowStockProducts());
			request.setAttribute("error", "Một số dữ liệu không thể tải từ database: " + e.getMessage());
		}

		request.setAttribute("pageTitle", "UTESHOP Vendor - Dashboard");
		request.setAttribute("currentPage", "dashboard");

		request.getRequestDispatcher("/WEB-INF/views/vendor/home.jsp").forward(request, response);
	}

	/**
	 * Handle Products Management - WITH REAL DATA
	 */
	private void handleProducts(HttpServletRequest request, HttpServletResponse response, User authUser)
			throws ServletException, IOException {

		System.out.println("📦 Loading REAL products management for: " + authUser.getEmail());

		try {
			// Get REAL vendor's shop from database
			Map<String, Object> vendorShop = vendorService.getVendorShop(authUser.getUserId());
			request.setAttribute("vendorShop", vendorShop);

			if (vendorShop != null && vendorShop.get("shop_id") != null) {
				int shopId = (Integer) vendorShop.get("shop_id");

				// Get filter parameters
				String filter = request.getParameter("filter");
				String search = request.getParameter("search");
				int page = getIntParameter(request, "page", 1);

				// Load REAL shop products from database
				List<Map<String, Object>> products = vendorService.getShopProducts(shopId, 100);

				// Apply client-side filters (can be moved to database later)
				if ("low_stock".equals(filter)) {
					products = products.stream().filter(p -> (Integer) p.get("stock_quantity") < 10).toList();
				} else if ("out_of_stock".equals(filter)) {
					products = products.stream().filter(p -> (Integer) p.get("stock_quantity") == 0).toList();
				} else if ("active".equals(filter)) {
					products = products.stream().filter(p -> "ACTIVE".equals(p.get("status"))).toList();
				}

				if (search != null && !search.trim().isEmpty()) {
					String searchLower = search.toLowerCase();
					products = products.stream()
							.filter(p -> ((String) p.get("product_name")).toLowerCase().contains(searchLower)).toList();
				}

				request.setAttribute("products", products);
				request.setAttribute("currentFilter", filter);
				request.setAttribute("searchQuery", search);

				// Calculate product statistics
				Map<String, Object> productStats = calculateProductStats(products, shopId);
				request.setAttribute("productStats", productStats);

				System.out.println("✅ REAL products loaded: " + products.size() + " products");

			} else {
				System.out.println("ℹ️ Vendor has no shop, redirecting to setup");
				response.sendRedirect(request.getContextPath() + "/vendor/setup");
				return;
			}

		} catch (Exception e) {
			System.err.println("⚠️ Error loading REAL products: " + e.getMessage());
			e.printStackTrace();
			request.setAttribute("vendorShop", createDummyVendorShop());
			request.setAttribute("products", createDummyProducts());
			request.setAttribute("productStats", createDummyProductStats());
			request.setAttribute("error", "Không thể tải dữ liệu sản phẩm từ database: " + e.getMessage());
		}

		request.setAttribute("pageTitle", "UTESHOP Vendor - Quản lý sản phẩm");
		request.setAttribute("currentPage", "products");

		request.getRequestDispatcher("/WEB-INF/views/vendor/products.jsp").forward(request, response);
	}

	/**
	 * Handle Orders Management - WITH REAL DATA
	 */
	private void handleOrders(HttpServletRequest request, HttpServletResponse response, User authUser)
			throws ServletException, IOException {

		System.out.println("🛒 Loading REAL vendor shop orders for: " + authUser.getEmail());

		try {
			// Get REAL vendor's shop from database
			Map<String, Object> vendorShop = vendorService.getVendorShop(authUser.getUserId());
			request.setAttribute("vendorShop", vendorShop);

			if (vendorShop != null && vendorShop.get("shop_id") != null) {
				int shopId = (Integer) vendorShop.get("shop_id");

				// Get filter parameters
				String status = request.getParameter("status");
				String search = request.getParameter("search");
				String dateFrom = request.getParameter("date_from");
				String dateTo = request.getParameter("date_to");
				int page = getIntParameter(request, "page", 1);

				// Load REAL orders from database
				List<Map<String, Object>> orders = vendorService.getRecentOrders(shopId, 100);

				// Apply client-side filters (can be moved to database later)
				if (status != null && !status.isEmpty()) {
					orders = orders.stream().filter(o -> status.equalsIgnoreCase((String) o.get("order_status")))
							.toList();
				}

				if (search != null && !search.trim().isEmpty()) {
					String searchLower = search.toLowerCase();
					orders = orders.stream()
							.filter(o -> ((String) o.get("order_number")).toLowerCase().contains(searchLower)
									|| ((String) o.get("customer_name")).toLowerCase().contains(searchLower))
							.toList();
				}

				request.setAttribute("orders", orders);
				request.setAttribute("currentStatus", status);
				request.setAttribute("searchQuery", search);
				request.setAttribute("dateFrom", dateFrom);
				request.setAttribute("dateTo", dateTo);

				// Calculate order statistics
				Map<String, Object> orderStats = calculateOrderStats(orders);
				request.setAttribute("orderStats", orderStats);

				System.out.println("✅ REAL shop orders loaded: " + orders.size() + " orders");

			} else {
				System.out.println("ℹ️ Vendor has no shop, redirecting to setup");
				response.sendRedirect(request.getContextPath() + "/vendor/setup");
				return;
			}

		} catch (Exception e) {
			System.err.println("⚠️ Error loading REAL shop orders: " + e.getMessage());
			e.printStackTrace();
			request.setAttribute("vendorShop", createDummyVendorShop());
			request.setAttribute("orders", createDummyShopOrders());
			request.setAttribute("orderStats", createDummyShopOrderStats());
			request.setAttribute("error", "Không thể tải dữ liệu đơn hàng từ database: " + e.getMessage());
		}

		request.setAttribute("pageTitle", "UTESHOP Vendor - Quản lý đơn hàng shop");
		request.setAttribute("currentPage", "vendor-orders");

		request.getRequestDispatcher("/WEB-INF/views/vendor/orders.jsp").forward(request, response);
	}

	/**
	 * Handle Promotions Management - WITH DUMMY DATA (TO BE IMPLEMENTED)
	 */
	private void handlePromotions(HttpServletRequest request, HttpServletResponse response, User authUser)
			throws ServletException, IOException {

		System.out.println("🏷️ Loading promotions management for: " + authUser.getEmail());

		try {
			// Get vendor's shop
			Map<String, Object> vendorShop = vendorService.getVendorShop(authUser.getUserId());
			request.setAttribute("vendorShop", vendorShop);

			if (vendorShop != null && vendorShop.get("shop_id") != null) {
				// TODO: Implement real promotions from database
				// For now, use dummy data
				List<Map<String, Object>> promotions = createDummyPromotions();
				request.setAttribute("promotions", promotions);

				Map<String, Object> promotionStats = calculatePromotionStats(promotions);
				request.setAttribute("promotionStats", promotionStats);

				System.out.println("✅ Promotions loaded: " + promotions.size() + " promotions (dummy data)");

			} else {
				response.sendRedirect(request.getContextPath() + "/vendor/setup");
				return;
			}

		} catch (Exception e) {
			System.err.println("⚠️ Error loading promotions: " + e.getMessage());
			e.printStackTrace();
			request.setAttribute("vendorShop", createDummyVendorShop());
			request.setAttribute("promotions", new ArrayList<>());
			request.setAttribute("promotionStats", new HashMap<>());
			request.setAttribute("error", "Không thể tải dữ liệu khuyến mãi: " + e.getMessage());
		}

		request.setAttribute("pageTitle", "UTESHOP Vendor - Quản lý khuyến mãi");
		request.setAttribute("currentPage", "promotions");

		request.getRequestDispatcher("/WEB-INF/views/vendor/promotions.jsp").forward(request, response);
	}

	/**
	 * Handle Revenue Reports - WITH REAL DATA
	 */
	private void handleRevenue(HttpServletRequest request, HttpServletResponse response, User authUser)
			throws ServletException, IOException {

		System.out.println("📊 Loading REAL revenue reports for: " + authUser.getEmail());

		try {
			// Get vendor's shop
			Map<String, Object> vendorShop = vendorService.getVendorShop(authUser.getUserId());
			request.setAttribute("vendorShop", vendorShop);

			if (vendorShop != null && vendorShop.get("shop_id") != null) {
				int shopId = (Integer) vendorShop.get("shop_id");

				// Load REAL revenue data from orders
				List<Map<String, Object>> revenueData = generateRevenueData(shopId);
				request.setAttribute("revenueData", revenueData);

				Map<String, Object> revenueStats = calculateRevenueStats(revenueData);
				request.setAttribute("revenueStats", revenueStats);

				System.out.println("✅ REAL revenue data loaded: " + revenueData.size() + " data points");

			} else {
				response.sendRedirect(request.getContextPath() + "/vendor/setup");
				return;
			}

		} catch (Exception e) {
			System.err.println("⚠️ Error loading REAL revenue data: " + e.getMessage());
			e.printStackTrace();
			request.setAttribute("vendorShop", createDummyVendorShop());
			request.setAttribute("revenueData", createDummyRevenueData());
			request.setAttribute("revenueStats", createDummyRevenueStats());
			request.setAttribute("error", "Không thể tải dữ liệu doanh thu từ database: " + e.getMessage());
		}

		request.setAttribute("pageTitle", "UTESHOP Vendor - Báo cáo doanh thu");
		request.setAttribute("currentPage", "revenue");

		request.getRequestDispatcher("/WEB-INF/views/vendor/revenue.jsp").forward(request, response);
	}

	/**
	 * Handle Shop Profile Settings - WITH REAL DATA
	 */
	private void handleShopProfile(HttpServletRequest request, HttpServletResponse response, User authUser)
			throws ServletException, IOException {

		System.out.println("⚙️ Loading REAL shop profile for: " + authUser.getEmail());

		try {
			// Get REAL vendor's shop from database
			Map<String, Object> vendorShop = vendorService.getVendorShop(authUser.getUserId());
			request.setAttribute("vendorShop", vendorShop);

			if (vendorShop != null && vendorShop.get("shop_id") != null) {
				System.out.println("✅ REAL shop profile loaded: " + vendorShop.get("shop_name"));
			} else {
				System.out.println("ℹ️ Vendor has no shop, redirecting to setup");
				response.sendRedirect(request.getContextPath() + "/vendor/setup");
				return;
			}

		} catch (Exception e) {
			System.err.println("⚠️ Error loading REAL shop profile: " + e.getMessage());
			e.printStackTrace();
			request.setAttribute("vendorShop", createDummyVendorShop());
			request.setAttribute("error", "Không thể tải thông tin shop từ database: " + e.getMessage());
		}

		request.setAttribute("pageTitle", "UTESHOP Vendor - Cài đặt Shop");
		request.setAttribute("currentPage", "shop-profile");

		request.getRequestDispatcher("/WEB-INF/views/vendor/shop-profile.jsp").forward(request, response);
	}

	/**
	 * Handle Shop Setup (for new vendors)
	 */
	private void handleShopSetup(HttpServletRequest request, HttpServletResponse response, User authUser)
			throws ServletException, IOException {

		System.out.println("🚀 Loading shop setup for: " + authUser.getEmail());

		// Check if vendor already has a shop
		try {
			Map<String, Object> existingShop = vendorService.getVendorShop(authUser.getUserId());
			if (existingShop != null) {
				System.out.println("ℹ️ Vendor already has a shop, redirecting to dashboard");
				response.sendRedirect(request.getContextPath() + "/vendor/dashboard");
				return;
			}
		} catch (Exception e) {
			System.err.println("⚠️ Error checking existing shop: " + e.getMessage());
		}

		request.setAttribute("pageTitle", "UTESHOP Vendor - Thiết lập Shop");
		request.setAttribute("currentPage", "setup");

		request.getRequestDispatcher("/WEB-INF/views/vendor/setup.jsp").forward(request, response);
	}

	// ============================================================================
	// CALCULATION AND UTILITY METHODS
	// ============================================================================

	/**
	 * Calculate product statistics from real data
	 */
	private Map<String, Object> calculateProductStats(List<Map<String, Object>> products, int shopId) throws Exception {
		Map<String, Object> stats = new HashMap<>();

		if (products != null && !products.isEmpty()) {
			stats.put("total_products", products.size());
			stats.put("active_products",
					products.stream().mapToInt(p -> "ACTIVE".equals(p.get("status")) ? 1 : 0).sum());
			stats.put("low_stock_products",
					products.stream().mapToInt(p -> (Integer) p.get("stock_quantity") < 10 ? 1 : 0).sum());
			stats.put("out_of_stock_products",
					products.stream().mapToInt(p -> (Integer) p.get("stock_quantity") == 0 ? 1 : 0).sum());
		} else {
			// Get real stats from VendorService
			Map<String, Object> realStats = vendorService.getShopStats(shopId);
			stats.put("total_products", realStats.get("total_products"));
			stats.put("active_products", realStats.get("in_stock_products"));
			stats.put("low_stock_products", realStats.get("low_stock_products"));
			stats.put("out_of_stock_products", 0);
		}

		return stats;
	}

	/**
	 * Calculate order statistics from real data
	 */
	private Map<String, Object> calculateOrderStats(List<Map<String, Object>> orders) {
		Map<String, Object> stats = new HashMap<>();

		if (orders != null && !orders.isEmpty()) {
			stats.put("total_orders", orders.size());
			stats.put("new_orders", orders.stream().mapToInt(o -> "NEW".equals(o.get("order_status")) ? 1 : 0).sum());
			stats.put("processing_orders",
					orders.stream().mapToInt(o -> "PROCESSING".equals(o.get("order_status")) ? 1 : 0).sum());
			stats.put("shipped_orders",
					orders.stream().mapToInt(o -> "SHIPPING".equals(o.get("order_status")) ? 1 : 0).sum());
			stats.put("delivered_orders",
					orders.stream().mapToInt(o -> "DELIVERED".equals(o.get("order_status")) ? 1 : 0).sum());
			stats.put("cancelled_orders",
					orders.stream().mapToInt(o -> "CANCELLED".equals(o.get("order_status")) ? 1 : 0).sum());

			// Calculate revenue from order amounts (remove currency formatting first)
			double totalRevenue = orders.stream().mapToDouble(o -> {
				String amount = (String) o.get("total_amount");
				return Double.parseDouble(amount.replace(",", "").replace("₫", ""));
			}).sum();

			stats.put("total_revenue", formatCurrency(totalRevenue));
			stats.put("avg_order_value", formatCurrency(totalRevenue / Math.max(orders.size(), 1)));
		} else {
			stats.put("total_orders", 0);
			stats.put("new_orders", 0);
			stats.put("processing_orders", 0);
			stats.put("shipped_orders", 0);
			stats.put("delivered_orders", 0);
			stats.put("cancelled_orders", 0);
			stats.put("total_revenue", formatCurrency(0));
			stats.put("avg_order_value", formatCurrency(0));
		}

		return stats;
	}

	/**
	 * Generate revenue data from real orders
	 */
	private List<Map<String, Object>> generateRevenueData(int shopId) throws Exception {
		List<Map<String, Object>> revenueData = new ArrayList<>();

		// Get orders from the last 7 days
		List<Map<String, Object>> recentOrders = vendorService.getRecentOrders(shopId, 100);

		// Group by date and calculate daily revenue
		Map<String, Double> dailyRevenue = new HashMap<>();
		Map<String, Integer> dailyOrderCount = new HashMap<>();

		for (Map<String, Object> order : recentOrders) {
			// Extract date from order creation timestamp
			String orderDate = order.get("created_at").toString().substring(0, 10); // YYYY-MM-DD

			// Parse revenue amount
			String amountStr = (String) order.get("total_amount");
			double amount = Double.parseDouble(amountStr.replace(",", "").replace("₫", ""));

			dailyRevenue.merge(orderDate, amount, Double::sum);
			dailyOrderCount.merge(orderDate, 1, Integer::sum);
		}

		// Convert to list format for chart
		for (Map.Entry<String, Double> entry : dailyRevenue.entrySet()) {
			Map<String, Object> data = new HashMap<>();
			String date = entry.getKey();
			data.put("date", date.substring(5)); // MM-DD format
			data.put("revenue", entry.getValue());
			data.put("formatted_revenue", formatCurrency(entry.getValue()));
			data.put("order_count", dailyOrderCount.getOrDefault(date, 0));
			revenueData.add(data);
		}

		// Sort by date descending
		revenueData.sort((a, b) -> ((String) b.get("date")).compareTo((String) a.get("date")));

		return revenueData;
	}

	/**
	 * Calculate revenue statistics
	 */
	private Map<String, Object> calculateRevenueStats(List<Map<String, Object>> revenueData) {
		Map<String, Object> stats = new HashMap<>();

		if (revenueData != null && !revenueData.isEmpty()) {
			double totalRevenue = revenueData.stream().mapToDouble(r -> (Double) r.get("revenue")).sum();
			int totalOrders = revenueData.stream().mapToInt(r -> (Integer) r.get("order_count")).sum();

			stats.put("total_revenue", formatCurrency(totalRevenue));
			stats.put("total_orders", totalOrders);
			stats.put("average_order_value", formatCurrency(totalRevenue / Math.max(totalOrders, 1)));
			stats.put("days_count", revenueData.size());

			// Get highest revenue day
			revenueData.stream().max(Comparator.comparing(r -> (Double) r.get("revenue"))).ifPresent(bestDay -> {
				stats.put("best_day", bestDay.get("date"));
				stats.put("best_day_revenue", bestDay.get("formatted_revenue"));
			});
		} else {
			stats.put("total_revenue", formatCurrency(0));
			stats.put("total_orders", 0);
			stats.put("average_order_value", formatCurrency(0));
			stats.put("days_count", 0);
		}

		return stats;
	}

	/**
	 * Calculate promotion statistics (dummy for now)
	 */
	private Map<String, Object> calculatePromotionStats(List<Map<String, Object>> promotions) {
		Map<String, Object> stats = new HashMap<>();

		if (promotions != null && !promotions.isEmpty()) {
			stats.put("total_promotions", promotions.size());
			stats.put("active_promotions",
					promotions.stream().mapToInt(p -> "ACTIVE".equals(p.get("status")) ? 1 : 0).sum());
			stats.put("scheduled_promotions",
					promotions.stream().mapToInt(p -> "SCHEDULED".equals(p.get("status")) ? 1 : 0).sum());
			stats.put("expired_promotions",
					promotions.stream().mapToInt(p -> "EXPIRED".equals(p.get("status")) ? 1 : 0).sum());
		} else {
			stats.put("total_promotions", 0);
			stats.put("active_promotions", 0);
			stats.put("scheduled_promotions", 0);
			stats.put("expired_promotions", 0);
		}

		return stats;
	}

	// ============================================================================
	// FALLBACK DUMMY DATA METHODS (IF DATABASE FAILS)
	// ============================================================================

	private Map<String, Object> createDummyVendorShop() {
		Map<String, Object> shop = new HashMap<>();
		shop.put("shop_id", 3);
		shop.put("shop_name", "KhoiTech Store");
		shop.put("shop_description", "Chuyên cung cấp thiết bị công nghệ cao cấp");
		shop.put("shop_logo", "/assets/images/shops/khoitech.jpg");
		shop.put("total_rating", 5.0);
		shop.put("total_reviews", 1);
		shop.put("is_verified", true);
		shop.put("product_count", 10);
		shop.put("created_at", LocalDateTime.of(2025, 1, 11, 9, 0));
		return shop;
	}

	private Map<String, Object> createDummyVendorStats() {
		Map<String, Object> stats = new HashMap<>();
		stats.put("total_products", 10);
		stats.put("in_stock_products", 9);
		stats.put("low_stock_products", 1);
		stats.put("total_orders", 1);
		stats.put("pending_orders", 0);
		stats.put("total_revenue", "12,540,000₫");
		stats.put("revenue_today", "0₫");
		return stats;
	}

	private List<Map<String, Object>> createDummyRecentOrders() {
		List<Map<String, Object>> orders = new ArrayList<>();

		Map<String, Object> order1 = new HashMap<>();
		order1.put("order_id", 1);
		order1.put("order_number", "ORD20250301001");
		order1.put("customer_name", "Nguyễn Văn Nam");
		order1.put("total_amount", "12,540,000₫");
		order1.put("order_status", "DELIVERED");
		order1.put("payment_method", "VNPAY");
		order1.put("item_count", 1);
		order1.put("created_at", LocalDateTime.of(2025, 3, 15, 10, 30));
		orders.add(order1);

		return orders;
	}

	private List<Map<String, Object>> createDummyLowStockProducts() {
		List<Map<String, Object>> products = new ArrayList<>();

		Map<String, Object> product1 = new HashMap<>();
		product1.put("product_id", 8);
		product1.put("product_name", "Xbox Series X");
		product1.put("stock_quantity", 12);
		product1.put("min_stock_level", 15);
		product1.put("image_url", "/assets/images/products/xbox.jpg");
		products.add(product1);

		return products;
	}

	private List<Map<String, Object>> createDummyProducts() {
		List<Map<String, Object>> products = new ArrayList<>();

		String[][] productData = { { "4", "PlayStation 5 Console", "12,990,000₫", "15", "ACTIVE", "1" },
				{ "5", "Xbox Series X", "11,990,000₫", "12", "ACTIVE", "0" },
				{ "6", "Gaming Chair DXRacer", "7,990,000₫", "20", "ACTIVE", "0" },
				{ "7", "Logitech G Pro X Superlight", "2,990,000₫", "50", "ACTIVE", "0" },
				{ "8", "Razer BlackWidow V3", "3,790,000₫", "30", "ACTIVE", "0" } };

		for (String[] data : productData) {
			Map<String, Object> product = new HashMap<>();
			product.put("product_id", Integer.parseInt(data[0]));
			product.put("product_name", data[1]);
			product.put("formatted_price", data[2]);
			product.put("stock_quantity", Integer.parseInt(data[3]));
			product.put("status", data[4]);
			product.put("total_sold", Integer.parseInt(data[5]));
			product.put("image_url", "/assets/images/products/product" + data[0] + ".jpg");
			product.put("created_at", LocalDateTime.of(2025, 2, Integer.parseInt(data[0]), 10, 0));
			products.add(product);
		}

		return products;
	}

	private List<Map<String, Object>> createDummyShopOrders() {
		List<Map<String, Object>> orders = new ArrayList<>();

		Map<String, Object> order1 = new HashMap<>();
		order1.put("order_id", 1);
		order1.put("order_number", "ORD20250301001");
		order1.put("customer_name", "Nguyễn Văn Nam");
		order1.put("total_amount", "12,540,000₫");
		order1.put("order_status", "DELIVERED");
		order1.put("payment_method", "VNPAY");
		order1.put("item_count", 1);
		order1.put("created_at", LocalDateTime.of(2025, 3, 15, 10, 30));
		orders.add(order1);

		return orders;
	}

	private List<Map<String, Object>> createDummyPromotions() {
		List<Map<String, Object>> promotions = new ArrayList<>();

		String[][] promotionData = { { "Flash Sale Gaming", "GAMING20", "20", "ACTIVE" },
				{ "Khuyến mãi cuối năm", "ENDYEAR25", "25", "SCHEDULED" } };

		for (String[] data : promotionData) {
			Map<String, Object> promotion = new HashMap<>();
			promotion.put("promotion_name", data[0]);
			promotion.put("promotion_code", data[1]);
			promotion.put("discount_percent", Integer.parseInt(data[2]));
			promotion.put("status", data[3]);
			promotions.add(promotion);
		}

		return promotions;
	}

	private List<Map<String, Object>> createDummyRevenueData() {
		List<Map<String, Object>> revenueData = new ArrayList<>();

		String[] dates = { "03-15" };
		double[] revenues = { 12540000 };
		int[] orders = { 1 };

		for (int i = 0; i < dates.length; i++) {
			Map<String, Object> data = new HashMap<>();
			data.put("date", dates[i]);
			data.put("revenue", revenues[i]);
			data.put("formatted_revenue", formatCurrency(revenues[i]));
			data.put("order_count", orders[i]);
			revenueData.add(data);
		}

		return revenueData;
	}

	private Map<String, Object> createDummyProductStats() {
		Map<String, Object> stats = new HashMap<>();
		stats.put("total_products", 10);
		stats.put("active_products", 9);
		stats.put("low_stock_products", 1);
		stats.put("out_of_stock_products", 0);
		return stats;
	}

	private Map<String, Object> createDummyShopOrderStats() {
		Map<String, Object> stats = new HashMap<>();
		stats.put("total_orders", 1);
		stats.put("new_orders", 0);
		stats.put("processing_orders", 0);
		stats.put("shipped_orders", 0);
		stats.put("delivered_orders", 1);
		stats.put("cancelled_orders", 0);
		stats.put("total_revenue", "12,540,000₫");
		stats.put("avg_order_value", "12,540,000₫");
		return stats;
	}

	private Map<String, Object> createDummyRevenueStats() {
		Map<String, Object> stats = new HashMap<>();
		stats.put("total_revenue", "12,540,000₫");
		stats.put("total_orders", 1);
		stats.put("average_order_value", "12,540,000₫");
		stats.put("days_count", 1);
		stats.put("best_day", "03-15");
		stats.put("best_day_revenue", "12,540,000₫");
		return stats;
	}

	// ============================================================================
	// UTILITY METHODS
	// ============================================================================

	private String getRequestPath(HttpServletRequest request) {
		String path = request.getRequestURI();
		String contextPath = request.getContextPath();

		if (path.startsWith(contextPath)) {
			path = path.substring(contextPath.length());
		}

		return path;
	}

	private User getAuthenticatedUser(HttpServletRequest request) {
		try {
			HttpSession session = request.getSession(false);
			if (session == null)
				return null;

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
		request.setAttribute("userRoleDisplay", user != null ? "Vendor" : "Guest");
		request.setAttribute("currentDateTime", LocalDateTime.now());
		request.setAttribute("serverTime",
				LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss")));
	}

	private int getIntParameter(HttpServletRequest request, String paramName, int defaultValue) {
		try {
			String paramValue = request.getParameter(paramName);
			return paramValue != null ? Integer.parseInt(paramValue) : defaultValue;
		} catch (NumberFormatException e) {
			return defaultValue;
		}
	}

	private String formatCurrency(double amount) {
		return String.format("%,.0f₫", amount);
	}

	@Override
	public void destroy() {
		System.out.println("🗑️ VendorController WITH REAL DATA destroyed at: " + LocalDateTime.now());
		super.destroy();
	}
}
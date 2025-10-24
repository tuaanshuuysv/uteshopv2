package vn.ute.uteshop.dao;

import vn.ute.uteshop.model.User;
import java.util.Map;

/**
 * UserProfileDao - Get real profile data from database
 * Created: 2025-10-23 06:52:00 UTC by tuaanshuuysv
 */
public interface UserProfileDao {
    
    /**
     * Get user statistics (orders, spending, etc.)
     */
    Map<String, Object> getUserStatistics(Integer userId);
    
    /**
     * Get vendor/shop statistics
     */
    Map<String, Object> getVendorStatistics(Integer userId);
    
    /**
     * Get admin/system statistics
     */
    Map<String, Object> getAdminStatistics();
    
    /**
     * Get user activity logs
     */
    Map<String, Object> getUserActivity(Integer userId);
}
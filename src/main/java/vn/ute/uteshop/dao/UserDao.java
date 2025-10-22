package vn.ute.uteshop.dao;

import vn.ute.uteshop.model.User;
import java.util.List;

/**
 * UserDao - Enhanced for User Management
 * Updated: 2025-10-21 21:02:56 UTC by tuaanshuuysv
 * Added: Missing methods for admin user management features
 */
public interface UserDao {
    // ===== EXISTING METHODS (giữ nguyên) =====
    User findById(Integer id);
    User findByEmail(String email);
    User findByUsername(String username);
    Integer save(User user);
    boolean update(User user);
    boolean updatePassword(Integer userId, String passwordHash, String salt);
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);
    
    // ===== NEW METHODS FOR USER MANAGEMENT =====
    
    /**
     * Find all users
     * @return List of all users
     */
    List<User> findAll();
    
    /**
     * Delete user by ID
     * @param userId User ID to delete
     * @return true if successful, false otherwise
     */
    boolean delete(Integer userId);
    
    /**
     * Find users with pagination
     * @param offset Starting position
     * @param limit Maximum number of users to return
     * @return List of users
     */
    List<User> findWithPagination(int offset, int limit);
    
    /**
     * Count total users
     * @return Total number of users
     */
    int countAll();
    
    /**
     * Find users by role ID
     * @param roleId Role ID to filter
     * @return List of users with specified role
     */
    List<User> findByRole(Integer roleId);
    
    /**
     * Find users by active status
     * @param isActive Active status to filter
     * @return List of users with specified active status
     */
    List<User> findByActiveStatus(Boolean isActive);
    
    /**
     * Search users by keyword (email, username, fullName)
     * @param keyword Search keyword
     * @return List of matching users
     */
    List<User> searchByKeyword(String keyword);
    
    /**
     * Find users with filters
     * @param keyword Search keyword (optional)
     * @param roleId Role filter (optional)
     * @param isActive Status filter (optional)
     * @param offset Starting position
     * @param limit Maximum number of users
     * @return List of filtered users
     */
    List<User> findWithFilters(String keyword, Integer roleId, Boolean isActive, int offset, int limit);
    
    /**
     * Count users with filters
     * @param keyword Search keyword (optional)
     * @param roleId Role filter (optional)
     * @param isActive Status filter (optional)
     * @return Number of matching users
     */
    int countWithFilters(String keyword, Integer roleId, Boolean isActive);
    
    /**
     * Update last login time
     * @param userId User ID
     * @return true if successful
     */
    boolean updateLastLogin(Integer userId);
}
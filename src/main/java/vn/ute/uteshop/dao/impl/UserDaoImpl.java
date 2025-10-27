package vn.ute.uteshop.dao.impl;

import vn.ute.uteshop.dao.UserDao;
import vn.ute.uteshop.model.User;
import vn.ute.uteshop.config.DataSourceFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * UserDaoImpl - COMPLETELY FIXED VERSION
 * Updated: 2025-10-26 18:53:28 UTC by tuaanshuuysv
 * Fixed: Line 120 - setTimestamp(LocalDateTime) error
 */
public class UserDaoImpl implements UserDao {

    @Override
    public User findById(Integer id) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public User findByUsername(String username) {
        String sql = "SELECT * FROM users WHERE username = ?";
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public Integer save(User user) {
        String sql = "INSERT INTO users (username, email, password_hash, salt, full_name, phone, " +
                    "role_id, is_active, is_verified) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPasswordHash());
            stmt.setString(4, user.getSalt());
            stmt.setString(5, user.getFullName());
            stmt.setString(6, user.getPhone());
            stmt.setInt(7, user.getRoleId());
            stmt.setBoolean(8, user.getIsActive());
            stmt.setBoolean(9, user.getIsVerified());
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean update(User user) {
        String sql = "UPDATE users SET username = ?, email = ?, full_name = ?, phone = ?, " +
                    "is_active = ?, is_verified = ?, last_login = ?, updated_at = CURRENT_TIMESTAMP " +
                    "WHERE user_id = ?";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getPhone());
            stmt.setBoolean(5, user.getIsActive());
            stmt.setBoolean(6, user.getIsVerified());
            // FIXED: Line 120 - Use getLastLoginTimestamp() instead of getLastLogin()
            stmt.setTimestamp(7, user.getLastLoginTimestamp());
            stmt.setInt(8, user.getUserId());
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean updatePassword(Integer userId, String passwordHash, String salt) {
        String sql = "UPDATE users SET password_hash = ?, salt = ?, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, passwordHash);
            stmt.setString(2, salt);
            stmt.setInt(3, userId);
            
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean existsByUsername(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE username = ?";
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, username);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean existsByEmail(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<User> findAll() {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            
            System.out.println("✅ UserDao: Found " + users.size() + " users");
            
        } catch (SQLException e) {
            System.err.println("❌ UserDao: Error finding all users: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public boolean delete(Integer userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                System.out.println("✅ UserDao: User deleted successfully: ID " + userId);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ UserDao: Error deleting user: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public List<User> findWithPagination(int offset, int limit) {
        String sql = "SELECT * FROM users ORDER BY created_at DESC LIMIT ? OFFSET ?";
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, limit);
            stmt.setInt(2, offset);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            
            System.out.println("✅ UserDao: Found " + users.size() + " users with pagination (offset: " + offset + ", limit: " + limit + ")");
            
        } catch (SQLException e) {
            System.err.println("❌ UserDao: Error finding users with pagination: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM users";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("✅ UserDao: Total users count: " + count);
                return count;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ UserDao: Error counting users: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<User> findByRole(Integer roleId) {
        String sql = "SELECT * FROM users WHERE role_id = ? ORDER BY created_at DESC";
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, roleId);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            
            System.out.println("✅ UserDao: Found " + users.size() + " users with role ID: " + roleId);
            
        } catch (SQLException e) {
            System.err.println("❌ UserDao: Error finding users by role: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public List<User> findByActiveStatus(Boolean isActive) {
        String sql = "SELECT * FROM users WHERE is_active = ? ORDER BY created_at DESC";
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setBoolean(1, isActive);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            
            System.out.println("✅ UserDao: Found " + users.size() + " users with active status: " + isActive);
            
        } catch (SQLException e) {
            System.err.println("❌ UserDao: Error finding users by active status: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public List<User> searchByKeyword(String keyword) {
        String sql = "SELECT * FROM users WHERE email LIKE ? OR username LIKE ? OR full_name LIKE ? ORDER BY created_at DESC";
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            String searchPattern = "%" + keyword + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            
            System.out.println("✅ UserDao: Found " + users.size() + " users matching keyword: " + keyword);
            
        } catch (SQLException e) {
            System.err.println("❌ UserDao: Error searching users by keyword: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public List<User> findWithFilters(String keyword, Integer roleId, Boolean isActive, int offset, int limit) {
        StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE 1=1");
        List<Object> parameters = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (email LIKE ? OR username LIKE ? OR full_name LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }
        
        if (roleId != null) {
            sql.append(" AND role_id = ?");
            parameters.add(roleId);
        }
        
        if (isActive != null) {
            sql.append(" AND is_active = ?");
            parameters.add(isActive);
        }
        
        sql.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");
        parameters.add(limit);
        parameters.add(offset);
        
        List<User> users = new ArrayList<>();
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
            
            System.out.println("✅ UserDao: Found " + users.size() + " users with filters (keyword: " + keyword + ", roleId: " + roleId + ", isActive: " + isActive + ")");
            
        } catch (SQLException e) {
            System.err.println("❌ UserDao: Error finding users with filters: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    @Override
    public int countWithFilters(String keyword, Integer roleId, Boolean isActive) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users WHERE 1=1");
        List<Object> parameters = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (email LIKE ? OR username LIKE ? OR full_name LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            parameters.add(searchPattern);
            parameters.add(searchPattern);
            parameters.add(searchPattern);
        }
        
        if (roleId != null) {
            sql.append(" AND role_id = ?");
            parameters.add(roleId);
        }
        
        if (isActive != null) {
            sql.append(" AND is_active = ?");
            parameters.add(isActive);
        }
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < parameters.size(); i++) {
                stmt.setObject(i + 1, parameters.get(i));
            }
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("✅ UserDao: Count with filters: " + count);
                return count;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ UserDao: Error counting users with filters: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public boolean updateLastLogin(Integer userId) {
        String sql = "UPDATE users SET last_login = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP WHERE user_id = ?";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                System.out.println("✅ UserDao: Last login updated for user ID: " + userId);
                return true;
            }
            
        } catch (SQLException e) {
            System.err.println("❌ UserDao: Error updating last login: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    // FIXED: mapResultSetToUser with proper Timestamp handling
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setSalt(rs.getString("salt"));
        user.setFullName(rs.getString("full_name"));
        user.setPhone(rs.getString("phone"));
        user.setAvatar(rs.getString("avatar"));
        user.setDateOfBirth(rs.getDate("date_of_birth"));
        user.setGender(rs.getString("gender"));
        user.setRoleId(rs.getInt("role_id"));
        user.setIsActive(rs.getBoolean("is_active"));
        user.setIsVerified(rs.getBoolean("is_verified"));
        
        // FIXED: Use setCreatedAt(Timestamp) instead of LocalDateTime
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        user.setLastLogin(rs.getTimestamp("last_login"));
        
        return user;
    }
}
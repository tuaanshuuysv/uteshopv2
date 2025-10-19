package vn.ute.uteshop.dao.impl;

import vn.ute.uteshop.dao.OtpTokenDao;
import vn.ute.uteshop.model.OtpToken;
import vn.ute.uteshop.config.DataSourceFactory;

import java.sql.*;

/**
 * OtpTokenDaoImpl - Complete OTP Token Data Access Implementation
 * Created by tuaanshuuysv on 2025-10-19
 * Updated: 2025-10-19 23:34:58 UTC
 * Fixed: OTP expiry time calculation, recently used OTP support
 * Compatible with: Tomcat 10.x, Jakarta EE, MySQL 8.x
 */
public class OtpTokenDaoImpl implements OtpTokenDao {

    @Override
    public Integer save(OtpToken otpToken) {
        // ✅ FIX: Database calculates expiry time with DATE_ADD
        String sql = "INSERT INTO otp_codes (user_id, otp_code, otp_type, expires_at, is_used) " +
                    "VALUES (?, ?, ?, DATE_ADD(NOW(), INTERVAL 5 MINUTE), ?)";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, otpToken.getUserId());
            stmt.setString(2, otpToken.getOtpCode());
            stmt.setString(3, otpToken.getOtpType());
            stmt.setBoolean(4, false); // Always start as unused
            
            System.out.println("💾 Saving OTP with SQL-calculated expiry time");
            System.out.println("🔑 OTP Code: " + otpToken.getOtpCode());
            System.out.println("👤 User ID: " + otpToken.getUserId());
            System.out.println("🏷️ OTP Type: " + otpToken.getOtpType());
            System.out.println("🕐 Current UTC: 2025-10-19 23:34:58");
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                ResultSet generatedKeys = stmt.getGeneratedKeys();
                if (generatedKeys.next()) {
                    Integer otpId = generatedKeys.getInt(1);
                    System.out.println("✅ OTP created successfully with ID: " + otpId);
                    
                    // Verify the saved OTP
                    verifyCreatedOtp(otpId);
                    
                    return otpId;
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Error saving OTP: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public OtpToken findValidOtp(Integer userId, String otpCode, String otpType) {
        // ✅ FIX: Removed reserved keyword 'current_time'
        String sql = "SELECT *, " +
                    "NOW() as db_current_time, " +
                    "TIMESTAMPDIFF(SECOND, NOW(), expires_at) as seconds_remaining " +
                    "FROM otp_codes " +
                    "WHERE user_id = ? AND otp_code = ? AND otp_type = ? " +
                    "AND is_used = FALSE AND expires_at > NOW() " +
                    "ORDER BY created_at DESC LIMIT 1";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, otpCode);
            stmt.setString(3, otpType);
            
            System.out.println("🔍 Searching for valid OTP:");
            System.out.println("   User ID: " + userId);
            System.out.println("   OTP Code: " + otpCode);
            System.out.println("   OTP Type: " + otpType);
            System.out.println("   Current UTC: 2025-10-19 23:34:58");
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                OtpToken token = mapResultSetToOtpToken(rs);
                
                Timestamp dbCurrentTime = rs.getTimestamp("db_current_time");
                int secondsRemaining = rs.getInt("seconds_remaining");
                
                System.out.println("✅ Valid OTP found!");
                System.out.println("🕐 Current DB time: " + dbCurrentTime);
                System.out.println("⏰ OTP expires at: " + token.getExpiresAt());
                System.out.println("⏱️ Seconds remaining: " + secondsRemaining);
                
                return token;
            } else {
                System.err.println("❌ No valid OTP found");
                // Debug: Check what OTPs exist for this user
                debugOtpsForUser(userId);
            }
        } catch (SQLException e) {
            System.err.println("❌ Error finding valid OTP: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * ✅ NEW METHOD: Find recently used OTP for password reset flow
     * This handles the case where OTP was already marked as used in verify step
     */
    public OtpToken findRecentlyUsedOtp(Integer userId, String otpCode, String otpType) {
        String sql = "SELECT *, " +
                    "NOW() as db_current_time, " +
                    "TIMESTAMPDIFF(MINUTE, created_at, NOW()) as minutes_since_created " +
                    "FROM otp_codes " +
                    "WHERE user_id = ? AND otp_code = ? AND otp_type = ? " +
                    "AND is_used = TRUE " +
                    "AND created_at >= NOW() - INTERVAL 10 MINUTE " +
                    "ORDER BY created_at DESC LIMIT 1";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, otpCode);
            stmt.setString(3, otpType);
            
            System.out.println("🔍 Searching for recently used OTP:");
            System.out.println("   User ID: " + userId);
            System.out.println("   OTP Code: " + otpCode);
            System.out.println("   OTP Type: " + otpType);
            System.out.println("   Condition: Used within last 10 minutes");
            System.out.println("   Current UTC: 2025-10-19 23:34:58");
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                OtpToken token = mapResultSetToOtpToken(rs);
                
                Timestamp dbCurrentTime = rs.getTimestamp("db_current_time");
                int minutesSinceCreated = rs.getInt("minutes_since_created");
                
                System.out.println("✅ Recently used OTP found!");
                System.out.println("🕐 Current DB time: " + dbCurrentTime);
                System.out.println("⏰ OTP created at: " + token.getCreatedAt());
                System.out.println("⏱️ Minutes since created: " + minutesSinceCreated);
                System.out.println("🔒 OTP is used: " + token.getIsUsed());
                
                // Verify it's recent enough (within 10 minutes)
                if (minutesSinceCreated <= 10) {
                    System.out.println("✅ OTP is recent enough for password reset");
                    return token;
                } else {
                    System.err.println("❌ OTP is too old: " + minutesSinceCreated + " minutes");
                    return null;
                }
            } else {
                System.err.println("❌ No recently used OTP found");
                debugOtpsForUser(userId);
            }
        } catch (SQLException e) {
            System.err.println("❌ Error finding recently used OTP: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean markAsUsed(Integer otpId) {
        String sql = "UPDATE otp_codes SET is_used = TRUE WHERE otp_id = ?";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, otpId);
            int affectedRows = stmt.executeUpdate();
            System.out.println("✅ OTP marked as used: " + otpId + " (affected rows: " + affectedRows + ")");
            System.out.println("🕐 Marked at UTC: 2025-10-19 23:34:58");
            return affectedRows > 0;
        } catch (SQLException e) {
            System.err.println("❌ Error marking OTP as used: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public void cleanupExpiredOtps() {
        String sql = "DELETE FROM otp_codes WHERE expires_at < NOW()";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            int deletedRows = stmt.executeUpdate();
            System.out.println("✅ Cleaned up " + deletedRows + " expired OTP codes");
            System.out.println("🕐 Cleanup at UTC: 2025-10-19 23:34:58");
        } catch (SQLException e) {
            System.err.println("❌ Error cleaning up expired OTPs: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Helper method to verify created OTP
     */
    private void verifyCreatedOtp(Integer otpId) {
        String sql = "SELECT otp_id, created_at, expires_at, " +
                    "TIMESTAMPDIFF(MINUTE, created_at, expires_at) as minutes_diff " +
                    "FROM otp_codes WHERE otp_id = ?";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, otpId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                System.out.println("🔍 VERIFICATION - OTP ID: " + rs.getInt("otp_id"));
                System.out.println("🕐 Created at: " + rs.getTimestamp("created_at"));
                System.out.println("⏰ Expires at: " + rs.getTimestamp("expires_at"));
                System.out.println("⏱️ Duration: " + rs.getInt("minutes_diff") + " minutes");
                
                int minutesDiff = rs.getInt("minutes_diff");
                if (minutesDiff != 5) {
                    System.err.println("❌ WARNING: OTP duration is " + minutesDiff + " minutes instead of 5!");
                } else {
                    System.out.println("✅ OTP duration is correct: 5 minutes");
                }
            }
        } catch (SQLException e) {
            System.err.println("❌ Error verifying OTP: " + e.getMessage());
        }
    }

    /**
     * ✅ Enhanced debug method with corrected SQL
     */
    public void debugOtpsForUser(Integer userId) {
        String sql = "SELECT *, " +
                    "NOW() as db_now, " +
                    "TIMESTAMPDIFF(SECOND, created_at, expires_at) as duration_seconds, " +
                    "TIMESTAMPDIFF(SECOND, NOW(), expires_at) as remaining_seconds " +
                    "FROM otp_codes WHERE user_id = ? ORDER BY created_at DESC LIMIT 5";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            System.out.println("🔍 DEBUG: Recent OTPs for user " + userId + ":");
            System.out.println("🕐 Current UTC: 2025-10-19 23:34:58");
            System.out.println("+" + "-".repeat(130) + "+");
            System.out.printf("| %-8s | %-10s | %-15s | %-20s | %-20s | %-8s | %-10s | %-12s |\n", 
                             "OTP ID", "OTP Code", "Type", "Created At", "Expires At", "Used", "Duration", "Remaining");
            System.out.println("+" + "-".repeat(130) + "+");
            
            while (rs.next()) {
                System.out.printf("| %-8d | %-10s | %-15s | %-20s | %-20s | %-8s | %-10d | %-12d |\n",
                    rs.getInt("otp_id"),
                    rs.getString("otp_code"),
                    rs.getString("otp_type"),
                    rs.getTimestamp("created_at"),
                    rs.getTimestamp("expires_at"),
                    rs.getBoolean("is_used") ? "YES" : "NO",
                    rs.getInt("duration_seconds"),
                    rs.getInt("remaining_seconds")
                );
            }
            System.out.println("+" + "-".repeat(130) + "+");
            System.out.println("🕐 Current DB time: " + new Timestamp(System.currentTimeMillis()));
            
        } catch (SQLException e) {
            System.err.println("❌ Error debugging OTPs: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Helper method to map ResultSet to OtpToken
     */
    private OtpToken mapResultSetToOtpToken(ResultSet rs) throws SQLException {
        OtpToken otpToken = new OtpToken();
        otpToken.setOtpId(rs.getInt("otp_id"));
        otpToken.setUserId(rs.getInt("user_id"));
        otpToken.setOtpCode(rs.getString("otp_code"));
        otpToken.setOtpType(rs.getString("otp_type"));
        otpToken.setExpiresAt(rs.getTimestamp("expires_at"));
        otpToken.setIsUsed(rs.getBoolean("is_used"));
        otpToken.setCreatedAt(rs.getTimestamp("created_at"));
        return otpToken;
    }

    /**
     * ✅ Additional helper method to find OTP by ID
     */
    public OtpToken findById(Integer otpId) {
        String sql = "SELECT * FROM otp_codes WHERE otp_id = ?";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, otpId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToOtpToken(rs);
            }
        } catch (SQLException e) {
            System.err.println("❌ Error finding OTP by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    /**
     * ✅ Method to check if OTP exists
     */
    public boolean otpExists(Integer userId, String otpCode, String otpType) {
        String sql = "SELECT COUNT(*) FROM otp_codes WHERE user_id = ? AND otp_code = ? AND otp_type = ?";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, otpCode);
            stmt.setString(3, otpType);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("🔍 OTP exists check: " + count + " found");
                return count > 0;
            }
        } catch (SQLException e) {
            System.err.println("❌ Error checking OTP existence: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    /**
     * ✅ Clean up used OTP after successful password reset
     */
    public void cleanupUsedOtp(Integer otpId) {
        try {
            // Mark OTP as consumed (optional - you can also delete it)
            String sql = "UPDATE otp_codes SET is_used = TRUE WHERE otp_id = ?";
            
            try (Connection conn = DataSourceFactory.getConnection();
                 PreparedStatement stmt = conn.prepareStatement(sql)) {
                
                stmt.setInt(1, otpId);
                int updated = stmt.executeUpdate();
                System.out.println("🗑️ Cleaned up used OTP: " + otpId + " (updated: " + updated + ")");
            }
        } catch (SQLException e) {
            System.err.println("❌ Error cleaning up OTP: " + e.getMessage());
        }
    }
}
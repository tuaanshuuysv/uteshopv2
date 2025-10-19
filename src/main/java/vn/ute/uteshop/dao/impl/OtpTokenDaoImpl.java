package vn.ute.uteshop.dao.impl;

import vn.ute.uteshop.dao.OtpTokenDao;
import vn.ute.uteshop.model.OtpToken;
import vn.ute.uteshop.config.DataSourceFactory;

import java.sql.*;

public class OtpTokenDaoImpl implements OtpTokenDao {

    @Override
    public Integer save(OtpToken otpToken) {
        String sql = "INSERT INTO otp_codes (user_id, otp_code, otp_type, expires_at, is_used) " +
                    "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            stmt.setInt(1, otpToken.getUserId());
            stmt.setString(2, otpToken.getOtpCode());
            stmt.setString(3, otpToken.getOtpType());
            stmt.setTimestamp(4, otpToken.getExpiresAt());
            stmt.setBoolean(5, otpToken.getIsUsed());
            
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
    public OtpToken findValidOtp(Integer userId, String otpCode, String otpType) {
        String sql = "SELECT * FROM otp_codes WHERE user_id = ? AND otp_code = ? AND otp_type = ? " +
                    "AND is_used = FALSE AND expires_at > CURRENT_TIMESTAMP ORDER BY created_at DESC LIMIT 1";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            stmt.setString(2, otpCode);
            stmt.setString(3, otpType);
            
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return mapResultSetToOtpToken(rs);
            }
        } catch (SQLException e) {
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
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public void cleanupExpiredOtps() {
        String sql = "DELETE FROM otp_codes WHERE expires_at < CURRENT_TIMESTAMP";
        
        try (Connection conn = DataSourceFactory.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

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
}
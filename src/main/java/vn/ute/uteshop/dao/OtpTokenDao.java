package vn.ute.uteshop.dao;

import vn.ute.uteshop.model.OtpToken;

public interface OtpTokenDao {
    Integer save(OtpToken otpToken);
    OtpToken findValidOtp(Integer userId, String otpCode, String otpType);
    boolean markAsUsed(Integer otpId);
    void cleanupExpiredOtps();
}
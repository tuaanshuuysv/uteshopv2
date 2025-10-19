package vn.ute.uteshop.model;

import java.sql.Timestamp;

public class OtpToken {
    private Integer otpId;
    private Integer userId;
    private String otpCode;
    private String otpType; // REGISTRATION, FORGOT_PASSWORD, EMAIL_VERIFICATION
    private Timestamp expiresAt;
    private Boolean isUsed;
    private Timestamp createdAt;

    // Constructors
    public OtpToken() {}

    public OtpToken(Integer userId, String otpCode, String otpType, Timestamp expiresAt) {
        this.userId = userId;
        this.otpCode = otpCode;
        this.otpType = otpType;
        this.expiresAt = expiresAt;
        this.isUsed = false;
    }

    // Getters and Setters
    public Integer getOtpId() { return otpId; }
    public void setOtpId(Integer otpId) { this.otpId = otpId; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getOtpCode() { return otpCode; }
    public void setOtpCode(String otpCode) { this.otpCode = otpCode; }

    public String getOtpType() { return otpType; }
    public void setOtpType(String otpType) { this.otpType = otpType; }

    public Timestamp getExpiresAt() { return expiresAt; }
    public void setExpiresAt(Timestamp expiresAt) { this.expiresAt = expiresAt; }

    public Boolean getIsUsed() { return isUsed; }
    public void setIsUsed(Boolean isUsed) { this.isUsed = isUsed; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
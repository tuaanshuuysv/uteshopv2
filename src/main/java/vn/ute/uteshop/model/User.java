package vn.ute.uteshop.model;

import java.time.LocalDateTime;
import java.sql.Timestamp;
import java.util.Date;

/**
 * User Model - COMPLETE FIXED VERSION
 * Updated: 2025-10-26 18:33:55 UTC by tuaanshuuysv
 * Fix: All compatibility issues resolved
 */
public class User {
    private int userId;
    private String username;
    private String email;
    private String password;
    private String passwordHash;
    private String salt;
    private String fullName;
    private String phone;
    private String avatar;
    private String gender;
    private Date dateOfBirth;
    private boolean isActive;
    private boolean isVerified;
    private int roleId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime lastLoginAt;
    private LocalDateTime lastLogin;
    
    // Constructors
    public User() {}
    
    public User(String username, String email, String password, String fullName, String phone, int roleId) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.phone = phone;
        this.roleId = roleId;
        this.isActive = true;
        this.isVerified = false;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    public User(String username, String email, String passwordHash, String salt, String fullName, String phone, int roleId) {
        this.username = username;
        this.email = email;
        this.passwordHash = passwordHash;
        this.salt = salt;
        this.fullName = fullName;
        this.phone = phone;
        this.roleId = roleId;
        this.isActive = true;
        this.isVerified = false;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    // Getters and setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    
    public String getSalt() { return salt; }
    public void setSalt(String salt) { this.salt = salt; }
    
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getAvatar() { return avatar; }
    public void setAvatar(String avatar) { this.avatar = avatar; }
    
    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }
    
    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }
    
    public boolean isActive() { return isActive; }
    public boolean getIsActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    public void setIsActive(boolean active) { isActive = active; }
    
    public boolean isVerified() { return isVerified; }
    public boolean getIsVerified() { return isVerified; }
    public void setVerified(boolean verified) { isVerified = verified; }
    public void setIsVerified(boolean verified) { isVerified = verified; }
    
    public int getRoleId() { return roleId; }
    public void setRoleId(int roleId) { this.roleId = roleId; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public void setCreatedAt(Timestamp timestamp) { 
        this.createdAt = timestamp != null ? timestamp.toLocalDateTime() : null; 
    }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    public void setUpdatedAt(Timestamp timestamp) { 
        this.updatedAt = timestamp != null ? timestamp.toLocalDateTime() : null; 
    }
    
    public LocalDateTime getLastLoginAt() { return lastLoginAt; }
    public void setLastLoginAt(LocalDateTime lastLoginAt) { 
        this.lastLoginAt = lastLoginAt;
        this.lastLogin = lastLoginAt;
    }
    public void setLastLoginAt(Timestamp timestamp) { 
        LocalDateTime dt = timestamp != null ? timestamp.toLocalDateTime() : null;
        this.lastLoginAt = dt;
        this.lastLogin = dt;
    }
    
    public LocalDateTime getLastLogin() { 
        return lastLogin != null ? lastLogin : lastLoginAt; 
    }
    public void setLastLogin(LocalDateTime lastLogin) { 
        this.lastLogin = lastLogin; 
        this.lastLoginAt = lastLogin;
    }
    public void setLastLogin(Timestamp timestamp) { 
        LocalDateTime dt = timestamp != null ? timestamp.toLocalDateTime() : null;
        this.lastLogin = dt; 
        this.lastLoginAt = dt;
    }
    
    // Timestamp conversion methods
    public Timestamp getCreatedAtTimestamp() {
        return createdAt != null ? Timestamp.valueOf(createdAt) : null;
    }
    
    public Timestamp getUpdatedAtTimestamp() {
        return updatedAt != null ? Timestamp.valueOf(updatedAt) : null;
    }
    
    public Timestamp getLastLoginTimestamp() {
        LocalDateTime dt = lastLogin != null ? lastLogin : lastLoginAt;
        return dt != null ? Timestamp.valueOf(dt) : null;
    }
    
    // Utility methods for days calculation
    public long calculateDaysSinceCreated() {
        if (createdAt == null) return 0;
        return java.time.Duration.between(createdAt, LocalDateTime.now()).toDays();
    }
    
    public long calculateDaysSinceLastLogin() {
        LocalDateTime lastLoginTime = lastLogin != null ? lastLogin : lastLoginAt;
        if (lastLoginTime == null) return 0;
        return java.time.Duration.between(lastLoginTime, LocalDateTime.now()).toDays();
    }
    
    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", email='" + email + '\'' +
                ", fullName='" + fullName + '\'' +
                ", phone='" + phone + '\'' +
                ", isActive=" + isActive +
                ", isVerified=" + isVerified +
                ", roleId=" + roleId +
                '}';
    }
}
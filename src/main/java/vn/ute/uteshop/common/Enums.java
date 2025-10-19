package vn.ute.uteshop.common;

public final class Enums {
    public enum UserRole { 
        GUEST(1), USER(2), VENDOR(3), ADMIN(4);
        
        private final int value;
        UserRole(int value) { this.value = value; }
        public int getValue() { return value; }
    }
    
    public enum OtpType { 
        REGISTRATION, FORGOT_PASSWORD, EMAIL_VERIFICATION 
    }
    
    public enum OrderStatus { 
        NEW, CONFIRMED, PROCESSING, SHIPPING, DELIVERED, CANCELLED, RETURNED 
    }
    
    public enum PaymentMethod { 
        COD, VNPAY, MOMO, BANK_TRANSFER 
    }
    
    public enum PaymentStatus {
        PENDING, PAID, FAILED, REFUNDED
    }
    
    public enum ProductStatus {
        ACTIVE, INACTIVE, OUT_OF_STOCK, DISCONTINUED
    }
}
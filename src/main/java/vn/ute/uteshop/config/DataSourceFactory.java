package vn.ute.uteshop.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * DataSourceFactory - FIXED FOR MYSQL STRICT MODE
 * Updated: 2025-10-26 17:43:30 UTC by tuaanshuuysv
 */
public class DataSourceFactory {
    
    private static final String DB_URL = "jdbc:mysql://localhost:3306/uteshop?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "huy2406"; 
    
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("✅ MySQL Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            System.err.println("❌ MySQL Driver not found: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    public static Connection getConnection() throws SQLException {
        try {
            Connection conn = DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
            
            // DISABLE STRICT MODE
            try (Statement stmt = conn.createStatement()) {
                stmt.execute("SET sql_mode = ''");
                System.out.println("✅ MySQL strict mode disabled");
            } catch (SQLException e) {
                System.err.println("⚠️ Could not disable strict mode: " + e.getMessage());
            }
            
            System.out.println("✅ Database connection established: " + DB_URL);
            return conn;
        } catch (SQLException e) {
            System.err.println("❌ Database connection failed: " + e.getMessage());
            System.err.println("   URL: " + DB_URL);
            System.err.println("   Username: " + DB_USERNAME);
            throw e;
        }
    }
}
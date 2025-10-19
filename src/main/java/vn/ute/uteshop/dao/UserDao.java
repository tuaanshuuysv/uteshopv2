package vn.ute.uteshop.dao;

import vn.ute.uteshop.model.User;
import java.util.List;

public interface UserDao {
    User findById(Integer id);
    User findByEmail(String email);
    User findByUsername(String username);
    Integer save(User user);
    boolean update(User user);
    boolean updatePassword(Integer userId, String passwordHash, String salt);
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);
}
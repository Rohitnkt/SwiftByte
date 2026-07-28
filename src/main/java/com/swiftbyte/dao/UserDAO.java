package com.swiftbyte.dao;
import java.util.List;

import com.swiftbyte.model.User;

public interface UserDAO {
 boolean addUser(User u);
 void updateUser(User u);
 void deleteUser(int id);
 User getUserByEmail(String email);
 void updateLastLogin(int userId);
 User getUser(int id);
 boolean emailExists(String email);
 List<User>getAllUser();
}

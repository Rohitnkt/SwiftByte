package com.swiftbyte.dao;
import java.util.List;

import com.swiftbyte.model.User;

public interface UserDAO {
 void addUser(User u);
 void updateUser(User u);
 void deleteUser(int id);
 User getUser(int id);
 List<User>getAllUser();
}

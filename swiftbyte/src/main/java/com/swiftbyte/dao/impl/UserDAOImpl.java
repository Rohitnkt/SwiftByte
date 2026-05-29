package com.swiftbyte.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

import com.swiftbyte.dao.UserDAO;
import com.swiftbyte.model.User;
import com.swiftbyte.util.DBConnection;

public class UserDAOImpl implements UserDAO{
	private static final String INSERT_QUERY =
		    "INSERT INTO users(full_name,email,password,phone_number,"
		    + "delivery_address,role,last_login_at) VALUES(?,?,?,?,?,?,?)";

	private static final String SELECT_QUERY =
            "SELECT * FROM users WHERE user_id = ?";

	@Override
	public void addUser(User u) {
		// TODO Auto-generated method stub
		
		Connection connection=DBConnection.getConnection();
		try {
			PreparedStatement pstmt=connection.prepareStatement(INSERT_QUERY);
			pstmt.setString(1, u.getFullName());
			pstmt.setString(2, u.getEmail());
			pstmt.setString(3, u.getPassword());
			pstmt.setString(4, u.getPhoneNumber());
			pstmt.setString(5, u.getDeliveryAddress());
			pstmt.setString(6, u.getRole());
			pstmt.setTimestamp(7,
			        new Timestamp(System.currentTimeMillis()));
			int i=pstmt.executeUpdate();
			System.out.println(i);
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

	@Override
	public void updateUser(User u) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void deleteUser(int id) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public User getUser(int id) {
		User u=null;
		

		    try {
		        Connection connection = DBConnection.getConnection();

		        PreparedStatement pstmt =
		                connection.prepareStatement(SELECT_QUERY);

		        pstmt.setInt(1, id);

		        ResultSet res = pstmt.executeQuery();

		        while (res.next()) {

		            int userId = res.getInt("user_id");
		            String fullName = res.getString("full_name");
		            String email = res.getString("email");
		            String password = res.getString("password");
		            String phoneNumber = res.getString("phone_number");
		            String deliveryAddress = res.getString("delivery_address");
		            String role = res.getString("role");
		            Timestamp lastLoginAt =
		                    res.getTimestamp("last_login_at");
		            Timestamp createdAt =
		                    res.getTimestamp("created_at");
		            Timestamp updatedAt =
		                    res.getTimestamp("updated_at");

		            u = new User(
		                    userId,
		                    fullName,
		                    email,
		                    password,
		                    phoneNumber,
		                    deliveryAddress,
		                    role,
		                    lastLoginAt,
		                    createdAt,
		                    updatedAt
		            );
		        }

		    } catch (SQLException e) {
		        e.printStackTrace();
		    }

			return u;
		
		// TODO Auto-generated method stub
	}

	@Override
	public List<User> getAllUser() {
		// TODO Auto-generated method stub
		return null;
	}
	
 
}


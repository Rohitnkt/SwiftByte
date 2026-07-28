package com.swiftbyte.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.swiftbyte.dao.UserDAO;
import com.swiftbyte.model.User;
import com.swiftbyte.util.DBConnection;

public class UserDAOImpl implements UserDAO{
	//private static final String INSERT_QUERY =
	//	    "INSERT INTO users(full_name,email,password,phone_number,"
		   // + "delivery_address,role,last_login_at) VALUES(?,?,?,?,?,?,?)";
	
	private static final String INSERT_QUERY =
		    "INSERT INTO users(full_name,email,password,phone_number,"
		    + "delivery_address,role,last_login_at) VALUES(?,?,?,?,?,?,?)";
	
	private static final String SELECT_BY_EMAIL_QUERY =
		    "SELECT * FROM users WHERE email = ?";
	
	private static final String UPDATE_LAST_LOGIN_QUERY =
		    "UPDATE users SET last_login_at = ? WHERE user_id = ?";

	private static final String SELECT_QUERY =
            "SELECT * FROM users WHERE user_id = ?";
	private static final String SELECT_ALL_QUERY =
	        "SELECT * FROM users";
	private static final String UPDATE_QUERY =
		    "UPDATE users SET full_name = ?, email = ?, password = ?, "
		    + "phone_number = ?, delivery_address = ?, "
		    + "updated_at = ? "
		    + "WHERE user_id = ?";
	private static final String DELETE_QUERY =
	        "DELETE FROM users WHERE user_id = ?";
	/*	// TODO Auto-generated method stub
		
		Connection connection=DBConnection.getConnection();
		try {
			PreparedStatement pstmt=connection.prepareStatement(INSERT_QUERY);
			pstmt.setString(1, u.getFullName());
			pstmt.setString(2, u.getEmail());
			pstmt.setString(3, u.getPassword());
			pstmt.setString(4, u.getPhoneNumber());
			pstmt.setString(5, u.getDeliveryAddress());
			pstmt.setTimestamp(6,
			        new Timestamp(System.currentTimeMillis()));
			pstmt.setInt(7, u.getUserId());
			int i =pstmt.executeUpdate();
			System.out.println(i);	
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}*/
	@Override
	public boolean addUser(User u) {
	    Connection connection = DBConnection.getConnection();
	    try {
	        PreparedStatement pstmt = connection.prepareStatement(INSERT_QUERY);
	        pstmt.setString(1, u.getFullName());
	        pstmt.setString(2, u.getEmail());
	        pstmt.setString(3, u.getPassword());
	        pstmt.setString(4, u.getPhoneNumber());
	        pstmt.setString(5, u.getDeliveryAddress());
	        pstmt.setString(6, u.getRole());
	        pstmt.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
	        int i = pstmt.executeUpdate();
	        System.out.println("Rows inserted: " + i);
	        return i > 0;              // ✅ true when insert succeeds
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;              // ✅ false only on failure
	    }
	}


	@Override
	public User getUserByEmail(String email) {
	    User u = null;
	    try {
	        Connection connection = DBConnection.getConnection();
	        PreparedStatement pstmt = connection.prepareStatement(SELECT_BY_EMAIL_QUERY);
	        pstmt.setString(1, email);
	        ResultSet res = pstmt.executeQuery();
	        if (res.next()) {
	            u = new User(
	                res.getInt("user_id"),
	                res.getString("full_name"),
	                res.getString("email"),
	                res.getString("password"),
	                res.getString("phone_number"),
	                res.getString("delivery_address"),
	                res.getString("role"),
	                res.getTimestamp("last_login_at"),
	                res.getTimestamp("created_at"),
	                res.getTimestamp("updated_at")
	            );
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return u;
	}
	
	
	@Override
	public void updateLastLogin(int userId) {
	    try {
	        Connection connection = DBConnection.getConnection();
	        PreparedStatement pstmt = connection.prepareStatement(UPDATE_LAST_LOGIN_QUERY);
	        pstmt.setTimestamp(1, new Timestamp(System.currentTimeMillis()));
	        pstmt.setInt(2, userId);
	        pstmt.executeUpdate();
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	}
	@Override
	public boolean emailExists(String email) {
	    Connection connection = DBConnection.getConnection();
	    try {
	        PreparedStatement pstmt = connection.prepareStatement(
	            "SELECT 1 FROM users WHERE email = ? LIMIT 1");
	        pstmt.setString(1, email);
	        ResultSet rs = pstmt.executeQuery();
	        return rs.next();
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    }
	}

	
	
	
	@Override
	public void updateUser(User u) {
		// TODO Auto-generated method stub
		 try {

		        Connection connection = DBConnection.getConnection();

		        PreparedStatement pstmt =
		                connection.prepareStatement(UPDATE_QUERY);


		        pstmt.setString(1, u.getFullName());
		        pstmt.setString(2, u.getEmail());
		        pstmt.setString(3, u.getPassword());
		        pstmt.setString(4, u.getPhoneNumber());
		        pstmt.setString(5, u.getDeliveryAddress());
		        pstmt.setTimestamp(6,
		                new Timestamp(System.currentTimeMillis()));
		        pstmt.setInt(7, u.getUserId());
		        int i = pstmt.executeUpdate();

		        System.out.println(i);

		    } catch (SQLException e) {
		        e.printStackTrace();
		    }
		
		
	}

	@Override
	public void deleteUser(int id) {
		// TODO Auto-generated method stub
		
		try {

	        Connection connection = DBConnection.getConnection();

	        PreparedStatement pstmt =
	                connection.prepareStatement(DELETE_QUERY);

	        pstmt.setInt(1, id);

	        int i = pstmt.executeUpdate();

	        if (i > 0) {
	            System.out.println("User deleted successfully");
	        } else {
	            System.out.println("User not found");
	        }

	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	}

	@Override
	public User getUser(int id) {
		// TODO Auto-generated method stub
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
		
	}

	@Override
	public List<User> getAllUser() {
		// TODO Auto-generated method stub
		  List<User> userList = new ArrayList<>();

		    try {

		        Connection connection = DBConnection.getConnection();

		        PreparedStatement pstmt =
		                connection.prepareStatement(SELECT_ALL_QUERY);

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

		            User u = new User(
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

		            userList.add(u);
		        }

		    } catch (SQLException e) {
		        e.printStackTrace();
		    }

		    return userList;
		
	}
	
 
}


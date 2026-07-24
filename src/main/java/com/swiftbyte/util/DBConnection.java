package com.swiftbyte.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
	private static final String URL="jdbc:mysql://localhost:3306/swiftbyte";
	private static final String USERNAME="root";
	private static final String PASSWORD="password";
	private static Connection con;
 public static Connection getConnection() {
	// TODO Auto-generated method stub
	 try {
		Class.forName("com.mysql.cj.jdbc.Driver");
		con=DriverManager.getConnection(URL,USERNAME,PASSWORD);
	 } catch (ClassNotFoundException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	 } catch (SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
	 return con;
}
 }


package com.swiftbyte.test;

import java.sql.Connection;
import com.swiftbyte.util.DBConnection;

public class ConnectionTest {

    public static void main(String[] args) {

        Connection connection = DBConnection.getConnection();

        if (connection != null) {
            System.out.println("Database Connected Successfully");
        } else {
            System.out.println("Database Connection Failed");
        }
    }
}
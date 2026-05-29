package com.swiftbyte.test;

import com.swiftbyte.dao.impl.UserDAOImpl;
import com.swiftbyte.model.User;

public class Testing {

    public static void main(String[] args) {

        UserDAOImpl dao = new UserDAOImpl();
        
        
        
        User u = dao.getUser(1);

        if (u != null) {
            System.out.println(u);
        } else {
            System.out.println("User not found");
        }
        
        
        
        
        
        

        /*User u = new User();

        u.setFullName("Rohit Kumar");
        u.setEmail("rohit@gmail.com");
        u.setPassword("123456");
        u.setPhoneNumber("9876543210");
        u.setDeliveryAddress("Delhi");
        u.setRole("CUSTOMER");

        dao.addUser(u);

        System.out.println("User Added Successfully");*/
    }
}
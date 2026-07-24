package com.swiftbyte.test;

import com.swiftbyte.dao.RestaurantDAO;
import com.swiftbyte.dao.impl.RestaurantDAOImpl;

public class RestaurantDeleteTest {

    public static void main(String[] args) {

        RestaurantDAO dao = new RestaurantDAOImpl();

        boolean status = dao.deleteRestaurant(1);

        if (status) {
            System.out.println("Restaurant Deleted Successfully");
        } else {
            System.out.println("Restaurant Not Found");
        }
    }
}
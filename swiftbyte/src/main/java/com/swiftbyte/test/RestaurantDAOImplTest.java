package com.swiftbyte.test;

import java.sql.Time;

import com.swiftbyte.dao.RestaurantDAO;
import com.swiftbyte.dao.impl.RestaurantDAOImpl;
import com.swiftbyte.model.Restaurant;

public class RestaurantDAOImplTest {

    public static void main(String[] args) {

        Restaurant restaurant = new Restaurant();

        // user_id = 3 exists in your users table
        restaurant.setOwnerId(3);

        restaurant.setRestaurantName("Domino's Pizza");
        restaurant.setCuisineType("Pizza");
        restaurant.setAddress("BTM Layout, Bangalore");
        restaurant.setPhoneNumber("9876543210");
        restaurant.setEmail("dominos@gmail.com");
        restaurant.setOpeningTime(Time.valueOf("09:00:00"));
        restaurant.setClosingTime(Time.valueOf("23:00:00"));
        restaurant.setRating(4.5);
        restaurant.setActive(true);

        // Create DAO object
        RestaurantDAO dao = new RestaurantDAOImpl();

        // Call addRestaurant()
        boolean status = dao.addRestaurant(restaurant);

        if (status) {
            System.out.println("Restaurant Added Successfully");
        } else {
            System.out.println("Restaurant Not Added");
        }
    }
}
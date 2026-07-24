package com.swiftbyte.test;

import java.sql.Time;

import com.swiftbyte.dao.RestaurantDAO;
import com.swiftbyte.dao.impl.RestaurantDAOImpl;
import com.swiftbyte.model.Restaurant;

public class RestaurantUpdateTest {

    public static void main(String[] args) {

        Restaurant restaurant = new Restaurant();

        // Existing restaurant ID
        restaurant.setRestaurantId(1);

        restaurant.setRestaurantName("Domino's India");
        restaurant.setCuisineType("Fast Food");
        restaurant.setAddress("Marathahalli, Bangalore");
        restaurant.setPhoneNumber("9999999999");
        restaurant.setEmail("dominosindia@gmail.com");
        restaurant.setOpeningTime(Time.valueOf("10:00:00"));
        restaurant.setClosingTime(Time.valueOf("22:30:00"));
        restaurant.setRating(4.8);
        restaurant.setActive(true);

        RestaurantDAO dao = new RestaurantDAOImpl();

        boolean status = dao.updateRestaurant(restaurant);

        if (status) {
            System.out.println("Restaurant Updated Successfully");
        } else {
            System.out.println("Restaurant Update Failed");
        }
    }
}
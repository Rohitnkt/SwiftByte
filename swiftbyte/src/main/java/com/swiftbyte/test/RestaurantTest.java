package com.swiftbyte.test;

import java.sql.Time;

import com.swiftbyte.model.Restaurant;

public class RestaurantTest {

    public static void main(String[] args) {

        Restaurant restaurant = new Restaurant();

        restaurant.setRestaurantId(1);
        restaurant.setOwnerId(101);
        restaurant.setRestaurantName("Domino's Pizza");
        restaurant.setCuisineType("Pizza");
        restaurant.setAddress("BTM Layout, Bangalore");
        restaurant.setPhoneNumber("9876543210");
        restaurant.setEmail("dominos@gmail.com");
        restaurant.setOpeningTime(Time.valueOf("09:00:00"));
        restaurant.setClosingTime(Time.valueOf("23:00:00"));
        restaurant.setRating(4.5);
        restaurant.setActive(true);

        System.out.println("Restaurant ID      : " + restaurant.getRestaurantId());
        System.out.println("Owner ID           : " + restaurant.getOwnerId());
        System.out.println("Restaurant Name    : " + restaurant.getRestaurantName());
        System.out.println("Cuisine Type       : " + restaurant.getCuisineType());
        System.out.println("Address            : " + restaurant.getAddress());
        System.out.println("Phone Number       : " + restaurant.getPhoneNumber());
        System.out.println("Email              : " + restaurant.getEmail());
        System.out.println("Opening Time       : " + restaurant.getOpeningTime());
        System.out.println("Closing Time       : " + restaurant.getClosingTime());
        System.out.println("Rating             : " + restaurant.getRating());
        System.out.println("Active             : " + restaurant.isActive());
    }
}
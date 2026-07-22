package com.swiftbyte.test;

import java.util.List;

import com.swiftbyte.dao.RestaurantDAO;
import com.swiftbyte.dao.impl.RestaurantDAOImpl;
import com.swiftbyte.model.Restaurant;

public class RestaurantGetAllTest {

    public static void main(String[] args) {

        RestaurantDAO dao = new RestaurantDAOImpl();

        List<Restaurant> restaurants = dao.getAllRestaurants();

        if (restaurants.isEmpty()) {
            System.out.println("No Restaurants Found");
        } else {

            for (Restaurant restaurant : restaurants) {

                System.out.println("---------------------------------");
                System.out.println("Restaurant ID : " + restaurant.getRestaurantId());
                System.out.println("Name          : " + restaurant.getRestaurantName());
                System.out.println("Cuisine       : " + restaurant.getCuisineType());
                System.out.println("Rating        : " + restaurant.getRating());
            }
        }
    }
}
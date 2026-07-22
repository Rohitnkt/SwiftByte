package com.swiftbyte.test;

import com.swiftbyte.dao.RestaurantDAO;
import com.swiftbyte.dao.impl.RestaurantDAOImpl;
import com.swiftbyte.model.Restaurant;

public class RestaurantGetByIdTest {

    public static void main(String[] args) {

        RestaurantDAO dao = new RestaurantDAOImpl();

        Restaurant restaurant = dao.getRestaurantById(1);

        if (restaurant != null) {

            System.out.println("Restaurant Found");
            System.out.println("---------------------------");
            System.out.println("Restaurant ID : " + restaurant.getRestaurantId());
            System.out.println("Owner ID      : " + restaurant.getOwnerId());
            System.out.println("Name          : " + restaurant.getRestaurantName());
            System.out.println("Cuisine       : " + restaurant.getCuisineType());
            System.out.println("Rating        : " + restaurant.getRating());

        } else {

            System.out.println("Restaurant Not Found");
        }
    }
}
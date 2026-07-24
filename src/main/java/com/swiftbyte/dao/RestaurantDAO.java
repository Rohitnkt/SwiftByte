package com.swiftbyte.dao;

import java.util.List;
import com.swiftbyte.model.Restaurant;

public interface RestaurantDAO {

    boolean addRestaurant(Restaurant restaurant);

    Restaurant getRestaurantById(int restaurantId);

    List<Restaurant> getAllRestaurants();

    List<Restaurant> getActiveRestaurants();

    List<Restaurant> getTopRestaurantChains(int limit);

    List<Restaurant> searchRestaurants(String query);

    List<Restaurant> getRestaurantsByCuisine(String cuisineType);

    boolean updateRestaurant(Restaurant restaurant);

    boolean deleteRestaurant(int restaurantId);
}
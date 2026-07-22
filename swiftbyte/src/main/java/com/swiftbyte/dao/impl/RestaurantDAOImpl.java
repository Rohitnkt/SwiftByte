package com.swiftbyte.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import com.swiftbyte.dao.RestaurantDAO;
import com.swiftbyte.model.Restaurant;
import com.swiftbyte.util.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO {

    public RestaurantDAOImpl() {

    }

    @Override
    public boolean addRestaurant(Restaurant restaurant) {

        String query = "INSERT INTO restaurants(owner_id, restaurant_name, cuisine_type, address, phone_number, email, opening_time, closing_time, rating, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(query)) {

            pstmt.setInt(1, restaurant.getOwnerId());
            pstmt.setString(2, restaurant.getRestaurantName());
            pstmt.setString(3, restaurant.getCuisineType());
            pstmt.setString(4, restaurant.getAddress());
            pstmt.setString(5, restaurant.getPhoneNumber());
            pstmt.setString(6, restaurant.getEmail());
            pstmt.setTime(7, restaurant.getOpeningTime());
            pstmt.setTime(8, restaurant.getClosingTime());
            pstmt.setDouble(9, restaurant.getRating());
            pstmt.setBoolean(10, restaurant.isActive());

            int rowsAffected = pstmt.executeUpdate();

            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public Restaurant getRestaurantById(int restaurantId) {

        return null;
    }

    @Override
    public List<Restaurant> getAllRestaurants() {

        return null;
    }

    @Override
    public boolean updateRestaurant(Restaurant restaurant) {

        return false;
    }

    @Override
    public boolean deleteRestaurant(int restaurantId) {

        return false;
    }

}
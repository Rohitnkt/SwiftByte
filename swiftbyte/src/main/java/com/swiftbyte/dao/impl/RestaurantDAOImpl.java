package com.swiftbyte.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;
import java.sql.ResultSet;
import com.swiftbyte.dao.RestaurantDAO;
import com.swiftbyte.model.Restaurant;
import com.swiftbyte.util.DBConnection;
import java.util.ArrayList;

public class RestaurantDAOImpl implements RestaurantDAO {
	private static final String INSERT_RESTAURANT =
		    "INSERT INTO restaurants(owner_id, restaurant_name, cuisine_type, address, phone_number, email, opening_time, closing_time, rating, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		private static final String GET_RESTAURANT_BY_ID =
		    "SELECT * FROM restaurants WHERE restaurant_id = ?";
		private static final String GET_ALL_RESTAURANTS =
			    "SELECT * FROM restaurants";
    public RestaurantDAOImpl() {

    }

    @Override
    public boolean addRestaurant(Restaurant restaurant) {
    	    try (Connection con = DBConnection.getConnection();
    	         PreparedStatement pstmt = con.prepareStatement(INSERT_RESTAURANT)) {

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
    	 Restaurant restaurant = null;

    	    try (Connection con = DBConnection.getConnection();
    	         PreparedStatement pstmt = con.prepareStatement(GET_RESTAURANT_BY_ID)) {

    	        pstmt.setInt(1, restaurantId);

    	        ResultSet rs = pstmt.executeQuery();

    	        if (rs.next()) {

    	            restaurant = new Restaurant();

    	            restaurant.setRestaurantId(rs.getInt("restaurant_id"));
    	            restaurant.setOwnerId(rs.getInt("owner_id"));
    	            restaurant.setRestaurantName(rs.getString("restaurant_name"));
    	            restaurant.setCuisineType(rs.getString("cuisine_type"));
    	            restaurant.setAddress(rs.getString("address"));
    	            restaurant.setPhoneNumber(rs.getString("phone_number"));
    	            restaurant.setEmail(rs.getString("email"));
    	            restaurant.setOpeningTime(rs.getTime("opening_time"));
    	            restaurant.setClosingTime(rs.getTime("closing_time"));
    	            restaurant.setRating(rs.getDouble("rating"));
    	            restaurant.setActive(rs.getBoolean("is_active"));
    	            restaurant.setCreatedAt(rs.getTimestamp("created_at"));
    	            restaurant.setUpdatedAt(rs.getTimestamp("updated_at"));
    	        }

    	    } catch (SQLException e) {
    	        e.printStackTrace();
    	    }

    	    return restaurant;
        
    }

    @Override
    public List<Restaurant> getAllRestaurants() {

    	List<Restaurant> restaurants = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_ALL_RESTAURANTS);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {

                Restaurant restaurant = new Restaurant();

                restaurant.setRestaurantId(rs.getInt("restaurant_id"));
                restaurant.setOwnerId(rs.getInt("owner_id"));
                restaurant.setRestaurantName(rs.getString("restaurant_name"));
                restaurant.setCuisineType(rs.getString("cuisine_type"));
                restaurant.setAddress(rs.getString("address"));
                restaurant.setPhoneNumber(rs.getString("phone_number"));
                restaurant.setEmail(rs.getString("email"));
                restaurant.setOpeningTime(rs.getTime("opening_time"));
                restaurant.setClosingTime(rs.getTime("closing_time"));
                restaurant.setRating(rs.getDouble("rating"));
                restaurant.setActive(rs.getBoolean("is_active"));
                restaurant.setCreatedAt(rs.getTimestamp("created_at"));
                restaurant.setUpdatedAt(rs.getTimestamp("updated_at"));

                restaurants.add(restaurant);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
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
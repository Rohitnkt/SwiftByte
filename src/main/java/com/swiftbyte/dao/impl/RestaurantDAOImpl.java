package com.swiftbyte.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.swiftbyte.dao.RestaurantDAO;
import com.swiftbyte.model.Restaurant;
import com.swiftbyte.util.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO {

    private static final String INSERT_RESTAURANT =
            "INSERT INTO restaurants(owner_id, restaurant_name, cuisine_type, address, phone_number, email, opening_time, closing_time, rating, is_active, image_url, delivery_time_min, delivery_time_max, promo_offer, location, is_top_chain) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String GET_RESTAURANT_BY_ID =
            "SELECT * FROM restaurants WHERE restaurant_id = ?";

    private static final String GET_ALL_RESTAURANTS =
            "SELECT * FROM restaurants ORDER BY rating DESC, restaurant_name ASC";

    private static final String GET_ACTIVE_RESTAURANTS =
            "SELECT * FROM restaurants WHERE is_active = TRUE ORDER BY rating DESC, restaurant_name ASC";

    private static final String GET_TOP_RESTAURANT_CHAINS =
            "SELECT * FROM restaurants WHERE is_active = TRUE AND is_top_chain = TRUE ORDER BY rating DESC, restaurant_name ASC LIMIT ?";

    private static final String SEARCH_RESTAURANTS =
            "SELECT * FROM restaurants WHERE is_active = TRUE AND (restaurant_name LIKE ? OR cuisine_type LIKE ? OR location LIKE ? OR address LIKE ?) ORDER BY rating DESC";

    private static final String GET_RESTAURANTS_BY_CUISINE =
            "SELECT * FROM restaurants WHERE is_active = TRUE AND cuisine_type LIKE ? ORDER BY rating DESC";

    private static final String UPDATE_RESTAURANT =
            "UPDATE restaurants SET restaurant_name=?, cuisine_type=?, address=?, phone_number=?, email=?, opening_time=?, closing_time=?, rating=?, is_active=?, image_url=?, delivery_time_min=?, delivery_time_max=?, promo_offer=?, location=?, is_top_chain=? WHERE restaurant_id=?";

    private static final String DELETE_RESTAURANT =
            "DELETE FROM restaurants WHERE restaurant_id = ?";

    public RestaurantDAOImpl() {
    }

    private Restaurant mapRestaurant(ResultSet rs) throws SQLException {
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

        try {
            restaurant.setImageUrl(rs.getString("image_url"));
            restaurant.setDeliveryTimeMin(rs.getInt("delivery_time_min"));
            restaurant.setDeliveryTimeMax(rs.getInt("delivery_time_max"));
            restaurant.setPromoOffer(rs.getString("promo_offer"));
            restaurant.setLocation(rs.getString("location"));
            restaurant.setTopChain(rs.getBoolean("is_top_chain"));
        } catch (SQLException ignored) {
            // Backward compatible when optional columns are not migrated yet.
        }

        return restaurant;
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
            pstmt.setString(11, restaurant.getImageUrl());
            pstmt.setInt(12, restaurant.getDeliveryTimeMin());
            pstmt.setInt(13, restaurant.getDeliveryTimeMax());
            pstmt.setString(14, restaurant.getPromoOffer());
            pstmt.setString(15, restaurant.getLocation());
            pstmt.setBoolean(16, restaurant.isTopChain());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public Restaurant getRestaurantById(int restaurantId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_RESTAURANT_BY_ID)) {

            pstmt.setInt(1, restaurantId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return mapRestaurant(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<Restaurant> getAllRestaurants() {
        return queryRestaurantList(GET_ALL_RESTAURANTS);
    }

    @Override
    public List<Restaurant> getActiveRestaurants() {
        return queryRestaurantList(GET_ACTIVE_RESTAURANTS);
    }

    @Override
    public List<Restaurant> getTopRestaurantChains(int limit) {
        List<Restaurant> restaurants = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_TOP_RESTAURANT_CHAINS)) {

            pstmt.setInt(1, limit);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                restaurants.add(mapRestaurant(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
    }

    @Override
    public List<Restaurant> searchRestaurants(String query) {
        List<Restaurant> restaurants = new ArrayList<>();
        String pattern = "%" + query + "%";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(SEARCH_RESTAURANTS)) {

            pstmt.setString(1, pattern);
            pstmt.setString(2, pattern);
            pstmt.setString(3, pattern);
            pstmt.setString(4, pattern);

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                restaurants.add(mapRestaurant(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
    }

    @Override
    public List<Restaurant> getRestaurantsByCuisine(String cuisineType) {
        List<Restaurant> restaurants = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_RESTAURANTS_BY_CUISINE)) {

            pstmt.setString(1, "%" + cuisineType + "%");
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                restaurants.add(mapRestaurant(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
    }

    private List<Restaurant> queryRestaurantList(String sql) {
        List<Restaurant> restaurants = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                restaurants.add(mapRestaurant(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return restaurants;
    }

    @Override
    public boolean updateRestaurant(Restaurant restaurant) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(UPDATE_RESTAURANT)) {

            pstmt.setString(1, restaurant.getRestaurantName());
            pstmt.setString(2, restaurant.getCuisineType());
            pstmt.setString(3, restaurant.getAddress());
            pstmt.setString(4, restaurant.getPhoneNumber());
            pstmt.setString(5, restaurant.getEmail());
            pstmt.setTime(6, restaurant.getOpeningTime());
            pstmt.setTime(7, restaurant.getClosingTime());
            pstmt.setDouble(8, restaurant.getRating());
            pstmt.setBoolean(9, restaurant.isActive());
            pstmt.setString(10, restaurant.getImageUrl());
            pstmt.setInt(11, restaurant.getDeliveryTimeMin());
            pstmt.setInt(12, restaurant.getDeliveryTimeMax());
            pstmt.setString(13, restaurant.getPromoOffer());
            pstmt.setString(14, restaurant.getLocation());
            pstmt.setBoolean(15, restaurant.isTopChain());
            pstmt.setInt(16, restaurant.getRestaurantId());

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean deleteRestaurant(int restaurantId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(DELETE_RESTAURANT)) {

            pstmt.setInt(1, restaurantId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}

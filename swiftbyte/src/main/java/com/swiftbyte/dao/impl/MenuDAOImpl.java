package com.swiftbyte.dao.impl;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import com.swiftbyte.dao.MenuDAO;
import com.swiftbyte.model.Menu;
import com.swiftbyte.util.DBConnection;
import java.util.ArrayList;
import java.util.List;

public class MenuDAOImpl implements MenuDAO {

    private static final String INSERT_MENU_ITEM =
            "INSERT INTO menu_items (restaurant_id, item_name, description, price, category, is_available, image_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
    private static final String GET_MENU_BY_ID =
            "SELECT * FROM menu_items WHERE menu_id = ?";
    private static final String GET_ALL_MENU_ITEMS =
            "SELECT * FROM menu_items";
    private static final String GET_MENU_ITEMS_BY_RESTAURANT =
            "SELECT * FROM menu_items WHERE restaurant_id = ?";
    private static final String UPDATE_MENU_ITEM =
    	    "UPDATE menu_items SET restaurant_id=?, item_name=?, description=?, price=?, category=?, is_available=?, image_url=? WHERE menu_id=?";
    private static final String DELETE_MENU_ITEM =
            "DELETE FROM menu_items WHERE menu_id = ?";

    @Override
    public boolean addMenuItem(Menu menu) {

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(INSERT_MENU_ITEM)) {

            pstmt.setInt(1, menu.getRestaurantId());
            pstmt.setString(2, menu.getItemName());
            pstmt.setString(3, menu.getDescription());
            pstmt.setDouble(4, menu.getPrice());
            pstmt.setString(5, menu.getCategory());
            pstmt.setBoolean(6, menu.isAvailable());
            pstmt.setString(7, menu.getImageUrl());

            return pstmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public Menu getMenuById(int menuId) {
    
    	    Menu menu = null;

    	    try (Connection con = DBConnection.getConnection();
    	         PreparedStatement pstmt = con.prepareStatement(GET_MENU_BY_ID)) {

    	        pstmt.setInt(1, menuId);

    	        ResultSet rs = pstmt.executeQuery();

    	        if (rs.next()) {

    	            menu = new Menu();

    	            menu.setMenuId(rs.getInt("menu_id"));
    	            menu.setRestaurantId(rs.getInt("restaurant_id"));
    	            menu.setItemName(rs.getString("item_name"));
    	            menu.setDescription(rs.getString("description"));
    	            menu.setPrice(rs.getDouble("price"));
    	            menu.setCategory(rs.getString("category"));
    	            menu.setAvailable(rs.getBoolean("is_available"));
    	            menu.setImageUrl(rs.getString("image_url"));
    	            menu.setCreatedAt(rs.getTimestamp("created_at"));
    	            menu.setUpdatedAt(rs.getTimestamp("updated_at"));
    	        }

    	    } catch (SQLException e) {
    	        e.printStackTrace();
    	    }

    	    return menu;
    }

    @Override
    public java.util.List<Menu> getAllMenuItems() {
    	 List<Menu> menuList = new ArrayList<>();

    	    try (Connection con = DBConnection.getConnection();
    	         PreparedStatement pstmt = con.prepareStatement(GET_ALL_MENU_ITEMS);
    	         ResultSet rs = pstmt.executeQuery()) {

    	        while (rs.next()) {

    	            Menu menu = new Menu();

    	            menu.setMenuId(rs.getInt("menu_id"));
    	            menu.setRestaurantId(rs.getInt("restaurant_id"));
    	            menu.setItemName(rs.getString("item_name"));
    	            menu.setDescription(rs.getString("description"));
    	            menu.setPrice(rs.getDouble("price"));
    	            menu.setCategory(rs.getString("category"));
    	            menu.setAvailable(rs.getBoolean("is_available"));
    	            menu.setImageUrl(rs.getString("image_url"));
    	            menu.setCreatedAt(rs.getTimestamp("created_at"));
    	            menu.setUpdatedAt(rs.getTimestamp("updated_at"));

    	            menuList.add(menu);
    	        }

    	    } catch (SQLException e) {
    	        e.printStackTrace();
    	    }

    	    return menuList;
    }

    @Override
    public java.util.List<Menu> getMenuItemsByRestaurant(int restaurantId) {
    	 List<Menu> menuList = new ArrayList<>();

    	    try (Connection con = DBConnection.getConnection();
    	         PreparedStatement pstmt = con.prepareStatement(GET_MENU_ITEMS_BY_RESTAURANT)) {

    	        pstmt.setInt(1, restaurantId);

    	        ResultSet rs = pstmt.executeQuery();

    	        while (rs.next()) {

    	            Menu menu = new Menu();

    	            menu.setMenuId(rs.getInt("menu_id"));
    	            menu.setRestaurantId(rs.getInt("restaurant_id"));
    	            menu.setItemName(rs.getString("item_name"));
    	            menu.setDescription(rs.getString("description"));
    	            menu.setPrice(rs.getDouble("price"));
    	            menu.setCategory(rs.getString("category"));
    	            menu.setAvailable(rs.getBoolean("is_available"));
    	            menu.setImageUrl(rs.getString("image_url"));
    	            menu.setCreatedAt(rs.getTimestamp("created_at"));
    	            menu.setUpdatedAt(rs.getTimestamp("updated_at"));

    	            menuList.add(menu);
    	        }

    	    } catch (SQLException e) {
    	        e.printStackTrace();
    	    }

    	    return menuList;
    }

    @Override
    public boolean updateMenuItem(Menu menu) {
    	 try (Connection con = DBConnection.getConnection();
    	         PreparedStatement pstmt = con.prepareStatement(UPDATE_MENU_ITEM)) {

    	        pstmt.setInt(1, menu.getRestaurantId());
    	        pstmt.setString(2, menu.getItemName());
    	        pstmt.setString(3, menu.getDescription());
    	        pstmt.setDouble(4, menu.getPrice());
    	        pstmt.setString(5, menu.getCategory());
    	        pstmt.setBoolean(6, menu.isAvailable());
    	        pstmt.setString(7, menu.getImageUrl());
    	        pstmt.setInt(8, menu.getMenuId());

    	        return pstmt.executeUpdate() > 0;

    	    } catch (SQLException e) {
    	        e.printStackTrace();
    	    }

    	    return false;
    }

    @Override
    public boolean deleteMenuItem(int menuId) {
    	try (Connection con = DBConnection.getConnection();
    	         PreparedStatement pstmt = con.prepareStatement(DELETE_MENU_ITEM)) {

    	        pstmt.setInt(1, menuId);

    	        return pstmt.executeUpdate() > 0;

    	    } catch (SQLException e) {
    	        e.printStackTrace();
    	    }

    	    return false;
    }
}
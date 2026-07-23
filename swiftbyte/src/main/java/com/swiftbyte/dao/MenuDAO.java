package com.swiftbyte.dao;

import java.util.List;
import com.swiftbyte.model.Menu;

public interface MenuDAO {

    // Insert a menu item
    boolean addMenuItem(Menu menu);

    // Get a menu item by ID
    Menu getMenuById(int menuId);

    // Get all menu items
    List<Menu> getAllMenuItems();

    // Get all menu items of a particular restaurant
    List<Menu> getMenuItemsByRestaurant(int restaurantId);

    // Update a menu item
    boolean updateMenuItem(Menu menu);

    // Delete a menu item
    boolean deleteMenuItem(int menuId);
}
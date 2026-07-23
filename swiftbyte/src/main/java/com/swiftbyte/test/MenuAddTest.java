package com.swiftbyte.test;

import com.swiftbyte.dao.MenuDAO;
import com.swiftbyte.dao.impl.MenuDAOImpl;
import com.swiftbyte.model.Menu;

public class MenuAddTest {

    public static void main(String[] args) {

        Menu menu = new Menu();

        // Make sure restaurant_id = 1 exists in the restaurants table.
        menu.setRestaurantId(2);
        menu.setItemName("Chicken Burger");
        menu.setDescription("Juicy grilled chicken burger with cheese");
        menu.setPrice(199.00);
        menu.setCategory("Burger");
        menu.setAvailable(true);
        menu.setImageUrl("images/chicken_burger.jpg");

        MenuDAO menuDAO = new MenuDAOImpl();

        boolean status = menuDAO.addMenuItem(menu);

        if (status) {
            System.out.println("Menu item added successfully.");
        } else {
            System.out.println("Failed to add menu item.");
        }
    }
}
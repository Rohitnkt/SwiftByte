package com.swiftbyte.test;

import com.swiftbyte.dao.MenuDAO;
import com.swiftbyte.dao.impl.MenuDAOImpl;
import com.swiftbyte.model.Menu;

public class MenuUpdateTest {

    public static void main(String[] args) {

        MenuDAO menuDAO = new MenuDAOImpl();

        Menu menu = menuDAO.getMenuById(2);

        if (menu != null) {

            menu.setItemName("Chicken Cheese Burger");
            menu.setDescription("Double cheese grilled chicken burger");
            menu.setPrice(249.00);

            boolean status = menuDAO.updateMenuItem(menu);

            if (status) {
                System.out.println("Menu item updated successfully.");
            } else {
                System.out.println("Failed to update menu item.");
            }

        } else {
            System.out.println("Menu item not found.");
        }
    }
}
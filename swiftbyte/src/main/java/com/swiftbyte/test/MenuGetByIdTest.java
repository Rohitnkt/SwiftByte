package com.swiftbyte.test;

import com.swiftbyte.dao.MenuDAO;
import com.swiftbyte.dao.impl.MenuDAOImpl;
import com.swiftbyte.model.Menu;

public class MenuGetByIdTest {

    public static void main(String[] args) {

        MenuDAO menuDAO = new MenuDAOImpl();

        Menu menu = menuDAO.getMenuById(2);

        if (menu != null) {

            System.out.println("Menu ID       : " + menu.getMenuId());
            System.out.println("Restaurant ID : " + menu.getRestaurantId());
            System.out.println("Item Name     : " + menu.getItemName());
            System.out.println("Description   : " + menu.getDescription());
            System.out.println("Price         : " + menu.getPrice());
            System.out.println("Category      : " + menu.getCategory());
            System.out.println("Available     : " + menu.isAvailable());
            System.out.println("Image URL     : " + menu.getImageUrl());

        } else {

            System.out.println("Menu item not found.");
        }
    }
}
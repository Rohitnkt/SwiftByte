package com.swiftbyte.test;

import java.util.List;
import java.util.ArrayList;
import com.swiftbyte.dao.MenuDAO;
import com.swiftbyte.dao.impl.MenuDAOImpl;
import com.swiftbyte.model.Menu;

public class MenuGetAllTest {

    public static void main(String[] args) {

        MenuDAO menuDAO = new MenuDAOImpl();

        List<Menu> menuList = menuDAO.getAllMenuItems();

        if (menuList.isEmpty()) {
            System.out.println("No menu items found.");
        } else {

            for (Menu menu : menuList) {

                System.out.println("------------------------------");
                System.out.println("Menu ID       : " + menu.getMenuId());
                System.out.println("Restaurant ID : " + menu.getRestaurantId());
                System.out.println("Item Name     : " + menu.getItemName());
                System.out.println("Description   : " + menu.getDescription());
                System.out.println("Price         : " + menu.getPrice());
                System.out.println("Category      : " + menu.getCategory());
                System.out.println("Available     : " + menu.isAvailable());
                System.out.println("Image URL     : " + menu.getImageUrl());
            }
        }
    }
}
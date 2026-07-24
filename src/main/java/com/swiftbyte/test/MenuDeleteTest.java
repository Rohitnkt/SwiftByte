package com.swiftbyte.test;

import com.swiftbyte.dao.MenuDAO;
import com.swiftbyte.dao.impl.MenuDAOImpl;

public class MenuDeleteTest {

    public static void main(String[] args) {

        MenuDAO menuDAO = new MenuDAOImpl();

        boolean status = menuDAO.deleteMenuItem(2);

        if (status) {
            System.out.println("Menu item deleted successfully.");
        } else {
            System.out.println("Menu item not found.");
        }
    }
}
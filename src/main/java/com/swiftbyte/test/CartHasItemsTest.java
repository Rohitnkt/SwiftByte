package com.swiftbyte.test;

import com.swiftbyte.dao.CartDAO;
import com.swiftbyte.dao.impl.CartDAOImpl;

public class CartHasItemsTest {

    public static void main(String[] args) {

        CartDAO cartDAO = new CartDAOImpl();

        boolean hasItems = cartDAO.hasCartItems(2);
        if (hasItems) {
            System.out.println("Cart contains items.");
        } else {
            System.out.println("Cart is empty.");
        }
    }
}
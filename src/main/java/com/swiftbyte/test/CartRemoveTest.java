package com.swiftbyte.test;

import com.swiftbyte.dao.CartDAO;
import com.swiftbyte.dao.impl.CartDAOImpl;

public class CartRemoveTest {

    public static void main(String[] args) {

        CartDAO cartDAO = new CartDAOImpl();

        boolean status = cartDAO.removeCartItem(2);

        if (status) {
            System.out.println("Cart item removed successfully.");
        } else {
            System.out.println("Failed to remove cart item.");
        }
    }
}
package com.swiftbyte.test;

import com.swiftbyte.dao.CartDAO;
import com.swiftbyte.dao.impl.CartDAOImpl;

public class CartClearTest {

    public static void main(String[] args) {

        CartDAO cartDAO = new CartDAOImpl();

        boolean status = cartDAO.clearCart(2);

        if (status) {
            System.out.println("Cart cleared successfully.");
        } else {
            System.out.println("Failed to clear cart.");
        }
    }
}
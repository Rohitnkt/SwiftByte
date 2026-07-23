package com.swiftbyte.test;

import com.swiftbyte.dao.CartDAO;
import com.swiftbyte.dao.impl.CartDAOImpl;
import com.swiftbyte.model.Cart;

public class CartUserMenuTest {

    public static void main(String[] args) {

        CartDAO dao = new CartDAOImpl();

        Cart cart = dao.getCartItemByUserAndMenu(2, 3);

        if (cart != null) {

            System.out.println("Cart Found");
            System.out.println("----------------------");
            System.out.println("Cart ID : " + cart.getCartId());
            System.out.println("Quantity : " + cart.getQuantity());
            System.out.println("Unit Price : " + cart.getUnitPrice());
            System.out.println("Total Price : " + cart.getTotalPrice());

        } else {

            System.out.println("Cart Item Not Found");

        }
    }
}
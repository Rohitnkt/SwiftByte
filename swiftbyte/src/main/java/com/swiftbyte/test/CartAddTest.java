package com.swiftbyte.test;

import com.swiftbyte.dao.CartDAO;
import com.swiftbyte.dao.impl.CartDAOImpl;
import com.swiftbyte.model.Cart;

public class CartAddTest {

    public static void main(String[] args) {

        Cart cart = new Cart();

        // Existing IDs in the database
        cart.setUserId(2);
        cart.setRestaurantId(2);
        cart.setMenuId(3);
        cart.setQuantity(2);
        cart.setUnitPrice(199.00);
        cart.setTotalPrice(398.00);

        CartDAO cartDAO = new CartDAOImpl();

        boolean status = cartDAO.addToCart(cart);

        if (status) {
            System.out.println("Item added to cart successfully.");
        } else {
            System.out.println("Failed to add item to cart.");
        }
    }
}
package com.swiftbyte.test;

import com.swiftbyte.dao.CartDAO;
import com.swiftbyte.dao.impl.CartDAOImpl;
import com.swiftbyte.model.Cart;

public class CartUpdateTest {

    public static void main(String[] args) {

        CartDAO cartDAO = new CartDAOImpl();

        // Fetch existing cart item
        Cart cart = cartDAO.getCartItemById(2);

        if (cart != null) {

            // Update values
            cart.setQuantity(3);
            cart.setUnitPrice(199.00);
            cart.setTotalPrice(597.00);

            boolean status = cartDAO.updateCartItem(cart);

            if (status) {
                System.out.println("Cart updated successfully.");
            } else {
                System.out.println("Failed to update cart.");
            }

        } else {

            System.out.println("Cart item not found.");
        }
    }
}
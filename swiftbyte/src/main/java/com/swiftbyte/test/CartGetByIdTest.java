package com.swiftbyte.test;

import com.swiftbyte.dao.CartDAO;
import com.swiftbyte.dao.impl.CartDAOImpl;
import com.swiftbyte.model.Cart;
import java.sql.ResultSet;
public class CartGetByIdTest {

    public static void main(String[] args) {

        CartDAO cartDAO = new CartDAOImpl();

        Cart cart = cartDAO.getCartItemById(2);

        
        if (cart != null) {

            System.out.println("Cart ID        : " + cart.getCartId());
            System.out.println("User ID        : " + cart.getUserId());
            System.out.println("Restaurant ID  : " + cart.getRestaurantId());
            System.out.println("Menu ID        : " + cart.getMenuId());
            System.out.println("Quantity       : " + cart.getQuantity());
            System.out.println("Total Price    : " + cart.getTotalPrice());

        } else {

            System.out.println("Cart item not found.");

        }
    }
}
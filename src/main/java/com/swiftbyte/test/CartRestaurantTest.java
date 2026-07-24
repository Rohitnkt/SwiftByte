package com.swiftbyte.test;

import com.swiftbyte.dao.CartDAO;
import com.swiftbyte.dao.impl.CartDAOImpl;

public class CartRestaurantTest {

    public static void main(String[] args) {

        CartDAO cartDAO = new CartDAOImpl();

        Integer restaurantId = cartDAO.getRestaurantIdInCart(2);

        if (restaurantId != null) {
            System.out.println("Restaurant ID in Cart : " + restaurantId);
        } else {
            System.out.println("Cart is empty.");
        }
    }
}
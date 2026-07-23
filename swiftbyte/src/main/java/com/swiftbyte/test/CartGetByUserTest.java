package com.swiftbyte.test;

import java.util.List;

import com.swiftbyte.dao.CartDAO;
import com.swiftbyte.dao.impl.CartDAOImpl;
import com.swiftbyte.model.Cart;

public class CartGetByUserTest {

    public static void main(String[] args) {

        CartDAO cartDAO = new CartDAOImpl();

        List<Cart> cartList = cartDAO.getCartByUser(2);

        if (cartList.isEmpty()) {

            System.out.println("Cart is empty.");

        } else {

            for (Cart cart : cartList) {

                System.out.println("----------------------------");
                System.out.println("Cart ID        : " + cart.getCartId());
                System.out.println("User ID        : " + cart.getUserId());
                System.out.println("Restaurant ID  : " + cart.getRestaurantId());
                System.out.println("Menu ID        : " + cart.getMenuId());
                System.out.println("Quantity       : " + cart.getQuantity());
                System.out.println("Total Price    : " + cart.getTotalPrice());
            }
        }
    }
}
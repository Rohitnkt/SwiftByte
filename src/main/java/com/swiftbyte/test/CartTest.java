package com.swiftbyte.test;

import com.swiftbyte.model.Cart;

public class CartTest {

    public static void main(String[] args) {

        Cart cart = new Cart();

        cart.setCartId(1);
        cart.setUserId(1);
        cart.setRestaurantId(2);
        cart.setMenuId(2);
        cart.setQuantity(2);
        cart.setTotalPrice(398.00);

        System.out.println("Cart ID        : " + cart.getCartId());
        System.out.println("User ID        : " + cart.getUserId());
        System.out.println("Restaurant ID  : " + cart.getRestaurantId());
        System.out.println("Menu ID        : " + cart.getMenuId());
        System.out.println("Quantity       : " + cart.getQuantity());
        System.out.println("Total Price    : " + cart.getTotalPrice());
    }
}
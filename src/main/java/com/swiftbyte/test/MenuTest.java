package com.swiftbyte.test;

import com.swiftbyte.model.Menu;

public class MenuTest {

    public static void main(String[] args) {
        Menu menu = new Menu();

        menu.setMenuId(1);
        menu.setRestaurantId(1);
        menu.setItemName("Chicken Burger");
        menu.setDescription("Grilled chicken burger with cheese");
        menu.setPrice(199.00);
        menu.setCategory("Burger");
        menu.setAvailable(true);
        menu.setImageUrl("images/chicken_burger.jpg");

        System.out.println("Menu ID          : " + menu.getMenuId());
        System.out.println("Restaurant ID    : " + menu.getRestaurantId());
        System.out.println("Item Name        : " + menu.getItemName());
        System.out.println("Description      : " + menu.getDescription());
        System.out.println("Price            : " + menu.getPrice());
        System.out.println("Category         : " + menu.getCategory());
        System.out.println("Available        : " + menu.isAvailable());
        System.out.println("Image URL        : " + menu.getImageUrl());
    }
}
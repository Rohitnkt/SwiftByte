package com.swiftbyte.model;

import java.sql.Timestamp;

/**
 * Cart header model.
 * One cart per user. Line items are stored separately in CartItem.
 */
public class Cart {

    private int cartId;
    private int userId;
    private int restaurantId;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Cart() {
    }

    public Cart(int userId, int restaurantId) {
        this.userId = userId;
        this.restaurantId = restaurantId;
    }

    public int getCartId() {
        return cartId;
    }

    public void setCartId(int cartId) {
        this.cartId = cartId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }
}

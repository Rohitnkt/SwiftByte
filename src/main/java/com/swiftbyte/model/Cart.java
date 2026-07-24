package com.swiftbyte.model;

import java.sql.Timestamp;

public class Cart {

    private int cartId;
    private int userId;
    private int restaurantId;
    private int menuId;
    private int quantity;
    private double unitPrice;
    private double totalPrice;
    private Timestamp createdAt;
    private Timestamp updatedAt;
  
    // Default Constructor
    public Cart() {
    }

    // Parameterized Constructor
    public Cart(int cartId, int userId, int restaurantId,
                int menuId, int quantity,double unitPrice, double totalPrice,
                Timestamp createdAt, Timestamp updatedAt) {

        this.cartId = cartId;
        this.userId = userId;
        this.restaurantId = restaurantId;
        this.menuId = menuId;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.totalPrice = totalPrice;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
       
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

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
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
    
    public double getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(double unitPrice) {
        this.unitPrice = unitPrice;
    }
}
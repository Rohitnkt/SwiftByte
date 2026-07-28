package com.swiftbyte.model;

import java.sql.Time;
import java.sql.Timestamp;

public class Restaurant {

    private int restaurantId;
    private int ownerId;
    private String restaurantName;
    private String cuisineType;
    private String address;
    private String phoneNumber;
    private String email;
    private Time openingTime;
    private Time closingTime;
    private double rating;
    private boolean isActive;
    private String imageUrl;
    private int deliveryTimeMin;
    private int deliveryTimeMax;
    private String promoOffer;
    private String location;
    private boolean topChain;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Restaurant() {
    }

    public Restaurant(int ownerId, String restaurantName, String cuisineType,
                      String address, String phoneNumber, String email,
                      Time openingTime, Time closingTime,
                      double rating, boolean isActive,String imagePath) {

        this.ownerId = ownerId;
        this.restaurantName = restaurantName;
        this.cuisineType = cuisineType;
        this.address = address;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.openingTime = openingTime;
        this.closingTime = closingTime;
        this.rating = rating;
        this.isActive = isActive;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public String getRestaurantName() {
        return restaurantName;
    }

    public void setRestaurantName(String restaurantName) {
        this.restaurantName = restaurantName;
    }

    public String getCuisineType() {
        return cuisineType;
    }

    public void setCuisineType(String cuisineType) {
        this.cuisineType = cuisineType;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public Time getOpeningTime() {
        return openingTime;
    }

    public void setOpeningTime(Time openingTime) {
        this.openingTime = openingTime;
    }

    public Time getClosingTime() {
        return closingTime;
    }

    public void setClosingTime(Time closingTime) {
        this.closingTime = closingTime;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
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

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getDeliveryTimeMin() {
        return deliveryTimeMin;
    }

    public void setDeliveryTimeMin(int deliveryTimeMin) {
        this.deliveryTimeMin = deliveryTimeMin;
    }

    public int getDeliveryTimeMax() {
        return deliveryTimeMax;
    }

    public void setDeliveryTimeMax(int deliveryTimeMax) {
        this.deliveryTimeMax = deliveryTimeMax;
    }

    public String getPromoOffer() {
        return promoOffer;
    }

    public void setPromoOffer(String promoOffer) {
        this.promoOffer = promoOffer;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public boolean isTopChain() {
        return topChain;
    }

    public void setTopChain(boolean topChain) {
        this.topChain = topChain;
    }

    public String getDeliveryTimeLabel() {
        if (deliveryTimeMin > 0 && deliveryTimeMax > 0) {
            return deliveryTimeMin + "-" + deliveryTimeMax + " mins";
        }
        if (deliveryTimeMin > 0) {
            return deliveryTimeMin + " mins";
        }
        return "25-35 mins";
    }
}
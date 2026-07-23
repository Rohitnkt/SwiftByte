package com.swiftbyte.dao;

import java.util.List;
import com.swiftbyte.model.Cart;

public interface CartDAO {

    // Add an item to the cart
    boolean addToCart(Cart cart);

    // Get a cart item by cart ID
    Cart getCartItemById(int cartId);
    
    // Get a cart item by user and menu
    Cart getCartItemByUserAndMenu(int userId, int menuId);

    // Get all cart items for a user
    List<Cart> getCartByUser(int userId);

    // Update quantity or total price
    boolean updateCartItem(Cart cart);

    // Remove a single cart item
    boolean removeCartItem(int cartId);

    // Remove all items of a user
    boolean clearCart(int userId);

    // Check if the cart already contains items
    boolean hasCartItems(int userId);

    // Get the restaurant associated with the current cart
    Integer getRestaurantIdInCart(int userId);
}
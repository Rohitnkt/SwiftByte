package com.swiftbyte.dao;

import java.util.List;

import com.swiftbyte.model.Cart;
import com.swiftbyte.model.CartItem;


public interface CartDAO {

    
    String addItem(int userId, int restaurantId, int menuId, int quantity, double unitPrice);

   
    Cart getCartByUser(int userId);

  
    List<CartItem> getCartItemsByUser(int userId);

   
    CartItem getCartItemById(int cartItemId);

   
    CartItem getCartItemByUserAndMenu(int userId, int menuId);

   
    boolean updateCartItem(int cartItemId, int quantity, double unitPrice);

    
    boolean removeCartItem(int cartItemId);

    
    boolean clearCart(int userId);

    
    boolean hasCartItems(int userId);

   
    Integer getRestaurantIdInCart(int userId);
}

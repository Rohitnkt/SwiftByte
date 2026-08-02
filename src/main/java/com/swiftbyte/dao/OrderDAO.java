package com.swiftbyte.dao;

import java.util.List;

import com.swiftbyte.model.Order;

public interface OrderDAO {

    /** Creates the order + its order_items in ONE transaction. Returns generated order_id (0 on failure). */
    int placeOrder(Order order);

    /** All orders of a user, newest first (items included). */
    List<Order> findByUserId(int userId);

    /** One order with its items, scoped to the user so nobody can read someone else's order. */
    Order findByIdForUser(int orderId, int userId);

    /** Cancels an order only if it is still 'Placed' and belongs to the user. 
     * @throws ClassNotFoundException */
    boolean cancelOrder(int orderId, int userId, String reason) throws ClassNotFoundException;
}

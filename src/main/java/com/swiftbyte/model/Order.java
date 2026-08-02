package com.swiftbyte.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

/**
 * Maps to table `orders`
 * order_id, user_id, restaurant_id, subtotal, delivery_fee, tax,
 * total, delivery_address, status, payment_method, created_at
 */
public class Order {

    private int orderId;
    private int userId;
    private int restaurantId;
    private BigDecimal subtotal    = BigDecimal.ZERO;
    private BigDecimal deliveryFee = BigDecimal.ZERO;
    private BigDecimal tax         = BigDecimal.ZERO;
    private BigDecimal total       = BigDecimal.ZERO;
    private String deliveryAddress;
    private String status        = "PLACED";
    private String paymentMethod = "COD";
    private Timestamp createdAt;

    /** not a DB column - filled by the DAO when loading an order */
    private List<OrderItem> items = new ArrayList<OrderItem>();

    /** not a DB column - convenience for the orders history page */
    private String restaurantName;

    public Order() { }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }

    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }

    public BigDecimal getDeliveryFee() { return deliveryFee; }
    public void setDeliveryFee(BigDecimal deliveryFee) { this.deliveryFee = deliveryFee; }

    public BigDecimal getTax() { return tax; }
    public void setTax(BigDecimal tax) { this.tax = tax; }

    public BigDecimal getTotal() { return total; }
    public void setTotal(BigDecimal total) { this.total = total; }

    public String getDeliveryAddress() { return deliveryAddress; }
    public void setDeliveryAddress(String deliveryAddress) { this.deliveryAddress = deliveryAddress; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) {
        this.items = (items == null) ? new ArrayList<OrderItem>() : items;
    }

    public String getRestaurantName() { return restaurantName; }
    public void setRestaurantName(String restaurantName) { this.restaurantName = restaurantName; }

    /** total number of dishes in the order (sum of quantities) */
    public int getTotalQuantity() {
        int q = 0;
        for (OrderItem oi : items) q += oi.getQuantity();
        return q;
    }

    @Override
    public String toString() {
        return "Order{id=" + orderId + ", userId=" + userId + ", total=" + total
             + ", status=" + status + "}";
    }
}

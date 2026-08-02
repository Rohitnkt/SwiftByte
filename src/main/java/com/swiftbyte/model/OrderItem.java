package com.swiftbyte.model;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * Maps to table `order_items`
 * order_item_id, order_id, item_id, item_name, unit_price, quantity, line_total
 */
public class OrderItem {

    private int orderItemId;
    private int orderId;
    private int itemId;
    private String itemName;
    private BigDecimal unitPrice = BigDecimal.ZERO;
    private int quantity = 1;
    private BigDecimal lineTotal = BigDecimal.ZERO;

    public OrderItem() { }

    public OrderItem(int itemId, String itemName, BigDecimal unitPrice, int quantity) {
        this.itemId = itemId;
        this.itemName = itemName;
        this.unitPrice = (unitPrice == null) ? BigDecimal.ZERO : unitPrice;
        this.quantity = quantity;
        this.lineTotal = this.unitPrice
        	    .multiply(BigDecimal.valueOf(quantity))
        	    .setScale(2, RoundingMode.HALF_UP);

        
    }

    public int getOrderItemId() { return orderItemId; }
    public void setOrderItemId(int orderItemId) { this.orderItemId = orderItemId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getItemId() { return itemId; }
    public void setItemId(int itemId) { this.itemId = itemId; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getLineTotal() { return lineTotal; }
    public void setLineTotal(BigDecimal lineTotal) { this.lineTotal = lineTotal; }

    @Override
    public String toString() {
        return "OrderItem{" + itemName + " x" + quantity + " = " + lineTotal + "}";
    }
}

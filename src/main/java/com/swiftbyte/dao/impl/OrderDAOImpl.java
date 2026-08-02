package com.swiftbyte.dao.impl;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.swiftbyte.dao.OrderDAO;
import com.swiftbyte.model.Order;
import com.swiftbyte.model.OrderItem;
import com.swiftbyte.util.DBConnection;   // <-- change to YOUR connection class if different

public class OrderDAOImpl implements OrderDAO {

    private static final String INSERT_ORDER =
        "INSERT INTO orders (user_id, restaurant_id, subtotal, delivery_fee, tax, total, " +
        "delivery_address, status, payment_method) VALUES (?,?,?,?,?,?,?,?,?)";

    private static final String INSERT_ITEM =
        "INSERT INTO order_items (order_id, item_id, item_name, unit_price, quantity, line_total) " +
        "VALUES (?,?,?,?,?,?)";

    /*private static final String SELECT_BY_USER =
        "SELECT o.*, r.name AS restaurant_name FROM orders o " +
        "LEFT JOIN restaurants r ON r.restaurant_id = o.restaurant_id " +
        "WHERE o.user_id = ? ORDER BY o.order_id DESC";*/
    private static final String SELECT_BY_USER =
    	    "SELECT o.*, r.restaurant_name AS restaurant_name FROM orders o " +
    	    "LEFT JOIN restaurants r ON r.restaurant_id = o.restaurant_id " +
    	    "WHERE o.user_id = ? ORDER BY o.order_id DESC";

    /*private static final String SELECT_ONE =
        "SELECT o.*, r.name AS restaurant_name FROM orders o " +
        "LEFT JOIN restaurants r ON r.restaurant_id = o.restaurant_id " +
        "WHERE o.order_id = ? AND o.user_id = ?";*/
    
    private static final String SELECT_ONE =
    	    "SELECT o.*, r.restaurant_name AS restaurant_name FROM orders o " +
    	    "LEFT JOIN restaurants r ON r.restaurant_id = o.restaurant_id " +
    	    "WHERE o.order_id = ? AND o.user_id = ?";
    private static final String SELECT_ITEMS =
        "SELECT * FROM order_items WHERE order_id = ? ORDER BY order_item_id";

    @Override
    public int placeOrder(Order order) {
        if (order == null || order.getItems().isEmpty()) return 0;

        Connection con = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            int orderId = 0;
            try (PreparedStatement ps = con.prepareStatement(INSERT_ORDER, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, order.getUserId());
                ps.setInt(2, order.getRestaurantId());
                ps.setBigDecimal(3, nz(order.getSubtotal()));
                ps.setBigDecimal(4, nz(order.getDeliveryFee()));
                ps.setBigDecimal(5, nz(order.getTax()));
                ps.setBigDecimal(6, nz(order.getTotal()));
                ps.setString(7, order.getDeliveryAddress());
                ps.setString(8, order.getStatus() == null ? "PLACED" : order.getStatus());
                ps.setString(9, order.getPaymentMethod() == null ? "COD" : order.getPaymentMethod());
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) orderId = keys.getInt(1);
                }
            }

            if (orderId == 0) { con.rollback(); return 0; }

            try (PreparedStatement ps = con.prepareStatement(INSERT_ITEM)) {
                for (OrderItem oi : order.getItems()) {
                    BigDecimal unit = nz(oi.getUnitPrice());
                    BigDecimal line = (oi.getLineTotal() == null || oi.getLineTotal().signum() == 0)
                            ? unit.multiply(BigDecimal.valueOf(oi.getQuantity()))
                            : oi.getLineTotal();
                    ps.setInt(1, orderId);
                    ps.setInt(2, oi.getItemId());
                    ps.setString(3, oi.getItemName());
                    ps.setBigDecimal(4, unit);
                    ps.setInt(5, oi.getQuantity());
                    ps.setBigDecimal(6, line);
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            con.commit();
            order.setOrderId(orderId);
            return orderId;

        } catch (Exception e) {
            if (con != null) try { con.rollback(); } catch (SQLException ignore) { }
            e.printStackTrace();
            return 0;
        } finally {
            if (con != null) {
                try { con.setAutoCommit(true); } catch (SQLException ignore) { }
                try { con.close(); } catch (SQLException ignore) { }
            }
        }
    }

    
    @Override
    public boolean cancelOrder(int orderId, int userId, String reason) throws ClassNotFoundException {
        String sql = "UPDATE orders SET status = 'Cancelled', cancellation_reason = ? " +
                     "WHERE order_id = ? AND user_id = ? AND status = 'Placed'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, reason != null ? reason.trim() : null);
            ps.setInt(2, orderId);
            ps.setInt(3, userId);

            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
     
    
    @Override
    public List<Order> findByUserId(int userId) {
        List<Order> list = new ArrayList<Order>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SELECT_BY_USER)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
            for (Order o : list) o.setItems(loadItems(con, o.getOrderId()));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Order findByIdForUser(int orderId, int userId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(SELECT_ONE)) {
            ps.setInt(1, orderId);
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order o = map(rs);
                    o.setItems(loadItems(con, orderId));
                    return o;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private List<OrderItem> loadItems(Connection con, int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<OrderItem>();
        try (PreparedStatement ps = con.prepareStatement(SELECT_ITEMS)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem oi = new OrderItem();
                    oi.setOrderItemId(rs.getInt("order_item_id"));
                    oi.setOrderId(rs.getInt("order_id"));
                    oi.setItemId(rs.getInt("item_id"));
                    oi.setItemName(rs.getString("item_name"));
                    oi.setUnitPrice(rs.getBigDecimal("unit_price"));
                    oi.setQuantity(rs.getInt("quantity"));
                    oi.setLineTotal(rs.getBigDecimal("line_total"));
                    items.add(oi);
                }
            }
        }
        return items;
    }

    private Order map(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setUserId(rs.getInt("user_id"));
        o.setRestaurantId(rs.getInt("restaurant_id"));
        o.setSubtotal(rs.getBigDecimal("subtotal"));
        o.setDeliveryFee(rs.getBigDecimal("delivery_fee"));
        o.setTax(rs.getBigDecimal("tax"));
        o.setTotal(rs.getBigDecimal("total"));
        o.setDeliveryAddress(rs.getString("delivery_address"));
        o.setStatus(rs.getString("status"));
        o.setPaymentMethod(rs.getString("payment_method"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        try { o.setRestaurantName(rs.getString("restaurant_name")); } catch (SQLException ignore) { }
        return o;
    }

    private BigDecimal nz(BigDecimal b) { return b == null ? BigDecimal.ZERO : b; }
}

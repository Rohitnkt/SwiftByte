package com.swiftbyte.dao.impl;

import com.swiftbyte.dao.CartDAO;
import com.swiftbyte.model.Cart;
import com.swiftbyte.model.CartItem;
import com.swiftbyte.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class CartDAOImpl implements CartDAO {

    private static final String CREATE_CART =
            "INSERT INTO cart (user_id, restaurant_id) VALUES (?, ?)";

    private static final String GET_CART_BY_USER =
            "SELECT cart_id, user_id, restaurant_id, created_at, updated_at " +
                    "FROM cart WHERE user_id = ?";

    private static final String ADD_CART_ITEM =
            "INSERT INTO cart_items (cart_id, menu_id, quantity, unit_price, total_price) " +
                    "VALUES (?, ?, ?, ?, ?) " +
                    "ON DUPLICATE KEY UPDATE quantity = quantity + VALUES(quantity), " +
                    "total_price = (quantity + VALUES(quantity)) * unit_price";

    private static final String GET_CART_ITEM_BY_ID =
            "SELECT cart_item_id, cart_id, menu_id, quantity, unit_price, total_price, created_at, updated_at " +
                    "FROM cart_items WHERE cart_item_id = ?";

    private static final String GET_CART_ITEM_BY_USER_AND_MENU =
            "SELECT ci.cart_item_id, ci.cart_id, ci.menu_id, ci.quantity, ci.unit_price, ci.total_price, " +
                    "ci.created_at, ci.updated_at " +
                    "FROM cart c JOIN cart_items ci ON c.cart_id = ci.cart_id " +
                    "WHERE c.user_id = ? AND ci.menu_id = ?";

    private static final String GET_CART_ITEMS_BY_USER =
            "SELECT ci.cart_item_id, ci.cart_id, ci.menu_id, ci.quantity, ci.unit_price, ci.total_price, " +
                    "mi.item_name, mi.image_url, ci.created_at, ci.updated_at " +
                    "FROM cart c " +
                    "JOIN cart_items ci ON c.cart_id = ci.cart_id " +
                    "JOIN menu_items mi ON ci.menu_id = mi.menu_id " +
                    "WHERE c.user_id = ? " +
                    "ORDER BY ci.created_at";

    private static final String UPDATE_CART_ITEM =
            "UPDATE cart_items SET quantity = ?, total_price = ? WHERE cart_item_id = ?";

    private static final String REMOVE_CART_ITEM =
            "DELETE FROM cart_items WHERE cart_item_id = ?";

    private static final String CLEAR_CART_ITEMS =
            "DELETE ci FROM cart_items ci JOIN cart c ON ci.cart_id = c.cart_id WHERE c.user_id = ?";

    private static final String DELETE_CART =
            "DELETE FROM cart WHERE user_id = ?";

    private static final String HAS_CART_ITEMS =
            "SELECT COUNT(*) FROM cart c JOIN cart_items ci ON c.cart_id = ci.cart_id WHERE c.user_id = ?";

    private static final String GET_RESTAURANT_ID_IN_CART =
            "SELECT restaurant_id FROM cart WHERE user_id = ?";

    // ---------- Helpers ----------

    private Cart mapCart(ResultSet rs) throws SQLException {
        Cart cart = new Cart();
        cart.setCartId(rs.getInt("cart_id"));
        cart.setUserId(rs.getInt("user_id"));
        cart.setRestaurantId(rs.getInt("restaurant_id"));
        cart.setCreatedAt(rs.getTimestamp("created_at"));
        cart.setUpdatedAt(rs.getTimestamp("updated_at"));
        return cart;
    }

    private CartItem mapCartItem(ResultSet rs) throws SQLException {
        CartItem item = new CartItem();
        item.setCartItemId(rs.getInt("cart_item_id"));
        item.setCartId(rs.getInt("cart_id"));
        item.setMenuId(rs.getInt("menu_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setUnitPrice(rs.getDouble("unit_price"));
        item.setTotalPrice(rs.getDouble("total_price"));

        // Optional joined columns from menu_items
        try {
            item.setItemName(rs.getString("item_name"));
        } catch (SQLException ignored) {
        }
        try {
            item.setImageUrl(rs.getString("image_url"));
        } catch (SQLException ignored) {
        }

        item.setCreatedAt(rs.getTimestamp("created_at"));
        item.setUpdatedAt(rs.getTimestamp("updated_at"));
        return item;
    }

    @Override
    public Cart getCartByUser(int userId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_CART_BY_USER)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapCart(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    
    @Override
    public String addItem(int userId, int restaurantId, int menuId, int quantity, double unitPrice) {
        if (quantity <= 0) {
            return "Quantity must be greater than zero.";
        }

        Cart cart = getCartByUser(userId);

        if (cart == null) {
            // No cart yet -> create header
            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(CREATE_CART, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, userId);
                ps.setInt(2, restaurantId);
                ps.executeUpdate();
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    cart = new Cart();
                    cart.setCartId(keys.getInt(1));
                    cart.setUserId(userId);
                    cart.setRestaurantId(restaurantId);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                return "Could not create cart.";
            }
        } else if (cart.getRestaurantId() != restaurantId) {
            return "You can only order from one restaurant at a time. " +
                    "Please clear your cart or complete the current order first.";
        }

        double totalPrice = quantity * unitPrice;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(ADD_CART_ITEM)) {
            ps.setInt(1, cart.getCartId());
            ps.setInt(2, menuId);
            ps.setInt(3, quantity);
            ps.setDouble(4, unitPrice);
            ps.setDouble(5, totalPrice);
            ps.executeUpdate();
            return null;
        } catch (SQLException e) {
            e.printStackTrace();
            return "Could not add item to cart.";
        }
    }

    @Override
    public CartItem getCartItemById(int cartItemId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_CART_ITEM_BY_ID)) {
            ps.setInt(1, cartItemId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapCartItem(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public CartItem getCartItemByUserAndMenu(int userId, int menuId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_CART_ITEM_BY_USER_AND_MENU)) {
            ps.setInt(1, userId);
            ps.setInt(2, menuId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapCartItem(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<CartItem> getCartItemsByUser(int userId) {
        List<CartItem> items = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_CART_ITEMS_BY_USER)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                items.add(mapCartItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }

    @Override
    public boolean updateCartItem(int cartItemId, int quantity, double unitPrice) {
        if (quantity <= 0) {
            return false;
        }
        double totalPrice = quantity * unitPrice;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(UPDATE_CART_ITEM)) {
            ps.setInt(1, quantity);
            ps.setDouble(2, totalPrice);
            ps.setInt(3, cartItemId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean removeCartItem(int cartItemId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(REMOVE_CART_ITEM)) {
            ps.setInt(1, cartItemId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean clearCart(int userId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement psClear = con.prepareStatement(CLEAR_CART_ITEMS);
             PreparedStatement psDelete = con.prepareStatement(DELETE_CART)) {
            psClear.setInt(1, userId);
            psClear.executeUpdate();
            psDelete.setInt(1, userId);
            return psDelete.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean hasCartItems(int userId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(HAS_CART_ITEMS)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public Integer getRestaurantIdInCart(int userId) {
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(GET_RESTAURANT_ID_IN_CART)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("restaurant_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}

package com.swiftbyte.dao.impl;
import java.util.List;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;
import com.swiftbyte.dao.CartDAO;
import com.swiftbyte.model.Cart;
import com.swiftbyte.util.DBConnection;
import java.util.ArrayList;
public class CartDAOImpl implements CartDAO {

	private static final String INSERT_CART =
		    "INSERT INTO cart (user_id, restaurant_id, menu_id, quantity, unit_price, total_price) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String GET_CART_BY_ID =
            "SELECT * FROM cart WHERE cart_id = ?";
    private static final String GET_CART_BY_USER =
            "SELECT * FROM cart WHERE user_id = ?";
    private static final String GET_CART_BY_USER_AND_MENU =
    	    "SELECT * FROM cart WHERE user_id = ? AND menu_id = ?";
    private static final String UPDATE_CART =
    	    "UPDATE cart SET quantity = ?, unit_price = ?, total_price = ? WHERE cart_id = ?";
    private static final String DELETE_CART =
            "DELETE FROM cart WHERE cart_id = ?";
    private static final String CLEAR_CART =
            "DELETE FROM cart WHERE user_id = ?";
    private static final String HAS_CART_ITEMS =
            "SELECT COUNT(*) FROM cart WHERE user_id = ?";
    private static final String GET_RESTAURANT_ID_IN_CART =
            "SELECT restaurant_id FROM cart WHERE user_id = ? LIMIT 1";
    @Override
    public boolean addToCart(Cart cart) {

    	  try (Connection con = DBConnection.getConnection();
    		         PreparedStatement pstmt = con.prepareStatement(INSERT_CART)) {

    		        pstmt.setInt(1, cart.getUserId());
    		        pstmt.setInt(2, cart.getRestaurantId());
    		        pstmt.setInt(3, cart.getMenuId());
    		        pstmt.setInt(4, cart.getQuantity());
    		        pstmt.setDouble(5, cart.getUnitPrice());
    		        pstmt.setDouble(6, cart.getTotalPrice());

    		        return pstmt.executeUpdate() > 0;

    		    } catch (SQLException e) {
    		        e.printStackTrace();
    		    }

    		    return false;
    		}

    @Override
    public Cart getCartItemById(int cartId) {
    	Cart cart = null;
    	    try (Connection con = DBConnection.getConnection();
    	         PreparedStatement pstmt = con.prepareStatement(GET_CART_BY_ID)) {

    	        pstmt.setInt(1, cartId);

    	        ResultSet rs = pstmt.executeQuery();

    	        if (rs.next()) {

    	            cart = new Cart();

    	            cart.setCartId(rs.getInt("cart_id"));
    	            cart.setUserId(rs.getInt("user_id"));
    	            cart.setRestaurantId(rs.getInt("restaurant_id"));
    	            cart.setMenuId(rs.getInt("menu_id"));
    	            cart.setQuantity(rs.getInt("quantity"));
    	            cart.setTotalPrice(rs.getDouble("total_price"));
    	            cart.setTotalPrice(rs.getDouble("total_price"));
    	            cart.setCreatedAt(rs.getTimestamp("created_at"));
    	            cart.setUpdatedAt(rs.getTimestamp("updated_at"));
    	        }

    	    } catch (SQLException e) {
    	        e.printStackTrace();
    	    }

    	    return cart;
    	
    }

    @Override
    public List<Cart> getCartByUser(int userId) {
    	List<Cart> cartList = new ArrayList<>();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_CART_BY_USER)) {

            pstmt.setInt(1, userId);

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {

                Cart cart = new Cart();

                cart.setCartId(rs.getInt("cart_id"));
                cart.setUserId(rs.getInt("user_id"));
                cart.setRestaurantId(rs.getInt("restaurant_id"));
                cart.setMenuId(rs.getInt("menu_id"));
                cart.setQuantity(rs.getInt("quantity"));
                cart.setUnitPrice(rs.getDouble("unit_price"));
                cart.setTotalPrice(rs.getDouble("total_price"));
                cart.setCreatedAt(rs.getTimestamp("created_at"));
                cart.setUpdatedAt(rs.getTimestamp("updated_at"));

                cartList.add(cart);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cartList;
    }
    @Override
    public Cart getCartItemByUserAndMenu(int userId, int menuId) {

        Cart cart = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pstmt = con.prepareStatement(GET_CART_BY_USER_AND_MENU)) {

            pstmt.setInt(1, userId);
            pstmt.setInt(2, menuId);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {

                cart = new Cart();

                cart.setCartId(rs.getInt("cart_id"));
                cart.setUserId(rs.getInt("user_id"));
                cart.setRestaurantId(rs.getInt("restaurant_id"));
                cart.setMenuId(rs.getInt("menu_id"));
                cart.setQuantity(rs.getInt("quantity"));
                cart.setUnitPrice(rs.getDouble("unit_price"));
                cart.setTotalPrice(rs.getDouble("total_price"));
                cart.setCreatedAt(rs.getTimestamp("created_at"));
                cart.setUpdatedAt(rs.getTimestamp("updated_at"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return cart;
    }

    @Override
    public boolean updateCartItem(Cart cart) {
    	try (Connection con = DBConnection.getConnection();
    	         PreparedStatement pstmt = con.prepareStatement(UPDATE_CART)) {

    	        pstmt.setInt(1, cart.getQuantity());
    	        pstmt.setDouble(2, cart.getUnitPrice());
    	        pstmt.setDouble(3, cart.getTotalPrice());
    	        pstmt.setInt(4, cart.getCartId());

    	        return pstmt.executeUpdate() > 0;

    	    } catch (SQLException e) {
    	        e.printStackTrace();
    	    }

    	    return false;
    }

    @Override
    public boolean removeCartItem(int cartId) {
    	 try (Connection con = DBConnection.getConnection();
    	         PreparedStatement pstmt = con.prepareStatement(DELETE_CART)) {

    	        pstmt.setInt(1, cartId);

    	        return pstmt.executeUpdate() > 0;

    	    } catch (SQLException e) {
    	        e.printStackTrace();
    	    }

    	    return false;
    }

    @Override
    public boolean clearCart(int userId) {
    	try (Connection con = DBConnection.getConnection();
    	         PreparedStatement pstmt = con.prepareStatement(CLEAR_CART)) {

    	        pstmt.setInt(1, userId);

    	        return pstmt.executeUpdate() > 0;

    	    } catch (SQLException e) {
    	        e.printStackTrace();
    	    }

    	    return false;
    }

    @Override
    public boolean hasCartItems(int userId) {
    	try (Connection con = DBConnection.getConnection();
    	         PreparedStatement pstmt = con.prepareStatement(HAS_CART_ITEMS)) {

    	        pstmt.setInt(1, userId);

    	        ResultSet rs = pstmt.executeQuery();

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
    	         PreparedStatement pstmt = con.prepareStatement(GET_RESTAURANT_ID_IN_CART)) {

    	        pstmt.setInt(1, userId);

    	        ResultSet rs = pstmt.executeQuery();

    	        if (rs.next()) {
    	            return rs.getInt("restaurant_id");
    	        }

    	    } catch (SQLException e) {
    	        e.printStackTrace();
    	    }

    	    return null;
    }
}
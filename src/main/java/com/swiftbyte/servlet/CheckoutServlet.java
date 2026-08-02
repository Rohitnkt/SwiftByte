package com.swiftbyte.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.swiftbyte.dao.CartDAO;
import com.swiftbyte.dao.impl.CartDAOImpl;
import com.swiftbyte.model.Cart;
import com.swiftbyte.model.CartItem;
import com.swiftbyte.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Loads the logged-in user's cart and forwards to checkout.jsp.
 * No payment processing yet - order review + address confirmation only.
 */
@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        CartDAO cartDAO = new CartDAOImpl();
        Cart cart = cartDAO.getCartByUser(user.getUserId());

        List<CartItem> cartItems = cartDAO.getCartItemsByUser(user.getUserId());
        if (cartItems == null) {
            cartItems = new ArrayList<CartItem>();
        }

        double grandTotal = 0.0;
        for (CartItem item : cartItems) {
            grandTotal += item.getTotalPrice();
        }

        if (cart != null) {
            request.setAttribute("restaurantId", Integer.valueOf(cart.getRestaurantId()));
        }

        if (cartItems.isEmpty()) {
            session.setAttribute("flashMessage", "Your cart is empty.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("grandTotal", Double.valueOf(grandTotal));

        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }
}

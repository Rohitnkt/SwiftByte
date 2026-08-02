package com.swiftbyte.servlet;

import com.swiftbyte.dao.impl.CartDAOImpl;
import com.swiftbyte.model.CartItem;
import com.swiftbyte.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * Handles cart operations: add, update, remove, clear, view.
 * Enforces login and the single-restaurant rule.
 */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private final CartDAOImpl cartDAO = new CartDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = getLoggedInUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        List<CartItem> cartItems = cartDAO.getCartItemsByUser(user.getUserId());
        double grandTotal = 0;
        for (CartItem item : cartItems) {
            grandTotal += item.getTotalPrice();
        }

        Integer restaurantId = cartDAO.getRestaurantIdInCart(user.getUserId());

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("grandTotal", grandTotal);
        request.setAttribute("restaurantId", restaurantId);
        request.setAttribute("cartItemCount", cartItems.size());

        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        User user = getLoggedInUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "add";
        }

        switch (action.toLowerCase()) {
            case "add":
                handleAdd(request, response, user);
                break;
            case "update":
                handleUpdate(request, response, user);
                break;
            case "remove":
                handleRemove(request, response, user);
                break;
            case "clear":
                handleClear(request, response, user);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/cart");
        }
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        String menuIdParam = request.getParameter("menuId");
        String restaurantIdParam = request.getParameter("restaurantId");
        String quantityParam = request.getParameter("quantity");
        String unitPriceParam = request.getParameter("unitPrice");

        if (menuIdParam == null || restaurantIdParam == null || unitPriceParam == null) {
            setFlashMessage(request, "Missing item details.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        int menuId = Integer.parseInt(menuIdParam);
        int restaurantId = Integer.parseInt(restaurantIdParam);
        int quantity = (quantityParam == null || quantityParam.isEmpty()) ? 1 : Integer.parseInt(quantityParam);
        double unitPrice = Double.parseDouble(unitPriceParam);

        String error = cartDAO.addItem(user.getUserId(), restaurantId, menuId, quantity, unitPrice);

        if (error != null) {
            setFlashMessage(request, error);
        } else {
            setFlashMessage(request, "Item added to cart.");
        }

        // Redirect back to the restaurant menu so user can add more items
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect(request.getContextPath() + "/menu?restaurantId=" + restaurantId);
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        String cartItemIdParam = request.getParameter("cartItemId");
        String quantityParam = request.getParameter("quantity");
        String unitPriceParam = request.getParameter("unitPrice");

        if (cartItemIdParam == null || quantityParam == null || unitPriceParam == null) {
            setFlashMessage(request, "Missing item details.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        int cartItemId;
        int quantity;
        double unitPrice;
        try {
            cartItemId = Integer.parseInt(cartItemIdParam.trim());
            quantity = Integer.parseInt(quantityParam.trim());
            unitPrice = Double.parseDouble(unitPriceParam.trim());
        } catch (NumberFormatException e) {
            setFlashMessage(request, "Could not update quantity.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // Quantity 0 (or less) means the user wants the line item gone.
        if (quantity <= 0) {
            boolean removed = cartDAO.removeCartItem(cartItemId);
            setFlashMessage(request, removed ? "Item removed from cart." : "Could not remove item.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        boolean ok = cartDAO.updateCartItem(cartItemId, quantity, unitPrice);
        if (ok) {
            setFlashMessage(request, "Quantity updated.");
        } else {
            setFlashMessage(request, "Could not update quantity.");
        }
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void handleRemove(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        int cartItemId = Integer.parseInt(request.getParameter("cartItemId"));
        boolean ok = cartDAO.removeCartItem(cartItemId);
        if (ok) {
            setFlashMessage(request, "Item removed from cart.");
        } else {
            setFlashMessage(request, "Could not remove item.");
        }
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private void handleClear(HttpServletRequest request, HttpServletResponse response, User user)
            throws IOException {

        cartDAO.clearCart(user.getUserId());
        setFlashMessage(request, "Cart cleared.");
        response.sendRedirect(request.getContextPath() + "/cart");
    }

    private User getLoggedInUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        Object obj = session.getAttribute("user");
        return (obj instanceof User) ? (User) obj : null;
    }

    private void setFlashMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("flashMessage", message);
    }
}

package com.swiftbyte.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.List;

import com.swiftbyte.dao.CartDAO;
import com.swiftbyte.dao.OrderDAO;
import com.swiftbyte.dao.impl.CartDAOImpl;
import com.swiftbyte.dao.impl.OrderDAOImpl;
import com.swiftbyte.model.Cart;
import com.swiftbyte.model.CartItem;
import com.swiftbyte.model.Order;
import com.swiftbyte.model.OrderItem;
import com.swiftbyte.model.User;
import com.swiftbyte.util.OrderMailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * POST /place-order
 * Re-computes the bill on the server (never trusts the browser),
 * writes orders + order_items in one transaction, clears the cart,
 * sends the confirmation e-mail, then redirects to the success page.
 */
@WebServlet("/place-order")
public class PlaceOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final BigDecimal FREE_DELIVERY_ABOVE = new BigDecimal("499.00");
    private static final BigDecimal DELIVERY_FEE        = new BigDecimal("19.00");
    private static final BigDecimal PACKAGING_FEE       = new BigDecimal("10.00");
    private static final BigDecimal GST_RATE            = new BigDecimal("0.05");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // never place an order on a GET
        response.sendRedirect(request.getContextPath() + "/checkout");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        CartDAO cartDAO = new CartDAOImpl();
        Cart cart = cartDAO.getCartByUser(user.getUserId());
        List<CartItem> cartItems = cartDAO.getCartItemsByUser(user.getUserId());

        if (cart == null || cartItems == null || cartItems.isEmpty()) {
            session.setAttribute("flashError", "Your cart is empty.");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        String address = user.getDeliveryAddress();
        String typed = request.getParameter("deliveryAddress");
        if (typed != null && !typed.trim().isEmpty()) {
            address = typed.trim();
        }
        if (address == null || address.trim().isEmpty()) {
            session.setAttribute("flashError", "Please add a delivery address before placing the order.");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }
        if (address.length() > 500) {
            address = address.substring(0, 500);
        }

        String paymentMethod = request.getParameter("paymentMethod");
        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            paymentMethod = "COD";
        }
        paymentMethod = paymentMethod.trim().toUpperCase();
        if (!"COD".equals(paymentMethod) && !"UPI".equals(paymentMethod) && !"CARD".equals(paymentMethod)) {
            paymentMethod = "COD";
        }

        // ---- server-side bill (same rules as checkout.jsp) ----
        BigDecimal subtotal = BigDecimal.ZERO;
        List<OrderItem> orderItems = new ArrayList<OrderItem>();

        for (CartItem ci : cartItems) {
            BigDecimal unit = BigDecimal.valueOf(ci.getUnitPrice()).setScale(2, RoundingMode.HALF_UP);
            int qty = ci.getQuantity() < 1 ? 1 : ci.getQuantity();
            BigDecimal line = unit.multiply(BigDecimal.valueOf(qty)).setScale(2, RoundingMode.HALF_UP);
            subtotal = subtotal.add(line);

            OrderItem oi = new OrderItem();
            oi.setItemId(ci.getMenuId());
            oi.setItemName(ci.getItemName());
            oi.setUnitPrice(unit);
            oi.setQuantity(qty);
            oi.setLineTotal(line);
            orderItems.add(oi);
        }

        subtotal = subtotal.setScale(2, RoundingMode.HALF_UP);
        BigDecimal delivery = (subtotal.compareTo(FREE_DELIVERY_ABOVE) >= 0) ? BigDecimal.ZERO : DELIVERY_FEE;
        // orders table has no packaging column -> packaging is stored inside delivery_fee
        BigDecimal feeColumn = delivery.add(PACKAGING_FEE).setScale(2, RoundingMode.HALF_UP);
        BigDecimal gst = subtotal.multiply(GST_RATE).setScale(2, RoundingMode.HALF_UP);
        BigDecimal total = subtotal.add(feeColumn).add(gst).setScale(2, RoundingMode.HALF_UP);

        Order order = new Order();
        order.setUserId(user.getUserId());
        order.setRestaurantId(cart.getRestaurantId());
        order.setSubtotal(subtotal);
        order.setDeliveryFee(feeColumn);
        order.setTax(gst);
        order.setTotal(total);
        order.setDeliveryAddress(address);
        order.setStatus("Placed");
        order.setPaymentMethod(paymentMethod);
        order.setItems(orderItems);

        OrderDAO orderDAO = new OrderDAOImpl();
        int orderId = orderDAO.placeOrder(order);

        if (orderId == 0) {
            session.setAttribute("flashError", "We could not place your order. Please try again.");
            response.sendRedirect(request.getContextPath() + "/checkout");
            return;
        }

        cartDAO.clearCart(user.getUserId());

        // e-mail is best-effort: a mail failure must never fail a placed order
        try {
            OrderMailUtil.sendOrderConfirmation(user.getEmail(), user.getFullName(), order);
        } catch (Exception e) {
            e.printStackTrace();
        }

        session.setAttribute("lastOrderId", Integer.valueOf(orderId));
        response.sendRedirect(request.getContextPath() + "/order-success?id=" + orderId);
    }
}

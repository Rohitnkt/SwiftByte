package com.swiftbyte.servlet;

import com.swiftbyte.dao.OrderDAO;
import com.swiftbyte.dao.impl.OrderDAOImpl;
import com.swiftbyte.model.Order;
import com.swiftbyte.model.User;
import com.swiftbyte.util.CancelMailUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/cancel-order")
public class CancelOrderServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final OrderDAO orderDAO = new OrderDAOImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");

        // 1. Auth guard
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=session-expired");
            return;
        }

        // 2. Validate order id
        int orderId;
        try {
            orderId = Integer.parseInt(req.getParameter("orderId").trim());
            if (orderId <= 0) throw new NumberFormatException("non-positive");
        } catch (Exception e) {
            session.setAttribute("flashError", "Invalid order reference.");
            resp.sendRedirect(req.getContextPath() + "/restaurants");
            return;
        }

        // 3. Reason (optional, trimmed, length-capped)
        String reason = req.getParameter("reason");
        reason = (reason == null || reason.trim().isEmpty()) ? "Not specified" : reason.trim();
        if (reason.length() > 255) reason = reason.substring(0, 255);

        // 4. Snapshot the order BEFORE cancelling (so the mail total is accurate)
        Order order = null;
        try {
            order = orderDAO.findByIdForUser(orderId, user.getUserId());
        } catch (Exception e) {
            log("Order lookup failed for #" + orderId, e);
        }

        if (order == null) {
            session.setAttribute("flashError", "Order not found.");
            resp.sendRedirect(req.getContextPath() + "/restaurants");
            return;
        }

        // 5. Cancel
        boolean cancelled = false;
        boolean serverError = false;
        try {
            cancelled = orderDAO.cancelOrder(orderId, user.getUserId(), reason);
        } catch (ClassNotFoundException e) {
            serverError = true;
            log("JDBC driver missing while cancelling order #" + orderId, e);
        } catch (Exception e) {
            serverError = true;
            log("Cancel failed for order #" + orderId, e);
        }

        // 6. Feedback + notification
        if (cancelled) {
            session.setAttribute("flashSuccess",
                    "Order #" + orderId + " cancelled. Refund (if any) will be processed in 3-5 working days.");

            BigDecimal total = (order.getTotal() != null) ? order.getTotal() : BigDecimal.ZERO;

            try {
                CancelMailUtil.sendCancellationMail(
                        user.getEmail(),
                        user.getFullName(),
                        orderId,
                        total,reason
                );
            } catch (Exception mailEx) {
                // Never fail the cancellation because the mailer is down
                log("Cancellation mail failed for order #" + orderId, mailEx);
            }
        } else if (serverError) {
            session.setAttribute("flashError", "Something went wrong on our side. Please try again.");
        } else {
            session.setAttribute("flashError",
                    "This order can no longer be cancelled (it may already be out for delivery).");
        }

        // 7. Back to the order page
        resp.sendRedirect(req.getContextPath() + "/order-success?id=" + orderId);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        resp.sendRedirect(req.getContextPath() + "/restaurants");
    }
}

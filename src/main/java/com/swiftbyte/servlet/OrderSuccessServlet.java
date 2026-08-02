package com.swiftbyte.servlet;

import java.io.IOException;

import com.swiftbyte.dao.OrderDAO;
import com.swiftbyte.dao.impl.OrderDAOImpl;
import com.swiftbyte.model.Order;
import com.swiftbyte.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/** GET /order-success?id=123 - premium confirmation page for the just-placed order. */
@WebServlet("/order-success")
public class OrderSuccessServlet extends HttpServlet {

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

        int orderId = 0;
        try {
            orderId = Integer.parseInt(request.getParameter("id"));
        } catch (Exception ignore) {
            Object last = session.getAttribute("lastOrderId");
            if (last instanceof Integer) orderId = ((Integer) last).intValue();
        }

        Order order = (orderId > 0) ? new OrderDAOImpl().findByIdForUser(orderId, user.getUserId()) : null;

        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/restaurants");
            return;
        }

        request.setAttribute("order", order);
        request.getRequestDispatcher("/order-success.jsp").forward(request, response);
    }
}

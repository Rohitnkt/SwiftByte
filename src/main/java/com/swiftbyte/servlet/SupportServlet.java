package com.swiftbyte.servlet;

import java.io.IOException;

import com.swiftbyte.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/support")
public class SupportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/support.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderId = request.getParameter("orderId");
        String issueType = request.getParameter("issueType");
        String message = request.getParameter("message");

        if (issueType == null || issueType.trim().isEmpty() ||
            message == null || message.trim().isEmpty()) {
            session.setAttribute("flashError", "Please fill in all required fields.");
            response.sendRedirect(request.getContextPath() + "/support" +
                    (orderId != null && !orderId.isEmpty() ? "?orderId=" + orderId : ""));
            return;
        }

        // Here you can:
        // 1. Save to a support_tickets table
        // 2. Send email to support@swiftbyte.com
        // 3. Log to a file
        // For now, we show a success message.

        System.out.println("Support request from user " + user.getUserId() +
                " | Order: " + orderId +
                " | Type: " + issueType +
                " | Message: " + message.trim());

        session.setAttribute("flashSuccess",
                "Your support request has been received. We'll contact you soon.");
        response.sendRedirect(request.getContextPath() + "/support" +
                (orderId != null && !orderId.isEmpty() ? "?orderId=" + orderId : ""));
    }
}

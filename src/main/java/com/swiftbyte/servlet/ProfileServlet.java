package com.swiftbyte.servlet;

import com.swiftbyte.dao.OrderDAO;
import com.swiftbyte.dao.impl.OrderDAOImpl;
import com.swiftbyte.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAOImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }
        req.setAttribute("user", user);
        req.setAttribute("orders", orderDAO.findByUserId(user.getUserId()));
        req.getRequestDispatcher("/profile.jsp").forward(req, resp);
    }
}

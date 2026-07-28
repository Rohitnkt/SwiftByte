package com.swiftbyte.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import com.swiftbyte.dao.impl.UserDAOImpl;
import com.swiftbyte.model.User;
import com.swiftbyte.util.PasswordUtil;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAOImpl userDAO = new UserDAOImpl();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        User u = userDAO.getUserByEmail(email);

        if (u == null || !PasswordUtil.verify(password, u.getPassword())) {
            req.setAttribute("error", "Invalid email or password.");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession();
        session.setAttribute("user", u);
        session.setAttribute("userId", u.getUserId());
        session.setAttribute("role", u.getRole());

        resp.sendRedirect(req.getContextPath() + "/restaurants?login=success");
    }
}

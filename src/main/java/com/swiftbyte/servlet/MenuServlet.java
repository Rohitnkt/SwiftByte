package com.swiftbyte.servlet;

import java.io.IOException;
import java.util.List;

import com.swiftbyte.dao.impl.MenuDAOImpl;
import com.swiftbyte.dao.impl.RestaurantDAOImpl;
import com.swiftbyte.model.Menu;
import com.swiftbyte.model.Restaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            int restaurantId = Integer.parseInt(req.getParameter("restaurantId"));
            MenuDAOImpl menuDao = new MenuDAOImpl();
            RestaurantDAOImpl restDao = new RestaurantDAOImpl();

            List<Menu> menus = menuDao.getMenuItemsByRestaurant(restaurantId);
            Restaurant restaurant = restDao.getRestaurantById(restaurantId); 

            req.setAttribute("menus", menus);
            req.setAttribute("restaurant", restaurant);
            req.getRequestDispatcher("/Menu.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/restaurants");
        }
    }
}
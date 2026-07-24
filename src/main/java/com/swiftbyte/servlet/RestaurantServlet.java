package com.swiftbyte.servlet;

import java.io.IOException;
import java.util.List;

import com.swiftbyte.dao.impl.RestaurantDAOImpl;
import com.swiftbyte.model.Restaurant;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/restaurants")
public class RestaurantServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RestaurantDAOImpl restaurantDAO = new RestaurantDAOImpl();

        List<Restaurant> restaurants = restaurantDAO.getAllRestaurants();

        request.setAttribute("restaurants", restaurants);

        RequestDispatcher rd = request.getRequestDispatcher("/Restaurant.jsp");
        rd.forward(request, response);
    }
}
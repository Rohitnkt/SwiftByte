package com.swiftbyte.servlet;

import com.swiftbyte.dao.impl.UserDAOImpl;
import com.swiftbyte.model.User;
import com.swiftbyte.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAOImpl userDAO = new UserDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String fullName = trim(request.getParameter("fullName"));
        String email = trim(request.getParameter("email")).toLowerCase();
        String phoneNumber = onlyDigits(request.getParameter("phoneNumber"));
        String password = request.getParameter("password") == null ? "" : request.getParameter("password");
        String street = trim(request.getParameter("street"));
        String landmark = trim(request.getParameter("landmark"));
        String city = trim(request.getParameter("city"));
        String state = trim(request.getParameter("state"));
        String pincode = onlyDigits(request.getParameter("pincode"));

        keepOldValues(request, fullName, email, phoneNumber, street, landmark, city, state, pincode);

        if (!fullName.matches("^[A-Za-z ]{3,60}$")) {
            fail(request, response, "Enter a valid full name.");
            return;
        }

        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]{2,}$") || email.length() > 100) {
            fail(request, response, "Enter a valid email address.");
            return;
        }

        if (!phoneNumber.matches("^[6-9][0-9]{9}$")) {
            fail(request, response, "Enter a valid 10-digit Indian mobile number.");
            return;
        }

        if (!isStrongPassword(password)) {
            fail(request, response, "Password must contain uppercase, lowercase, number and special character.");
            return;
        }

        if (street.length() < 5 || street.length() > 150) {
            fail(request, response, "Enter a valid street / house / area.");
            return;
        }

        if (!city.matches("^[A-Za-z ]{2,50}$")) {
            fail(request, response, "Enter a valid city.");
            return;
        }

        if (!state.matches("^[A-Za-z ]{2,50}$")) {
            fail(request, response, "Enter a valid state.");
            return;
        }

        if (!pincode.matches("^[1-9][0-9]{5}$")) {
            fail(request, response, "Enter a valid 6-digit PIN code.");
            return;
        }

        try {
            if (userDAO.emailExists(email)) {
                fail(request, response, "This email is already registered. Please sign in.");
                return;
            }

            StringBuilder address = new StringBuilder();
            address.append(street);

            if (!landmark.isEmpty()) {
                address.append(", Near ").append(landmark);
            }

            address.append(", ").append(city);
            address.append(", ").append(state);
            address.append(" - ").append(pincode);

            User user = new User();
            user.setFullName(fullName);
            user.setEmail(email);
            //user.setPassword(password); // If you have PasswordUtil, hash here.
            user.setPassword(PasswordUtil.hash(password));   // ✅ SHA-256 hashed

            user.setPhoneNumber(phoneNumber);
            user.setDeliveryAddress(address.toString());
            user.setRole("customer");
            String hashed = PasswordUtil.hash(password);
            System.out.println("RAW: " + password);
            System.out.println("HASHED: " + hashed);
           // user.setPassword(hashed);
            boolean saved = userDAO.addUser(user);

            if (saved) {
                response.sendRedirect(request.getContextPath() + "/login.jsp?registered=success");
                
            } else {
                fail(request, response, "Could not create account. Please check your details and try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            fail(request, response, "Something went wrong. Please try again.");
        }
    }

    private String trim(String value) {
        if (value == null) {
            return "";
        }
        return value.trim().replaceAll("\\s+", " ");
    }

    private String onlyDigits(String value) {
        if (value == null) {
            return "";
        }
        return value.replaceAll("\\D", "");
    }

    private boolean isStrongPassword(String password) {
        return password != null
                && password.length() >= 8
                && password.matches(".*[A-Z].*")
                && password.matches(".*[a-z].*")
                && password.matches(".*[0-9].*")
                && password.matches(".*[^A-Za-z0-9].*");
    }

    private void keepOldValues(
            HttpServletRequest request,
            String fullName,
            String email,
            String phoneNumber,
            String street,
            String landmark,
            String city,
            String state,
            String pincode
    ) {
        request.setAttribute("fullName", fullName);
        request.setAttribute("email", email);
        request.setAttribute("phoneNumber", phoneNumber);
        request.setAttribute("street", street);
        request.setAttribute("landmark", landmark);
        request.setAttribute("city", city);
        request.setAttribute("state", state);
        request.setAttribute("pincode", pincode);
    }

    private void fail(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("error", message);
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }
}

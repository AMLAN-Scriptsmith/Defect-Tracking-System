package com.dts.servlet;

import com.dts.dao.UserDAO;
import com.dts.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    private String getLandingPathByRole(User user) {
        return "/dashboard";
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        try {
            User user = userDAO.authenticate(email, password);
            if (user == null) {
                req.setAttribute("error", "Invalid email or password");
                req.getRequestDispatcher("/signin.jsp").forward(req, resp);
                return;
            }

            HttpSession session = req.getSession(true);
            session.setAttribute("currentUser", user);
            resp.sendRedirect(req.getContextPath() + getLandingPathByRole(user));
        } catch (SQLException e) {
            String message = e.getMessage();
            if (message != null && message.toLowerCase().contains("access denied for user")) {
                req.setAttribute("error", "Database credentials are invalid. Update DB_USER/DB_PASSWORD env vars or src/main/resources/db.properties.");
                req.getRequestDispatcher("/signin.jsp").forward(req, resp);
                return;
            }
            throw new ServletException("Error while authenticating user", e);
        }
    }
}

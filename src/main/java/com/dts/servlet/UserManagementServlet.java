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
import java.sql.SQLIntegrityConstraintViolationException;
import java.sql.SQLException;
import java.util.Set;

@WebServlet("/users")
public class UserManagementServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private static final Set<String> ALLOWED_ROLES = Set.of("TEST_ENGINEER", "DEVELOPER", "PROJECT_MANAGER");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");
        if (!"ADMIN".equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        try {
            req.setAttribute("users", userDAO.findAll());
            req.getRequestDispatcher("/users.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Error fetching users", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");
        if (!"ADMIN".equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        String action = req.getParameter("action");
        try {
            switch (action) {
                case "delete" -> {
                    int userId = Integer.parseInt(req.getParameter("userId"));
                    userDAO.deleteUser(userId);
                    resp.sendRedirect(req.getContextPath() + "/users?deleted=true");
                }
                case "create" -> {
                    String fullName = req.getParameter("fullName");
                    String email = req.getParameter("email");
                    String password = req.getParameter("password");
                    String role = req.getParameter("role");

                    if (isBlank(fullName) || isBlank(email) || isBlank(password) || !ALLOWED_ROLES.contains(role)) {
                        resp.sendRedirect(req.getContextPath() + "/users?error=invalid_create");
                        return;
                    }

                    userDAO.createUser(fullName.trim(), email.trim(), password.trim(), role);
                    resp.sendRedirect(req.getContextPath() + "/users?created=true");
                }
                case "updateRole" -> {
                    int userId = Integer.parseInt(req.getParameter("userId"));
                    String role = req.getParameter("role");
                    if (!ALLOWED_ROLES.contains(role)) {
                        resp.sendRedirect(req.getContextPath() + "/users?error=invalid_role");
                        return;
                    }
                    userDAO.updateUserRole(userId, role);
                    resp.sendRedirect(req.getContextPath() + "/users?roleUpdated=true");
                }
                default -> resp.sendRedirect(req.getContextPath() + "/users");
            }
        } catch (SQLIntegrityConstraintViolationException e) {
            resp.sendRedirect(req.getContextPath() + "/users?error=duplicate_email");
        } catch (SQLException e) {
            throw new ServletException("Error managing users", e);
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}

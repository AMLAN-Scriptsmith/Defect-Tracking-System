package com.dts.servlet;

import com.dts.dao.DefectDAO;
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

@WebServlet("/assign")
public class AssignmentPageServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();
    private final DefectDAO defectDAO = new DefectDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (User) session.getAttribute("currentUser");
        if (!"PROJECT_MANAGER".equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        try {
            req.setAttribute("developers", userDAO.findDevelopers());
            req.setAttribute("defects", defectDAO.findByFilters(null, "NEW"));
            req.getRequestDispatcher("/assign.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Error loading assignment page", e);
        }
    }
}

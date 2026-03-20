package com.dts.servlet;

import com.dts.dao.DefectDAO;
import com.dts.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;

@WebServlet("/report")
public class ReportServlet extends HttpServlet {

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
            Map<String, Integer> report = defectDAO.countByStatus();
            req.setAttribute("report", report);
            req.getRequestDispatcher("/report.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Error generating report", e);
        }
    }
}

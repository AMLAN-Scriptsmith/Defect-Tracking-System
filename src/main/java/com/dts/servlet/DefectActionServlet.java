package com.dts.servlet;

import com.dts.dao.DefectDAO;
import com.dts.model.Defect;
import com.dts.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/defect-action")
public class DefectActionServlet extends HttpServlet {

    private final DefectDAO defectDAO = new DefectDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("currentUser");
        String action = req.getParameter("action");

        try {
            switch (action) {
                case "add" -> addDefect(req, resp, user);
                case "assign" -> assignDefect(req, resp, user);
                case "updateStatus" -> updateStatus(req, resp, user);
                default -> resp.sendRedirect(req.getContextPath() + "/dashboard");
            }
        } catch (SQLException e) {
            throw new ServletException("Error handling defect action", e);
        }
    }

    private void addDefect(HttpServletRequest req, HttpServletResponse resp, User user) throws SQLException, IOException {
        if (!"TEST_ENGINEER".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        Defect defect = new Defect();
        defect.setTitle(req.getParameter("title"));
        defect.setDescription(req.getParameter("description"));
        defect.setSeverity(req.getParameter("severity"));
        defect.setCreatedBy(user.getId());

        defectDAO.addDefect(defect);
        resp.sendRedirect(req.getContextPath() + "/defects?created=true");
    }

    private void assignDefect(HttpServletRequest req, HttpServletResponse resp, User user) throws SQLException, IOException {
        if (!"PROJECT_MANAGER".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }
        int defectId = Integer.parseInt(req.getParameter("defectId"));
        int developerId = Integer.parseInt(req.getParameter("developerId"));
        defectDAO.assignDefect(defectId, developerId);

        resp.sendRedirect(req.getContextPath() + "/defects?assigned=true");
    }

    private void updateStatus(HttpServletRequest req, HttpServletResponse resp, User user) throws SQLException, IOException {
        if (!"DEVELOPER".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        int defectId = Integer.parseInt(req.getParameter("defectId"));
        String status = req.getParameter("status");
        String notes = req.getParameter("resolutionNotes");

        defectDAO.updateStatus(defectId, user.getId(), status, notes);
        resp.sendRedirect(req.getContextPath() + "/defects?updated=true");
    }
}

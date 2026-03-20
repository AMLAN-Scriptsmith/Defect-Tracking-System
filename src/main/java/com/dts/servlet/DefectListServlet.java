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
import java.util.List;

@WebServlet("/defects")
public class DefectListServlet extends HttpServlet {

    private final DefectDAO defectDAO = new DefectDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("currentUser");

        String idParam = req.getParameter("defectId");
        String status = req.getParameter("status");
        Integer defectId = null;
        if (idParam != null && !idParam.isBlank()) {
            try {
                defectId = Integer.parseInt(idParam);
            } catch (NumberFormatException e) {
                req.setAttribute("error", "Defect ID must be numeric");
            }
        }

        try {
            List<Defect> defects;
            if ("DEVELOPER".equals(user.getRole())) {
                defects = defectDAO.findForDeveloper(user.getId());
            } else {
                defects = defectDAO.findByFilters(defectId, status);
            }
            req.setAttribute("defects", defects);
            req.getRequestDispatcher("/defects.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Error fetching defects", e);
        }
    }
}

package com.dts.dao;

import com.dts.model.Defect;
import com.dts.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DefectDAO {

    public boolean addDefect(Defect defect) throws SQLException {
        String sql = "INSERT INTO defects (title, description, severity, status, created_by, assigned_to, resolution_notes) " +
            "VALUES (?, ?, ?, 'NEW', ?, NULL, NULL)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, defect.getTitle());
            ps.setString(2, defect.getDescription());
            ps.setString(3, defect.getSeverity());
            ps.setInt(4, defect.getCreatedBy());
            return ps.executeUpdate() > 0;
        }
    }

    public boolean assignDefect(int defectId, int developerId) throws SQLException {
        String sql = "UPDATE defects SET assigned_to = ?, status = 'ASSIGNED' WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, developerId);
            ps.setInt(2, defectId);
            return ps.executeUpdate() > 0;
        }
    }

    public boolean updateStatus(int defectId, int developerId, String status, String notes) throws SQLException {
        String sql = "UPDATE defects SET status = ?, resolution_notes = ? WHERE id = ? AND assigned_to = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, notes);
            ps.setInt(3, defectId);
            ps.setInt(4, developerId);
            return ps.executeUpdate() > 0;
        }
    }

    public List<Defect> findByFilters(Integer defectId, String status) throws SQLException {
        StringBuilder sql = new StringBuilder(
                "SELECT id, title, description, severity, status, created_by, assigned_to, resolution_notes, created_at FROM defects WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (defectId != null) {
            sql.append(" AND id = ?");
            params.add(defectId);
        }
        if (status != null && !status.isBlank()) {
            sql.append(" AND status = ?");
            params.add(status.toUpperCase());
        }
        sql.append(" ORDER BY created_at DESC");

        List<Defect> defects = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Defect defect = new Defect();
                    defect.setId(rs.getInt("id"));
                    defect.setTitle(rs.getString("title"));
                    defect.setDescription(rs.getString("description"));
                    defect.setSeverity(rs.getString("severity"));
                    defect.setStatus(rs.getString("status"));
                    defect.setCreatedBy(rs.getInt("created_by"));
                    int assigned = rs.getInt("assigned_to");
                    defect.setAssignedTo(rs.wasNull() ? null : assigned);
                    defect.setResolutionNotes(rs.getString("resolution_notes"));
                    defect.setCreatedAt(rs.getTimestamp("created_at"));
                    defects.add(defect);
                }
            }
        }
        return defects;
    }

    public List<Defect> findForDeveloper(int developerId) throws SQLException {
        String sql = "SELECT id, title, description, severity, status, created_by, assigned_to, resolution_notes, created_at " +
                "FROM defects WHERE assigned_to = ? ORDER BY created_at DESC";
        List<Defect> defects = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, developerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Defect defect = new Defect();
                    defect.setId(rs.getInt("id"));
                    defect.setTitle(rs.getString("title"));
                    defect.setDescription(rs.getString("description"));
                    defect.setSeverity(rs.getString("severity"));
                    defect.setStatus(rs.getString("status"));
                    defect.setCreatedBy(rs.getInt("created_by"));
                    int assigned = rs.getInt("assigned_to");
                    defect.setAssignedTo(rs.wasNull() ? null : assigned);
                    defect.setResolutionNotes(rs.getString("resolution_notes"));
                    defect.setCreatedAt(rs.getTimestamp("created_at"));
                    defects.add(defect);
                }
            }
        }
        return defects;
    }

    public Map<String, Integer> countByStatus() throws SQLException {
        String sql = "SELECT status, COUNT(*) AS total FROM defects GROUP BY status";
        Map<String, Integer> report = new HashMap<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                report.put(rs.getString("status"), rs.getInt("total"));
            }
        }
        return report;
    }
}

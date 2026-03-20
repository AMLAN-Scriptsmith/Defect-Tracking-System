<%@ page import="java.util.Map" %>
<%@ page import="com.dts.model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (!"PROJECT_MANAGER".equals(currentUser.getRole())) {
        response.sendRedirect("dashboard");
        return;
    }

    Map<String, Integer> report = (Map<String, Integer>) request.getAttribute("report");
    int total = 0;
    if (report != null) {
        for (Integer value : report.values()) {
            total += value;
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Defect Report</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,700&family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<div class="nav">
    <div class="nav-inner">
        <strong>Project Manager Report</strong>
        <div>
            <a href="dashboard">Dashboard</a>
            <a href="logout">Logout</a>
        </div>
    </div>
</div>

<div class="container">
    <div class="card page-hero reveal reveal-on">
        <p class="eyebrow">Reporting Center</p>
        <h2>Defect Status Summary</h2>
        <p>Track trend snapshots to understand project stability and closure momentum.</p>
        <div class="metrics-grid">
            <div class="metric-item">
                <span>Total Tickets</span>
                <strong><%= total %></strong>
            </div>
            <div class="metric-item">
                <span>Status Types</span>
                <strong><%= report == null ? 0 : report.size() %></strong>
            </div>
        </div>
    </div>

    <div class="card reveal reveal-on delay-1">
        <h2>Defect Status Summary</h2>
        <div class="table-wrap">
            <table class="enhanced-table">
                <thead>
                <tr>
                    <th>Status</th>
                    <th>Total</th>
                </tr>
                </thead>
                <tbody>
                <% if (report == null || report.isEmpty()) { %>
                <tr>
                    <td colspan="2">No data available.</td>
                </tr>
                <% } else {
                    for (Map.Entry<String, Integer> entry : report.entrySet()) {
                %>
                <tr>
                    <td><span class="status-pill status-<%= entry.getKey().toLowerCase().replace("-", "") %>"><%= entry.getKey() %></span></td>
                    <td><strong><%= entry.getValue() %></strong></td>
                </tr>
                <% }
                } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>

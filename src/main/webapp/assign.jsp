<%@ page import="java.util.List" %>
<%@ page import="com.dts.model.User" %>
<%@ page import="com.dts.model.Defect" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (!"PROJECT_MANAGER".equals(currentUser.getRole())) {
        response.sendRedirect("dashboard");
        return;
    }

    List<User> developers = (List<User>) request.getAttribute("developers");
    List<Defect> defects = (List<Defect>) request.getAttribute("defects");
    int developerCount = developers == null ? 0 : developers.size();
    int newDefectCount = defects == null ? 0 : defects.size();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Assign Defects</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,700&family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<div class="nav">
    <div class="nav-inner">
        <strong>Assign Defects</strong>
        <div>
            <a href="dashboard">Dashboard</a>
            <a href="logout">Logout</a>
        </div>
    </div>
</div>

<div class="container">
    <div class="card page-hero reveal reveal-on">
        <p class="eyebrow">Project Manager Panel</p>
        <h2>Assign Defects to Developers</h2>
        <p>Balance workload smartly and move NEW defects into active resolution.</p>
        <div class="metrics-grid">
            <div class="metric-item">
                <span>NEW Defects</span>
                <strong><%= newDefectCount %></strong>
            </div>
            <div class="metric-item">
                <span>Available Developers</span>
                <strong><%= developerCount %></strong>
            </div>
        </div>
    </div>

    <div class="grid grid-2">
    <div class="card reveal reveal-on delay-1">
        <h2>Assign Defect</h2>
        <form action="defect-action" method="post">
            <input type="hidden" name="action" value="assign">

            <label>Defect</label>
            <select name="defectId" required>
                <% if (defects == null || defects.isEmpty()) { %>
                <option value="">No NEW defects</option>
                <% } else {
                    for (Defect d : defects) {
                %>
                <option value="<%= d.getId() %>"><%= d.getId() %> - <%= d.getTitle() %></option>
                <% }
                } %>
            </select>

            <label>Developer</label>
            <select name="developerId" required>
                <% if (developers != null) {
                    for (User d : developers) {
                %>
                <option value="<%= d.getId() %>"><%= d.getFullName() %> (<%= d.getEmail() %>)</option>
                <% }
                } %>
            </select>

            <button type="submit">Assign</button>
        </form>
    </div>

    <div class="card reveal reveal-on delay-2">
        <h2>NEW Defects</h2>
        <div class="table-wrap">
            <table class="enhanced-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Severity</th>
                </tr>
                </thead>
                <tbody>
                <% if (defects == null || defects.isEmpty()) { %>
                <tr>
                    <td colspan="3">No NEW defects to assign.</td>
                </tr>
                <% } else {
                    for (Defect d : defects) {
                %>
                <tr>
                    <td><%= d.getId() %></td>
                    <td><%= d.getTitle() %></td>
                    <td><span class="badge"><%= d.getSeverity() %></span></td>
                </tr>
                <% }
                } %>
                </tbody>
            </table>
        </div>
    </div>
    </div>
</div>
</body>
</html>

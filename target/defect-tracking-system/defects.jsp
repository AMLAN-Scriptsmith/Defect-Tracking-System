<%@ page import="java.util.List" %>
<%@ page import="com.dts.model.Defect" %>
<%@ page import="com.dts.model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    List<Defect> defects = (List<Defect>) request.getAttribute("defects");
    int totalDefects = defects == null ? 0 : defects.size();
    int openDefects = 0;
    int fixedDefects = 0;
    int pendingDefects = 0;
    if (defects != null) {
        for (Defect defect : defects) {
            if ("FIXED".equals(defect.getStatus())) {
                fixedDefects++;
            } else if ("PENDING".equals(defect.getStatus())) {
                pendingDefects++;
            } else {
                openDefects++;
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Defects</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,700&family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<div class="nav">
    <div class="nav-inner">
        <strong>Defect List</strong>
        <div>
            <a href="dashboard">Dashboard</a>
            <a href="logout">Logout</a>
        </div>
    </div>
</div>

<div class="container">
    <div class="card page-hero reveal reveal-on">
        <p class="eyebrow">Defect Workspace</p>
        <h2>Defect List and Search</h2>
        <p>Use quick filters to narrow down tickets and keep issue resolution moving.</p>
        <div class="metrics-grid">
            <div class="metric-item">
                <span>Total</span>
                <strong><%= totalDefects %></strong>
            </div>
            <div class="metric-item">
                <span>Open</span>
                <strong><%= openDefects %></strong>
            </div>
            <div class="metric-item">
                <span>Fixed</span>
                <strong><%= fixedDefects %></strong>
            </div>
            <div class="metric-item">
                <span>Pending</span>
                <strong><%= pendingDefects %></strong>
            </div>
        </div>
    </div>

    <div class="card reveal reveal-on delay-1">
        <h2>Search Defects</h2>
        <% if (!"DEVELOPER".equals(currentUser.getRole())) { %>
        <form action="defects" method="get" class="grid grid-2 filter-form">
            <div>
                <label>Defect ID</label>
                <input type="number" name="defectId" placeholder="Ex: 1001">
            </div>
            <div>
                <label>Status</label>
                <select name="status">
                    <option value="">ALL</option>
                    <option value="NEW">NEW</option>
                    <option value="ASSIGNED">ASSIGNED</option>
                    <option value="FIXED">FIXED</option>
                    <option value="PENDING">PENDING</option>
                    <option value="RE-OPEN">RE-OPEN</option>
                </select>
            </div>
            <div>
                <button type="submit">Search</button>
            </div>
        </form>
        <% } else { %>
        <p>Showing defects assigned to you.</p>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
        <p class="error"><%= request.getAttribute("error") %></p>
        <% } %>
    </div>

    <div class="card reveal reveal-on delay-2">
        <h2>Defects</h2>
        <div class="table-wrap">
            <table class="enhanced-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Title</th>
                    <th>Severity</th>
                    <th>Status</th>
                    <th>Assigned To</th>
                    <th>Created At</th>
                    <th>Resolution Notes</th>
                    <% if ("DEVELOPER".equals(currentUser.getRole())) { %>
                    <th>Action</th>
                    <% } %>
                </tr>
                </thead>
                <tbody>
                <% if (defects == null || defects.isEmpty()) { %>
                <tr>
                    <td colspan="8">No defects found.</td>
                </tr>
                <% } else {
                    for (Defect d : defects) {
                %>
                <tr>
                    <td><%= d.getId() %></td>
                    <td><%= d.getTitle() %></td>
                    <td><span class="badge"><%= d.getSeverity() %></span></td>
                    <td>
                        <span class="status-pill status-<%= d.getStatus().toLowerCase().replace("-", "") %>"><%= d.getStatus() %></span>
                    </td>
                    <td><%= d.getAssignedTo() == null ? "-" : d.getAssignedTo() %></td>
                    <td><%= d.getCreatedAt() %></td>
                    <td><%= d.getResolutionNotes() == null ? "-" : d.getResolutionNotes() %></td>
                    <% if ("DEVELOPER".equals(currentUser.getRole())) { %>
                    <td><a class="table-link" href="update-status.jsp?defectId=<%= d.getId() %>">Update</a></td>
                    <% } %>
                </tr>
                <%
                    }
                } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>

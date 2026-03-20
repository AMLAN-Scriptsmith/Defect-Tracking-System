<%@ page import="com.dts.model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (!"DEVELOPER".equals(currentUser.getRole())) {
        response.sendRedirect("dashboard");
        return;
    }
    String defectId = request.getParameter("defectId");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Update Defect Status</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<div class="nav">
    <div class="nav-inner">
        <strong>Update Defect</strong>
        <div>
            <a href="defects">Defects</a>
            <a href="logout">Logout</a>
        </div>
    </div>
</div>

<div class="container">
    <div class="card" style="max-width: 700px;">
        <h2>Update Status</h2>
        <form action="defect-action" method="post">
            <input type="hidden" name="action" value="updateStatus">

            <label>Defect ID</label>
            <input type="number" name="defectId" value="<%= defectId == null ? "" : defectId %>" required>

            <label>Status</label>
            <select name="status" required>
                <option value="FIXED">FIXED</option>
                <option value="PENDING">PENDING</option>
                <option value="RE-OPEN">RE-OPEN</option>
            </select>

            <label>Resolution Notes</label>
            <textarea name="resolutionNotes" placeholder="Describe fix or blocker"></textarea>

            <button type="submit">Save Status</button>
        </form>
    </div>
</div>
</body>
</html>

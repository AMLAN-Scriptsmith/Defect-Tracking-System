<%@ page import="com.dts.model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (!"TEST_ENGINEER".equals(currentUser.getRole())) {
        response.sendRedirect("dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Register Defect</title>
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<div class="nav">
    <div class="nav-inner">
        <strong>Register Defect</strong>
        <div>
            <a href="dashboard">Dashboard</a>
            <a href="logout">Logout</a>
        </div>
    </div>
</div>

<div class="container">
    <div class="card" style="max-width: 700px;">
        <h2>New Defect</h2>
        <form action="defect-action" method="post">
            <input type="hidden" name="action" value="add">

            <label>Title</label>
            <input type="text" name="title" required>

            <label>Description</label>
            <textarea name="description" required></textarea>

            <label>Severity</label>
            <select name="severity" required>
                <option value="LOW">LOW</option>
                <option value="MEDIUM">MEDIUM</option>
                <option value="HIGH">HIGH</option>
                <option value="CRITICAL">CRITICAL</option>
            </select>

            <button type="submit">Create Defect</button>
        </form>
    </div>
</div>
</body>
</html>

<%@ page import="java.util.List" %>
<%@ page import="com.dts.model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
    if (!"ADMIN".equals(currentUser.getRole())) {
        response.sendRedirect("dashboard");
        return;
    }

    List<User> users = (List<User>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Employees</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,700&family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWix+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkR4j8DqRLVQjaxAg/P070nxsVX2yQO7Q3Nw==" crossorigin="anonymous" referrerpolicy="no-referrer">
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<div class="nav nav-strong">
    <div class="nav-inner">
        <div class="nav-brand"><i class="fa-solid fa-users-gear"></i> Admin User Management</div>
        <div class="nav-links">
            <a href="dashboard">Dashboard</a>
            <a href="logout">Logout</a>
        </div>
    </div>
</div>

<div class="container">
    <div class="card page-hero reveal reveal-on">
        <p class="eyebrow">Admin Control</p>
        <h2>Create Users, Update Roles, and Maintain Access</h2>
        <p>Use this panel to onboard employees and maintain role-based permissions.</p>

        <% if ("true".equals(request.getParameter("created"))) { %>
        <p class="success-banner">User created successfully.</p>
        <% } %>
        <% if ("true".equals(request.getParameter("deleted"))) { %>
        <p class="success-banner">User deleted successfully.</p>
        <% } %>
        <% if ("true".equals(request.getParameter("roleUpdated"))) { %>
        <p class="success-banner">User role updated successfully.</p>
        <% } %>
        <% if ("duplicate_email".equals(request.getParameter("error"))) { %>
        <p class="error">Email already exists. Use a different email address.</p>
        <% } else if (request.getParameter("error") != null) { %>
        <p class="error">Unable to process request. Check inputs and try again.</p>
        <% } %>
    </div>

    <div class="grid grid-2">
        <div class="card reveal reveal-on delay-1">
            <h3><i class="fa-solid fa-user-plus"></i> Add New User</h3>
            <form action="users" method="post">
                <input type="hidden" name="action" value="create">

                <label>Full Name</label>
                <input type="text" name="fullName" required>

                <label>Email</label>
                <input type="email" name="email" required>

                <label>Password</label>
                <input type="password" name="password" required>

                <label>Role</label>
                <select name="role" required>
                    <option value="TEST_ENGINEER">TEST_ENGINEER</option>
                    <option value="DEVELOPER">DEVELOPER</option>
                    <option value="PROJECT_MANAGER">PROJECT_MANAGER</option>
                </select>

                <button type="submit">Create User</button>
            </form>
        </div>

        <div class="card reveal reveal-on delay-1">
            <h3><i class="fa-solid fa-user-shield"></i> Role Policy</h3>
            <p>Only non-admin roles can be created or changed from this panel.</p>
            <div class="feature-strip" style="margin-top: 10px;">
                <div>
                    <h3>Tester</h3>
                    <p>Registers defects as NEW.</p>
                </div>
                <div>
                    <h3>Developer</h3>
                    <p>Updates status to FIXED/PENDING/RE-OPEN.</p>
                </div>
                <div>
                    <h3>Manager</h3>
                    <p>Assigns defects and views reports.</p>
                </div>
            </div>
        </div>
    </div>

    <div class="card reveal reveal-on delay-2">
        <h2>Employees</h2>
        <div class="table-wrap">
            <table class="enhanced-table">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Update Role</th>
                    <th>Delete</th>
                </tr>
                </thead>
                <tbody>
                <% if (users == null || users.isEmpty()) { %>
                <tr>
                    <td colspan="6">No users found.</td>
                </tr>
                <% } else {
                    for (User u : users) {
                %>
                <tr>
                    <td><%= u.getId() %></td>
                    <td><%= u.getFullName() %></td>
                    <td><%= u.getEmail() %></td>
                    <td><span class="badge"><%= u.getRole() %></span></td>
                    <td>
                        <% if (!"ADMIN".equals(u.getRole())) { %>
                        <form action="users" method="post" style="margin: 0; display: flex; gap: 8px; align-items: center;">
                            <input type="hidden" name="action" value="updateRole">
                            <input type="hidden" name="userId" value="<%= u.getId() %>">
                            <select name="role" style="margin: 0;">
                                <option value="TEST_ENGINEER" <%= "TEST_ENGINEER".equals(u.getRole()) ? "selected" : "" %>>TEST_ENGINEER</option>
                                <option value="DEVELOPER" <%= "DEVELOPER".equals(u.getRole()) ? "selected" : "" %>>DEVELOPER</option>
                                <option value="PROJECT_MANAGER" <%= "PROJECT_MANAGER".equals(u.getRole()) ? "selected" : "" %>>PROJECT_MANAGER</option>
                            </select>
                            <button type="submit" style="margin: 0; width: auto;">Save</button>
                        </form>
                        <% } else { %>
                        Protected
                        <% } %>
                    </td>
                    <td>
                        <% if (!"ADMIN".equals(u.getRole())) { %>
                        <form action="users" method="post" style="margin: 0;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="userId" value="<%= u.getId() %>">
                            <button type="submit" class="danger-btn" style="margin: 0;">Delete</button>
                        </form>
                        <% } else { %>
                        Protected
                        <% } %>
                    </td>
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

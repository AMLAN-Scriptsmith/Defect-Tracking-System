<%@ page import="com.dts.model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
%>
<!DOCTYPE html>
<html>
<head>
    <title>DTS Dashboard</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,700&family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWix+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkR4j8DqRLVQjaxAg/P070nxsVX2yQO7Q3Nw==" crossorigin="anonymous" referrerpolicy="no-referrer">
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<div class="nav nav-strong">
    <div class="nav-inner">
        <div class="nav-brand"><i class="fa-solid fa-gauge-high"></i> DTS Dashboard</div>
        <div class="nav-links">
            <a href="defects"><i class="fa-solid fa-list-check"></i> Defects</a>
            <% if ("PROJECT_MANAGER".equals(currentUser.getRole())) { %>
            <a href="assign"><i class="fa-solid fa-user-check"></i> Assign</a>
            <a href="report"><i class="fa-solid fa-chart-line"></i> Report</a>
            <% } %>
            <% if ("TEST_ENGINEER".equals(currentUser.getRole())) { %>
            <a href="new-defect.jsp"><i class="fa-solid fa-file-circle-plus"></i> New Defect</a>
            <% } %>
            <% if ("ADMIN".equals(currentUser.getRole())) { %>
            <a href="users"><i class="fa-solid fa-users-gear"></i> Users</a>
            <% } %>
            <span class="role-chip"><%= currentUser.getFullName() %> (<%= currentUser.getRole() %>)</span>
            <a href="logout"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </div>
    </div>
</div>

<div class="container">
    <div class="card dash-hero reveal reveal-on">
        <p class="eyebrow">Workspace Overview</p>
        <h2>Welcome back, <%= currentUser.getFullName() %></h2>
        <p>Choose the next action for your role and keep defect flow moving without delays.</p>
    </div>

    <div class="grid grid-3 mini-panels reveal reveal-on delay-1">
        <div class="card mini-panel mini-track">
            <h3><i class="fa-solid fa-magnifying-glass-chart"></i> Track</h3>
            <p>Monitor defects by status, owner, and severity.</p>
        </div>
        <div class="card mini-panel mini-collab">
            <h3><i class="fa-solid fa-people-group"></i> Collaborate</h3>
            <p>Share updates between QA, PM, and developers.</p>
        </div>
        <div class="card mini-panel mini-deliver">
            <h3><i class="fa-solid fa-flag-checkered"></i> Deliver</h3>
            <p>Push issues from assignment to closure with confidence.</p>
        </div>
    </div>

    <div class="card reveal reveal-on delay-2">
        <h3><i class="fa-solid fa-bolt"></i> Actions</h3>
        <div class="action-grid">
            <a class="action-tile tile-blue" href="defects">
                <span class="tile-title"><i class="fa-solid fa-list-check"></i> View Defects</span>
                <span class="tile-sub">Browse all defects and current states.</span>
            </a>

            <% if ("TEST_ENGINEER".equals(currentUser.getRole())) { %>
            <a class="action-tile tile-green" href="new-defect.jsp">
                <span class="tile-title"><i class="fa-solid fa-file-circle-plus"></i> Register Defect</span>
                <span class="tile-sub">Create a new issue with details and severity.</span>
            </a>
            <% } %>

            <% if ("PROJECT_MANAGER".equals(currentUser.getRole())) { %>
            <a class="action-tile tile-orange" href="assign">
                <span class="tile-title"><i class="fa-solid fa-user-check"></i> Assign Defect</span>
                <span class="tile-sub">Route issues to developers with ownership.</span>
            </a>
            <a class="action-tile tile-purple" href="report">
                <span class="tile-title"><i class="fa-solid fa-chart-line"></i> Generate Report</span>
                <span class="tile-sub">View defect analytics and status trends.</span>
            </a>
            <% } %>

            <% if ("ADMIN".equals(currentUser.getRole())) { %>
            <a class="action-tile tile-red" href="users">
                <span class="tile-title"><i class="fa-solid fa-users-gear"></i> Manage Users</span>
                <span class="tile-sub">Create users, update roles, and remove non-admin users.</span>
            </a>
            <% } %>
        </div>
    </div>

    <div class="image-grid reveal reveal-on delay-2">
        <article class="image-card card">
            <img src="https://images.unsplash.com/photo-1551434678-e076c223a692?auto=format&fit=crop&w=1200&q=80" alt="Engineers collaborating on software quality">
            <div>
                <h3><i class="fa-solid fa-users"></i> Team Sync</h3>
                <p>Keep everyone aligned with transparent defect ownership.</p>
            </div>
        </article>
        <article class="image-card card">
            <img src="https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=1200&q=80" alt="Dashboard analytics on computer screen">
            <div>
                <h3><i class="fa-solid fa-chart-pie"></i> Defect Analytics</h3>
                <p>Use reports to prioritize bottlenecks and improve delivery.</p>
            </div>
        </article>
        <article class="image-card card">
            <img src="https://images.unsplash.com/photo-1522071820081-009f0129c71c?auto=format&fit=crop&w=1200&q=80" alt="Development team discussing sprint tasks">
            <div>
                <h3><i class="fa-solid fa-rocket"></i> Faster Closure</h3>
                <p>Move issues from NEW to FIXED with role-based workflows.</p>
            </div>
        </article>
    </div>

    <div class="card tip-card reveal reveal-on delay-2">
        <h3><i class="fa-solid fa-lightbulb"></i> Daily Focus</h3>
        <p>Review newly opened defects first, then close old pending items to keep cycle time healthy.</p>
    </div>
</div>
</body>
</html>

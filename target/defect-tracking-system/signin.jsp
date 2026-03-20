<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <title>DTS Sign In</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,700&family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWix+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkR4j8DqRLVQjaxAg/P070nxsVX2yQO7Q3Nw==" crossorigin="anonymous" referrerpolicy="no-referrer">
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<div class="ambient-shape shape-a"></div>
<div class="ambient-shape shape-b"></div>

<div class="nav nav-strong">
    <div class="nav-inner">
        <div class="nav-brand"><i class="fa-solid fa-bug"></i> DTS</div>
        <div class="nav-links">
            <a href="<%= ctx %>/"><i class="fa-solid fa-house"></i> Welcome</a>
            <a href="<%= ctx %>/signin.jsp"><i class="fa-solid fa-right-to-bracket"></i> Sign In</a>
        </div>
    </div>
</div>

<div class="container auth-page-wrap">
    <section class="card auth-page-hero reveal reveal-on">
        <p class="eyebrow">Secure Access</p>
        <h1>Sign In to Continue Your Defect Workflow</h1>
        <p class="hero-copy">Review, assign, fix, and report defects from your dedicated workspace.</p>
    </section>

    <section class="auth-grid reveal reveal-on delay-1">
        <div class="card auth-card">
            <h2><i class="fa-solid fa-user-lock"></i> Sign In</h2>
            <p>Enter your work account credentials.</p>

            <% if (request.getAttribute("error") != null) { %>
            <p class="error"><%= request.getAttribute("error") %></p>
            <% } %>

            <form action="<%= ctx %>/login" method="post">
                <label>Email</label>
                <input type="email" name="email" placeholder="user@company.com" required>

                <label>Password</label>
                <input type="password" name="password" required>

                <button type="submit">Login</button>
            </form>
        </div>

        <div class="card users-card">
            <h3><i class="fa-solid fa-id-card"></i> Demo Accounts</h3>
            <div class="sample-user-list">
                <p><strong>ADMIN</strong><span>admin@dts.com / admin123</span></p>
                <p><strong>TEST_ENGINEER</strong><span>tester@dts.com / test123</span></p>
                <p><strong>DEVELOPER</strong><span>dev@dts.com / dev123</span></p>
                <p><strong>PROJECT_MANAGER</strong><span>pm@dts.com / pm123</span></p>
            </div>
            <div class="signin-image-card">
                <img src="https://images.unsplash.com/photo-1552664730-d307ca884978?auto=format&fit=crop&w=1200&q=80" alt="Software team in standup planning defects">
                <p>Use role-based access to jump directly into your responsibilities.</p>
            </div>
        </div>
    </section>
</div>
</body>
</html>

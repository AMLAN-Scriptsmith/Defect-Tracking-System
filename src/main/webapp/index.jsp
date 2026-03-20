<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
    <title>DTS Welcome</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,700&family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css" integrity="sha512-SnH5WK+bZxgPHs44uWix+LLJAJ9/2PkPKZ5QiAj6Ta86w+fsb2TkR4j8DqRLVQjaxAg/P070nxsVX2yQO7Q3Nw==" crossorigin="anonymous" referrerpolicy="no-referrer">
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<div class="ambient-shape shape-a"></div>
<div class="ambient-shape shape-b"></div>

<div class="container welcome-wrap">
    <section class="welcome-hero card reveal">
        <p class="eyebrow">Welcome to DTS</p>
        <h1>Track defects with clarity, speed, and team accountability.</h1>
        <p class="hero-copy">
            Your workspace for raising defects, assigning ownership, and driving every ticket from NEW to FIXED.
        </p>
        <div class="hero-cta-row">
            <a class="btn-pill" href="<%= ctx %>/signin.jsp">Sign In</a>
            <span class="hero-meta">Tomcat + JSP + JDBC + MySQL</span>
        </div>
    </section>

    <section class="image-grid reveal delay-1">
        <article class="image-card card">
            <img src="https://images.unsplash.com/photo-1461749280684-dccba630e2f6?auto=format&fit=crop&w=1200&q=80" alt="Developer analyzing code issues">
            <div>
                <h3>Identify Issues Early</h3>
                <p>Capture defects quickly and reduce late-stage surprises.</p>
            </div>
        </article>
        <article class="image-card card">
            <img src="https://images.unsplash.com/photo-1516321497487-e288fb19713f?auto=format&fit=crop&w=1200&q=80" alt="Team discussion around project defects">
            <div>
                <h3>Collaborate Better</h3>
                <p>Give QA, PM, and developers one shared workflow.</p>
            </div>
        </article>
        <article class="image-card card">
            <img src="https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?auto=format&fit=crop&w=1200&q=80" alt="Project manager reviewing defect reports">
            <div>
                <h3>Ship with Confidence</h3>
                <p>Assign ownership and close issues with full visibility.</p>
            </div>
        </article>
        <article class="image-card card">
            <img src="https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=1200&q=80" alt="Cross functional product team in planning session">
            <div>
                <h3>One Team, One Board</h3>
                <p>Bring tester, developer, manager, and admin workflows into one clean system.</p>
            </div>
        </article>
    </section>

    <section id="features" class="card feature-strip reveal delay-2">
        <div>
            <h3>Plan</h3>
            <p>Capture new defects with severity and clear notes.</p>
        </div>
        <div>
            <h3>Assign</h3>
            <p>Route defects to developers with clear ownership.</p>
        </div>
        <div>
            <h3>Resolve</h3>
            <p>Update progress and report status by team role.</p>
        </div>
    </section>
</div>

<script>
    // Lightweight reveal animation for initial page load.
    window.addEventListener("DOMContentLoaded", function () {
        document.querySelectorAll('.reveal').forEach(function (el) {
            el.classList.add('reveal-on');
        });
    });
</script>
</body>
</html>

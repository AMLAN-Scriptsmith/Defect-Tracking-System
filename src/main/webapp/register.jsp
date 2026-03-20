<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>DTS Register</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,500;9..144,700&family=Manrope:wght@400;500;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
<div class="ambient-shape shape-a"></div>
<div class="ambient-shape shape-b"></div>

<div class="container welcome-wrap">
    <section class="card register-hero reveal reveal-on">
        <p class="eyebrow">Create Access Request</p>
        <h1>Join the Defect Tracking Workspace</h1>
        <p class="hero-copy">Fill this registration request and share it with your admin team for account creation.</p>
        <div class="hero-cta-row">
            <a class="btn-pill" href="index.jsp#signin">Sign In</a>
            <a class="btn-pill btn-pill-secondary" href="index.jsp">Back to Welcome</a>
        </div>
    </section>

    <section class="card register-card reveal reveal-on delay-1">
        <h2>Register</h2>
        <p>Please provide your details. Admin approval is required before access is granted.</p>

        <form action="#" method="post" onsubmit="return false;">
            <label>Full Name</label>
            <input type="text" name="fullName" placeholder="Your full name" required>

            <label>Email</label>
            <input type="email" name="email" placeholder="you@company.com" required>

            <label>Role</label>
            <select name="role" required>
                <option value="">Select role</option>
                <option value="TEST_ENGINEER">Test Engineer</option>
                <option value="DEVELOPER">Developer</option>
                <option value="PROJECT_MANAGER">Project Manager</option>
            </select>

            <label>Why do you need access?</label>
            <textarea name="reason" placeholder="Briefly describe your work scope" required></textarea>

            <button type="submit">Submit Request</button>
            <p class="register-note">Demo mode: share details with ADMIN to create your account.</p>
        </form>
    </section>
</div>
</body>
</html>

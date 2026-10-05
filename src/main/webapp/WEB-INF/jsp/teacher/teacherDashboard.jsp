<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Teacher Dashboard</title>
    <style>
        :root {
            --sidebar-width: 240px;
            --sidebar-width-min: 80px;
            --card-radius: 16px;
        }

        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f6f8;
            color: #111;
            transition: background-color 0.3s, color 0.3s;
        }

        body.dark {
            --background: #121212;
            --text-color: #f0f0f0;

            --navbar-dark-primary: #1e1e1e;
            --navbar-dark-secondary: #2a2a2a;
            --navbar-light-primary: #f0f0f0;
            --navbar-light-secondary: #bbbbbb;

            background-color: var(--background);
            color: var(--text-color);
        }

        #main-content {
            margin-left: 260px;
            padding: 2rem;
            transition: margin-left 0.3s ease, background-color 0.3s, color 0.3s;
            min-height: 100vh;
        }

        #main-content.collapsed {
            margin-left: 100px;
        }

        /* Animation */
        .fade-in {
            opacity: 0;
            transform: translateY(10px);
            animation: fadeInSlide 0.8s ease forwards;
        }

        @keyframes fadeInSlide {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .float-hover {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .float-hover:hover {
            transform: translateY(-6px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.12);
        }

        .top-bar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }

        .top-bar h2 {
            font-size: 2rem;
        }

        /* Toggle Switch Styles */
        .theme-switch {
            display: flex;
            align-items: center;
            gap: 0.4rem;
            cursor: pointer;
            user-select: none;
        }

        .theme-switch input {
            display: none;
        }

        .theme-switch .slider {
            width: 38px;
            height: 20px;
            background-color: #ccc;
            border-radius: 34px;
            position: relative;
            transition: background-color 0.3s;
        }

        .theme-switch .slider::before {
            content: "";
            position: absolute;
            height: 14px;
            width: 14px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            border-radius: 50%;
            transition: transform 0.3s;
        }

        .theme-switch input:checked + .slider {
            background-color: #a9a3a4;
        }

        .theme-switch input:checked + .slider::before {
            transform: translateX(18px);
        }

        .theme-switch .label-text {
            font-size: 0.8rem;
        }

        /* Cards Section */
        /* Cards Section */
        .cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }

        .card {
            padding: 1.8rem 1.4rem;
            height: 160px;
            border-radius: var(--card-radius);
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            transition: background-color 0.3s, color 0.3s;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .bg-blue {
            background: linear-gradient(to top left, #d9efff, #eaf4ff);
        }

        .bg-green {
            background: linear-gradient(to top left, #d4fdd7, #e7fbe8);
        }

        .bg-orange {
            background: linear-gradient(to top left, #ffe3c1, #fff3e6);
        }

        .bg-purple {
            background: linear-gradient(to top left, #dfe9ff, #eff3ff);
        }

        /* Hover animation */
        .float-hover:hover {
            transform: translateY(-6px);
            box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
        }

        /* Dark Mode Card Background */
        body.dark .card {
            background: var(--navbar-dark-secondary);
            color: var(--text-color);
        }

        /* Quick Actions */
        .quick-actions {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 1.2rem;
        }

        .quick-actions .action {
            padding: 1.4rem;
            height: 110px;
            border-radius: var(--card-radius);
            background: linear-gradient(135deg, #f5faff, #e6f0ff);
            color: #0b2545;
            text-align: center;
            font-weight: 600;
            font-size: 1rem;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.06);
            border: 1px solid #dce6f0;
            transition: transform 0.3s ease, box-shadow 0.3s ease, background 0.3s ease;
            cursor: pointer;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
        }

        .quick-actions .action:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 16px rgba(0, 0, 0, 0.12);
        }

        body.dark .quick-actions .action {
            background: linear-gradient(135deg, #1f1f1f, #2c2c2c);
            color: var(--text-color);
            border: 1px solid #333;
            box-shadow: 0 3px 6px rgba(255, 255, 255, 0.05);
        }

        h3 {
            margin-bottom: 1rem;
        }

        body.dark .card:hover {
            background: linear-gradient(to top left, #2a2a2a, #333);
        }

        body.dark .quick-actions .action:hover {
            background: linear-gradient(135deg, #292929, #3a3a3a);
            box-shadow: 0 10px 16px rgba(255, 255, 255, 0.05);
        }

    </style>
</head>
<body>
<%@ include file="sidebar.jsp" %>

<div id="main-content">
    <!-- Top Bar -->
    <div class="top-bar fade-in">
        <h2>Teacher Dashboard</h2>
<%--        <label class="theme-switch">--%>
<%--            <input type="checkbox" id="darkToggle" onchange="toggleDarkMode()">--%>
<%--            <span class="slider"></span>--%>
<%--            <span class="label-text">Dark Mode</span>--%>
<%--        </label>--%>
    </div>

    <!-- Cards -->
    <div class="cards">
        <div class="card bg-blue fade-in float-hover" style="animation-delay: 0.1s;">
            <h4>Today's Attendance</h4>
            <p>${todaysAttendance}%</p> <!-- Displays Today's Attendance Percentage -->
        </div>
        <div class="card bg-green fade-in float-hover" style="animation-delay: 0.2s;">
            <h4>Total Students</h4>
            <p>${totalStudents}</p> <!-- Displays Total Students -->
        </div>
        <div class="card bg-orange fade-in float-hover" style="animation-delay: 0.3s;">
            <h4>Classes Assigned</h4>
            <p>${classesAssigned}</p> <!-- Displays Classes Assigned -->
        </div>
        <div class="card bg-purple fade-in float-hover" style="animation-delay: 0.4s;">
            <h4>Attendance Rate</h4>
            <p>${attendanceRate}%</p> <!-- Displays Overall Attendance Rate -->
        </div>
    </div>

    <!-- Quick Actions -->
    <h3 class="fade-in">Quick Actions</h3>
    <div class="quick-actions fade-in">
        <div class="action float-hover" onclick="location.href='<%= request.getContextPath() %>/teacher/student-attendance/view?teacherId=<%= session.getAttribute("teacherId") %>'">
            Mark Attendance
        </div>
        <div class="action float-hover" onclick="location.href='<%= request.getContextPath() %>/teacher/student-attendance/student-attendance-history'">
            View Records
        </div>
        <div class="action float-hover" onclick="location.href='<%= request.getContextPath() %>/teachers/teacher-profile'">
            Manage Profile
        </div>
        <div class="action float-hover" onclick="location.href='<%= request.getContextPath() %>/logout'">
            Logout
        </div>
    </div>
</div>

<!-- Scripts -->
<script>
    const navToggle = document.getElementById('nav-toggle');
    const mainContent = document.getElementById('main-content');

    function adjustMainContent() {
        if (navToggle && navToggle.checked) {
            mainContent.classList.add("collapsed");
        } else {
            mainContent.classList.remove("collapsed");
        }
    }

    function toggleDarkMode() {
        const isDark = document.body.classList.toggle("dark");
        localStorage.setItem("theme", isDark ? "dark" : "light");
        document.getElementById("darkToggle").checked = isDark;
        reanimateElements(); // <- Trigger animation refresh
    }

    window.addEventListener("DOMContentLoaded", () => {
        const theme = localStorage.getItem("theme");
        const isDark = theme === "dark";
        if (isDark) document.body.classList.add("dark");
        document.getElementById("darkToggle").checked = isDark;
        adjustMainContent();
    });

    if (navToggle) {
        navToggle.addEventListener("change", adjustMainContent);
    }

    function reanimateElements() {
        const animatedElements = document.querySelectorAll('.fade-in');
        animatedElements.forEach(el => {
            el.classList.remove('fade-in');
            // Force reflow
            void el.offsetWidth;
            el.classList.add('fade-in');
        });
    }

</script>
</body>
</html>
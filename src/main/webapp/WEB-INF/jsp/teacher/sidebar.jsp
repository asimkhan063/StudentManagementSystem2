<%@ page contentType="text/html;charset=UTF-8" %>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    Long teacherId = (Long) session.getAttribute("roleId");
    if (teacherId == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    String teacherPhoto = (String) session.getAttribute("teacherPhoto");
    String teacherName = (String) session.getAttribute("teacherName");
%>

<style>
    :root {
        --background: #f9fafe; /* Very light blue background */
        --text-color: #1e2a38; /* Dark blue-gray font */

        --navbar-width: 256px;
        --navbar-width-min: 80px;

        --navbar-dark-primary: #e3f2fd; /* Light soft blue */
        --navbar-dark-secondary: #d0e7f9; /* Lighter blue for footer */
        --navbar-light-primary: #0066cc; /* Primary action blue */
        --navbar-light-secondary: #6699cc; /* Subtle text blue */
    }

    html, body {
        margin: 0;
        background: var(--background);
        color: var(--text-color);
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    body.dark {
        --background: #121212;
        --text-color: #f0f0f0;

        --navbar-dark-primary: #1e1e1e;
        --navbar-dark-secondary: #2a2a2a;
        --navbar-light-primary: #f0f0f0;
        --navbar-light-secondary: #bbbbbb;
        --navbar-dark-mid : #323131;
    }

    #nav-toggle:checked ~ #nav-header {
        width: calc(var(--navbar-width-min) - 16px);
    }
    #nav-toggle:checked ~ #nav-content,
    #nav-toggle:checked ~ #nav-footer {
        width: var(--navbar-width-min);
    }
    #nav-toggle:checked ~ #nav-header #nav-title {
        opacity: 0;
        pointer-events: none;
        transition: opacity 0.1s;
    }
    #nav-toggle:checked ~ #nav-header label[for=nav-toggle] {
        left: calc(50% - 8px);
        transform: translate(-50%);
    }
    #nav-toggle:checked ~ #nav-header #nav-toggle-burger {
        background: var(--navbar-light-primary);
    }
    #nav-toggle:checked ~ #nav-header #nav-toggle-burger:before,
    #nav-toggle:checked ~ #nav-header #nav-toggle-burger::after {
        width: 16px;
        background: var(--navbar-light-secondary);
        transform: translate(0, 0) rotate(0deg);
    }
    #nav-toggle:checked ~ #nav-content .nav-button span {
        opacity: 0;
        transition: opacity 0.1s;
    }
    #nav-toggle:checked ~ #nav-content .nav-button .fas {
        min-width: calc(100% - 16px);
    }
    #nav-toggle:checked ~ #nav-footer #nav-footer-avatar {
        margin-left: 0;
        left: 50%;
        transform: translate(-50%);
    }
    #nav-toggle:checked ~ #nav-footer #nav-footer-titlebox,
    #nav-toggle:checked ~ #nav-footer label[for=nav-footer-toggle] {
        opacity: 0;
        transition: opacity 0.1s;
        pointer-events: none;
    }

    #nav-bar {
        position: fixed;
        left: 1vw;
        top: 1vw;
        height: calc(100% - 2vw);
        background: var(--navbar-dark-primary);
        border-radius: 16px;
        transition: width 0.3s ease;
        display: flex;
        flex-direction: column;
        color: var(--text-color);
        font-family: Verdana, Geneva, Tahoma, sans-serif;
        overflow: hidden;
        user-select: none;
    }
    #nav-bar hr {
        margin: 0;
        position: relative;
        left: 16px;
        width: calc(100% - 32px);
        border: none;
        border-top: solid 1px var(--navbar-dark-secondary);
    }
    #nav-bar a {
        color: inherit;
        text-decoration: inherit;
    }
    #nav-bar input[type=checkbox] {
        display: none;
    }

    #nav-header {
        position: relative;
        width: var(--navbar-width);
        left: 16px;
        width: calc(var(--navbar-width) - 16px);
        min-height: 80px;
        background: var(--navbar-dark-primary);
        border-radius: 16px;
        z-index: 2;
        display: flex;
        align-items: center;
        transition: width 0.3s ease;
    }
    #nav-header hr {
        position: absolute;
        bottom: 0;
    }

    #nav-title {
        font-size: 1.5rem;
        transition: opacity 1s;
    }

    label[for=nav-toggle] {
        position: absolute;
        right: 0;
        width: 3rem;
        height: 100%;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
    }

    #nav-toggle-burger {
        position: relative;
        width: 16px;
        height: 2px;
        background: var(--navbar-dark-primary);
        border-radius: 99px;
        transition: background 0.2s;
    }
    #nav-toggle-burger:before,
    #nav-toggle-burger:after {
        content: "";
        position: absolute;
        top: -6px;
        width: 10px;
        height: 2px;
        background: var(--navbar-light-primary);
        border-radius: 99px;
        transform: translate(2px, 8px) rotate(30deg);
        transition: 0.2s;
    }
    #nav-toggle-burger:after {
        top: 6px;
        transform: translate(2px, -8px) rotate(-30deg);
    }

    #nav-content {
        margin: -16px 0;
        padding: 16px 0;
        position: relative;
        flex: 1;
        width: var(--navbar-width);
        background: var(--navbar-dark-primary);
        box-shadow: 0 0 0 16px var(--navbar-dark-primary);
        direction: rtl;
        overflow-x: hidden;
        transition: width 0.3s ease;
    }
    #nav-content::-webkit-scrollbar {
        width: 8px;
        height: 8px;
    }
    #nav-content::-webkit-scrollbar-thumb {
        border-radius: 99px;
        background-color: #9fc8f9; /* Soft light blue thumb */
    }
    #nav-content::-webkit-scrollbar-button {
        height: 16px;
    }

    .nav-button {
        position: relative;
        margin-left: 16px;
        height: 54px;
        display: flex;
        align-items: center;
        color: var(--navbar-light-secondary);
        direction: ltr;
        cursor: pointer;
        z-index: 1;
        transition: color 0.2s;
    }
    .nav-button span {
        transition: opacity 1s;
    }
    .nav-button .fas {
        transition: min-width 0.2s;
    }

    #nav-content-highlight {
        position: absolute;
        left: 0;
        width: 4px;
        height: 50px;
        background-color: var(--navbar-dark-primary);
        transition: top 0.3s ease;
    }

    #nav-bar .fas {
        min-width: 3rem;
        text-align: center;
    }

    #nav-footer {
        position: relative;
        width: var(--navbar-width);
        height: 54px;
        background: var(--navbar-dark-secondary);
        border-radius: 16px;
        display: flex;
        flex-direction: column;
        z-index: 2;
        transition: width 0.3s ease;
    }

    #nav-footer-heading {
        position: relative;
        width: 100%;
        height: 54px;
        display: flex;
        align-items: center;
    }

    #nav-footer-avatar {
        position: relative;
        margin: 11px 0 11px 16px;
        left: 0;
        width: 32px;
        height: 32px;
        border-radius: 50%;
        overflow: hidden;
        transform: translate(0);
        transition: 0.2s;
    }
    #nav-footer-avatar img {
        height: 100%;
    }

    #nav-footer-titlebox {
        position: relative;
        margin-left: 16px;
        display: flex;
        flex-direction: column;
        transition: opacity 1s;
        max-width: 130px; /* adjust this value as needed */
        overflow: hidden;
    }

    #nav-footer-subtitle {
        color: var(--navbar-light-secondary);
        font-size: 0.6rem;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    #nav-toggle:not(:checked) ~ #nav-footer-toggle:checked + #nav-footer {
        height: 30%;
        min-height: 54px;
    }
    #nav-toggle:not(:checked) ~ #nav-footer-toggle:checked + #nav-footer label[for=nav-footer-toggle] {
        transform: rotate(180deg);
    }

    label[for=nav-footer-toggle] {
        position: absolute;
        right: 0;
        width: 3rem;
        height: 100%;
        display: flex;
        align-items: center;
        cursor: pointer;
        transition: transform 0.2s, opacity 0.2s;
    }

    #nav-footer-content {
        margin: 0 16px 16px 16px;
        border-top: solid 1px var(--navbar-light-secondary);
        padding: 16px 0;
        color: var(--text-color);
        font-size: 0.8rem;
        overflow: auto;
    }
    #nav-footer-content::-webkit-scrollbar {
        width: 8px;
        height: 8px;
    }
    #nav-footer-content::-webkit-scrollbar-thumb {
        border-radius: 99px;
        background-color: #9fc8f9;
    }
    .nav-button:hover {
        background-color: var(--navbar-dark-secondary);
        color: var(--navbar-light-secondary) !important;
        border-radius: 8px;
    }

    .log-out:hover {
        background-color: var(--navbar-dark-mid) !important;
        color: var(--navbar-light-secondary) !important;
        border-radius: 8px;
    }

    /* Responsive sidebar & layout */
    @media (max-width: 768px) {
        #nav-bar {
            position: fixed;
            left: -100%;
            top: 0;
            height: 100%;
            width: var(--navbar-width);
            transition: left 0.3s ease-in-out;
            z-index: 1000;
        }

        #nav-toggle:checked ~ #nav-bar {
            left: 0;
        }

        #nav-header,
        #nav-content,
        #nav-footer {
            width: 100%;
            border-radius: 0;
        }

        body::before {
            content: '';
            display: block;
            position: fixed;
            top: 0;
            left: 0;
            width: 100vw;
            height: 100vh;
            background: rgba(0, 0, 0, 0.3);
            z-index: 999;
            opacity: 0;
            pointer-events: none;
            transition: opacity 0.3s;
        }

        #nav-toggle:checked ~ body::before {
            opacity: 1;
            pointer-events: auto;
        }
    }

    /* Adjust layout for smaller screens */
    @media (max-width: 480px) {
        #nav-title {
            font-size: 1.2rem;
        }

        .nav-button {
            height: 48px;
        }

        #nav-footer-content {
            font-size: 0.7rem;
        }

        #nav-footer-subtitle {
            font-size: 0.5rem;
        }
    }

    /* if there is no image is fetched from database */
    .teacher-avatar-letter {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background-color: #4a90e2;
        color: white;
        font-size: 20px;
        font-weight: bold;
        display: flex;
        align-items: center;
        justify-content: center;
        text-align: center;
        line-height: 1;
    }

</style>

<div id="nav-bar">
    <input id="nav-toggle" type="checkbox"/>
    <div id="nav-header"><a id="nav-title" href="/teachers" target="_blank"><i class="fas fa-chalkboard-teacher"></i>Teacher</a>
        <label for="nav-toggle"><span id="nav-toggle-burger"></span></label>
        <hr/>
    </div>
    <div id="nav-content">
        <div id="nav-content-highlight"></div>
        <a href="<%= request.getContextPath() %>/teachers/dashboard" class="nav-button">
            <i class="fas fa-home"></i><span>Dashboard</span>
        </a>

        <a href="${pageContext.request.contextPath}/teachers/teacherStudents" class="nav-button">
            <i class="fas fa-user-graduate"></i><span>Students</span>
        </a>

        <a href="<%= request.getContextPath() %>/teacher/student-attendance/view?teacherId=<%= session.getAttribute("teacherId") %>" class="nav-button">
            <i class="fas fa-check-square"></i><span>Attendance</span>
        </a>
        <a href="<%= request.getContextPath() %>/teachers/academics" class="nav-button">
            <i class="fas fa-book"></i><span>Assignments &amp; Quizzes</span>
        </a>

        <a href="/teacher/student-attendance/student-attendance-history" class="nav-button">
            <i class="fas fa-calendar-alt"></i><span>Attendance History</span>
        </a>

        <a href="<%= request.getContextPath() %>/teachers/teacher-profile" class="nav-button">
            <i class="fas fa-user-tie"></i><span>About me</span>
        </a>

<%--        <a href="/logout" class="nav-button">--%>
<%--            <i class="fas fa-sign-out-alt"></i><span>Logout</span>--%>
<%--        </a>--%>

    </div>
    <input id="nav-footer-toggle" type="checkbox"/>

    <div id="nav-footer">
        <div id="nav-footer-heading">
            <div id="nav-footer-avatar">
                <img id="teacherPhoto"
                     src="<%= (teacherPhoto != null && !teacherPhoto.trim().isEmpty()) ? teacherPhoto : "" %>"
                     alt="Teacher Photo"
                     onerror="handleImageError()" />

                <div id="initialAvatar" class="teacher-avatar-letter" style="display: none;"></div>
            </div>
            <div id="nav-footer-titlebox">
                <a id="nav-footer-title" href="#">Welcome</a>
                <span id="nav-footer-subtitle" title="<%= teacherName %>"><b><%= teacherName %></b></span>
            </div>
            <label for="nav-footer-toggle"><i class="fas fa-caret-up"></i></label>
        </div>

        <div id="nav-footer-content">
            <a href="/logout" class="nav-button log-out" onclick="return confirm('Are you sure you want to log out?');">
            <i class="fas fa-sign-out-alt"></i><span>Logout</span>
            </a>
        </div>
    </div>

<%--    <div id="nav-footer">
        <div id="nav-footer-heading">
            <div id="nav-footer-avatar"><img src="https://gravatar.com/avatar/4474ca42d303761c2901fa819c4f2547"/></div>
            <div id="nav-footer-titlebox"><a id="nav-footer-title" href="https://codepen.io/uahnbu/pens/public" target="_blank">Welcome</a><span id="nav-footer-subtitle">Admin</span></div>
            <label for="nav-footer-toggle"><i class="fas fa-caret-up"></i></label>
        </div>
        <div id="nav-footer-content">
            <a href="logout" class="nav-button"><i class="fas fa-sign-out-alt"></i><span>Logout</span></a>
        </div>
    </div>--%>

</div>

<script>
    const navButtons = document.querySelectorAll('.nav-button');
    const highlight = document.getElementById('nav-content-highlight');

    navButtons.forEach((btn, index) => {
        btn.addEventListener('mouseenter', () => {
            highlight.style.top = `${16 + index * 54}px`;
        });
    });

    // if there is no image is fetched from database
    function handleImageError() {
        const img = document.getElementById("teacherPhoto");
        const letter = document.getElementById("initialAvatar");

        img.style.display = "none";

        const name = "<%= teacherName != null ? teacherName : "" %>";
        if (name.length > 0) {
            const firstChar = name.charAt(0).toUpperCase();
            letter.textContent = firstChar;
            letter.style.display = "flex";
            console.log("Image not found. Showing letter:", firstChar);
        } else {
            console.log("No teacher name found.");
        }
    }

    window.onload = function () {
        const img = document.getElementById("teacherPhoto");

        // Force fallback if no photo URL is provided
        if (!img.src || img.src.endsWith("/") || img.src.endsWith("null")) {
            handleImageError();
        }
    }
</script>

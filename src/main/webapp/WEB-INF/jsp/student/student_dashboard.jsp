<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="student_sidebar.jsp" %>
<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    String role=(String)session.getAttribute("role");
    Long roleId= (Long) session.getAttribute("roleId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <link rel="stylesheet" href="/student_frontend/style.css">
</head>
<body class="bg-gray-100">

<!-- Main Content -->
<main class="ml-64 p-6">
    <h1 class="text-3xl font-bold text-blue-600">Welcome, <%--<%= role %>--%> ${student.name}!</h1>



    <!-- Profile Section -->
    <section class="bg-white p-6 mt-6 shadow-lg rounded-lg">
        <h2 class="text-xl font-semibold text-green-600 mb-4">Your Profile</h2>
        <div class="flex items-center space-x-4">
            <div class="w-24 h-24 rounded-full overflow-hidden border shadow">
                <img src="${student.photoPath != null ? student.photoPath : '/images/default_avatar.png'}"
                     alt="Student Photo" class="w-full h-full object-cover">
            </div>
            <div>
                <p class="text-lg font-semibold">${student.name}</p>
                <p class="text-gray-600">ID: <%=roleId%></p>
                <p>Email: ${student.email}</p>
                <p>Grade: ${student.grade} ${student.section}</p>

                <a href="/student/profile">View Profile</a><br/>
                <a href="/logout">Logout</a>
            </div>


        </div>
    </section>

    <!-- Attendance Overview -->
    <section class="bg-white p-6 mt-6 shadow-lg rounded-lg">
        <h2 class="text-xl font-semibold text-green-600 mb-4">Attendance Overview</h2>
        <div class="w-full bg-gray-300 rounded-full h-6">
            <div class="bg-green-500 h-6 rounded-full text-white text-center" style="width: 85%">85%</div>
        </div>
    </section>

    <!-- Subjects & Schedule -->
    <section class="bg-white p-6 mt-6 shadow-lg rounded-lg">
        <h2 class="text-xl font-semibold text-blue-600 mb-4">Subjects & Schedule</h2>
        <div class="grid grid-cols-3 gap-4">
            <div class="bg-blue-100 p-4 rounded shadow">
                <p class="font-semibold">Mathematics</p>
                <p class="text-gray-600">Mon, Wed, Fri - 10 AM</p>
            </div>
            <div class="bg-green-100 p-4 rounded shadow">
                <p class="font-semibold">Science</p>
                <p class="text-gray-600">Tue, Thu - 11 AM</p>
            </div>
            <div class="bg-yellow-100 p-4 rounded shadow">
                <p class="font-semibold">English</p>
                <p class="text-gray-600">Mon, Wed, Fri - 12 PM</p>
            </div>
        </div>
    </section>

    <!-- Performance Chart -->
    <section class="bg-white p-6 mt-6 shadow-lg rounded-lg">
        <h2 class="text-xl font-semibold text-purple-600 mb-4">Your Grades</h2>
        <canvas id="gradesChart"></canvas>
    </section>

    <!-- Notices -->
    <section class="bg-white p-6 mt-6 shadow-lg rounded-lg">
        <h2 class="text-xl font-semibold text-yellow-600 mb-4">Notices & Announcements</h2>
        <p class="text-gray-600">No new notices</p>
    </section>

    <!-- Assignments -->
    <section class="bg-white p-6 mt-6 shadow-lg rounded-lg">
        <h2 class="text-xl font-semibold text-orange-600 mb-4">Assignments & Fees</h2>
        <button class="bg-orange-500 text-white px-4 py-2 rounded shadow hover:bg-orange-600">View Assignments</button>
    </section>

</main>

<script>
    // Grades Chart
    const ctx = document.getElementById('gradesChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Math', 'Science', 'English', 'History'],
            datasets: [{
                label: 'Grades',
                data: [85, 78, 90, 88],
                backgroundColor: ['#4CAF50', '#2196F3', '#FFC107', '#9C27B0']
            }]
        }
    });
</script>
    <%@ include file="../ai/assistant.jsp" %>

</body>
</html>

</body>
</html>
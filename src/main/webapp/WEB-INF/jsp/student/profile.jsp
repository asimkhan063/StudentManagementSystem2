<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Student Profile</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link rel="stylesheet" href="/student_frontend/style.css">
</head>
<body class="bg-gray-100 min-h-screen flex">

<%@include file="student_sidebar.jsp"%>

<div class="flex-1 p-8">
    <div class="max-w-4xl mx-auto bg-white rounded-2xl shadow-md p-8">
        <h2 class="text-3xl font-semibold text-gray-800 mb-6">Student Profile</h2>

        <div class="flex items-center gap-6 mb-8">
            <div class="w-24 h-24 rounded-full overflow-hidden border shadow">
                <img src="${student.photoPath != null ? student.photoPath : '/images/default_avatar.png'}"
                     alt="Student Photo" class="w-full h-full object-cover">
            </div>
            <div>
                <h3 class="text-xl font-bold text-gray-800">${student.name}</h3>
                <p class="text-gray-600">${student.email}</p>
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
                <label class="block text-sm text-gray-600">Phone No</label>
                <p class="text-lg text-gray-900 font-medium">${student.phoneNo}</p>
            </div>

            <div>
                <label class="block text-sm text-gray-600">Alternate Phone</label>
                <p class="text-lg text-gray-900 font-medium">${student.altPhoneNo}</p>
            </div>

            <div>
                <label class="block text-sm text-gray-600">Grade</label>
                <p class="text-lg text-gray-900 font-medium">${student.grade}</p>
            </div>

            <div>
                <label class="block text-sm text-gray-600">Section</label>
                <p class="text-lg text-gray-900 font-medium">${student.section}</p>
            </div>

            <div>
                <label class="block text-sm text-gray-600">Roll No</label>
                <p class="text-lg text-gray-900 font-medium">${student.rollNo}</p>
            </div>

            <div>
                <label class="block text-sm text-gray-600">Gender</label>
                <p class="text-lg text-gray-900 font-medium">${student.gender}</p>
            </div>

            <div>
                <label class="block text-sm text-gray-600">Father's Name</label>
                <p class="text-lg text-gray-900 font-medium">${student.fatherName}</p>
            </div>

            <div>
                <label class="block text-sm text-gray-600">Mother's Name</label>
                <p class="text-lg text-gray-900 font-medium">${student.motherName}</p>
            </div>

            <div>
                <label class="block text-sm text-gray-600">Aadhaar No</label>
                <p class="text-lg text-gray-900 font-medium">${student.aadhaarNo}</p>
            </div>

            <div class="md:col-span-2">
                <label class="block text-sm text-gray-600">Address</label>
                <p class="text-lg text-gray-900 font-medium">${student.address}</p>
            </div>

            <div>
                <label class="block text-sm text-gray-600">Session</label>
                <p class="text-lg text-gray-900 font-medium">${student.sessionId}</p>
            </div>

<%--            <div>--%>
<%--                <label class="block text-sm text-gray-600">Status</label>--%>
<%--                <p class="text-lg text-gray-900 font-medium">--%>
<%--                    <span class="${student.active ? 'text-green-600' : 'text-red-600'}">--%>
<%--                        ${student.active ? 'Active' : 'Inactive'}--%>
<%--                    </span>--%>
<%--                </p>--%>
<%--            </div>--%>

        </div>

        <div class="mt-4 flex space-x-4">
            <a href="/student/dashboard" class="inline-block bg-blue-600 text-white px-4 py-2 rounded-lg shadow hover:bg-blue-700 transition">
                Back to Dashboard
            </a>

            <a <%--href="/student/edit?id=${id}"--%> onclick="openEditModal(${student.id})" class="inline-block bg-green-600 text-white px-4 py-2 rounded-lg shadow hover:bg-green-700 transition">
                Update Profile
            </a>
        </div>

    </div>
</div>
<script>
    async function openEditModal(id) {
        window.location.href = `edit?id=${student.id}`;
    }
</script>
</body>
</html>
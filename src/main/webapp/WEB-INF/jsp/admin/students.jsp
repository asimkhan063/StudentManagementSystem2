<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ include file="sidebar.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Management</title>
    <script src="https://cdn.tailwindcss.com"></script>

    <script src="https://kit.fontawesome.com/f64fe89afb.js" crossorigin="anonymous"></script>
    <link href="https://unpkg.com/ag-grid-community@30.0.0/styles/ag-grid.css" rel="stylesheet" />
    <link href="https://unpkg.com/ag-grid-community@30.0.0/styles/ag-theme-alpine.css" rel="stylesheet" />

    <script src="https://unpkg.com/ag-grid-community@30.0.0/dist/ag-grid-community.noStyle.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>    <script>
        tailwind.config = {
            darkMode: 'class', // ⬅️ enable class-based dark mode
            theme: {
                extend: {},
            }
        };
    </script>
    <style>
        .bg-blue-600 {
            background-color: #2563eb !important;
        }

    </style>

    <link rel="stylesheet" href="/student_frontend/style.css">
</head>
<body class="bg-gray-100">

<main class="ml-64 p-6">
    <div class="flex justify-between items-center" onclick="href=''">
        <h1 class="text-3xl font-bold">Student Management</h1>
        <a id="openModalButton"  href="addoreditstudent" class="bg-blue-600 text-white px-4 py-2 rounded-lg shadow-md hover:bg-blue-700">
            + Add New Student
        </a>
    </div>

    <!-- Student List Section -->
    <section class="bg-white p-6 mt-6 shadow-lg rounded-lg">
        <h2 class="text-xl font-semibold mb-4">Student List</h2>
        <div class="overflow-x-auto">
            <table class="w-full border-collapse border border-gray-300" id="studentTable">
                <thead class="bg-blue-600 text-Black">
                <tr>
                    <th>Photo</th>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Grade</th>
                    <th>Address</th>
                    <th>Roll No</th>
                    <th>Father's Name</th>
                    <th>Mother's Name</th>
                    <th>Aadhaar No</th>
                    <th>Phone No</th>
                    <th>Alternate Phone No</th>
                    <th>Gender</th>
                    <th>Section</th>
                    <th>Session ID</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <!-- Dynamic rows will be inserted here -->
                </tbody>
            </table>
        </div>
    </section>


</main>

<!-- Modal for Adding Student -->
<div id="studentModal" class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center hidden">
    <div class="bg-white p-6 rounded-lg shadow-lg w-1/3">
        <span id="closeModalButton" class="text-red-500 cursor-pointer text-2xl float-right">&times;</span>
        <h2 class="text-2xl font-bold mb-4">Add Student</h2>
         <form id="studentForm"
               action="${pageContext.request.contextPath}/students"
               method="post"
               enctype="multipart/form-data"
               class="space-y-4">

             <input type="text"
                    id="name"
                    name="name"
                    placeholder="Student Name"
                    class="w-full p-2 border rounded"
                    required>

             <input type="email"
                    id="email"
                    name="email"
                    placeholder="Email"
                    class="w-full p-2 border rounded"
                    required>

             <input type="text"
                    id="grade"
                    name="grade"
                    placeholder="Grade"
                    class="w-full p-2 border rounded"
                    required>

             <input type="text"
                    id="phoneNo"
                    name="phoneNo"
                    placeholder="10 digit Phone Number"
                    class="w-full p-2 border rounded"
                    maxlength="10"
                    minlength="10"
                    pattern="[0-9]{10}"
                    inputmode="numeric"
                    required>


             <input type="file"
                    name="image"
                    id="image"
                    accept="image/*"
                    class="w-full p-2 border rounded">

             <button type="submit"
                     class="bg-blue-600 text-white px-4 py-2 rounded-lg shadow-md w-full">
                 Add Student
             </button>
         </form>
    </div>
</div>

<script>
    document.getElementById('openModalButton').addEventListener('click', function () {
        document.getElementById('studentModal').classList.remove('hidden');
    });

    document.getElementById('closeModalButton').addEventListener('click', function () {
        document.getElementById('studentModal').classList.add('hidden');
    });
</script>

<script src="/student_frontend/script.js"></script>
</body>
</html>
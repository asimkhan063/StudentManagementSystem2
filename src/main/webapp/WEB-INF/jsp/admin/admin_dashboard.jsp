<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Admin Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script src="https://kit.fontawesome.com/f64fe89afb.js" crossorigin="anonymous"></script>
    <link href="https://unpkg.com/ag-grid-community@30.0.0/styles/ag-grid.css" rel="stylesheet" />
    <link href="https://unpkg.com/ag-grid-community@30.0.0/styles/ag-theme-alpine.css" rel="stylesheet" />

    <script src="https://unpkg.com/ag-grid-community@30.0.0/dist/ag-grid-community.noStyle.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <script>
        tailwind.config = {
            darkMode: 'class', // ⬅️ enable class-based dark mode
            theme: {
                extend: {},
            }
        };
    </script>

    <style>
        body {
            background: linear-gradient(to bottom right, #e0f7fa, #ffffff);
            font-family: 'Poppins', sans-serif;
            transition: background 0.3s ease;
        }
        .dark-mode {
            background: linear-gradient(to bottom right, #121212, #333);
            color: #ffffff;
        }
        .glass-card {
            background: rgba(255, 255, 255, 0.6);
            backdrop-filter: blur(15px);
            border-radius: 18px;
            box-shadow: 0 15px 30px rgba(0, 200, 255, 0.15);
            padding: 30px;
            text-align: center;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .glass-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 25px 50px rgba(0, 200, 255, 0.25);
        }
        .glow-text {
            text-shadow: 0 0 10px rgba(0, 200, 255, 0.5);
        }
        .dark-mode .glass-card {
            background: rgba(255, 255, 255, 0.1);
            color: #ffffff;
        }
        .chart-container {
            background-color: rgba(255, 255, 255, 0.1);
            border-radius: 1.5rem;
            box-shadow: 0 15px 30px rgba(0, 200, 255, 0.1);
            padding: 2rem;
            margin-top: 4rem;
        }
        canvas {
            max-height: 300px;
        }
        .sidebar-collapsed #menuItems,
        .sidebar-collapsed #sidebarTitle,
        .sidebar-collapsed .sidebar-logo {
            display: none;
        }
        .sidebar-collapsed {
            width: 4rem !important; /* w-16 */
        }

        .main-content-collapsed {
            margin-left: 4rem !important; /* ml-16 */
        }

        .main-content-expanded {
            margin-left: 16rem !important; /* ml-64 */
        }

        .sidebar-logo-collapsed {
            display: none;
        }

        .sidebar-text {
            transition: opacity 0.3s ease;
        }

        .collapsed-text {
            opacity: 0;
            pointer-events: none;
        }
    </style>
</head>
<body class="text-gray-900" id="dashboardBody">
<div class="flex transition-all" id="layoutWrapper">


    <%@ include file="sidebar.jsp" %>
      <!-- Main Content -->
   <%-- <div id="mainContent" class="ml-64 transition-all duration-300 p-8">--%>
      <!-- Main Content -->
      <div id="mainContent" class="main-content-expanded transition-all duration-300 p-8">

      <div class="flex justify-between items-center mb-6">
            <h1 class="text-5xl font-extrabold glow-text dark:text-white">Admin Dashboard</h1>
            <button onclick="toggleDarkMode()" class="bg-gray-200 px-4 py-2 rounded-lg shadow hover:bg-gray-300">🌙 Toggle Mode</button>
        </div>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-8">
            <div class="glass-card">
                <h2 class="text-lg">🧑‍🎓 Students</h2>
                <p class="text-4xl font-bold glow-text" id="studentCount">${stats.studentCount}</p>
            </div>
            <div class="glass-card">
                <h2 class="text-lg">👩‍🏫 Teachers</h2>
                <p class="text-4xl font-bold glow-text" id="teacherCount">${stats.teacherCount}</p>
            </div>
            <div class="glass-card">
                <h2 class="text-lg">📅 Attendance Rate</h2>
                <p class="text-4xl font-bold glow-text" id="attendanceRate">${stats.attendanceRate}</p>
            </div>
            <div class="glass-card">
                <h2 class="text-lg">💡 Active Modules</h2>
                <p class="text-4xl font-bold glow-text">5</p>
            </div>
        </div>

       <%-- <!-- Grid -->
        <div class="mt-12">
            <h2 class="text-2xl font-semibold mb-4 dark:text-white">📋 Student Data</h2>
            <div id="myGrid" class="ag-theme-alpine" style="height: 400px; width: 100%;"></div>
        </div>

        <!-- Chart -->
        <div class="chart-container">
            <h2 class="text-2xl font-semibold mb-4">📊 Grade Distribution</h2>
            <canvas id="gradeChart"></canvas>
        </div>--%>
          <!-- Chart Section -->
          <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6 mt-12">
              <div class="bg-white p-4 rounded shadow">
                  <h2 class="text-xl font-semibold mb-4">Grades Overview</h2>
                  <canvas id="gradeChart" height="200"></canvas>
              </div>

              <!-- ag-Grid Section -->
              <div class="bg-white rounded-xl shadow p-6">
                  <h2 class="text-lg font-semibold mb-4">Fees Collection</h2>
                  <canvas id="pieChart" height="200"></canvas>
              </div>
          </div>


          <div class="bg-white rounded-xl shadow p-6">
              <h2 class="text-lg font-semibold mb-4">Student Data</h2>
              <div class="ag-theme-alpine" style="height: 300px; width: 100%;">
                  <div id="myGrid" style="height: 100%; width: 100%;" class="ag-theme-alpine"></div>
              </div>
          </div>
    </div>
</div>

<script>
    function toggleDarkMode() {
        document.getElementById('dashboardBody').classList.toggle('dark-mode');
        document.documentElement.classList.toggle('dark'); // toggle `dark` on <html>
    }


    document.addEventListener('DOMContentLoaded', function () {
        // ✅ ag-Grid Setup
        const columnDefs = [
            { headerName: "ID", field: "id" },
            { headerName: "Name", field: "name" },
            { headerName: "Grade", field: "grade" },
            { headerName: "Attendance", field: "attendance" }
        ];

        // const rowData = [
        //     { id: 1, name: "Asim Khan", grade: "A", attendance: "95%" },
        //     { id: 2, name: "Rajat Yadav", grade: "B+", attendance: "88%" },
        //     { id: 3, name: "Anshu Gupta", grade: "A-", attendance: "92%" }
        // ];
               const rowData = [
                   <c:forEach var="student" items="${students}" varStatus="loop">
                   {
                       id: "${student.id}",
                       name: "${student.name}",
                       grade: "${student.grade}"
                         <%--attendance: "${student.attendanceRate}"--%>
                   }<c:if test="${!loop.last}">,</c:if>
                   </c:forEach>
               ];

        const gridOptions = {
            columnDefs: [
                { headerName: "ID", field: "id" },
                { headerName: "Name", field: "name" },
                { headerName: "Grade", field: "grade" },
                { headerName: "Attendance", field: "attendance" }
            ],
            rowData: rowData,
            pagination: true,
            paginationPageSize: 10,
            defaultColDef: {
                        flex: 1,
                        minWidth: 100,
                        sortable: true,
                        filter: true,
                        resizable: true
                    }
        };

        const gridDiv = document.querySelector('#myGrid');
        new agGrid.Grid(gridDiv, gridOptions);

        // const gridOptions = {
        //     columnDefs: columnDefs,
        //     rowData: rowData,
        //     pagination: true,
        //     animateRows: true,
        //     defaultColDef: {
        //         flex: 1,
        //         minWidth: 100,
        //         sortable: true,
        //         filter: true,
        //         resizable: true
        //     }
        // };
        //
        // const gridDiv = document.getElementById("myGrid");
        // new agGrid.Grid(gridDiv, gridOptions); // ✅ Correct usage for ag-Grid Community

        // ✅ Chart.js Setup
        const ctx = document.getElementById('gradeChart').getContext('2d');
        new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Asim', 'Rohit', 'Anshu'],
                datasets: [{
                    label: 'Grades (A=4, B+=3.5, A-=3.7)',
                    data: [4, 3.5, 3.7],
                    backgroundColor: ['#0ea5e9', '#34d399', '#fbbf24']
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 5
                    }
                }
            }
        });
        const pieChart = new Chart(document.getElementById('pieChart'), {
            type: 'doughnut',
            data: {
                labels: ['Paid', 'Unpaid'],
                datasets: [{
                    data: [75, 25],
                    backgroundColor: ['#10B981', '#F59E0B']
                }]
            }
        });
        //document.getElementById('studentCount').textContent = rowData.length;
       // document.getElementById('teacherCount').textContent = 10;
        //document.getElementById('attendanceRate').textContent = "91%";

    });
        // Simulated stats




    </script>
    <%@ include file="../ai/assistant.jsp" %>
</body>

</html>
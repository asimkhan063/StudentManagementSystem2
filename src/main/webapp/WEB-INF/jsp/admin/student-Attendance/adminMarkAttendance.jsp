<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html><head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Admin Dashboard - Student Attendance</title>

  <!-- TailwindCSS -->
  <script src="https://cdn.tailwindcss.com"></script>

  <!-- FontAwesome -->
  <script src="https://kit.fontawesome.com/f64fe89afb.js" crossorigin="anonymous"></script>

  <!-- AG Grid -->
  <link href="https://unpkg.com/ag-grid-community@30.0.0/styles/ag-grid.css" rel="stylesheet" />
  <link href="https://unpkg.com/ag-grid-community@30.0.0/styles/ag-theme-alpine.css" rel="stylesheet" />
  <script src="https://unpkg.com/ag-grid-community@30.0.0/dist/ag-grid-community.noStyle.js"></script>

  <!-- Chart.js -->
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

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

    /* Custom Styles for Student Attendance Page */
    .container {
      background: #ffffff;
      padding: 30px;
      border-radius: 15px;
      margin-top: 40px;
      box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
    }
    h2 {
      font-weight: 600;
      margin-bottom: 25px;
      color: #343a40;
    }
    .form-select, .form-control {
      border-radius: 8px;
      padding: 10px;
    }
    .btn {
      border-radius: 8px;
    }
    #search {
      border-radius: 8px;
      margin-top: 10px;
    }
    .table {
      border-radius: 8px;
      overflow: hidden;
    }
    .status-toggle-group {
      display: flex;
      gap: 6px;
    }
    .status-toggle.active {
      outline: 3px solid #0d6efd;
    }
    .toast {
      position: fixed;
      bottom: 20px;
      right: 20px;
      background: #198754;
      color: white;
      padding: 12px 20px;
      border-radius: 8px;
      display: none;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
      font-weight: 500;
    }
    @media (max-width: 768px) {
      .row > div {
        margin-bottom: 15px;
      }
    }

    /* Sidebar Styles for Admin Dashboard */
    .sidebar {
      position: fixed;
      top: 0;
      left: 0;
      width: 250px;
      height: 100%;
      background-color: #2c3e50;
      color: white;
      transition: all 0.3s ease;
    }

    .sidebar .sidebar-logo {
      padding: 20px;
      font-size: 1.5rem;
      font-weight: bold;
      color: #ecf0f1;
    }

    .sidebar .menu-item {
      padding: 15px;
      text-align: left;
      border-bottom: 1px solid #34495e;
    }

    .sidebar .menu-item:hover {
      background-color: #34495e;
      cursor: pointer;
    }

    .main-content {
      margin-left: 250px;
      padding: 20px;
      transition: margin-left 0.3s ease;
    }

    .sidebar-collapsed .main-content {
      margin-left: 0;
    }
  </style>
</head>

<body>

<%@ include file="/WEB-INF/jsp/admin/sidebar.jsp" %>
<div class="main-content">
  <div class="container">
    <h2>📋 Student Attendance</h2>


    <div class="row">
      <div class="col-md-4">
        <label class="form-label">Grade:</label>
        <select id="grade" class="form-select">
          <option value="">Select Grade</option>
        </select>
      </div>
      <div class="col-md-4">
        <label class="form-label">Section:</label>
        <select id="section" class="form-select">
          <option value="">Select Section</option>
        </select>
      </div>
      <div class="col-md-4">
        <label class="form-label">Date:</label>
        <input type="date" id="date" class="form-control" value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
      </div>
    </div>

    <div class="mt-4 d-flex flex-wrap gap-2">
      <button class="btn btn-info text-white" id="load-students">Load Students</button>
      <button class="btn btn-success" id="mark-all-present">Mark All Present</button>
      <a href="<%= request.getContextPath() %>/admin/student-attendance/attendance-history" class="btn btn-outline-primary">📅 View Past Attendance</a>
      <input type="text" id="search" placeholder="Search by name..." class="form-control w-100 w-md-auto">
    </div>

    <table class="table table-bordered table-hover mt-4">
      <thead class="table-light">
      <tr>
        <th style="width: 50px">#</th>
        <th>Student Name</th>
        <th style="width: 300px">Status</th>
      </tr>
      </thead>
      <tbody id="student-list"></tbody>
    </table>

    <button class="btn btn-primary mt-3" id="submit-attendance">Submit Attendance</button>
  </div>
</div>

<div id="toast-message" class="toast"></div>
<script>
  const contextPath = "<%= request.getContextPath() %>";

  document.addEventListener("DOMContentLoaded", () => {
    fetchGradesAndSections();
    document.getElementById("load-students").addEventListener("click", fetchStudents);
    document.getElementById("mark-all-present").addEventListener("click", markAllPresent);
    document.getElementById("submit-attendance").addEventListener("click", submitAttendance);
    document.getElementById("search").addEventListener("input", filterStudents);
  });

  function fetchGradesAndSections() {
    fetch(`${contextPath}/admin/student-attendance/grades`)
            .then(res => res.json())
            .then(data => {
              const gradeDropdown = document.getElementById("grade");
              data.forEach(grade => {
                gradeDropdown.innerHTML += `<option value="${grade}">${grade}</option>`;
              });
            });

    fetch(`${contextPath}/admin/student-attendance/sections`)
            .then(res => res.json())
            .then(data => {
              const sectionDropdown = document.getElementById("section");
              data.forEach(section => {
                sectionDropdown.innerHTML += `<option value="${section}">${section}</option>`;
              });
            });
  }

  function fetchStudents() {
    const grade = document.getElementById("grade").value;
    const section = document.getElementById("section").value;

    if (!grade || !section) return alert("Please select grade and section");

    fetch(`${contextPath}/admin/student-attendance/students-attendance?grade=${encodeURIComponent(grade)}&section=${encodeURIComponent(section)}`)
            .then(res => res.json())
            .then(data => {
              const tbody = document.getElementById("student-list");
              tbody.innerHTML = "";

              data.forEach((student, i) => {
                tbody.innerHTML += `
                        <tr>
                            <td><%--${i + 1}--%>
                             <div class="w-14 h-14 rounded-full overflow-hidden border shadow">
                              <img src="${student.photoPath != null ? student.photoPath : '/images/default_avatar.jpg'}"
                                   alt="Student Photo" class="w-full h-full object-cover">
                          </div>
                            </td>
                            <td>${student.name}</td>
                            <td>
                                <div class="status-toggle-group">
                                    <button type="button" class="btn btn-outline-success status-toggle" data-id="${student.id}" data-status="present">Present</button>
                                    <button type="button" class="btn btn-outline-danger status-toggle" data-id="${student.id}" data-status="absent">Absent</button>
                                    <button type="button" class="btn btn-outline-warning status-toggle" data-id="${student.id}" data-status="leave">Leave</button>
                                </div>
                            </td>
                        </tr>`;
              });

              document.querySelectorAll(".status-toggle").forEach(button => {
                button.addEventListener("click", () => {
                  const group = button.closest(".status-toggle-group");
                  group.querySelectorAll(".status-toggle").forEach(b => b.classList.remove("active"));
                  button.classList.add("active");
                });
              });
            });
  }

  function markAllPresent() {
    document.querySelectorAll(".status-toggle-group").forEach(group => {
      group.querySelectorAll(".status-toggle").forEach(btn => btn.classList.remove("active"));
      const presentBtn = group.querySelector(".status-toggle[data-status='present']");
      if (presentBtn) presentBtn.classList.add("active");
    });
  }

  function submitAttendance() {
    const date = document.getElementById("date").value;
    const grade = document.getElementById("grade").value;
    const section = document.getElementById("section").value;

    const attendanceList = [];

    document.querySelectorAll(".status-toggle.active").forEach(button => {
      attendanceList.push({
        studentId: button.getAttribute("data-id"),
        status: button.getAttribute("data-status")
      });
    });

    if (!grade || !section) return alert("Please select grade and section.");
    if (attendanceList.length === 0) return alert("Please mark attendance for at least one student.");

    fetch(`${contextPath}/admin/student-attendance/submit-attendance`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        date: date,
        grade: grade,
        section: section,
        attendance: attendanceList
      })
    })
            .then(res => {
              if (res.status === 409) {
                alert("Attendance already submitted for this class today.");
                return;
              }
              if (res.ok) {
                showToast("Attendance submitted successfully!");
                document.getElementById("submit-attendance").disabled = true;
              } else {
                alert("Something went wrong while submitting attendance.");
              }
            })
            .catch(err => console.error("Submit Error:", err));
  }

  function showToast(message) {
    const toast = document.getElementById("toast-message");
    toast.innerText = message;
    toast.style.display = "block";
    setTimeout(() => toast.style.display = "none", 3000);
  }

  function filterStudents() {
    const keyword = document.getElementById("search").value.toLowerCase();
    document.querySelectorAll("#student-list tr").forEach(row => {
      row.style.display = row.innerText.toLowerCase().includes(keyword) ? "" : "none";
    });
  }
</script>

</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    long teacherId = (long) session.getAttribute("teacherId");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Attendance</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background: #eef2f7;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
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
    </style>
</head>
<body>

<div class="container">
    <h2>📋 Student Attendance</h2>

    <input type="hidden" id="teacherId" value="<%= teacherId %>" />

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
        <a href="/teacher/student-attendance/student-attendance-history" class="btn btn-outline-primary">📅 View Past Attendance</a>
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

<div id="toast-message" class="toast"></div>

<script>
    const teacherId = document.getElementById("teacherId").value;

    document.addEventListener("DOMContentLoaded", () => {
        fetchGradesAndSections();
        document.getElementById("load-students").addEventListener("click", fetchStudents);
        document.getElementById("mark-all-present").addEventListener("click", markAllPresent);
        document.getElementById("submit-attendance").addEventListener("click", submitAttendance);
        document.getElementById("search").addEventListener("input", filterStudents);
    });

    function fetchGradesAndSections() {
        fetch("/teacher/student-attendance/grades")
            .then(res => res.json())
            .then(data => {
                const gradeDropdown = document.getElementById("grade");
                data.forEach(grade => {
                    gradeDropdown.innerHTML += `<option value="${grade}">${grade}</option>`;
                });
            });

        fetch("/teacher/student-attendance/sections")
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

        fetch(`/teacher/student-attendance/students-attendance?grade=${grade}&section=${section}`)
            .then(res => res.json())
            .then(data => {
                const tbody = document.getElementById("student-list");
                tbody.innerHTML = "";

                data.forEach((student, i) => {
                    tbody.innerHTML += `
                        <tr>
                            <td>${i + 1}</td>
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

        fetch("/teacher/student-attendance/submit-attendance", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                teacherId: teacherId,
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
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>Student Attendance History</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background-color: #f3f4f6;
            color: #2c3e50;
        }

        .main-content {
            margin-left: 260px;
            padding: 30px 40px;
            transition: margin-left 0.3s ease;
        }

        h2 {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 25px;
            color: #1f2937;
        }

        .filter-form {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
            align-items: center;
            margin-bottom: 30px;
        }

        .filter-form input[type="text"],
        .filter-form input[type="date"] {
            padding: 10px 15px;
            border-radius: 10px;
            border: 1px solid #d1d5db;
            background: #fff;
            font-size: 14px;
            flex: 1;
            min-width: 150px;
        }

        .filter-form input[type="submit"] {
            background: #2563eb;
            color: #fff;
            border: none;
            padding: 10px 20px;
            font-weight: 600;
            border-radius: 10px;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .filter-form input[type="submit"]:hover {
            background: #1d4ed8;
        }

        .card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
            padding: 25px;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 12px;
            font-size: 14px;
        }

        th {
            background-color: #1f2937;
            color: #fff;
            padding: 14px;
            text-align: center;
            border-radius: 8px 8px 0 0;
        }

        td {
            background-color: #f9fafb;
            padding: 12px;
            text-align: center;
            border-bottom: 1px solid #e5e7eb;
            border-radius: 6px;
        }

        tr:hover td {
            background-color: #f1f5f9;
        }

        .student-photo {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
            box-shadow: 0 0 2px rgba(0, 0, 0, 0.3);
        }

        .student-photo-placeholder {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background-color: #3b82f6;
            color: white;
            display: flex;
            justify-content: center;
            align-items: center;
            font-weight: bold;
            font-size: 16px;
            box-shadow: 0 0 2px rgba(0, 0, 0, 0.3);
        }

        .back-btn {
            margin-top: 30px;
            display: inline-block;
            background-color: #374151;
            color: white;
            padding: 10px 20px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
            transition: background-color 0.3s;
        }

        .back-btn:hover {
            background-color: #1f2937;
        }

        .no-data {
            text-align: center;
            padding: 20px;
            color: #9ca3af;
            font-style: italic;
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 20px;
            }

            .filter-form {
                flex-direction: column;
            }

            table, thead, tbody, th, td, tr {
                font-size: 13px;
            }

            .card {
                padding: 15px;
            }
        }
    </style>
</head>
<body>

<%@ include file="../sidebar.jsp" %>

<%
    Long teacherIdLong = (Long) session.getAttribute("teacherId");
    String teacherIdStr = teacherIdLong != null ? String.valueOf(teacherIdLong) : "";
    String contextPath = request.getContextPath();
%>

<div class="main-content">
    <h2>Student Attendance History</h2>

    <!-- Filter Form -->
    <form class="filter-form" method="get" action="<%= contextPath %>/teacher/student-attendance/student-attendance-history">
        <input type="hidden" name="teacherId" value="<%= teacherIdStr %>" />
        <input type="text" name="grade" placeholder="Grade" value="<%= request.getParameter("grade") != null ? request.getParameter("grade") : "" %>" />
        <input type="text" name="section" placeholder="Section" value="<%= request.getParameter("section") != null ? request.getParameter("section") : "" %>" />
        <input type="date" name="date" value="<%= request.getParameter("date") != null ? request.getParameter("date") : "" %>" />
        <input type="submit" value="Filter" />
    </form>

    <!-- Attendance History Table -->
    <div class="card">
        <c:if test="${empty history}">
            <p class="no-data">No attendance records found.</p>
        </c:if>

        <c:if test="${not empty history}">
            <table>
                <thead>
                <tr>
                    <th>Photo</th>
                    <th>Student ID</th>
                    <th>Name</th>
                    <th>Date</th>
                    <th>Grade</th>
                    <th>Section</th>
                    <th>Status</th>
<%--                    <th> </th>--%>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="record" items="${history}">
                    <c:forEach var="studentAttendance" items="${record.attendancelist}">
                        <tr>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty studentAttendance.student.photoPath
            and not fn:contains(studentAttendance.student.photoPath, 'placeholder')}">
                                        <img src="${pageContext.request.contextPath}${studentAttendance.student.photoPath}" alt="Photo" class="student-photo-placeholder" />
                                    </c:when>
                                    <c:otherwise>
                                        <div class="student-photo-placeholder">
                                            <c:choose>
                                                <c:when test="${not empty studentAttendance.student.name}">
                                                    <c:out value="${fn:substring(studentAttendance.student.name, 0, 1)}" />
                                                </c:when>
                                                <c:otherwise>-</c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>${studentAttendance.studentId}</td>
                            <td>${studentAttendance.student.name}</td>
                            <td>${record.date}</td>
                            <td>${record.grade}</td>
                            <td>${record.section}</td>
                            <td>${studentAttendance.status}</td>
<%--                            <td><td><p>Photo Path: ${pageContext.request.contextPath}${studentAttendance.student.photoPath}</p></td></td>--%>
                        </tr>
                    </c:forEach>
                </c:forEach>
                </tbody>
            </table>
        </c:if>
    </div>

    <!-- Back Button -->
    <a href="/teacher/student-attendance/view" class="back-btn">← Back to Attendance</a>
</div>

</body>
</html>
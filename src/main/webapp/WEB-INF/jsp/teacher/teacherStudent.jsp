<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="sidebar.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title>Filter Students</title>
    <style>
        body {
            margin-left: 250px;
            padding: 2rem;
            font-family: 'Segoe UI', sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            transition: all 0.3s ease;
        }

        .container {
            max-width: 1000px;
            margin: auto;
            background: var(--card-bg);
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            margin-bottom: 1.5rem;
            color: var(--heading-color);
        }

        form {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            justify-content: center;
            margin-bottom: 2rem;
        }

        select, button {
            padding: 0.6rem 1rem;
            font-size: 1rem;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            background-color: var(--input-bg);
            color: var(--text-color);
        }

        button {
            background-color: #007BFF;
            color: #fff;
            cursor: pointer;
            border: none;
            transition: 0.3s ease;
        }

        button:hover {
            background-color: #0056b3;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1rem;
            display: block;
            overflow-x: auto;
            white-space: nowrap;
        }

        th, td {
            padding: 0.8rem;
            text-align: center;
            border: 1px solid var(--border-color);
        }

        th {
            background-color: var(--table-head);
            color: var(--text-color);
        }

        tr:nth-child(even) {
            background-color: var(--row-alt);
        }

        td img {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }

        .initial-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: #007bff;
            color: white;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: auto;
        }

        @media (max-width: 768px) {
            form {
                flex-direction: column;
                align-items: stretch;
            }

            body {
                margin-left: 0;
                padding: 1rem;
            }

            .container {
                padding: 1rem;
            }
        }

        /* Dark Mode Theme Variables */
        body.dark-mode {
            --bg-color: #1c1c1c;
            --card-bg: #2a2a2a;
            --text-color: #f5f5f5;
            --heading-color: #ffffff;
            --border-color: #444;
            --input-bg: #333;
            --table-head: #444;
            --row-alt: #2e2e2e;
        }

        /* Light Mode Theme Variables */
        body:not(.dark-mode) {
            --bg-color: #f4f4f4;
            --card-bg: #ffffff;
            --text-color: #333;
            --heading-color: #222;
            --border-color: #ccc;
            --input-bg: #fff;
            --table-head: #f0f0f0;
            --row-alt: #fafafa;
        }
    </style>
</head>
<body class="<%= request.getSession().getAttribute("darkMode") != null && (Boolean)request.getSession().getAttribute("darkMode") ? "dark-mode" : "" %>">

<div class="container">
    <h2>Filter Students by Grade and Section</h2>

    <form action="teacherStudents" method="post" autocomplete="off">
        <select name="grade" required>
            <option value="" disabled selected>Select Grade</option>
            <c:forEach var="g" items="${grades}">
                <option value="${g}" ${g == selectedGrade ? 'selected' : ''}>${g}</option>
            </c:forEach>
        </select>

        <select name="section" required>
            <option value="" disabled selected>Select Section</option>
            <c:forEach var="s" items="${sections}">
                <option value="${s}" ${s == selectedSection ? 'selected' : ''}>${s}</option>
            </c:forEach>
        </select>

        <button type="submit">Search</button>
    </form>

    <c:if test="${not empty students}">
        <table>
            <thead>
            <tr>
<%--                <th>Img</th>--%>
                <th>Roll Number</th>
                <th>Student Name</th>
                <th>Grade</th>
                <th>Section</th>
                <th>Father</th>
                <th>Email</th>
                <th>Contact No</th>
<%--                <th> </th>--%>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="student" items="${students}">
                <tr>
<%--                    <td>--%>
<%--                        <c:choose>--%>
<%--                            <c:when test="${not empty student.photoPath}">--%>
<%--                                <img src="${pageContext.request.contextPath}${student.photoPath}" alt="Image" />--%>
<%--                            </c:when>--%>
<%--                            <c:otherwise>--%>
<%--                                <div class="initial-avatar">${student.name.substring(0,1)}</div>--%>
<%--                            </c:otherwise>--%>
<%--                        </c:choose>--%>
<%--                    </td>--%>
                    <td>${student.rollNo}</td>
                    <td>${student.name}</td>
                    <td>${student.grade}</td>
                    <td>${student.section}</td>
                    <td>${student.fatherName}</td>
                    <td>${student.email}</td>
                    <td>${student.phoneNo}</td>
<%--                    <td><p>Photo Path: ${pageContext.request.contextPath}${student.photoPath}</p></td>--%>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>

    <c:if test="${empty students}">
        <p style="text-align:center; margin-top: 2rem;">No students found for the selected grade and section.</p>
    </c:if>
</div>
</body>
</html>
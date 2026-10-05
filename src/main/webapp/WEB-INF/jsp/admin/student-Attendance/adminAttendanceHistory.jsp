<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Attendance History</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 32px; color: #172033; background: #f4f7fb; }
        .card { max-width: 1100px; margin: auto; padding: 24px; background: white; border-radius: 12px; box-shadow: 0 4px 18px #0001; }
        h1 { margin-top: 0; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px; border-bottom: 1px solid #e5e7eb; text-align: left; }
        th { background: #f0fdfa; }
        .back { display: inline-block; margin-bottom: 18px; color: #0f766e; }
        .empty { color: #64748b; padding: 18px 0; }
    </style>
</head>
<body>
<div class="card">
    <a class="back" href="${pageContext.request.contextPath}/admin/student-attendance/view">← Back to attendance</a>
    <h1>Attendance History</h1>
    <c:choose>
        <c:when test="${empty history}">
            <p class="empty">No attendance records found.</p>
        </c:when>
        <c:otherwise>
            <table>
                <thead><tr><th>Date</th><th>Grade</th><th>Section</th><th>Student ID</th><th>Status</th></tr></thead>
                <tbody>
                <c:forEach var="record" items="${history}">
                    <c:forEach var="entry" items="${record.attendancelist}">
                        <tr>
                            <td><c:out value="${record.date}"/></td>
                            <td><c:out value="${record.grade}"/></td>
                            <td><c:out value="${record.section}"/></td>
                            <td><c:out value="${entry.studentId}"/></td>
                            <td><c:out value="${entry.status}"/></td>
                        </tr>
                    </c:forEach>
                </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page session="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
  String role = (String) session.getAttribute("role");
  Long roleId = (Long) session.getAttribute("roleId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Student Attendance</title>
  <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<%@ include file="student_sidebar.jsp" %>
<!-- Main content with sidebar -->
<main class="ml-64 p-6">
  <div class="max-w-6xl mx-auto">
    <div class="text-center mb-10">
      <h2 class="text-3xl font-bold text-blue-600">Attendance Record</h2>
      <p class="text-lg text-gray-600">Welcome, <span class="font-semibold">${student.name}</span></p>
    </div>

    <!-- Attendance Table -->
    <div class="overflow-x-auto bg-white rounded-2xl shadow-lg">
      <table class="min-w-full text-sm text-left text-gray-700">
        <thead class="bg-blue-600 text-white uppercase text-xs">
        <tr>
          <th scope="col" class="px-6 py-3">Date</th>
          <th scope="col" class="px-6 py-3">Status</th>
          <th scope="col" class="px-6 py-3">Grade</th>
          <th scope="col" class="px-6 py-3">Section</th>
          <th scope="col" class="px-6 py-3">Recorded By</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="att" items="${attendanceList}">
          <tr class="border-b hover:bg-gray-50">
            <td class="px-6 py-4">${att.date}</td>
            <td class="px-6 py-4">
                                <span class="px-2 py-1 rounded-full text-white text-xs font-semibold
                                    <c:choose>
                                        <c:when test="${att.status eq 'Present'}">bg-green-500</c:when>
                                        <c:when test="${att.status eq 'Absent'}">bg-red-500</c:when>
                                        <c:when test="${att.status eq 'Leave'}">bg-yellow-500</c:when>
                                        <c:otherwise>bg-gray-400</c:otherwise>
                                    </c:choose>
                                ">
                                    ${att.status}
                                </span>
            </td>
            <td class="px-6 py-4">${att.grade}</td>
            <td class="px-6 py-4">${att.section}</td>
            <td class="px-6 py-4">${att.recordedBy}</td>
          </tr>
        </c:forEach>
        </tbody>
      </table>
    </div>
  </div>
</main>

</body>
</html>
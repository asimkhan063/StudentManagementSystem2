<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Subjects</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100">
<%@ include file="student_sidebar.jsp" %>

<div class="max-w-4xl mx-auto p-6 bg-white shadow-lg mt-10 rounded-lg">
    <h2 class="text-2xl font-semibold mb-4 text-blue-800">
        Subjects for Class ${student.grade} - Section ${student.section}
    </h2>

    <c:choose>
        <c:when test="${not empty subjects}">
            <ul class="list-disc ml-6 text-gray-700 space-y-1">
                <c:forEach var="subject" items="${subjects}">
                    <li class="text-lg">${subject.name}</li>
                </c:forEach>
            </ul>
        </c:when>
        <c:otherwise>
            <p class="text-red-600 text-lg">No subjects assigned for this class and section.</p>
        </c:otherwise>
    </c:choose>

    <div class="mt-6">
        <a href="/student/dashboard" class="text-blue-600 hover:underline">← Back to Dashboard</a>
    </div>
</div>

</body>
</html>
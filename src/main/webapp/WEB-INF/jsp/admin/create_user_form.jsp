<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Create User</title>
</head>
<body>
<main class="ml-64 p-6">
    <h1 class="text-3xl font-bold mb-4">Add New User</h1>

    <c:if test="${not empty message}">
        <div class="rounded bg-green-50 p-3 text-green-800"><c:out value="${message}"/></div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="rounded bg-red-50 p-3 text-red-700"><c:out value="${error}"/></div>
    </c:if>

    <form method="post" action="/admin/create-user" class="space-y-4">
        <input type="text" name="name" placeholder="Name" required class="p-2 border rounded w-full">
        <input type="email" name="email" placeholder="Email" required class="p-2 border rounded w-full">
        <select name="role" class="p-2 border rounded w-full">
            <option value="STUDENT">Student</option>
            <option value="TEACHER">Teacher</option>
            <option value="PARENT">Parent</option>
            <option value="ADMIN">Admin</option>
        </select>
        <input type="text" name="grade" placeholder="Grade (if student)" class="p-2 border rounded w-full">
        <input type="text" name="section" placeholder="Section (if student)" class="p-2 border rounded w-full">
        <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded">Create User</button>
    </form>
</main>
</body>
</html>

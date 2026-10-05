<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>School Management Login</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="icon"
          type="image/png"
          href="${pageContext.request.contextPath}/images/logo.png">
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">

<div class="flex w-full max-w-6xl bg-white rounded-lg shadow-lg overflow-hidden">
    <!-- Login Form -->
    <div class="w-full md:w-1/2 p-8">
        <div class="flex justify-center mb-6">
            <img src="${pageContext.request.contextPath}/assist/logo.jpg"
                 alt="School Logo"
                 class="h-16">
        </div>
        <h2 class="text-2xl font-bold mb-6 text-center text-blue-600">Welcome Back</h2>
        <%
            String error = (String) session.getAttribute("error");
            if (error != null) {
        %>
        <div style="color: red;"><%= error %></div>
        <%
                session.removeAttribute("error");
            }
        %>

        <form action="${pageContext.request.contextPath}/do-login" method="post" class="space-y-4">
            <input type="text" name="username" placeholder="Username" class="w-full px-4 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500" required>
            <input type="password" name="password" placeholder="Password" class="w-full px-4 py-2 border rounded focus:outline-none focus:ring-2 focus:ring-blue-500" required>

            <button type="submit" class="w-full bg-blue-600 text-white py-2 rounded hover:bg-blue-700 transition duration-300">Login</button>
        </form>

        <p class="text-center text-sm text-gray-500 mt-4">© 2026 School Management. All rights reserved.</p>
    </div>

    <!-- Image Section -->
    <div class="hidden md:block md:w-1/2">
        <img src="${pageContext.request.contextPath}/assist/education-login-banner.jpg"
             alt="School Management"
             class="h-full w-full object-cover">
    </div>
</div>

</body>
</html>

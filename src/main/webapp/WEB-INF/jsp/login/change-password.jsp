<%--
  Created by IntelliJ IDEA.
  User: Mayank
  Date: 16-04-2025
  Time: 11:46 pm
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<form action="/change-password" method="post">
    <label>New Password:</label>
    <input type="password" name="newPassword" required />

    <label>Confirm Password:</label>
    <input type="password" name="confirmPassword" required />

    <button type="submit">Update Password</button>
</form>

</body>
</html>
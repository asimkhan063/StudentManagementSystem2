<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${teacher.id == null ? 'Add Teacher' : 'Update Teacher'}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-10">
            <div class="card shadow p-4">
                <h2 class="text-center">${teacher.id == null ? 'Add Teacher' : 'Update Teacher'}</h2>

            <%--@elvariable id="teacher" type="teacher"--%>
                <form:form action="/teachers/save" method="POST" modelAttribute="teacher" enctype="multipart/form-data">
                    <form:hidden path="id"/>
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Name</label>
                            <form:input path="name" class="form-control"/>
                            <form:errors path="name" class="text-danger"/>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Email</label>
                            <form:input path="email" class="form-control"/>
                            <form:errors path="email" class="text-danger"/>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label">Qualification</label>
                            <form:input path="qualification" class="form-control"/>
                            <form:errors path="qualification" class="text-danger"/>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Specialization</label>
                            <form:input path="specialization" class="form-control"/>
                            <form:errors path="specialization" class="text-danger"/>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label">Experience</label>
                            <form:input path="experience" class="form-control" type="number"/>
                            <form:errors path="experience" class="text-danger"/>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Address</label>
                            <form:input path="address" class="form-control"/>
                            <form:errors path="address" class="text-danger"/>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label">Phone</label>
                            <form:input path="phone" class="form-control"/>
                            <form:errors path="phone" class="text-danger"/>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Alternate Phone (Optional)</label>
                            <form:input path="altPhoneNo" class="form-control"/>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label">Aadhaar Number</label>
                            <form:input path="aadhaarNo" class="form-control"/>
                            <form:errors path="aadhaarNo" class="text-danger"/>
                        </div>

                        <%--   image --%>
                        <div class="col-md-6    mb-3">
                            <label class="form-label">Upload Photo</label>
                            <input type="file" id="file" name="file" class="form-control">
                        </div>

                        <!-- ✅ Hidden field to store the uploaded image path -->
                        <form:hidden path="photoUrl"/>

                        <!-- ✅ Show the existing image if available -->
                        <c:if test="${not empty teacher.photoUrl}">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Current Photo</label>
                                <div>
                                    <img src="${pageContext.request.contextPath}${teacher.photoUrl}" alt="Teacher Photo"
                                         class="img-thumbnail" width="150">
                                </div>
                            </div>
                        </c:if>


                        <div class="col-md-6 mb-3">
                            <label class="form-label">Date of Birth</label>
                            <form:input path="dob" type="date" class="form-control" value="${teacher.dob}"/>
                            <form:errors path="dob" class="text-danger"/>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label">Date of Joining</label>
                            <form:input path="doj" type="date" class="form-control" value="${teacher.doj}"/>
                            <form:errors path="doj" class="text-danger"/>
                        </div>

                        <div class="col-md-6 mb-3">
                            <label class="form-label">Gender</label>
                            <form:select path="gender" class="form-select">
                                <form:option value="Male">Male</form:option>
                                <form:option value="Female">Female</form:option>
                                <form:option value="Other">Other</form:option>
                            </form:select>
                            <form:errors path="gender" class="text-danger"/>
                        </div>
<%--                        <div class="col-md-6 mb-3">--%>
<%--                            <label class="form-label">Active Status</label>--%>
<%--                            <form:checkbox path="isActive" class="form-check-input"/>--%>
<%--                        </div>--%>
                    </div>
                    <div class="text-center">
                        <button type="submit" class="btn btn-success px-5 py-2">${teacher.id == null ? 'Add' : 'Update'}</button>
                    </div>
                </form:form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
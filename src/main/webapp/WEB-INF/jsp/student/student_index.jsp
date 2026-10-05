<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Management</title>

```
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/student_frontend/style.css">

<style>
    .btn {
        background-color: #0c94ff;
        color: white;
        padding: 10px 16px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }

    .modal {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.4);
        overflow-y: auto;
        padding: 30px 0;
        box-sizing: border-box;
    }

    .modal-content {
        background-color: #fff;
        margin: 0 auto;
        padding: 25px;
        border: 1px solid #888;
        width: 90%;
        max-width: 600px;
        border-radius: 8px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
        box-sizing: border-box;
    }

    .modal-content form {
        display: flex;
        flex-direction: column;
        gap: 8px;
    }

    .modal-content input,
    .modal-content select {
        width: 100%;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        box-sizing: border-box;
    }

    .modal-content label {
        font-weight: bold;
        margin-top: 5px;
    }

    .modal-content button[type="submit"] {
        background-color: #0d9488;
        color: white;
        border: none;
        padding: 12px;
        border-radius: 5px;
        cursor: pointer;
        margin-top: 12px;
    }

    .close-btn {
        float: right;
        font-size: 28px;
        font-weight: bold;
        cursor: pointer;
        color: #555;
    }

    .table-section {
        overflow-x: auto;
        margin-top: 25px;
    }

    #studentTable {
        width: 100%;
        border-collapse: collapse;
    }

    #studentTable th,
    #studentTable td {
        padding: 10px;
        border: 1px solid #ddd;
        text-align: center;
        white-space: nowrap;
    }

    .student-photo {
        width: 50px;
        height: 50px;
        border-radius: 50%;
        object-fit: cover;
    }

    @media (max-width: 600px) {
        .modal-content {
            width: 95%;
            padding: 15px;
        }
    }
</style>
```

</head>

<body>

<%@ include file="includes/navbar.jsp" %>

<main>

```
<h2>Student Management</h2>

<!-- Add Student Button -->
<button id="openModalButton" class="btn" type="button">
    Add New Student
</button>

<!-- Add Student Modal -->
<div id="studentModal" class="modal">
    <div class="modal-content">

        <span id="closeModalButton" class="close-btn">&times;</span>

        <h2>Add Student</h2>

        <div id="errorMessages" style="color:red;"></div>

        <form id="studentForm"
              method="post"
              enctype="multipart/form-data">

            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>

            <label for="grade">Grade:</label>
            <input type="text" id="grade" name="grade" required>

            <label for="address">Address:</label>
            <input type="text" id="address" name="address">

            <label for="rollNo">Roll No:</label>
            <input type="text" id="rollNo" name="rollNo">

            <label for="fatherName">Father's Name:</label>
            <input type="text" id="fatherName" name="fatherName">

            <label for="motherName">Mother's Name:</label>
            <input type="text" id="motherName" name="motherName">

            <label for="aadhaarNo">Aadhaar No:</label>
            <input type="text" id="aadhaarNo" name="aadhaarNo">

            <label for="phoneNo">Phone No:</label>
            <input type="tel" id="phoneNo" name="phoneNo">

            <label for="altPhoneNo">Alternate Phone No:</label>
            <input type="tel" id="altPhoneNo" name="altPhoneNo">

            <label for="gender">Gender:</label>
            <select id="gender" name="gender">
                <option value="">Select Gender</option>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
                <option value="Other">Other</option>
            </select>

            <label for="section">Section:</label>
            <select id="section" name="section">
                <option value="">Select Section</option>
                <option value="A">A</option>
                <option value="B">B</option>
                <option value="C">C</option>
                <option value="D">D</option>
            </select>

            <label for="sessionId">Session ID:</label>
            <input type="text" id="sessionId" name="sessionId">

            <label for="image">Student Photo:</label>
            <input type="file"
                   id="image"
                   name="image"
                   accept="image/*">

            <button type="submit">Add Student</button>
        </form>
    </div>
</div>

<!-- Edit Student Modal -->
<div id="editStudentModal" class="modal">
    <div class="modal-content">

        <span id="closeEditModalButton" class="close-btn">&times;</span>

        <h2>Edit Student</h2>

        <div id="editErrorMessages" style="color:red;"></div>

        <form id="editStudentForm" enctype="multipart/form-data">

            <input type="hidden" id="editStudentId" name="id">

            <label for="editName">Name:</label>
            <input type="text" id="editName" name="name" required>

            <label for="editEmail">Email:</label>
            <input type="email" id="editEmail" name="email" required>

            <label for="editGrade">Grade:</label>
            <input type="text" id="editGrade" name="grade" required>

            <label for="editAddress">Address:</label>
            <input type="text" id="editAddress" name="address">

            <label for="editRollNo">Roll No:</label>
            <input type="text" id="editRollNo" name="rollNo">

            <label for="editFatherName">Father's Name:</label>
            <input type="text" id="editFatherName" name="fatherName">

            <label for="editMotherName">Mother's Name:</label>
            <input type="text" id="editMotherName" name="motherName">

            <label for="editAadhaarNo">Aadhaar No:</label>
            <input type="text" id="editAadhaarNo" name="aadhaarNo">

            <label for="editPhoneNo">Phone No:</label>
            <input type="tel" id="editPhoneNo" name="phoneNo">

            <label for="editAltPhoneNo">Alternate Phone No:</label>
            <input type="tel" id="editAltPhoneNo" name="altPhoneNo">

            <label for="editGender">Gender:</label>
            <select id="editGender" name="gender">
                <option value="">Select Gender</option>
                <option value="Male">Male</option>
                <option value="Female">Female</option>
                <option value="Other">Other</option>
            </select>

            <label for="editSection">Section:</label>
            <select id="editSection" name="section">
                <option value="">Select Section</option>
                <option value="A">A</option>
                <option value="B">B</option>
                <option value="C">C</option>
                <option value="D">D</option>
            </select>

            <label for="editSessionId">Session ID:</label>
            <input type="text" id="editSessionId" name="sessionId">

            <label for="photo">Student Photo:</label>
            <input type="file"
                   id="photo"
                   name="image"
                   accept="image/*">

            <button type="submit">Update Student</button>
        </form>
    </div>
</div>

<!-- Student List -->
<section class="table-section">

    <h2>Student List</h2>

    <table id="studentTable">
        <thead>
        <tr>
            <th>Photo</th>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Grade</th>
            <th>Address</th>
            <th>Roll No</th>
            <th>Father's Name</th>
            <th>Mother's Name</th>
            <th>Aadhaar No</th>
            <th>Phone No</th>
            <th>Alternate Phone No</th>
            <th>Gender</th>
            <th>Section</th>
            <th>Session ID</th>
            <th>Actions</th>
        </tr>
        </thead>

        <tbody>
        </tbody>
    </table>

</section>
```

</main>

<script src="${pageContext.request.contextPath}/student_frontend/script.js"></script>

</body>
</html>

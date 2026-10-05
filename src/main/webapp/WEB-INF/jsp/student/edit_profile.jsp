<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>Add / Edit Student</title>
<%--  <script src="includes/editProfile.js"></script>--%>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f9;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
    }
    .container {
      width: 80%;
      background: white;
      padding: 20px;
      border-radius: 10px;
      box-shadow: 0px 4px 10px rgba(0, 0, 0, 0.1);
    }
    h2 {
      text-align: center;
      color: #333;
    }
    form {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 20px;
    }
    .form-group {
      display: flex;
      flex-direction: column;
    }
    label {
      font-weight: bold;
      margin-bottom: 5px;
    }
    input, select {
      padding: 10px;
      border: 1px solid #ccc;
      border-radius: 5px;
      font-size: 14px;
    }
    button {
      grid-column: span 2;
      padding: 10px;
      background-color: #007BFF;
      color: white;
      border: none;
      border-radius: 5px;
      cursor: pointer;
      font-size: 16px;
    }
    button:hover {
      background-color: #0056b3;
    }
  </style>
</head>
<body>
<div class="container">
  <h2 id="formTitle">Add Student</h2>
  <form id="studentForm">
    <input type="hidden" id="studentId" name="studentId">

    <div class="form-group">
      <label for="name">Student Name</label>
      <input type="text" id="name" name="name" required>
    </div>
    <div class="form-group">
      <label for="email">Email</label>
      <input type="email" id="email" name="email" required>
    </div>
    <div class="form-group">
      <label for="grade">Grade</label>
      <input type="text" id="grade" name="grade" required>
    </div>
    <div class="form-group">
      <label for="address">Address</label>
      <input type="text" id="address" name="address">
    </div>
    <div class="form-group">
      <label for="rollNo">Roll No</label>
      <input type="number" id="rollNo" name="rollNo">
    </div>
    <div class="form-group">
      <label for="fatherName">Father's Name</label>
      <input type="text" id="fatherName" name="fatherName">
    </div>
    <div class="form-group">
      <label for="motherName">Mother's Name</label>
      <input type="text" id="motherName" name="motherName">
    </div>
    <div class="form-group">
      <label for="aadhaarNo">Aadhaar No</label>
      <input type="text" id="aadhaarNo" name="aadhaarNo">
    </div>
    <div class="form-group">
      <label for="phoneNo">Phone No</label>
      <input type="text" id="phoneNo" name="phoneNo">
    </div>
    <div class="form-group">
      <label for="altPhoneNo">Alternate Phone No</label>
      <input type="text" id="altPhoneNo" name="altPhoneNo">
    </div>
    <div class="form-group">
      <label for="gender">Gender</label>
      <select id="gender" name="gender">
        <option value="Male">Male</option>
        <option value="Female">Female</option>
      </select>
    </div>
    <div class="form-group">
      <label for="section">Section</label>
      <input type="text" id="section" name="section">
    </div>
    <div class="form-group">
      <label for="sessionId">Session ID</label>
      <input type="text" id="sessionId" name="sessionId">
    </div>
    <div class="form-group">
      <label for="image">Upload Photo</label>
      <%--<input type="file" id="photo" name="photo">--%>
      <input type="file" name="image" id="image" accept="image/*" />
    </div>

    <button type="submit">Save Student</button>
  </form>
</div>
<script>
  const apiBaseUrl = 'http://localhost:8080/students';
// const apiBaseUrl = 'https://school-management-production-2040.up.railway.app/students';

const urlParams = new URLSearchParams(window.location.search);
const studentId = urlParams.get("id");

// Fetch existing student data if editing
async function fetchStudentDetails() {
  if (!studentId) return;


  try {
    const response = await fetch(`http://localhost:8080/students/${studentId}`);
    if (!response.ok) throw new Error("Student not found.");

    const student = await response.json();

    document.getElementById("formTitle").innerText = "Edit Student";
    document.getElementById("studentId").value = student.id;
    document.getElementById("gender").value = student.gender;
    document.getElementById("section").value = student.section;
    document.getElementById("sessionId").value = student.sessionId;
    document.getElementById("grade").value = student.grade;
    document.getElementById("address").value = student.address;
    document.getElementById("rollNo").value = student.rollNo;
    document.getElementById("phoneNo").value = student.phoneNo;
    document.getElementById("motherName").value = student.motherName;
    document.getElementById("aadhaarNo").value = student.aadhaarNo;
    document.getElementById("altPhoneNo").value = student.altPhoneNo;
    document.getElementById("name").value = student.name;
    document.getElementById("email").value = student.email;
    document.getElementById("fatherName").value = student.fatherName;
  } catch (error) {
    console.error("Error fetching student details:", error);
  }
}

// Handle form submit
document.getElementById('studentForm').addEventListener('submit', async (e) => {
  e.preventDefault();

  const form = e.target;
  const formData = new FormData(form);

  const isUpdating = !!document.getElementById("studentId").value;
  const apiUrl = isUpdating ? `http://localhost:8080/students/${studentId}` : apiBaseUrl;

  try {
    const response = await fetch(`http://localhost:8080/students/${studentId}`, {
      method: "PUT", // Use POST even for updates
      body: formData
    });

    if (response.ok) {
      alert(isUpdating ? "Student updated successfully!" : "Student added successfully!");
      window.location.href = "profile"; // ✅ Make sure this is correct URL
    } else {
      alert("Error saving student.");
    }
  } catch (error) {
    console.error("Error:", error);
    alert("Failed to save student.");
  }
});

window.onload = fetchStudentDetails;
</script>
</body>
</html>
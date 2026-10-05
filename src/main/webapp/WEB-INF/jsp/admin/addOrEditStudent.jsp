<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Add Student</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 0;
            font-family: Arial, Helvetica, sans-serif;
            background: #f4f7fb;
            color: #333;
        }

        .page-container {
            width: 100%;
            min-height: 100vh;
            padding: 40px 20px;
        }

        .student-card {
            max-width: 950px;
            margin: auto;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 5px 25px rgba(0, 0, 0, 0.08);
            overflow: hidden;
        }

        .card-header {
            background: #2563eb;
            color: white;
            padding: 25px 30px;
        }

        .card-header h2 {
            margin: 0;
            font-size: 26px;
        }

        .card-header p {
            margin: 7px 0 0;
            font-size: 14px;
            opacity: 0.9;
        }

        .form-container {
            padding: 30px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 7px;
            color: #374151;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            height: 44px;
            padding: 10px 12px;
            border: 1px solid #d1d5db;
            border-radius: 7px;
            outline: none;
            font-size: 14px;
            background: #fff;
            transition: 0.2s;
        }

        .form-group input:focus,
        .form-group select:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
        }

        .form-group input[type="file"] {
            padding: 9px;
            cursor: pointer;
        }

        .gender-box {
            display: flex;
            gap: 25px;
            align-items: center;
            height: 44px;
        }

        .gender-option {
            display: flex;
            align-items: center;
            gap: 7px;
            font-size: 14px;
        }

        .gender-option input {
            width: auto;
            height: auto;
        }

        .button-container {
            margin-top: 30px;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        .btn {
            border: none;
            padding: 12px 24px;
            border-radius: 7px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.2s;
        }

        .btn-save {
            background: #2563eb;
            color: white;
        }

        .btn-save:hover {
            background: #1d4ed8;
        }

        .btn-cancel {
            background: #e5e7eb;
            color: #374151;
        }

        .btn-cancel:hover {
            background: #d1d5db;
        }

        .required {
            color: red;
        }

        @media (max-width: 700px) {

            .page-container {
                padding: 20px 10px;
            }

            .form-container {
                padding: 20px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-group.full-width {
                grid-column: auto;
            }

            .card-header h2 {
                font-size: 22px;
            }

            .button-container {
                justify-content: stretch;
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<div class="page-container">

    <div class="student-card">

        <!-- HEADER -->
        <div class="card-header">
            <h2>Add Student</h2>
            <p>Enter student information carefully</p>
        </div>

        <!-- FORM -->
        <div class="form-container">

            <form id="studentForm"
                  method="post"
                  enctype="multipart/form-data">

                <input type="hidden" id="studentId" name="studentId">

                <div class="form-grid">

                    <!-- STUDENT NAME -->
                    <div class="form-group">
                        <label for="name">
                            Student Name <span class="required">*</span>
                        </label>

                        <input type="text"
                               id="name"
                               name="name"
                               placeholder="Enter student name"
                               required>
                    </div>

                    <!-- EMAIL -->
                    <div class="form-group">
                        <label for="email">
                            Email <span class="required">*</span>
                        </label>

                        <input type="email"
                               id="email"
                               name="email"
                               placeholder="Enter email"
                               required>
                    </div>

                    <!-- GRADE -->
                    <div class="form-group">
                        <label for="grade">Grade</label>

                        <input type="text"
                               id="grade"
                               name="grade"
                               placeholder="Example: A">
                    </div>

                    <!-- ROLL NO -->
                    <div class="form-group">
                        <label for="rollNo">Roll No</label>

                        <input type="text"
                               id="rollNo"
                               name="rollNo"
                               placeholder="Enter roll number">
                    </div>

                    <!-- ADDRESS -->
                    <div class="form-group full-width">
                        <label for="address">Address</label>

                        <input type="text"
                               id="address"
                               name="address"
                               placeholder="Enter complete address">
                    </div>

                    <!-- FATHER NAME -->
                    <div class="form-group">
                        <label for="fatherName">Father's Name</label>

                        <input type="text"
                               id="fatherName"
                               name="fatherName"
                               placeholder="Enter father's name">
                    </div>

                    <!-- MOTHER NAME -->
                    <div class="form-group">
                        <label for="motherName">Mother's Name</label>

                        <input type="text"
                               id="motherName"
                               name="motherName"
                               placeholder="Enter mother's name">
                    </div>

                    <!-- AADHAAR -->
                    <div class="form-group">
                        <label for="aadhaarNo">Aadhaar No</label>

                        <input type="text"
                               id="aadhaarNo"
                               name="aadhaarNo"
                               placeholder="Enter Aadhaar number">
                    </div>

                    <!-- PHONE -->
                    <div class="form-group">
                        <label for="phoneNo">Phone No</label>

                        <input type="text"
                               id="phoneNo"
                               name="phoneNo"
                               placeholder="Enter phone number">
                    </div>

                    <!-- ALTERNATE PHONE -->
                    <div class="form-group">
                        <label for="altPhoneNo">Alternate Phone No</label>

                        <input type="text"
                               id="altPhoneNo"
                               name="altPhoneNo"
                               placeholder="Enter alternate phone number">
                    </div>

                    <!-- GENDER -->
                    <div class="form-group">
                        <label>Gender</label>

                        <div class="gender-box">

                            <label class="gender-option">
                                <input type="radio"
                                       name="gender"
                                       value="Male"
                                       checked>
                                Male
                            </label>

                            <label class="gender-option">
                                <input type="radio"
                                       name="gender"
                                       value="Female">
                                Female
                            </label>

                        </div>
                    </div>

                    <!-- SECTION -->
                    <div class="form-group">
                        <label for="section">Section</label>

                        <input type="text"
                               id="section"
                               name="section"
                               placeholder="Example: A">
                    </div>

                    <!-- SESSION -->
                    <div class="form-group">
                        <label for="sessionId">Session ID</label>

                        <input type="text"
                               id="sessionId"
                               name="sessionId"
                               placeholder="Example: 2026">
                    </div>

                    <!-- PHOTO -->
                    <div class="form-group">
                        <label for="image">Upload Photo</label>

                        <input type="file"
                               id="image"
                               name="image"
                               accept="image/*">
                    </div>

                </div>

                <!-- BUTTONS -->
                <div class="button-container">

                    <button type="button"
                            class="btn btn-cancel"
                            onclick="window.location.href='/admin/students'">
                        Cancel
                    </button>

                    <button type="submit"
                            class="btn btn-save">
                        Save Student
                    </button>

                </div>

            </form>

        </div>

    </div>

</div>

<script>
    document.getElementById("studentForm").addEventListener("submit", async function (event) {

        event.preventDefault();

        const form = this;
        const formData = new FormData(form);

        try {

            const response = await fetch("/students", {
                method: "POST",
                body: formData
            });

            if (response.ok) {

                alert("Student added successfully!");


                window.location.href = "/admin/dashboard";

            } else {

                const errorText = await response.text();

                console.error("Server Error:", errorText);

                alert("Student save nahi hua. Server error check karein.");
            }

        } catch (error) {

            console.error("Error:", error);

            alert("Student save karte waqt error aaya.");
        }

    });
</script>

</body>
</html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Teacher Profile</title>

    <!-- Bootstrap & FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(to right, #e0f7fa, #ffffff);
            font-family: 'Segoe UI', sans-serif;
        }

        .profile-container {
            max-width: 950px;
            margin: 60px auto;
            background: #fff;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }

        .profile-photo {
            width: 160px;
            height: 160px;
            border-radius: 50%;
            object-fit: cover;
            box-shadow: 0 6px 18px rgba(0,0,0,0.2);
        }

        #fallback {
            display: none;
            width: 160px;
            height: 160px;
            border-radius: 50%;
            font-size: 50px;
            background-color: #007bff;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 6px 18px rgba(0,0,0,0.2);
        }

        .profile-title {
            font-size: 36px;
            font-weight: bold;
            color: #007bff;
            margin-top: 15px;
        }

        .profile-subtitle {
            font-size: 18px;
            color: #6c757d;
            margin-bottom: 25px;
        }

        .info-table {
            width: 100%;
            border-collapse: collapse;
            margin: 30px 0;
        }

        .info-table th,
        .info-table td {
            padding: 14px 20px;
            text-align: left;
            border-bottom: 1px solid #dee2e6;
        }

        .info-table th {
            width: 30%;
            background-color: #f8f9fa;
            color: #495057;
            font-weight: 600;
        }

        .info-table td {
            color: #212529;
        }

        .btn-back,
        .btn-warning {
            width: 200px;
            font-weight: 500;
        }

        .action-buttons {
            gap: 20px;
        }

        @media (max-width: 768px) {
            .profile-title {
                font-size: 28px;
            }

            .profile-photo,
            #fallback {
                width: 120px;
                height: 120px;
            }

            #fallback {
                font-size: 40px;
            }

            .info-table th,
            .info-table td {
                padding: 10px 14px;
            }
        }
    </style>
</head>
<body>

<div class="profile-container text-center">
    <img src="${teacher.photoUrl}" class="profile-photo"
         onerror="this.style.display='none'; document.getElementById('fallback').style.display='flex';" alt="Profile Photo">

    <div id="fallback" style="display: none;">
        <%= ((String) session.getAttribute("teacherName")).substring(0, 1).toUpperCase() %>
    </div>

    <h2 class="profile-title">${teacher.name}</h2>
    <p class="profile-subtitle">${teacher.specialization}</p>

    <table class="table table-bordered info-table mt-4">
        <tr>
            <th>Email</th>
            <td>${teacher.email}</td>
        </tr>
        <tr>
            <th>Phone</th>
            <td>${teacher.phone}</td>
        </tr>
        <tr>
            <th>Alt Phone</th>
            <td>${teacher.altPhoneNo}</td>
        </tr>
        <tr>
            <th>Experience</th>
            <td>${teacher.experience} years</td>
        </tr>
        <tr>
            <th>Qualification</th>
            <td>${teacher.qualification}</td>
        </tr>
        <tr>
            <th>Date of Birth</th>
            <td>${teacher.dob}</td>
        </tr>
        <tr>
            <th>Date of Joining</th>
            <td>${teacher.doj}</td>
        </tr>
        <tr>
            <th>Address</th>
            <td>${teacher.address}</td>
        </tr>
    </table>

    <div class="d-flex justify-content-center mt-4 action-buttons flex-wrap">
        <a href="${pageContext.request.contextPath}/teachers/edit/${teacher.id}" class="btn btn-warning me-3 mb-2">
            <i class="fas fa-edit me-1"></i> Edit Profile
        </a>
        <a href="${pageContext.request.contextPath}/teachers/dashboard" class="btn btn-secondary btn-back mb-2">
            <i class="fas fa-arrow-left me-2"></i> Back to Dashboard
        </a>
    </div>
</div>

</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">

    <!-- Font Awesome for Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <style>
        /* Navbar Styles */
        .navbar {
            background: linear-gradient(135deg, #007bff, #00c6ff);
            padding: 18px 20px; /* Increased height */
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px; /* Added margin at the bottom */
        }

        .navbar-brand {
            font-size: 26px;
            font-weight: bold;
            color: white !important;
        }

        .nav-item .nav-link {
            color: white !important;
            font-size: 20px;
            margin: 0 15px;
            position: relative;
            transition: all 0.3s ease-in-out;
            padding: 10px 15px; /* Increased padding for better spacing */
        }

        /* Hover and Active Effects */
        .nav-item .nav-link::after {
            content: "";
            position: absolute;
            bottom: -4px;
            left: 50%;
            width: 0;
            height: 3px;
            background: white;
            transition: width 0.3s ease-in-out, left 0.3s ease-in-out;
        }

        .nav-item .nav-link:hover::after,
        .nav-item .nav-link.active::after {
            width: 100%;
            left: 0;
        }

        .nav-item .nav-link:hover {
            transform: translateY(-2px);
        }
    </style>
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg">
    <div class="container">
        <a class="navbar-brand" href="home.jsp">
            <i class="fas fa-school"></i> School Management
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="home.jsp">
                        <i class="fas fa-home"></i> Home
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="studentshow">
                        <i class="fas fa-user-tie"></i> Students
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" id="openModalButton" href="addoreditstudent">
                        <i class="fas fa-user-plus"></i> Add Student
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
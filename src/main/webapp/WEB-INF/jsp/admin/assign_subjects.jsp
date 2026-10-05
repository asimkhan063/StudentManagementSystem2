<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <title>Assign Subjects</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://kit.fontawesome.com/f64fe89afb.js" crossorigin="anonymous"></script>

  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

  <style>  body {
    background: linear-gradient(to bottom right, #e0f7fa, #ffffff);
    font-family: 'Poppins', sans-serif;
    transition: background 0.3s ease;
  }
  .dark-mode {
    background: linear-gradient(to bottom right, #121212, #333);
    color: #ffffff;
  }
  .glass-card {
    background: rgba(255, 255, 255, 0.6);
    backdrop-filter: blur(15px);
    border-radius: 18px;
    box-shadow: 0 15px 30px rgba(0, 200, 255, 0.15);
    padding: 30px;
    text-align: center;
    transition: transform 0.3s ease, box-shadow 0.3s ease;
  }
  .glass-card:hover {
    transform: translateY(-8px);
    box-shadow: 0 25px 50px rgba(0, 200, 255, 0.25);
  }
  .glow-text {
    text-shadow: 0 0 10px rgba(0, 200, 255, 0.5);
  }
  .dark-mode .glass-card {
    background: rgba(255, 255, 255, 0.1);
    color: #ffffff;
  }
  .chart-container {
    background-color: rgba(255, 255, 255, 0.1);
    border-radius: 1.5rem;
    box-shadow: 0 15px 30px rgba(0, 200, 255, 0.1);
    padding: 2rem;
    margin-top: 4rem;
  }
  canvas {
    max-height: 300px;
  }
  .sidebar-collapsed #menuItems,
  .sidebar-collapsed #sidebarTitle,
  .sidebar-collapsed .sidebar-logo {
    display: none;
  }
  .sidebar-collapsed {
    width: 4rem !important; /* w-16 */
  }

  .main-content-collapsed {
    margin-left: 4rem !important; /* ml-16 */
  }

  .main-content-expanded {
    margin-left: 16rem !important; /* ml-64 */
  }

  .sidebar-logo-collapsed {
    display: none;
  }

  .sidebar-text {
    transition: opacity 0.3s ease;
  }

  .collapsed-text {
    opacity: 0;
    pointer-events: none;
  }
  </style>
</head>
<body class="bg-gray-100 min-h-screen p-10">

<%@ include file="sidebar.jsp" %>
<div class="max-w-2xl mx-auto bg-white p-8 rounded-xl shadow-lg">
  <h2 class="text-3xl font-bold mb-6 text-center text-blue-700">Assign Subjects to Class</h2>

  <form method="post" action="/admin/assign-subjects" class="space-y-6">
    <div class="grid grid-cols-2 gap-6">
      <div>
        <label class="block font-semibold mb-1">Grade (Class)</label>
        <select id="gradeSelect" name="grade" class="w-full border p-2 rounded">
          <c:forEach begin="1" end="12" var="i">
            <option value="${i}">${i}</option>
          </c:forEach>
        </select>
      </div>

      <div>
        <label class="block font-semibold mb-1">Section</label>
        <select id="sectionSelect" name="section" class="w-full border p-2 rounded">
          <option value="A">A</option>
          <option value="B">B</option>
          <option value="C">C</option>
        </select>
      </div>
    </div>

    <div>
      <label class="block font-semibold mb-2">Select Subjects</label>
      <div id="subjectCheckboxes" class="space-y-2">
        <c:forEach items="${subjects}" var="subject">
          <label class="flex items-center">
            <input type="checkbox" name="subjectIds" value="${subject.id}" class="mr-2 subject-box">
              ${subject.name}
          </label>
        </c:forEach>
      </div>
    </div>

    <button type="submit"
            class="w-full bg-blue-600 text-white font-bold py-2 rounded hover:bg-blue-700 transition">
      Assign Subjects
    </button>
  </form>
</div>

<script>
  function loadAssignedSubjects() {
    const grade = $('#gradeSelect').val();
    const section = $('#sectionSelect').val();

    $.ajax({
      url: '/admin/get-assigned-subjects',
      type: 'GET',
      data: { grade: grade, section: section },
      success: function (assignedIds) {
        $('.subject-box').each(function () {
          const checkbox = $(this);
          const subjectId = checkbox.val();
          checkbox.prop('checked', assignedIds.includes(parseInt(subjectId)));
        });
      }
    });
  }

  $('#gradeSelect, #sectionSelect').on('change', loadAssignedSubjects);
  $(document).ready(loadAssignedSubjects);
</script>

</body>
</html>
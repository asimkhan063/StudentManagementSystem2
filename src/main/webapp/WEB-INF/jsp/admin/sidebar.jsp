<!-- Sidebar -->
<div id="sidebar" class="w-64 bg-white/40 backdrop-blur-md shadow-lg p-6 h-screen fixed top-0 left-0 transition-all duration-300 z-40 flex flex-col">
    <div class="flex justify-end">
        <button onclick="toggleSidebar()" class="bg-teal-500 text-white p-2 rounded-md shadow-md hover:bg-teal-600 transition">
            <i class="fa-solid fa-bars"></i>
        </button>
    </div>
    <div class="flex flex-col items-center mt-6">
        <div class="bg-teal-500 text-white rounded-full p-2">
            <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 14l9-5-9-5-9 5z"/>
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 14l6.16-3.422A12.083 12.083 0 0112 21.75a12.083 12.083 0 01-6.16-11.172L12 14z"/>
            </svg>
        </div>
        <%-- <h1 id="sidebarTitle" class="text-2xl font-bold text-teal-700 mt-2 sidebar-text transition-all duration-300">--%>
        <h1 id="sidebarTitle" class="text-2xl font-bold text-teal-700 dark:text-white mt-2 sidebar-text transition-all duration-300">
            StudentSys</h1>
    </div>
    <ul id="menuItems" class="space-y-4 font-medium text-gray-700 mt-8 transition-all duration-300">
        <li>  <a href="/admin/dashboard" class="sidebar-text">Dashboard</a></li>
        <li> <a href="/admin/students" class="sidebar-text">Student Management</a></li>
        <li>
            <a href="/admin/teachers" class="flex items-center space-x-2 hover:text-blue-600">
                <i class="fas fa-chalkboard-teacher"></i>
                <span>Manage Teachers</span>
            </a>
        </li>
        <li> <a href="/admin/assign-subjects" class="sidebar-text">Assign Subjects</a></li>
        <li><a href="/admin/fees" class="sidebar-text">Fees Management</a></li>
        <li><a href="/admin/parents" class="sidebar-text">Parent Accounts</a></li>
        <li><a href="/admin/student-attendance/view" class="sidebar-text">Attendence</a></li>
        <li><span class="sidebar-text"> Reports</span></li>
        <li><span class="sidebar-text">Settings</span></li>
        <li><a href="/logout">Logout</a></li>
    </ul>
</div>

<!-- JS Logic -->
<script>
    function toggleSidebar() {
        const sidebar = document.getElementById("sidebar");
        const mainContent = document.getElementById("mainContent");
        const sidebarTexts = document.querySelectorAll(".sidebar-text");

        sidebar.classList.toggle("sidebar-collapsed");
        mainContent.classList.toggle("main-content-collapsed");
        mainContent.classList.toggle("main-content-expanded");

        sidebarTexts.forEach(text => {
            text.classList.toggle("collapsed-text");
        });
    }
</script>
